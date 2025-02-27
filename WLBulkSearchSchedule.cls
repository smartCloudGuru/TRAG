global class WLBulkSearchSchedule implements Schedulable{
    
    global void execute(SchedulableContext RS){	                                
        callAndHandleResults();
    }
    
    
    @future(callout=true)
    public static void callAndHandleResults(){  
        WLSearchExtension wlse = new WLSearchExtension();
        Map<Watchlist_Search_Subject__c, HttpResponse> wlss_httpresponse_map = new Map<Watchlist_Search_Subject__c, HttpResponse>();
        List<Watchlist_Search_Subject__c> recurringSearchSubjectList = [select Id, Date_of_Birth__c, Name, Watchlist_Next_Search_Date__c, Search_Category__c, OwnerId, temp__c, 
                                                                        Searched_Query_parameter__c, Account__c, contentSetToInsert__c, searchCategoryToInsert__c, Disabled__c,
                                                                        Recurring__c, Bulk_Insert__c, Bulk_Insert_Searched__c
                                                                        from Watchlist_Search_Subject__c where Bulk_Insert__c = true 
                                                                        and Bulk_Insert_Searched__c = false /*and Account__c = '0010c00002DTyzP'*/
                                                                        and Account__r.parentId = '0010c000029mP7x' limit 40];
        system.debug('recurringSearchSubjectList :: '+recurringSearchSubjectList);
        List<HttpResponse> resList = new List<HttpResponse>();
        List<Watchlist_Search_Subject__c> wlssList = new List<Watchlist_Search_Subject__c>();
        for(Watchlist_Search_Subject__c wls : recurringSearchSubjectList){                             
            HttpResponse resp;
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            /*system.debug('searchCategoryValue after name :: '+searchCategoryValue);
            system.debug('parameters after name :: '+parameters);
            system.debug('before setting end point :: '+Label.WLSearchEndpoint+searchCategoryValue+parameters);*/
            req.setEndpoint(Label.WLSearchEndpoint+wls.Search_Category__c+wls.Searched_Query_parameter__c);
            req.setMethod('GET');
            try{
                system.debug('req :: '+req);
                resp = h.send(req);
                system.debug('resp :: '+resp);  
                system.debug('resp.getBody() :: '+resp.getBody());
                System.debug('resp.getStatusCode() :: '+resp.getStatusCode());
                resList.add(resp);
                wlss_httpresponse_map.put(wls, resp);
            }
            catch(Exception ex){
                system.debug('EXCEPTION :: '+ex.getMessage());
            }
        }
        try{
            for(Watchlist_Search_Subject__c wls : wlss_httpresponse_map.keyset()){
                HttpResponse res = wlss_httpresponse_map.get(wls);
                Watchlist_Search__c wlsearch = new Watchlist_Search__c();  
                Boolean isHit = false;
                if(res.getStatusCode() == 200){                
                    Dom.Document doc = res.getBodyDocument();
                    system.debug('doc :: '+doc);
                    Dom.XMLNode rootElement = doc.getRootElement();
                    for(Dom.XMLNode child : rootElement.getChildElements()) {
                        System.debug('child.getChildElementHead :: '+child.getName());
                        if(String.isNotEmpty(child.getName()) && child.getName().equals('head')){    
                            if(wls.Name.length() > 60){
                                wlsearch.Name__c = wls.Name.subString(0,60) +' '+ system.now().format('dd MMMM yyyy');                               
                                wlsearch.Name = wls.Name.subString(0,60)+' '+ system.now().format('dd MMMM yyyy');   
                            }
                            else{
                                wlsearch.Name__c = wls.Name +' '+ system.now().format('dd MMMM yyyy');                               
                                wlsearch.Name = wls.Name +' '+ system.now().format('dd MMMM yyyy');
                            }
                            wlsearch.content_set__c = wls.contentSetToInsert__c;
                            wlsearch.record_type__c = wls.searchCategoryToInsert__c;
                            
                            wlsearch.Date_of_Birth__c = wls.Date_of_Birth__c;                        
                            if(child.getChildElement('api-version', null) != null){
                                wlsearch.api_version__c = child.getChildElement('api-version', null).getText(); 
                            } 
                            if(child.getChildElement('backend-version', null) != null){
                                wlsearch.Backend_version__c = child.getChildElement('backend-version', null).getText();
                            } 
                            if(child.getChildElement('cached-results-id', null) != null){
                                wlsearch.Cached_results_id__c = child.getChildElement('cached-results-id', null).getText();
                            }              
                            if(Decimal.valueOf(child.getChildElement('total-hits', null).getText()) != null){
                                wlsearch.Total_hits__c = Decimal.valueOf(child.getChildElement('total-hits', null).getText());
                                if(wlsearch.Total_hits__c > 0){
                                    isHit = true;
                                }	                                
                            }
                            if(Decimal.valueOf(child.getChildElement('hits-from', null).getText()) != null){
                                wlsearch.hits_from__c = Decimal.valueOf(child.getChildElement('hits-from', null).getText()); 
                            }      
                            if(Decimal.valueOf(child.getChildElement('hits-to', null).getText()) != null){
                                wlsearch.hits_to__c = Decimal.valueOf(child.getChildElement('hits-to', null).getText());
                            } 
                            if(Boolean.valueOf(child.getChildElement('truncated', null).getText()) != null){
                                wlsearch.truncated__c = Boolean.valueOf(child.getChildElement('truncated', null).getText());
                            } 
                            //wlsearch.is_Recurring_Search__c = true;
                            wlsearch.Account__c = wls.Account__c; 
                            wlsearch.Last_searched__c = system.now();
                            /*wlsearch.content_set__c = contentSetToInsert;                        
                            wlsearch.record_type__c = searchCategoryToInsert;
                            wlsearch.search_type__c = searchPrecision;*/
                            wlsearch.Watchlist_Search_Subject__c = wls.Id; 
                            System.debug('child elements :: '+child.getChildElement('api-version', null).getText());
                        }
                    }
                    wlsearch.lastmodifieddate__c = DDUtility.drop_leading_zeros(system.now().format('dd MMMM yyyy'));
                    upsert wlsearch;
                    if(isHit){
                        wlse.handleSearchResults(wlsearch, rootElement.getChildElements() , wls, true);  
                        wls.Analysed__c = false;
                        wls.Status__c = 'Pending';
                    }
                    else{
                        DDUtility.markComplete(wlsearch.Id, 'searchsubject');
                    }
                    wls.Last_searched__c = DDUtility.drop_leading_zeros(system.now().format('dd MMMM yyyy'));
                    wls.Last_Searched_Date__c = system.today();
                    //wls.Hit__c = false;
                    wls.Bulk_Insert_Searched__c  = true; 
                }            
            }
            wlssList.addAll(wlss_httpresponse_map.keyset());
            system.debug('wlss_httpresponse_map.keyset() :: '+wlss_httpresponse_map.keyset());
            update wlssList;
        }
        catch(Exception ex){
            system.debug('EXCEPTION :: '+ex.getMessage());
        }
    }
}