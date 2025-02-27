public class WLSearchMoreDetailsExtension {
    
    public Watchlist_Search_Result__c wlsr;
    public ApexPages.StandardController stdcontroller;
    public pagereference pg;
    public String retURL {get;set;}
    public Map<Id, Map<String, String>> searchResultId_identificationDetails_identificationtype_Map{get;set;} 
    public List<Watchlist_Search_Result_SR__c> sanctionReferenceList{get;set;}
    public List<Watchlist_Search_Result_SOC__c> socList{get;set;}
    public List<Watchlist_Search_Result_Role__c> rolesList{get;set;}
    public List<Watchlist_Search_Result_Associate__c> associatesList{get;set;}
    public List<Watchlist_Search_Result_Source__c> sourcesList {get;set;} 
    public List<Watchlist_Search_Result__c> wlsr_DB;
    public Integer mapSize {get {return searchResultId_identificationDetails_identificationtype_Map.size();}}    
    public String citizenshipCountry {get;set;}
    public String suffix {get;set;}
    public String addressLine {get;set;}
    public String city {get;set;}
    public String zipcode {get;set;}
    public String url {get;set;} 
    public String cin {get;set;}
    public String lei {get;set;}
    public String ntn {get;set;}
    public String idn {get;set;}
    public String nin {get;set;}    
    public String pn {get;set;}    
    public String dateOfRegistration {get;set;}
    public String residentCountry {get;set;}
    public String dateOfBirthCountry {get;set;} 
    public String profileNotes {get;set;}
    public String selectedAction {get; set;}
    public Id watchlistresult{get; set;}
    public String formatteddate {get;set;} 
    public String matchedPrimaryName {get;set;}
    public String matchedScriptName {get;set;}
    public String matchedAlsoKnownAsName {get;set;}
    public boolean temp {get;set;}
    public boolean isOverRideView {get;set;}
    public boolean adverseMedia {get;set;}
    
    public WLSearchMoreDetailsExtension(ApexPages.StandardController controller) {
        system.debug('WLSearchMoreDetailsExtension :: constructor :: start ');     
        isOverRideView = false;
        adverseMedia = false;
        cin = '';
        lei = '';
        ntn = '';
        idn = '';        
        nin = '';
        pn = '';
        this.stdcontroller = controller;
        searchResultId_identificationDetails_identificationtype_Map = new Map<Id, Map<String, String>>();
        sanctionReferenceList = new List<Watchlist_Search_Result_SR__c>();
        socList = new List<Watchlist_Search_Result_SOC__c>();
        rolesList = new List<Watchlist_Search_Result_Role__c>();
        associatesList = new List<Watchlist_Search_Result_Associate__c>();
        sourcesList = new List<Watchlist_Search_Result_Source__c>();
        wlsr = (Watchlist_Search_Result__c)controller.getRecord(); 
        system.debug('wlsr :: '+wlsr);        
        //getMoreDetails();
        retURL = ApexPages.currentPage().getParameters().get('retURL');  
        if(retURL == null){
            isOverRideView = true;
        }
        else{
            String resultFound = ApexPages.currentPage().getParameters().get('resultFound'); 
            if(resultFound != null){
                retURL += '&resultFound='+resultFound+'&counter='+ApexPages.currentPage().getParameters().get('counter');
            }
            String searchSubjectId = ApexPages.currentPage().getParameters().get('searchSubjectId'); 
            if(searchSubjectId != null){
                retURL += '&searchSubjectId='+searchSubjectId+'&counter='+ApexPages.currentPage().getParameters().get('counter');
            }            
            String accId = ApexPages.currentPage().getParameters().get('accId'); 
            if(accId != null){
                retURL += '&accId='+accId+'&counter='+ApexPages.currentPage().getParameters().get('counter');
            }
        }
        system.debug('retURL :: '+retURL);
        
        /*List<Watchlist_Search_Result__c> wlsr_DB = getMoreDetails();*/
        /*for(Watchlist_Search_Result__c wlsrVal_DB : wlsr_DB){
            if(wlsrVal_DB.identification_type__c != null ){
                List<String> multipleIdentificationList = wlsrVal_DB.identification_type__c.split(';');
                system.debug('multipleIdentificationList :: '+multipleIdentificationList);
                if(multipleIdentificationList != null && !multipleIdentificationList.isEmpty()){
                    for(String multipleIdentificationVal : multipleIdentificationList){
                        List<String> keyValList = multipleIdentificationVal.split(':');
                        system.debug('keyValList :: '+keyValList);
                        if(keyValList != null && !keyValList.isEmpty() && keyValList.size() > 1){
                            identificationDetails_identificationtype_Map.put(keyValList[1], keyValList[0]);   
                            searchResultId_identificationDetails_identificationtype_Map.put(wlsrVal_DB.Id, identificationDetails_identificationtype_Map);
                        }                        
                    } 
                }
            }
        }*/
        system.debug('searchResultId_identificationDetails_identificationtype_Map in constructor :: '+searchResultId_identificationDetails_identificationtype_Map);
        system.debug('WLSearchMoreDetailsExtension :: constructor :: end ');
    }
    
    public Pagereference getActionValue(){
        system.debug('selectedAction :: '+selectedAction);
        system.debug('watchlistresult :: '+watchlistresult);
        DDUtility.selectedAction(watchlistresult, selectedAction);
        Pagereference pg = ApexPages.currentPage();            
        pg.setRedirect(true);
        return pg;
        //return this.stdcontroller.cancel();
    }        
    
    public Pagereference prevPage1(){
        system.debug('retURL 1 :: '+retURL);
        String param ;
        Pagereference pg = new Pagereference(retURL);
        if(ApexPages.currentPage().getParameters().get('searchId') != null){
            String searchId = ApexPages.currentPage().getParameters().get('searchId');
            String counter = ApexPages.currentPage().getParameters().get('counter');
            pg.getParameters().put('searchId',searchId);   
            pg.getParameters().put('counter',counter);   
        }
        else{
            param = ApexPages.currentPage().getParameters().get('searchURL')+'&searchCategory1='+ApexPages.currentPage().getParameters().get('searchCategory1')
                +'&searchPrecision='+ApexPages.currentPage().getParameters().get('searchPrecision')+'&searchType4='+ApexPages.currentPage().getParameters().get('searchType4')
                +'&name='+ApexPages.currentPage().getParameters().get('name')+'&yearStartRange='+ApexPages.currentPage().getParameters().get('yearStartRange')
                +'&yearEndRange='+ApexPages.currentPage().getParameters().get('yearEndRange')+'&date-of-birth='+ApexPages.currentPage().getParameters().get('date-of-birth')
                +'&country='+ApexPages.currentPage().getParameters().get('country');   
            pg.getParameters().put('searchURL',param);        
        }        
          
        pg.setRedirect(true);
        return pg;
    }
    
     public void getMoreDetails(){  
        system.debug('WLSearchExtension :: subjectSearch :: start ');        
        Map<String, String> identificationDetails_identificationtype_Map = new Map<String, String>();
        List<Watchlist_Search_Result_SR__c> watchlistsearchresultsanctionreferencelist = new List<Watchlist_Search_Result_SR__c>();
        List<Watchlist_Search_Result_Role__c> watchlistsearchresultrolelist = new List<Watchlist_Search_Result_Role__c>();
        List<Watchlist_Search_Result_Associate__c> watchlistsearchresultassociatelist = new List<Watchlist_Search_Result_Associate__c>();
        List<Watchlist_Search_Result_Source__c> watchlistsearchresultsourcelist = new List<Watchlist_Search_Result_Source__c>();
        wlsr_DB = [Select w.peid__c, w.wl_content_source__c, w.wl_content_sanc_ref_status__c, API_call_2__c, Temp__c, Adverse_media__c,
                   National_ID__c, National_Insurance_Number__c, Passport_Number__c,
                   matched_name_primary_name__c, matched_name_scripted__c, matched_name_also_known_as__c, 
                   w.wl_content_sanc_ref_start_year__c, w.wl_content_sanc_ref_start_month__c, 
                   w.wl_content_sanc_ref_start_day__c, w.wl_content_sanc_ref_list_prov_name__c, 
                   w.wl_content_sanc_ref_list_prov_code__c, w.wl_content_sanc_ref_end_year__c, 
                   w.wl_content_sanc_ref_end_month__c, w.wl_content_sanc_ref_end_day__c, w.wl_content_sanc_ref_desc2__c, 
                   w.wl_content_profile_notes__c, w.watckist_content_profile_notes__c, w.watchlist_source_details__c, 
                   w.watchlist_content_role_type__c, w.watchlist_content_role_occupation_cat__c,
                   w.watchlist_content_role_occup_start_year__c, w.watchlist_content_role_occup_start_month__c, 
                   w.watchlist_content_role_occup_start_day__c, w.watchlist_content_role_occup_end_year__c, 
                   w.watchlist_content_role_occup_end_month__c, w.watchlist_content_role_occup_end_day__c, w.watchlist_content_notice__c, 
                   w.watchlist_content_descriptions__c, w.watchlist_content_descriptions3__c, w.watchlist_content_descriptions2__c, 
                   w.watchlist_content_active_status__c, w.title_honorific__c, w.surname__c, w.suffix__c, w.so_stake_level_start_year__c, 
                   w.so_stake_level_start_month__c, w.so_stake_level_start_day__c, w.so_stake_level_ownership_percentage__c, 
                   w.so_stake_level_notes__c, w.so_stake_level_end_year__c, w.so_stake_level_end_month__c, w.so_stake_level_end_day__c, 
                   w.so_stake_level_3__c, w.so_stake_level_2__c, w.so_stake_level_1__c, w.so_source_details__c, w.so_profile_notes__c, 
                   w.so_djii_industry_description__c, w.so_djii_industry_Id__c, w.so_descriptions__c, w.so_descriptions3__c, 
                   w.so_descriptions2__c,  w.so_active_status__c, w.osn_language_code__c, w.middle_name__c, 
                   w.maiden_name__c, w.is_birth_place_country_territory__c, w.is_address_country_territory__c, w.is_Country_territory__c, 
                   w.image_url__c, w.identification_notes__c, w.identification_type__c, w.deceased__c, w.date_type__c, w.date_notes__c, 
                   w.country_type__c, w.country_region_code__c, w.country_profile__c, w.country_iso3_code__c, w.country_is02_code__c, 
                   w.birth_place_sub_region__c, w.birth_place_region__c, w.birth_place_name__c, w.birth_place_country_region_code__c, 
                   w.birth_place_country_profile__c, w.birth_place_country_iso3_code__c, w.birth_place_country_iso2_code__c, 
                   w.associate_relationship__c, w.associate_primary_name__c, w.associate_peid__c, w.associate_ex__c, w.associate_description__c, 
                   w.associate_description2__c, w.address_zip_code__c, w.address_url__c, w.address_sub_region__c, w.address_region__c, 
                   w.address_line__c, w.address_country_region_code__c, w.address_country_profile__c, w.address_country_iso3_code__c, 
                   w.address_country_iso2_code__c, w.address_city__c, w.Watchlist_Search__c, w.SystemModstamp, w.Single_String_Name__c, 
                   w.Script_Language_Code__c, w.OwnerId, w.Name, w.LastModifiedDate, w.LastModifiedById,w.IsDeleted, 
                   w.Id, w.First_name__c, w.CurrencyIsoCode, w.CreatedDate, w.CreatedById, w.ConnectionSentId, w.ConnectionReceivedId, 
                   w.Citizenship_Country__c, w.resident_Country__c 
                   From Watchlist_Search_Result__c w where Id =: wlsr.Id];
        system.debug('wlsr_DB in constructor :: '+wlsr_DB);                
        String dowjonesEndPoint = Label.WLPEIDEndpoint ;  
        HttpResponse res;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        if(!wlsr_DB.isEmpty() && wlsr_DB.size() == 1){
            /*if(wlsr_DB.get(0).Resident_Country__c != null && wlsr_DB.get(0).Resident_Country__c.equalsIgnoreCase('United kingdom')){
                wlsr_DB.get(0).Resident_Country__c = 'United Kingdom';
            }
            if(wlsr_DB.get(0).Citizenship_Country__c != null && wlsr_DB.get(0).Citizenship_Country__c.equalsIgnoreCase('United kingdom')){
                wlsr_DB.get(0).Citizenship_Country__c = 'United Kingdom';
            }
            if(wlsr_DB.get(0).birth_place_country_region_code__c != null && wlsr_DB.get(0).birth_place_country_region_code__c.equalsIgnoreCase('United kingdom')){
                wlsr_DB.get(0).birth_place_country_region_code__c = 'United Kingdom';
            }
            */
            if(wlsr_DB.get(0).Adverse_media__c != null){
                adversemedia = wlsr_DB.get(0).Adverse_media__c;
            }
            if(wlsr_DB.get(0).Resident_Country__c != null)
            residentCountry = DDutility.capitalizeFirstCharacter(wlsr_DB.get(0).Resident_Country__c);       
            if(wlsr_DB.get(0).Citizenship_Country__c != null)
            citizenshipCountry = DDutility.capitalizeFirstCharacter(wlsr_DB.get(0).Citizenship_Country__c);     
            if(wlsr_DB.get(0).birth_place_country_region_code__c != null)
            dateOfBirthCountry = DDutility.capitalizeFirstCharacter(wlsr_DB.get(0).birth_place_country_region_code__c);
            system.debug('wlsr_DB.get(0).LastModifiedDate ::'+wlsr_DB.get(0).LastModifiedDate);
            formatteddate = DDUtility.drop_leading_zeros(wlsr_DB.get(0).LastModifiedDate.format('dd MMMM yyyy'));
            system.debug('formatteddate :: '+formatteddate);
            if(wlsr_DB.get(0).National_ID__c != null)
                idn = wlsr_DB.get(0).National_ID__c;
            if(wlsr_DB.get(0).National_Insurance_Number__c != null)
                nin = wlsr_DB.get(0).National_Insurance_Number__c;
            if(wlsr_DB.get(0).Passport_Number__c != null)
                pn = wlsr_DB.get(0).Passport_Number__c;
        //if(String.isNotEmpty(wlsr.peid__c)){
            if(!wlsr_DB.get(0).API_call_2__c && String.isNotEmpty(wlsr_DB.get(0).peid__c))
            req.setEndpoint(dowjonesEndPoint+wlsr_DB.get(0).peid__c+'?include-associate-primary-name=true&ame_article_type=all'); 
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'PEID is missing'));
        }        
        try{
            if(!wlsr_DB.get(0).API_call_2__c){
            system.debug('req :: '+req);
            res = h.send(req);
            system.debug('res :: '+res);
            system.debug('res.getBody() :: '+res.getBody());
            System.debug('res.getStatusCode() :: '+res.getStatusCode());
            if(res.getStatusCode() == 200){
                Dom.Document doc = res.getBodyDocument();
                system.debug('doc :: '+doc);
                Dom.XMLNode rootElement = doc.getRootElement(); 
                //system.debug('api version :: '+rootElement.getAttributeValue(rootElement.getAttributeKeyAt(0), rootElement.getAttributeKeyNsAt(0)));
                if(rootElement.getAttribute('api-version', null) != null){
                    wlsr_DB.get(0).api_version__c = rootElement.getAttributeValue('api-version', null);
                }
                for(Dom.XMLNode child : rootElement.getChildElements()){
                    System.debug('child :: '+child);
                    System.debug('child.getName() :: '+child.getName());
                    if(String.isNotEmpty(child.getName()) && child.getName().equals('person')){ 
                        system.debug('child.getChildEl :: '+child.getChildElement('gender', null).getText());
                        if(child.getChildElement('gender', null) != null){
                            //String temp = child.getChildElement('gender', null).getText().subString(0,1).toLowerCase();
                            String temp = child.getChildElement('gender', null).getText();
                            wlsr_DB.get(0).gender__c = temp.toLowerCase();
                        }
                        if(child.getChildElement('deceased', null) != null){
                            wlsr_DB.get(0).deceased__c = Boolean.valueOf(child.getChildElement('deceased', null).getText());
                        }
                        system.debug('child.getChildEle :: '+child.getChildElement('person-name-details', null).getChildElements());
                        if(child.getChildElement('person-name-details', null) != null){
                            for(Dom.XMLNode child1 : child.getChildElement('person-name-details', null).getChildElements()){
                                system.debug('child1 :: '+child1.getName());
                                if(child1 != null && String.isNotBlank(child1.getName()) && child1.getName().equals('person-names')){  
                                        system.debug('child1.getChildEleme:: '+child1.getChildElement('person-name-value', null));                                    
                                        if(child1.getChildElement('person-name-value', null) != null){
                                            system.debug('child1.getChildEleme111:: '+child1.getChildElement('person-name-value', null).getAttribute('name-type', null)); 
                                            if(child1.getChildElement('person-name-value', null).getAttribute('name-type', null) != null
                                               && child1.getChildElement('person-name-value', null).getAttribute('name-type', null).equals('Primary Name')){
                                                   if(wlsr_DB.get(0).matched_name_primary_name__c != null){
                                                       system.debug('child1.getChildEleme222 if :: '+child1.getChildElement('person-name-value', null).getChildElement('first-name', null));
                                                       if(child1.getChildElement('person-name-value', null).getChildElement('first-name', null) != null){
                                                           wlsr_DB.get(0).matched_name_primary_name__c += '; '+child1.getChildElement('person-name-value', null).getChildElement('first-name', null).getText();
                                                       }
                                                       if(child1.getChildElement('person-name-value', null).getChildElement('middle-name', null) != null){
                                                           wlsr_DB.get(0).matched_name_primary_name__c += ' '+child1.getChildElement('person-name-value', null).getChildElement('middle-name', null).getText();
                                                       }
                                                       if(child1.getChildElement('person-name-value', null).getChildElement('surname', null) != null){
                                                           wlsr_DB.get(0).matched_name_primary_name__c += ' '+child1.getChildElement('person-name-value', null).getChildElement('surname', null).getText();
                                                       }
                                                       
                                                   }
                                                   else{
                                                       system.debug('child1.getChildEleme222 else :: '+child1.getChildElement('person-name-value', null).getChildElement('first-name', null));                                                       
                                                       if(child1.getChildElement('person-name-value', null).getChildElement('first-name', null) != null){
                                                           wlsr_DB.get(0).matched_name_primary_name__c = child1.getChildElement('person-name-value', null).getChildElement('first-name', null).getText();
                                                       }
                                                       system.debug('child1.getChildEleme444 else :: '+child1.getChildElement('person-name-value', null).getChildElement('first-name', null));                                                       
                                                       if(child1.getChildElement('person-name-value', null).getChildElement('middle-name', null) != null){
                                                           wlsr_DB.get(0).matched_name_primary_name__c += ' '+child1.getChildElement('person-name-value', null).getChildElement('middle-name', null).getText();
                                                       }
                                                       system.debug('child1.getChildEleme333 else :: '+child1.getChildElement('person-name-value', null).getChildElement('first-name', null));                                                       
                                                       if(child1.getChildElement('person-name-value', null).getChildElement('surname', null) != null){
                                                           wlsr_DB.get(0).matched_name_primary_name__c += ' '+child1.getChildElement('person-name-value', null).getChildElement('surname', null).getText();
                                                       }
                                                       
                                                   }
                                               }
                                            system.debug('wlsr_DB.get(0).matched_name_primary_name__c :: '+wlsr_DB.get(0).matched_name_primary_name__c);
                                            //system.debug('derfff111 :: '+child1.getChildElement('person-names-group', null));
                                            //system.debug('derfff222 :: '+child1.getChildElement('person-names-group', null).getChildElement('person-names', null));
                                            //system.debug('derfff333 :: '+child1.getChildElement('person-names-group', null).getChildElement('person-names', null).getChildElement('person-name-value', null));
                                            //system.debug('derfff :: '+child1.getChildElement('person-names-group', null).getChildElement('person-names', null).getChildElement('person-name-value', null).getAttribute('name-type', null));
                                            if(child1.getChildElement('person-names-group', null) != null
                                              && child1.getChildElement('person-names-group', null).getChildElement('person-names', null) != null
                                              && child1.getChildElement('person-names-group', null).getChildElement('person-names', null).getChildElement('person-name-value', null) != null){       
                                                  if(child1.getChildElement('person-names-group', null).getChildElement('person-names', null).getChildElement('person-name-value', null).getAttribute('name-type', null) !=null
                                                    && child1.getChildElement('person-names-group', null).getChildElement('person-names', null).getChildElement('person-name-value', null).getAttribute('name-type', null).equals('Original Script Name')){
                                                        if(child1.getChildElement('person-names-group', null).getChildElement('person-names', null).getChildElement('person-name-value', null).getChildElement('original-script-name', null) != null){
                                                            if(wlsr_DB.get(0).matched_name_scripted__c   != null){   
                                                                wlsr_DB.get(0).matched_name_scripted__c += ';'+child1.getChildElement('person-names-group', null).getChildElement('person-names', null).getChildElement('person-name-value', null).getChildElement('original-script-name', null).getText();
                                                            }
                                                            else{ 
                                                                wlsr_DB.get(0).matched_name_scripted__c = child1.getChildElement('person-names-group', null).getChildElement('person-names', null).getChildElement('person-name-value', null).getChildElement('original-script-name', null).getText();   
                                                            }
                                                        }
                                                    }
                                            }
                                            system.debug('wlsr_DB.get(0).matched_name_scripted__c :: '+wlsr_DB.get(0).matched_name_scripted__c);
                                            if(child1 != null && String.isNotBlank(child1.getName()) && child1.getName().equals('person-names')){                                      
                                                if(child1.getChildElement('person-name-value', null) != null){
                                                    if(child1.getChildElement('person-name-value', null).getAttribute('name-type', null) != null
                                                       && child1.getChildElement('person-name-value', null).getAttribute('name-type', null).equals('Also Known As')){
                                                           if(wlsr_DB.get(0).matched_name_also_known_as__c != null){
                                                               if(child1.getChildElement('person-name-value', null).getChildElement('first-name', null) != null){
                                                                   wlsr_DB.get(0).matched_name_also_known_as__c += '; '+child1.getChildElement('person-name-value', null).getChildElement('first-name', null).getText();
                                                               }
                                                               if(child1.getChildElement('person-name-value', null).getChildElement('surname', null) != null){
                                                                   wlsr_DB.get(0).matched_name_also_known_as__c += ' '+child1.getChildElement('person-name-value', null).getChildElement('surname', null).getText();
                                                               }
                                                               if(child1.getChildElement('person-name-value', null).getChildElement('middle-name', null) != null){
                                                                   wlsr_DB.get(0).matched_name_also_known_as__c += ' '+child1.getChildElement('person-name-value', null).getChildElement('middle-name', null).getText();
                                                               }
                                                           } 
                                                           else{
                                                               if(child1.getChildElement('person-name-value', null).getChildElement('first-name', null) != null){
                                                                   wlsr_DB.get(0).matched_name_also_known_as__c = child1.getChildElement('person-name-value', null).getChildElement('first-name', null).getText();
                                                               }
                                                               if(child1.getChildElement('person-name-value', null).getChildElement('surname', null) != null){
                                                                   wlsr_DB.get(0).matched_name_also_known_as__c += ' '+child1.getChildElement('person-name-value', null).getChildElement('surname', null).getText();
                                                               }
                                                               if(child1.getChildElement('person-name-value', null).getChildElement('middle-name', null) != null){
                                                                   wlsr_DB.get(0).matched_name_also_known_as__c += ' '+child1.getChildElement('person-name-value', null).getChildElement('middle-name', null).getText();
                                                               } 
                                                           }
                                                       }
                                                }
                                            }    
                                            system.debug('wlsr_DB.get(0).matched_name_also_known_as__c :: '+wlsr_DB.get(0).matched_name_also_known_as__c);
                                               /*if(child1.getChildElement('person-name-value', null).getChildElement('original-script-name', null).getChildElement('osn-language-code', null) != null){
                                                   if(wlsr_DB.get(0).osn_language_code__c != null){
                                                       wlsr_DB.get(0).osn_language_code__c +=  child1.getChildElement('person-name-value', null).getChildElement('original-script-name', null).getChildElement('osn-language-code', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).osn_language_code__c =  child1.getChildElement('person-name-value', null).getChildElement('original-script-name', null).getChildElement('osn-language-code', null).getText()+';';
                                                   }
                                               }
                                               if(child1.getChildElement('person-name-value', null).getChildElement('original-script-name', null).getChildElement('script-language-code', null) != null){
                                                   if(wlsr_DB.get(0).Script_Language_Code__c != null){
                                                       wlsr_DB.get(0).Script_Language_Code__c +=  child1.getChildElement('person-name-value', null).getChildElement('original-script-name', null).getChildElement('script-language-code', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).Script_Language_Code__c =  child1.getChildElement('person-name-value', null).getChildElement('original-script-name', null).getChildElement('script-language-code', null).getText()+';';                                                   
                                                   }
                                               }
                                               if(child1.getChildElement('person-names', null).getChildElement('person-name-value', null).getChildElement('single-string-name', null) != null){
                                                   if(wlsr_DB.get(0).Single_String_Name__c != null){
                                                       wlsr_DB.get(0).Single_String_Name__c +=  child1.getChildElement('person-names', null).getChildElement('person-name-value', null).getChildElement('single-string-name', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).Single_String_Name__c =  child1.getChildElement('person-names', null).getChildElement('person-name-value', null).getChildElement('single-string-name', null).getText()+';';
                                                   }
                                               }
                                               if(child1.getChildElement('person-names', null).getChildElement('person-name-value', null).getChildElement('maiden-name', null) != null){
                                                   if(wlsr_DB.get(0).maiden_name__c != null){
                                                       wlsr_DB.get(0).maiden_name__c +=  child1.getChildElement('person-names', null).getChildElement('person-name-value', null).getChildElement('maiden-name', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).maiden_name__c =  child1.getChildElement('person-names', null).getChildElement('person-name-value', null).getChildElement('maiden-name', null).getText()+';';
                                                   }
                                               }*/
                                               if(child1.getChildElement('person-name-value', null).getChildElement('title-honorific', null) != null){
                                                   if(wlsr_DB.get(0).title_honorific__c != null){
                                                       wlsr_DB.get(0).title_honorific__c +=  child1.getChildElement('person-name-value', null).getChildElement('title-honorific', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).title_honorific__c =  child1.getChildElement('person-name-value', null).getChildElement('title-honorific', null).getText()+';';
                                                   }
                                               }
                                               if(child1.getChildElement('person-name-value', null).getChildElement('first-name', null) != null){
                                                   if(wlsr_DB.get(0).First_name__c != null){
                                                       wlsr_DB.get(0).First_name__c += child1.getChildElement('person-name-value', null).getChildElement('first-name', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).First_name__c = child1.getChildElement('person-name-value', null).getChildElement('first-name', null).getText()+';';
                                                   }
                                               }
                                               if(child1.getChildElement('person-name-value', null).getChildElement('middle-name', null) != null){
                                                   if(wlsr_DB.get(0).middle_name__c != null){
                                                       wlsr_DB.get(0).middle_name__c +=  child1.getChildElement('person-name-value', null).getChildElement('middle-name', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).middle_name__c =  child1.getChildElement('person-name-value', null).getChildElement('middle-name', null).getText()+';';
                                                   }
                                               }
                                               if(child1.getChildElement('person-name-value', null).getChildElement('surname', null) != null){
                                                   if(wlsr_DB.get(0).surname__c != null){
                                                       wlsr_DB.get(0).surname__c +=  child1.getChildElement('person-name-value', null).getChildElement('surname', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).surname__c =  child1.getChildElement('person-name-value', null).getChildElement('surname', null).getText()+';';
                                                   }
                                               }
                                               if(child1.getChildElement('person-name-value', null).getChildElement('suffix', null) != null){
                                                   if(wlsr_DB.get(0).suffix__c != null){
                                                       wlsr_DB.get(0).suffix__c +=  child1.getChildElement('person-name-value', null).getChildElement('suffix', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).suffix__c =  child1.getChildElement('person-name-value', null).getChildElement('suffix', null).getText()+';';
                                                   }
                                               }
                                               if(child1.getChildElement('person-name-value', null).getAttribute('person-name-value', null) != null){
                                                   if(wlsr_DB.get(0).name_type__c != null){
                                                       wlsr_DB.get(0).name_type__c += String.valueOf(child1.getChildElement('person-name-value', null).getAttribute('person-name-value', null))+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).name_type__c = String.valueOf(child1.getChildElement('person-name-value', null).getAttribute('person-name-value', null))+';';
                                                   }
                                               }
                                           }
                                    } 
                                //}
                            }
                        }                        
                        system.debug('wlsr_DB.get(0) 1 :: '+wlsr_DB.get(0));
                        if(child.getChildElement('date-details', null) != null && child.getChildElement('date-details', null).getChildElement('date', null) != null){
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('date-type', null) != null){
                                wlsr_DB.get(0).date_type__c = child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('date-type', null);
                            }
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('day', null) != null){
                                //wlsr_DB.get(0).day__c = Decimal.valueOf(child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('day', null));
                            }
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('month', null) != null){
                                //wlsr_DB.get(0).month__c = Decimal.valueOf(child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('month', null));
                            }
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('year', null) != null){
                                //wlsr_DB.get(0).year__c = Decimal.valueOf(child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('year', null));
                            }
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('date-notes', null) != null){
                                wlsr_DB.get(0).date_notes__c = child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('date-notes', null);
                            }
                        }
                        if(child.getChildElement('birth-place-details', null) != null && child.getChildElement('birth-place-details', null).getChildElement('birth-place', null) != null){
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('place-name', null) != null ){
                                wlsr_DB.get(0).birth_place_name__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('place-name', null).getText();
                            }
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('region', null) != null ){
                                wlsr_DB.get(0).birth_place_region__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('region', null).getText();
                            }    
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('sub-region', null) != null ){
                                wlsr_DB.get(0).birth_place_sub_region__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('sub-region', null).getText();
                            }
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('sub-region', null) != null ){
                                wlsr_DB.get(0).birth_place_sub_region__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('sub-region', null).getText();
                            }
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null) != null){
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('djii-region-code', null) != null){
                                    //String temp = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                    String temp = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getText();
                                    //dateOfBirthCountry = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                    system.debug('temp :: '+temp);
                                    /*if(!String.isEmpty(temp)){
                                        String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                        system.debug('temp2 :: '+temp2);
                                        wlsr_DB.get(0).birth_place_country_region_code__c = temp2.subString(0,1)+temp2.subString(1, temp2.length()).toLowerCase();
                                        system.debug('wlsr_DB.get(0).birth_place_country_region_code__c  :: '+wlsr_DB.get(0).birth_place_country_region_code__c );
                                        if(wlsr_DB.get(0).birth_place_country_region_code__c != null && wlsr_DB.get(0).birth_place_country_region_code__c.equalsIgnoreCase('United kingdom')){
                                            wlsr_DB.get(0).birth_place_country_region_code__c = 'United Kingdom';
                                        }                                                                                
                                    }    */                                     
                                    dateOfBirthCountry = DDutility.capitalizeFirstCharacter(temp);//wlsr_DB.get(0).birth_place_country_region_code__c;
                                    system.debug('dateOfBirthCountry after  :: '+dateOfBirthCountry);
                                    wlsr_DB.get(0).birth_place_country_region_code__c = dateOfBirthCountry;
                                }
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('iso2-country-code', null) != null){
                                    wlsr_DB.get(0).birth_place_country_iso2_code__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('iso2-country-code', null);
                                }
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('iso3-country-code', null) != null){
                                    wlsr_DB.get(0).birth_place_country_iso3_code__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('iso3-country-code', null);
                                }
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('is-territory', null) != null){
                                    wlsr_DB.get(0).is_birth_place_country_territory__c = Boolean.valueOf(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('is-territory', null));
                                }
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('country-profile', null) != null){
                                    wlsr_DB.get(0).birth_place_country_profile__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('country-profile', null);
                                }
                            }
                        }
                        if(child.getChildElement('country-details', null) != null){
                            for(Dom.XMLNode child1 : child.getChildElement('country-details', null).getChildElements()){
                                if(child1.getName().equals('country-value')){
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('djii-region-code', null) != null){
                                           if(wlsr_DB.get(0).country_region_code__c != null){
                                               wlsr_DB.get(0).country_region_code__c += child1.getChildElement('country', null).getAttributeValue('djii-region-code', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).country_region_code__c = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null)+';';
                                           } 
                                       }
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('iso2-country-code', null) != null){
                                           if(wlsr_DB.get(0).country_is02_code__c != null){
                                               wlsr_DB.get(0).country_is02_code__c += child1.getChildElement('country', null).getAttributeValue('iso2-country-code', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).country_is02_code__c = child1.getChildElement('country', null).getAttributeValue('iso2-country-code', null)+';';
                                           } 
                                       }
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('iso3-country-code', null) != null){
                                           if(wlsr_DB.get(0).country_iso3_code__c != null){
                                               wlsr_DB.get(0).country_iso3_code__c += child1.getChildElement('country', null).getAttributeValue('iso3-country-code', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).country_iso3_code__c = child1.getChildElement('country', null).getAttributeValue('iso3-country-code', null)+';';
                                           } 
                                       } 
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('is-territory', null) != null){
                                           if(wlsr_DB.get(0).is_Country_territory__c != null){
                                               wlsr_DB.get(0).is_Country_territory__c += child1.getChildElement('country', null).getAttributeValue('is-territory', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).is_Country_territory__c = child1.getChildElement('country', null).getAttributeValue('is-territory', null)+';';
                                           }
                                       }
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('country-profile', null) != null){
                                           if(wlsr_DB.get(0).country_profile__c != null){
                                               wlsr_DB.get(0).country_profile__c += child1.getChildElement('country', null).getAttributeValue('country-profile', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).country_profile__c = child1.getChildElement('country', null).getAttributeValue('country-profile', null)+';';
                                           } 
                                       }
                                    if(child1.getAttribute('country-type', null) != null){ 
                                           if(wlsr_DB.get(0).country_type__c != null){
                                               //wlsr_DB.get(0).country_type__c +=  ';'+child1.getAttributeValue('country-type', null);
                                               if (child1.getAttributeValue('country-type', null).startsWith('Resident')){
                                                   //String temp = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null); 
                                                   String temp = child1.getChildElement('country', null).getText();                                                      
                                                   //String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                                   residentCountry = ';'+DDutility.capitalizeFirstCharacter(temp);//temp2.subString(0,1)+temp.subString(1,temp.length()).toLowerCase();
                                                   //wlsr_DB.get(0).Resident_Country__c = ';'+child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                               }
                                               else if(child1.getAttributeValue('country-type', null).startsWith('Citizen')){
                                                   //String temp = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                                   String temp = child1.getChildElement('country', null).getText();    
                                                   String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                                   citizenshipCountry = ';'+DDutility.capitalizeFirstCharacter(temp);//+temp2.subString(0,1)+temp.subString(1,temp.length()).toLowerCase();
                                                   //wlsr_DB.get(0).Citizenship_Country__c = ';'+child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                               }
                                           }
                                           else{
                                               //wlsr_DB.get(0).country_type__c = child1.getAttributeValue('country-type', null); 
                                               if(child1.getAttributeValue('country-type', null).startsWith('Resident')){
                                                   //String temp = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                                   String temp = child1.getChildElement('country', null).getText();    
                                                   String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                                   residentCountry = +DDutility.capitalizeFirstCharacter(temp);//(temp2.subString(0,1)+temp.subString(1,temp.length()).toLowerCase();
                                                   //wlsr_DB.get(0).Resident_Country__c = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                               }
                                               else if(child1.getAttributeValue('country-type', null).startsWith('Citizen')){
                                                   //String temp = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                                   String temp = child1.getChildElement('country', null).getText();    
                                                   String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                                   citizenshipCountry = +DDutility.capitalizeFirstCharacter(temp);//temp2.subString(0,1)+temp.subString(1,temp.length()).toLowerCase();
                                                   //wlsr_DB.get(0).Citizenship_Country__c = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                               }
                                           }  
                                       }
                                    /*if(residentCountry != null && residentCountry.equalsIgnorecase('United kingdom')){
                                        residentCountry = 'United Kingdom';
                                    }
                                    if(citizenshipCountry != null && citizenshipCountry.equalsIgnorecase('United kingdom')){
                                        citizenshipCountry = 'United Kingdom';
                                    }*/
                                    wlsr_DB.get(0).Resident_Country__c =  DDutility.capitalizeFirstCharacter(residentCountry);                          
                                    wlsr_DB.get(0).Citizenship_Country__c = DDutility.capitalizeFirstCharacter(citizenshipCountry);           
                                }
                            }
                              
                              if(child.getChildElement('address-details', null) != null){
                                  for(Dom.XMLNode child1 : child.getChildElement('address-details', null).getChildElements()){
                                      if(child1.getName().equals('address')){
                                          if(child1.getChildElement('address-line', null) != null){
                                              if(wlsr_DB.get(0).address_line__c != null){
                                                  wlsr_DB.get(0).address_line__c += ';'+child1.getChildElement('address-line', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_line__c = child1.getChildElement('address-line', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('city', null) != null){
                                              if(wlsr_DB.get(0).address_city__c != null){
                                                  wlsr_DB.get(0).address_city__c += ';'+child1.getChildElement('city', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_city__c = child1.getChildElement('city', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('region', null) != null){
                                              if(wlsr_DB.get(0).address_region__c != null){
                                                  wlsr_DB.get(0).address_region__c += ';'+child1.getChildElement('region', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_region__c = child1.getChildElement('region', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('sub-region', null) != null){
                                              if(wlsr_DB.get(0).address_sub_region__c != null){
                                                  wlsr_DB.get(0).address_sub_region__c += ';'+child1.getChildElement('sub-region', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_sub_region__c = child1.getChildElement('sub-region', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('zip-code', null) != null){
                                              if(wlsr_DB.get(0).address_zip_code__c != null){
                                                  wlsr_DB.get(0).address_zip_code__c += ';'+child1.getChildElement('zip-code', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_zip_code__c = child1.getChildElement('zip-code', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('djii-region-code', null) != null){
                                                 if(wlsr_DB.get(0).address_country_region_code__c != null){
                                                     wlsr_DB.get(0).address_country_region_code__c += ';'+child1.getChildElement('country', null).getAttribute('djii-region-code', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).address_country_region_code__c = child1.getChildElement('country', null).getAttribute('djii-region-code', null);
                                                 }
                                             }
                                          if(child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('iso2-country-code', null) != null){
                                                 if(wlsr_DB.get(0).address_country_iso2_code__c != null){
                                                     wlsr_DB.get(0).address_country_iso2_code__c += ';'+child1.getChildElement('country', null).getAttribute('iso2-country-code', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).address_country_iso2_code__c = child1.getChildElement('country', null).getAttribute('iso2-country-code', null);
                                                 }
                                             }
                                          if(child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('iso3-country-code', null) != null){
                                                 if(wlsr_DB.get(0).address_country_iso3_code__c != null){
                                                     wlsr_DB.get(0).address_country_iso3_code__c += ';'+child1.getChildElement('country', null).getAttribute('iso3-country-code', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).address_country_iso3_code__c = child1.getChildElement('country', null).getAttribute('iso3-country-code', null);
                                                 }
                                             }
                                          if(child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('is-territory', null) != null){
                                                 if(wlsr_DB.get(0).is_address_country_territory__c != null){
                                                     wlsr_DB.get(0).is_address_country_territory__c += ';'+child1.getChildElement('country', null).getAttribute('iso3-country-code', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).is_address_country_territory__c = child1.getChildElement('country', null).getAttribute('iso3-country-code', null);
                                                 }
                                             }
                                          if(child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('country-profile', null) != null){
                                                 if(wlsr_DB.get(0).address_country_profile__c != null){
                                                     wlsr_DB.get(0).address_country_profile__c += ';'+child1.getChildElement('country', null).getAttribute('country-profile', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).address_country_profile__c = child1.getChildElement('country', null).getAttribute('country-profile', null);
                                                 }
                                             }
                                          if(child1.getChildElement('address-url', null) != null){
                                              if(wlsr_DB.get(0).address_url__c != null){
                                                  wlsr_DB.get(0).address_url__c += ';'+child1.getChildElement('address-url', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_url__c = child1.getChildElement('address-url', null).gettext();
                                              }
                                          }
                                      }
                                  }
                              }
                              
                            if(child.getChildElement('identification-details', null) != null){                                
                                String temp = '';
                                for(Dom.XMLNode child1 : child.getChildElement('identification-details', null).getChildElements()){
                                    if(child1.getName().equals('identification')){
                                        if(child1.getAttribute('identification-type', null) != null){
                                            if(child1.getAttributeValue('identification-type', null).contains('National ID')){
                                                idn = /*child1.getAttributeValue('identification-type', null)+':'+*/child1.gettext();
                                                wlsr_DB.get(0).National_ID__c = idn;
                                            }  
                                            else if(child1.getAttributeValue('identification-type', null).contains('National Insurance')){
                                                nin = /*child1.getAttributeValue('identification-type', null)+':'+*/child1.gettext();
                                                wlsr_DB.get(0).National_Insurance_Number__c = nin;
                                            }
                                            else if(child1.getAttributeValue('identification-type', null).contains('Passport')){
                                                pn = /*child1.getAttributeValue('identification-type', null)+':'+*/child1.gettext();
                                                wlsr_DB.get(0).Passport_Number__c = pn;
                                            }                                                                                                                                                                                                                                                              
                                            else{
                                                if(temp != ''){
                                                    temp += ';'+child1.getAttributeValue('identification-type', null)+':'+child1.gettext();
                                                }
                                                else{
                                                    temp = child1.getAttributeValue('identification-type', null)+':'+child1.gettext();
                                                }
                                            }
                                        }
                                        /*if(child1.getAttribute('identification-notes', null) != null){
                                            if(wlsr_DB.get(0).identification_notes__c != null){
                                                wlsr_DB.get(0).identification_notes__c += child1.getAttribute('identification-notes', null)+';';
                                            }
                                            else{
                                                wlsr_DB.get(0).identification_notes__c = child1.getAttribute('identification-notes', null)+';';
                                            }
                                        }*/
                                    }
                                }
                                wlsr_DB.get(0).identification_type__c = idn+';'+pn+';'+nin+';'+temp;
                            }
                            if(child.getChildElement('image-details', null) != null){                                  
                                for(Dom.XMLNode child1 : child.getChildElement('image-details', null).getChildElements()){
                                    if(child1.getName().equals('image-url')){
                                        if(wlsr_DB.get(0).image_url__c != null){
                                            wlsr_DB.get(0).image_url__c += child1.getText()+';';
                                        }
                                        else{
                                            wlsr_DB.get(0).image_url__c = child1.getText()+';';
                                        }
                                    }
                                }
                            }
                            if(child.getChildElement('watchlist-content', null) != null
                               && child.getChildElement('watchlist-content', null).getChildElement('content-notice', null) != null){
                                   wlsr_DB.get(0).watchlist_content_notice__c = child.getChildElement('watchlist-content', null).getChildElement('content-notice', null).getText();
                               }
                              if(child.getChildElement('watchlist-content', null) != null
                                && child.getChildElement('watchlist-content', null).getChildElement('active-status', null) != null){
                                    wlsr_DB.get(0).watchlist_content_active_status__c = child.getChildElement('watchlist-content', null).getChildElement('active-status', null).getText();
                              }
                              if(child.getChildElement('watchlist-content', null) != null){
                                    for(Dom.XMLNode child1 : child.getChildElement('watchlist-content', null).getChildElements()){
                                        if(child1.getName().equals('description')){
                                            if(child1.getChildElement('description', null).getAttribute('description1', null) != null){
                                                if(wlsr_DB.get(0).watchlist_content_descriptions__c != null){
                                                    wlsr_DB.get(0).watchlist_content_descriptions__c += child1.getChildElement('description', null).getAttribute('description1', null)+';';
                                                }
                                                else{
                                                    wlsr_DB.get(0).watchlist_content_descriptions__c = child1.getChildElement('description', null).getAttribute('description1', null)+';';
                                                }
                                            }
                                            if(child1.getChildElement('description', null).getAttribute('description2', null) != null){
                                                if(wlsr_DB.get(0).watchlist_content_descriptions2__c != null){
                                                    wlsr_DB.get(0).watchlist_content_descriptions2__c += child1.getChildElement('description', null).getAttribute('description2', null)+';';
                                                }
                                                else{
                                                    wlsr_DB.get(0).watchlist_content_descriptions2__c = child1.getChildElement('description', null).getAttribute('description2', null)+';';
                                                }
                                            }
                                            if(child1.getChildElement('description', null).getAttribute('description3', null) != null){
                                                if(wlsr_DB.get(0).watchlist_content_descriptions3__c != null){
                                                    wlsr_DB.get(0).watchlist_content_descriptions3__c += child1.getChildElement('description', null).getAttribute('description3', null)+';';
                                                }
                                                else{
                                                    wlsr_DB.get(0).watchlist_content_descriptions3__c = child1.getChildElement('description', null).getAttribute('description3', null)+';';
                                                }
                                            }
                                        }
                                    }                                    
                                }                                                        
                            if(child.getChildElement('adverse-media-content', null) != null){
                                wlsr_DB.get(0).Adverse_media__c = true;
                                adversemedia = true;
                            }
                            system.debug('child.getChildElement associates  :: '+child.getChildElement('associates', null));
                            if(child.getChildElement('associates', null) != null){
                                for(Dom.XMLNode child1 : child.getChildElement('associates', null).getChildElements()){
                                    system.debug('child1.getName() :: '+child1.getName());
                                    Watchlist_Search_Result_Associate__c wlsra = new Watchlist_Search_Result_Associate__c();                                    
                                    if(child1.getName().equals('associate')){
                                        wlsra.Watchlist_Search_Result__c = wlsr.Id;
                                        if(child1.getAttribute('peid', null) != null){
                                            wlsra.peid__c = child1.getAttribute('peid', null);
                                            /*if(wlsr_DB.get(0).associate_peid__c != null){
                                                wlsr_DB.get(0).associate_peid__c += child1.getChildElement('associate', null).getAttribute('peid', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_peid__c = child1.getChildElement('associate', null).getAttribute('peid', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('primary-name', null) != null){
                                            wlsra.primary_name__c = child1.getAttribute('primary-name', null);
                                            /*if(wlsr_DB.get(0).associate_primary_name__c != null){
                                                wlsr_DB.get(0).associate_primary_name__c += child1.getChildElement('associate', null).getAttribute('primary-name', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_primary_name__c = child1.getChildElement('associate', null).getAttribute('primary-name', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('relationship', null) != null){
                                            wlsra.relationship__c = child1.getAttribute('relationship', null);
                                            /*if(wlsr_DB.get(0).associate_relationship__c != null){
                                                wlsr_DB.get(0).associate_relationship__c += child1.getChildElement('associate', null).getAttribute('relationship', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_relationship__c = child1.getChildElement('associate', null).getAttribute('relationship', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('description1', null) != null){
                                            wlsra.description1__c = child1.getAttribute('description1', null);
                                            /*if(wlsr_DB.get(0).associate_description__c != null){
                                                wlsr_DB.get(0).associate_description__c += child1.getChildElement('associate', null).getAttribute('description1', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_description__c = child1.getChildElement('associate', null).getAttribute('description1', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('description2', null) != null){
                                            wlsra.description2__c = child1.getAttribute('description2', null);
                                            /*if(wlsr_DB.get(0).associate_description2__c != null){
                                                wlsr_DB.get(0).associate_description2__c += child1.getChildElement('associate', null).getAttribute('description2', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_description2__c = child1.getChildElement('associate', null).getAttribute('description2', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('ex', null) != null){
                                            wlsra.ex__c = child1.getAttribute('ex', null);
                                            /*if(wlsr_DB.get(0).associate_ex__c != null){
                                                wlsr_DB.get(0).associate_ex__c += child1.getChildElement('associate', null).getAttribute('ex', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_ex__c = child1.getChildElement('associate', null).getAttribute('ex', null);    
                                            }*/
                                        }
                                    }
                                    watchlistsearchresultassociatelist.add(wlsra);
                                }
                            }
                            system.debug('watchlistsearchresultassociatelist :: '+watchlistsearchresultassociatelist);
                            if(!watchlistsearchresultassociatelist.isEmpty()){
                                insert watchlistsearchresultassociatelist;
                            }
                            
                              if(child.getChildElement('watchlist-content', null) != null
                                 && child.getChildElement('watchlist-content', null).getChildElement('role-details', null) != null){
                                     for(Dom.XMLNode child1 : child.getChildElement('watchlist-content', null).getChildElement('role-details', null).getChildElements()){                                        
                                         Watchlist_Search_Result_Role__c wlsrr = new Watchlist_Search_Result_Role__c();
                                         if(child1.getName().equals('role')){                                               
                                             wlsrr.Watchlist_Search_Result__c = wlsr.Id;
                                             if(child1.getChildElement('occupation-title', null).getAttribute('occupation-category', null) != null){
                                                 wlsrr.occupation_category_value__c = child1.getChildElement('occupation-title', null).getText();
                                                 wlsrr.Occupation_category__c = child1.getChildElement('occupation-title', null).getAttribute('occupation-category', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occupation_cat__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occupation_cat__c += child1.getChildElement('occupation-title', null).getAttribute('occupation-category', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occupation_cat__c = child1.getChildElement('occupation-title', null).getAttribute('occupation-category', null)+';';
                                                 } */
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('since-day', null) != null){
                                                 wlsrr.since_day__c = child1.getChildElement('occupation-title', null).getAttribute('since-day', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_start_day__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_day__c += child1.getChildElement('occupation-title', null).getAttribute('since-day', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_day__c = child1.getChildElement('occupation-title', null).getAttribute('since-day', null)+';';
                                                 } */
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('since-month', null) != null){
                                                 wlsrr.since_month__c = child1.getChildElement('occupation-title', null).getAttribute('since-month', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_start_month__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_month__c += child1.getChildElement('occupation-title', null).getAttribute('since-month', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_month__c = child1.getChildElement('occupation-title', null).getAttribute('since-month', null)+';';
                                                 } */
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('since-year', null) != null){
                                                 wlsrr.since_year__c = child1.getChildElement('occupation-title', null).getAttribute('since-year', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_start_year__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_year__c += child1.getChildElement('occupation-title', null).getAttribute('since-year', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_year__c = child1.getChildElement('occupation-title', null).getAttribute('since-year', null)+';';
                                                 }*/
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('to-day', null) != null){
                                                 wlsrr.to_day__c = child1.getChildElement('occupation-title', null).getAttribute('to-day', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_end_day__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_day__c += child1.getChildElement('occupation-title', null).getAttribute('to-day', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_day__c = child1.getChildElement('occupation-title', null).getAttribute('to-day', null)+';';
                                                 }*/
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('to-month', null) != null){
                                                 wlsrr.to_month__c = child1.getChildElement('occupation-title', null).getAttribute('to-month', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_end_month__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_month__c += child1.getChildElement('occupation-title', null).getAttribute('to-month', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_month__c = child1.getChildElement('occupation-title', null).getAttribute('to-month', null)+';';
                                                 }*/
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('to-year', null) != null){
                                                 wlsrr.to_year__c = child1.getChildElement('occupation-title', null).getAttribute('to-year', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_end_year__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_year__c += child1.getChildElement('occupation-title', null).getAttribute('to-year', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_year__c = child1.getChildElement('occupation-title', null).getAttribute('to-year', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('role-type', null) != null){
                                                 wlsrr.role_type__c = child1.getAttribute('role-type', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_type__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_type__c += child1.getAttribute('role-type', null)+';'; 
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_type__c = child1.getAttribute('role-type', null)+ ';'; 
                                                 }*/
                                             }
                                         }
                                         watchlistsearchresultrolelist.add(wlsrr);
                                     }                                            
                                 }
                            if(!watchlistsearchresultrolelist.isEmpty()){
                                insert watchlistsearchresultrolelist;
                            }
                              if(child.getChildElement('watchlist-content', null) != null
                                 && child.getChildElement('watchlist-content', null).getChildElement('sanctions-reference-details', null) != null){
                                     for(Dom.XMLNode child1 : child.getChildElement('watchlist-content', null).getChildElement('sanctions-reference-details', null).getChildElements()){   
                                         Watchlist_Search_Result_SR__c wlsrsr = new Watchlist_Search_Result_SR__c();
                                         system.debug('child1.getName() :: '+child1.getName());
                                         system.debug('child1.getText() :: '+child1.getText());
                                         system.debug('child1 fff :: '+child1.getAttribute('list-provider-code', null));
                                         wlsrsr.Watchlist_Search_Result__c = wlsr.Id;
                                         if(child1.getName().equals('sanctions-reference')){
                                             wlsrsr.value__c = child1.getText();
                                             if(child1.getAttribute('list-provider-name', null) != null){
                                                 wlsrsr.List_Provider_Name__c = child1.getAttribute('list-provider-name', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_list_prov_name__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_list_prov_name__c += child1.getAttribute('list-provider-name', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_list_prov_name__c = child1.getChildElement('sanctions-reference', null).getAttribute('list-provider-name', null)+';';
                                                 }*/
                                             }                                             
                                             if(child1.getAttribute('list-provider-code', null) != null){
                                                 wlsrsr.List_Provider_Code__c = child1.getAttribute('list-provider-code', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_list_prov_code__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_list_prov_code__c += child1.getChildElement('sanctions-reference', null).getAttribute('list-provider-code', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_list_prov_code__c = child1.getChildElement('sanctions-reference', null).getAttribute('list-provider-code', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('description2', null) != null){
                                                 wlsrsr.Description2__c = child1.getAttribute('description2', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_desc2__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_desc2__c += child1.getChildElement('sanctions-reference', null).getAttribute('description2', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_desc2__c = child1.getChildElement('sanctions-reference', null).getAttribute('description2', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('status', null) != null){
                                                 wlsrsr.status__c = child1.getAttribute('status', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_status__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_status__c += child1.getChildElement('sanctions-reference', null).getAttribute('status', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_status__c = child1.getChildElement('sanctions-reference', null).getAttribute('status', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('since-day', null) != null){
                                                 wlsrsr.Since_Day__c = child1.getAttribute('since-day', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_start_day__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_day__c += child1.getChildElement('sanctions-reference', null).getAttribute('since-day', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_day__c = child1.getChildElement('sanctions-reference', null).getAttribute('since-day', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('since-month', null) != null){
                                                 wlsrsr.since_month__c = child1.getAttribute('since-month', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_start_month__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_month__c += child1.getChildElement('sanctions-reference', null).getAttribute('since-month', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_month__c = child1.getChildElement('sanctions-reference', null).getAttribute('since-month', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('since-year', null) != null){
                                                 wlsrsr.since_year__c = child1.getAttribute('since-year', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_start_year__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_year__c += child1.getChildElement('sanctions-reference', null).getAttribute('since-year', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_year__c = child1.getChildElement('sanctions-reference', null).getAttribute('since-year', null)+';';
                                                 }*/
                                             }                                         
                                             if(child1.getAttribute('to-day', null) != null){
                                                 wlsrsr.to_day__c = child1.getAttribute('to-day', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_end_day__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_day__c += child1.getChildElement('sanctions-reference', null).getAttribute('to-day', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_day__c = child1.getChildElement('sanctions-reference', null).getAttribute('to-day', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('to-month', null) != null){
                                                 wlsrsr.to_month__c = child1.getAttribute('to-month', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_end_month__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_month__c += child1.getChildElement('sanctions-reference', null).getAttribute('to-month', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_month__c = child1.getChildElement('sanctions-reference', null).getAttribute('to-month', null) +';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('to-year', null) != null){
                                                 wlsrsr.to_year__c = child1.getAttribute('to-year', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_end_year__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_year__c += child1.getChildElement('sanctions-reference', null).getAttribute('to-year', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_year__c = child1.getChildElement('sanctions-reference', null).getAttribute('to-year', null)+';';
                                                 }*/
                                             }
                                             watchlistsearchresultsanctionreferencelist.add(wlsrsr);
                                         }                                         
                                     }                                     
                                 }
                            if(!watchlistsearchresultsanctionreferencelist.isEmpty()){
                                insert watchlistsearchresultsanctionreferencelist;
                            }  
                            
                            if(child.getChildElement('watchlist-content', null) != null
                               && child.getChildElement('watchlist-content', null).getChildElement('profile-notes', null) != null){
                                   String temp = child.getChildElement('watchlist-content', null).getChildElement('profile-notes', null).getText();
                                   if(temp.length() > 131000){
                                       wlsr_DB.get(0).wl_content_profile_notes__c = temp.substring(0, 131000);
                                       wlsr_DB.get(0).watckist_content_profile_notes__c = temp.substring(131001, temp.length());
                                   }
                                   else{
                                       wlsr_DB.get(0).wl_content_profile_notes__c = child.getChildElement('watchlist-content', null).getChildElement('profile-notes', null).getText();
                                   }
                               }
                            if(child.getChildElement('watchlist-content', null) != null
                               && child.getChildElement('watchlist-content', null).getChildElement('source-details', null) != null){
                                   for(Dom.XMLNode child1 : child.getChildElement('watchlist-content', null).getChildElement('source-details', null).getChildElements()){ 
                                       Watchlist_Search_Result_Source__c wlsrs = new Watchlist_Search_Result_Source__c();
                                       wlsrs.Watchlist_Search_Result__c =  wlsr.Id;
                                       if(child1.getName().equals('source')){
                                           if(!String.isEmpty(child1.getText())){
                                               wlsrs.value__c = child1.getText();
                                               if(child1.getText().startsWith('http')){
                                                   wlsrs.link__c = true;
                                               }
                                           }
                                           
                                              /*if(wlsr_DB.get(0).wl_content_source__c != null){
                                                  wlsr_DB.get(0).wl_content_source__c += ';'+child1.getText();
                                              }
                                              else{
                                                  wlsr_DB.get(0).wl_content_source__c = child1.getText();
                                              }*/
                                          }
                                       watchlistsearchresultsourcelist.add(wlsrs);
                                   }
                               }
                            if(!watchlistsearchresultsourcelist.isEmpty()){
                                insert watchlistsearchresultsourcelist;
                            } 
                              if(child.getChildElement('state-owned-companies-content', null) != null
                                 && child.getChildElement('state-owned-companies-content', null).getChildElement('content-notice', null) != null){
                                     //wlsr_DB.get(0).so_content_notice__c = child.getChildElement('state-owned-companies-content', null).getChildElement('content-notice', null).getText();
                                }
                              if(child.getChildElement('state-owned-companies-content', null) != null
                                 && child.getChildElement('state-owned-companies-content', null).getChildElement('active-status', null) != null){
                                     wlsr_DB.get(0).so_active_status__c = child.getChildElement('state-owned-companies-content', null).getChildElement('active-status', null).getText();
                                }
                            if(child.getChildElement('state-owned-companies-content', null) != null
                               && child.getChildElement('state-owned-companies-content', null).getChildElement('descriptions', null) != null){
                                   for(Dom.XMLNode child1 : child.getChildElement('state-owned-companies-content', null).getChildElements()){
                                       if(child1.getName().equals('descriptions')){
                                           if(child1.getChildElement('description', null).getAttribute('description1', null) != null){
                                               if(wlsr_DB.get(0).so_descriptions__c != null){
                                                   wlsr_DB.get(0).so_descriptions__c += child1.getChildElement('description', null).getAttribute('description1', null)+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_descriptions__c = child1.getChildElement('description', null).getAttribute('description1', null)+';';
                                               }
                                           }
                                           if(child1.getChildElement('description', null).getAttribute('description2', null) != null){
                                               if(wlsr_DB.get(0).so_descriptions2__c != null){
                                                   wlsr_DB.get(0).so_descriptions2__c += child1.getChildElement('description', null).getAttribute('description2', null)+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_descriptions2__c = child1.getChildElement('description', null).getAttribute('description2', null)+';';
                                               }
                                           }
                                           if(child1.getChildElement('description', null).getAttribute('description2', null) != null){
                                               if(wlsr_DB.get(0).so_descriptions3__c != null){
                                                   wlsr_DB.get(0).so_descriptions3__c += child1.getChildElement('description', null).getAttributeValue(child1.getChildElement('description', null).getAttributeKeyAt(2), child1.getChildElement('description', null).getAttributeKeyNsAt(2))+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_descriptions3__c = child1.getChildElement('description', null).getAttributeValue(child1.getChildElement('description', null).getAttributeKeyAt(2), child1.getChildElement('description', null).getAttributeKeyNsAt(2))+';';
                                               } 
                                           }
                                       }
                                   }
                               }
                            if(child.getChildElement('state-owned-companies-content', null) != null
                               && child.getChildElement('state-owned-companies-content', null).getChildElement('djii-industry-details', null) != null){
                                   for(Dom.XMLNode child1 : child.getChildElement('state-owned-companies-content', null).getChildElement('djii-industry-details', null).getChildElements()){
                                       if(child1.getName().equals('djii-industry')){
                                           if(child1.getAttribute('djii-industry-id', null) != null){
                                               if(wlsr_DB.get(0).so_djii_industry_Id__c != null){
                                                   wlsr_DB.get(0).so_djii_industry_Id__c += child1.getAttribute('djii-industry-id', null)+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_djii_industry_Id__c = child1.getChildElement('djii-industry', null).getAttributeValue(child1.getChildElement('djii-industry', null).getAttributeKeyAt(0), child1.getChildElement('djii-industry', null).getAttributeKeyNsAt(0))+';';
                                               }
                                           }
                                           if(child1.getAttribute('description', null) != null){
                                               if(wlsr_DB.get(0).so_djii_industry_description__c != null){
                                                   wlsr_DB.get(0).so_djii_industry_description__c += child1.getAttribute('description', null)+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_djii_industry_description__c = child1.getAttribute('description', null)+';';
                                               }
                                           }
                                       }
                                   }
                               }
                              if(child.getChildElement('state-owned-companies-content', null) != null
                                 && child.getChildElement('state-owned-companies-content', null).getChildElement('stake-level-details', null) != null){
                                     for(Dom.XMLNode child1 : child.getChildElement('state-owned-companies-content', null).getChildElement('stake-level-details', null).getChildElements()){
                                         if(child1.getName().equals('stake-level')){
                                             if(child1.getChildElement('ownership-percentage', null) != null){
                                                 if(wlsr_DB.get(0).so_stake_level_ownership_percentage__c != null){
                                                     wlsr_DB.get(0).so_stake_level_ownership_percentage__c += child1.getChildElement('ownership-percentage', null).getText()+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_ownership_percentage__c = child1.getChildElement('ownership-percentage', null).getText()+';';    
                                                 }
                                             }
                                             if(child1.getChildElement('stake-level-notes', null) != null){
                                                 if(wlsr_DB.get(0).so_stake_level_notes__c != null){
                                                     wlsr_DB.get(0).so_stake_level_notes__c += child1.getChildElement('stake-level-notes', null).getText()+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_notes__c = child1.getChildElement('stake-level-notes', null).getText()+';';    
                                                 }
                                             }
                                             if(child1.getChildElement('since-date', null) != null){
                                                 if(child1.getChildElement('since-date', null).getAttribute('day', null) != null){
                                                     if(wlsr_DB.get(0).so_stake_level_start_day__c != null){
                                                         wlsr_DB.get(0).so_stake_level_start_day__c += child1.getChildElement('since-date', null).getAttribute('day', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_start_day__c = child1.getChildElement('since-date', null).getAttribute('day', null)+';';
                                                     }
                                                 }
                                                 if(child1.getChildElement('since-date', null).getAttribute('month', null) != null){
                                                     if(wlsr_DB.get(0).so_stake_level_start_month__c != null){
                                                         wlsr_DB.get(0).so_stake_level_start_month__c += child1.getChildElement('since-date', null).getAttribute('month', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_start_month__c = child1.getChildElement('since-date', null).getAttribute('month', null)+';';
                                                     }
                                                 }
                                                 if(child1.getChildElement('since-date', null).getAttribute('year', null) != null){
                                                     if(wlsr_DB.get(0).so_stake_level_start_year__c != null){
                                                         wlsr_DB.get(0).so_stake_level_start_year__c += child1.getChildElement('since-date', null).getAttribute('year', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_start_year__c = child1.getChildElement('since-date', null).getAttribute('year', null)+';';
                                                     }
                                                 }
                                             }
                                             if(child1.getChildElement('to-date', null) != null){
                                                 if(child1.getChildElement('to-date', null).getAttribute('day', null) != null){
                                                     if(wlsr_DB.get(0).so_stake_level_end_day__c != null){
                                                         wlsr_DB.get(0).so_stake_level_end_day__c += child1.getChildElement('to-date', null).getAttribute('day', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_end_day__c = child1.getChildElement('stake-level', null).getChildElement('to-date', null).getChildElement('day', null).getText()+';';
                                                     }
                                                 }
                                                 if(child1.getChildElement('to-date', null).getAttribute('month', null) != null){
                                                     if(wlsr_DB.get(0).so_stake_level_end_month__c != null){
                                                         wlsr_DB.get(0).so_stake_level_end_month__c += child1.getChildElement('to-date', null).getAttribute('month', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_end_month__c = child1.getChildElement('to-date', null).getAttribute('month', null)+';';
                                                     }
                                                 }
                                                 if(child1.getChildElement('to-date', null).getAttribute('year', null) != null){
                                                     if(wlsr_DB.get(0).so_stake_level_end_year__c != null){
                                                         wlsr_DB.get(0).so_stake_level_end_year__c += child1.getChildElement('to-date', null).getAttribute('year', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_end_year__c = child1.getChildElement('to-date', null).getAttribute('year', null)+';';
                                                     }
                                                 }
                                             }
                                             if(child1.getAttribute('stake-level-1', null) != null){
                                                 if(wlsr_DB.get(0).so_stake_level_1__c != null){
                                                     wlsr_DB.get(0).so_stake_level_1__c += child1.getAttribute('stake-level-1', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_1__c = child1.getAttribute('stake-level-1', null)+';';
                                                 }
                                             }
                                             if(child1.getAttribute('stake-level-2', null) != null){
                                                 if(wlsr_DB.get(0).so_stake_level_2__c != null){
                                                     wlsr_DB.get(0).so_stake_level_2__c += child1.getAttribute('stake-level-2', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_2__c = child1.getAttribute('stake-level-2', null)+';';
                                                 }
                                             }
                                             if(child1.getAttribute('stake-level-3', null) != null){
                                                 if(wlsr_DB.get(0).so_stake_level_3__c != null){
                                                     wlsr_DB.get(0).so_stake_level_3__c += child1.getAttribute('stake-level-3', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_3__c = child1.getAttribute('stake-level-3', null)+';'; 
                                                 } 
                                             }
                                         }
                                     }
                                     if(child.getChildElement('state-owned-companies-content', null) != null 
                                        && child.getChildElement('state-owned-companies-content', null).getChildElement('source-details', null) != null){
                                            wlsr_DB.get(0).so_source_details__c += child.getChildElement('state-owned-companies-content', null).getChildElement('source-details', null).getText();
                                     } 
                                     if(child.getChildElement('state-owned-companies-content', null) != null 
                                        && child.getChildElement('state-owned-companies-content', null).getChildElement('profile-notes', null) != null){
                                            wlsr_DB.get(0).so_profile_notes__c += child.getChildElement('state-owned-companies-content', null).getChildElement('profile-notes', null).getText();
                                     }                                      
                                 }
                          }
                    }
                }                
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,res.getStatus()));
            }
                wlsr_DB.get(0).API_call_2__c = true; 
                matchedPrimaryName = wlsr_DB.get(0).matched_name_primary_name__c;
                matchedScriptName = wlsr_DB.get(0).matched_name_scripted__c;
                matchedAlsoKnownAsName = wlsr_DB.get(0).matched_name_also_known_as__c;
                update wlsr_DB.get(0);                
            }
            /*List<Watchlist_Search_Result__c> wlsrVal1_DB = [select Id, identification_type__c,wl_content_profile_notes__c,
                                                             (Select Id, OwnerId, Name,  Watchlist_Search_Result__c, List_Provider_Name__c, 
                                                              List_Provider_Code__c, Description2__c, status__c,
                                                              Since_Day__c, Since_Month__c, Since_Year__c, To_Day__c, To_Month__c, To_Year__c, 
                                                              Value__c From Watchlist_Search_Result_SR__r), 
                                                            (Select Id, OwnerId, Name, peid__c, primary_name__c, relationship__c, 
                                                             description2__c, ex__c, Watchlist_Search_Result__c From Watchlist_Search_Result_Associates__r),
                                                             (Select Value__c, Watchlist_Search_Result__c From Watchlist_Search_Result_Sources__r) , 
                                                            (Select Id, OwnerId, Name, role_type__c, Occupation_category__c,  
                                                             occupation_category_value__c, since_day__c, since_month__c, since_year__c, 
                                                             to_day__c, to_month__c, to_year__c, Watchlist_Search_Result__c 
                                                             From Watchlist_Search_Result_Roles__r) from Watchlist_Search_Result__c where Id =: wlsr.Id];
                system.debug('wlsrVal1_DB :: '+wlsrVal1_DB);*/           
            for(Watchlist_Search_Result__c wlsrVal2_DB : [select Id, identification_type__c,wl_content_profile_notes__c, matched_name_primary_name__c, 
                                                              matched_name_scripted__c, matched_name_also_known_as__c, watckist_content_profile_notes__c,
                                                             (Select Id, Name,  Watchlist_Search_Result__c, List_Provider_Name__c, 
                                                              List_Provider_Code__c, Description2__c, status__c,
                                                              Since_Day__c, Since_Month__c, Since_Year__c, To_Day__c, To_Month__c, To_Year__c, 
                                                              Value__c From Watchlist_Search_Result_SR__r), 
                                                            (Select Id, OwnerId, Name, peid__c, primary_name__c, relationship__c, 
                                                             description2__c, type__c, ex__c, Watchlist_Search_Result__c From Watchlist_Search_Result_Associates__r),
                                                             (Select Value__c, link__c, Watchlist_Search_Result__c From Watchlist_Search_Result_Sources__r) , 
                                                            (Select Id,  Name, role_type__c, Occupation_category__c,  
                                                             occupation_category_value__c, since_day__c, since_month__c, since_year__c, 
                                                             to_day__c, to_month__c, to_year__c, Watchlist_Search_Result__c 
                                                             From Watchlist_Search_Result_Roles__r) from Watchlist_Search_Result__c where Id =: wlsr.Id]){
                        matchedPrimaryName = wlsrVal2_DB.matched_name_primary_name__c;
                        matchedScriptName = wlsrVal2_DB.matched_name_scripted__c;
                        matchedAlsoKnownAsName = wlsrVal2_DB.matched_name_also_known_as__c; 
                       if(wlsrVal2_DB != null ){
                        List<String> multipleIdentificationList;
                        if(wlsrVal2_DB.identification_type__c != null){
                            multipleIdentificationList = wlsrVal2_DB.identification_type__c.split(';');
                        }
                        system.debug('multipleIdentificationList :: '+multipleIdentificationList);
                        if(multipleIdentificationList != null && !multipleIdentificationList.isEmpty()){
                            for(String multipleIdentificationVal : multipleIdentificationList){                                
                                List<String> keyValList = multipleIdentificationVal.split(':');
                                system.debug('keyValList :: '+keyValList);
                                if(keyValList != null && !keyValList.isEmpty() && keyValList.size() > 1){
                                    identificationDetails_identificationtype_Map.put(keyValList[1], keyValList[0]);    
                                    searchResultId_identificationDetails_identificationtype_Map.put(wlsrVal2_DB.Id, identificationDetails_identificationtype_Map);
                                } 
                            } 
                        }
                    }
                                                                 if(wlsrVal2_DB.wl_content_profile_notes__c != null){
                                                                     profileNotes = wlsrVal2_DB.wl_content_profile_notes__c;
                                                                 }
                                                                 if(wlsrVal2_DB.watckist_content_profile_notes__c != null){
                                                                     profileNotes += wlsrVal2_DB.watckist_content_profile_notes__c;  
                                                                 }                        
                    for(Watchlist_Search_Result_Role__c role : wlsrVal2_DB.Watchlist_Search_Result_Roles__r){
                         rolesList.add(role);                                         
                    }
                    for(Watchlist_Search_Result_Associate__c associate : wlsrVal2_DB.Watchlist_Search_Result_Associates__r){
                         associatesList.add(associate);                                         
                    }
                    for(Watchlist_Search_Result_Source__c source : wlsrVal2_DB.Watchlist_Search_Result_Sources__r){
                         sourcesList.add(source);                                         
                    }
                    for(Watchlist_Search_Result_SR__c sr : wlsrVal2_DB.Watchlist_Search_Result_SR__r){
                         sanctionReferenceList.add(sr);                                         
                    }
                    //rolesList = wlsrVal2_DB.Watchlist_Search_Result_Roles__r;
                    //associatesList = wlsrVal2_DB.Watchlist_Search_Result_Associates__r;
                    //sourcesList = wlsrVal2_DB.Watchlist_Search_Result_Sources__r;
                    //sanctionReferenceList = wlsrVal2_DB.Watchlist_Search_Result_SR__r;      
                }
            system.debug('sanctionReferenceList :: '+sanctionReferenceList); 
                system.debug('searchResultId_identificationDetails_identificationtype_Map :: '+searchResultId_identificationDetails_identificationtype_Map);
            //return wlsr_DB;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            //return null;
        } 
        system.debug('wlsr_DB.get(0) :: '+wlsr_DB.get(0));
        //return wlsr_DB;
    }  
    
    public void getEntityMoreDetails(){  
        
        Map<String, String> identificationDetails_identificationtype_Map = new Map<String, String>();
        List<Watchlist_Search_Result_SR__c> watchlistsearchresultsanctionreferencelist = new List<Watchlist_Search_Result_SR__c>();
        List<Watchlist_Search_Result_SOC__c> watchlistsearchresultsoclist = new List<Watchlist_Search_Result_SOC__c>();
        List<Watchlist_Search_Result_Role__c> watchlistsearchresultrolelist = new List<Watchlist_Search_Result_Role__c>();
        List<Watchlist_Search_Result_Associate__c> watchlistsearchresultassociatelist = new List<Watchlist_Search_Result_Associate__c>();
        List<Watchlist_Search_Result_Source__c> watchlistsearchresultsourcelist = new List<Watchlist_Search_Result_Source__c>();
        Integer count = 0;
        wlsr_DB = [Select w.peid__c, w.wl_content_source__c, w.wl_content_sanc_ref_status__c, API_call_2__c, Temp__c, Date_of_Registration__c, Adverse_media__c,
                   Company_Identification_Number__c, Legal_Entity_Identifier__c, National_ID__c, National_Insurance_Number__c, 
                   National_Tax_No__c, Passport_Number__c, 
                   matched_name_primary_name__c, matched_name_scripted__c, matched_name_also_known_as__c, 
                   w.wl_content_sanc_ref_start_year__c, w.wl_content_sanc_ref_start_month__c, 
                   w.wl_content_sanc_ref_start_day__c, w.wl_content_sanc_ref_list_prov_name__c, 
                   w.wl_content_sanc_ref_list_prov_code__c, w.wl_content_sanc_ref_end_year__c, 
                   w.wl_content_sanc_ref_end_month__c, w.wl_content_sanc_ref_end_day__c, w.wl_content_sanc_ref_desc2__c, 
                   w.wl_content_profile_notes__c, w.watckist_content_profile_notes__c, w.watchlist_source_details__c, 
                   w.watchlist_content_role_type__c, w.watchlist_content_role_occupation_cat__c,
                   w.watchlist_content_role_occup_start_year__c, w.watchlist_content_role_occup_start_month__c, 
                   w.watchlist_content_role_occup_start_day__c, w.watchlist_content_role_occup_end_year__c, 
                   w.watchlist_content_role_occup_end_month__c, w.watchlist_content_role_occup_end_day__c, w.watchlist_content_notice__c, 
                   w.watchlist_content_descriptions__c, w.watchlist_content_descriptions3__c, w.watchlist_content_descriptions2__c, 
                   w.watchlist_content_active_status__c, w.title_honorific__c, w.surname__c, w.suffix__c, w.so_stake_level_start_year__c, 
                   w.so_stake_level_start_month__c, w.so_stake_level_start_day__c, w.so_stake_level_ownership_percentage__c, 
                   w.so_stake_level_notes__c, w.so_stake_level_end_year__c, w.so_stake_level_end_month__c, w.so_stake_level_end_day__c, 
                   w.so_stake_level_3__c, w.so_stake_level_2__c, w.so_stake_level_1__c, w.so_source_details__c, w.so_profile_notes__c, 
                   w.so_djii_industry_description__c, w.so_djii_industry_Id__c, w.so_descriptions__c, w.so_descriptions3__c, 
                   w.so_descriptions2__c, w.so_active_status__c, w.osn_language_code__c, w.middle_name__c, 
                   w.maiden_name__c, w.is_birth_place_country_territory__c, w.is_address_country_territory__c, w.is_Country_territory__c, 
                   w.image_url__c, w.identification_notes__c, w.identification_type__c, w.deceased__c, w.date_type__c, w.date_notes__c, 
                   w.country_type__c, w.country_region_code__c, w.country_profile__c, w.country_iso3_code__c, w.country_is02_code__c, 
                   w.birth_place_sub_region__c, w.birth_place_region__c, w.birth_place_name__c, w.birth_place_country_region_code__c, 
                   w.birth_place_country_profile__c, w.birth_place_country_iso3_code__c, w.birth_place_country_iso2_code__c, 
                   w.associate_relationship__c, w.associate_primary_name__c, w.associate_peid__c, w.associate_ex__c, w.associate_description__c, 
                   w.associate_description2__c, w.address_zip_code__c, w.address_url__c, w.address_sub_region__c, w.address_region__c, 
                   w.address_line__c, w.address_country_region_code__c, w.address_country_profile__c, w.address_country_iso3_code__c, 
                   w.address_country_iso2_code__c, w.address_city__c, w.Watchlist_Search__c, w.SystemModstamp, w.Single_String_Name__c, 
                   w.Script_Language_Code__c, w.OwnerId, w.Name, w.LastModifiedDate, w.LastModifiedById,w.IsDeleted, 
                   w.Id, w.First_name__c, w.CurrencyIsoCode, w.CreatedDate, w.CreatedById, w.ConnectionSentId, w.ConnectionReceivedId, 
                   w.Citizenship_Country__c, w.resident_Country__c 
                   From Watchlist_Search_Result__c w where Id =: wlsr.Id];
        system.debug('wlsr_DB in constructor :: '+wlsr_DB);                
        String dowjonesEndPoint = Label.WLPEIDEndpoint ;  
        HttpResponse res;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        if(!wlsr_DB.isEmpty() && wlsr_DB.size() == 1){
            /*if(wlsr_DB.get(0).Resident_Country__c != null && wlsr_DB.get(0).Resident_Country__c.equalsIgnoreCase('United kingdom')){
                wlsr_DB.get(0).Resident_Country__c = 'United Kingdom';
            }
            if(wlsr_DB.get(0).Citizenship_Country__c != null && wlsr_DB.get(0).Citizenship_Country__c.equalsIgnoreCase('United kingdom')){
                wlsr_DB.get(0).Citizenship_Country__c = 'United Kingdom';
            }
            if(wlsr_DB.get(0).birth_place_country_region_code__c != null && wlsr_DB.get(0).birth_place_country_region_code__c.equalsIgnoreCase('United kingdom')){
                wlsr_DB.get(0).birth_place_country_region_code__c = 'United Kingdom';
            }
            */
            if(wlsr_DB.get(0).Adverse_media__c != null){
                adversemedia = wlsr_DB.get(0).Adverse_media__c;
            }
            if(wlsr_DB.get(0).Resident_Country__c != null)
                residentCountry = DDutility.capitalizeFirstCharacter(wlsr_DB.get(0).Resident_Country__c);  
            if(wlsr_DB.get(0).Citizenship_Country__c != null)
                citizenshipCountry = DDutility.capitalizeFirstCharacter(wlsr_DB.get(0).Citizenship_Country__c);            
            if(wlsr_DB.get(0).birth_place_country_region_code__c != null)
                dateOfBirthCountry = DDutility.capitalizeFirstCharacter(wlsr_DB.get(0).birth_place_country_region_code__c);
            system.debug('wlsr_DB.get(0).LastModifiedDate ::'+wlsr_DB.get(0).LastModifiedDate);            
            formatteddate = DDUtility.drop_leading_zeros(wlsr_DB.get(0).LastModifiedDate.format('dd MMMM yyyy'));
            system.debug('formatteddate :: '+formatteddate);
            if(!String.isEmpty(wlsr_DB.get(0).address_line__c)){
                    addressLine = wlsr_DB.get(0).address_line__c/*','+wlsr_DB.get(0).address_city__c*/;
                }
                if(!String.isEmpty(addressLine) && !String.isEmpty(wlsr_DB.get(0).address_region__c)){
                    addressLine += ','+wlsr_DB.get(0).address_region__c;                
                }
                else if(!String.isEmpty(wlsr_DB.get(0).address_region__c)) {
                    addressLine = wlsr_DB.get(0).address_region__c;
                }
            
            if(!String.isEmpty(wlsr_DB.get(0).address_city__c))
                city = wlsr_DB.get(0).address_city__c;
            if(!String.isEmpty(wlsr_DB.get(0).address_zip_code__c))
                zipcode = wlsr_DB.get(0).address_zip_code__c;
            if(!String.isEmpty(wlsr_DB.get(0).address_url__c))
                url = wlsr_DB.get(0).address_url__c;
            if(wlsr_DB.get(0).Company_Identification_Number__c != null)
                cin = wlsr_DB.get(0).Company_Identification_Number__c;
            if(wlsr_DB.get(0).Legal_Entity_Identifier__c != null)
                lei = wlsr_DB.get(0).Legal_Entity_Identifier__c;
            if(wlsr_DB.get(0).National_Tax_No__c != null)
                ntn = wlsr_DB.get(0).National_Tax_No__c;
        //if(String.isNotEmpty(wlsr.peid__c)){
            if(!wlsr_DB.get(0).API_call_2__c && String.isNotEmpty(wlsr_DB.get(0).peid__c))
                req.setEndpoint(dowjonesEndPoint+wlsr_DB.get(0).peid__c+'?include-associate-primary-name=true'); 
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'PEID is missing'));
        }        
        try{
            if(!wlsr_DB.get(0).API_call_2__c){
            system.debug('req :: '+req);
            res = h.send(req);
            system.debug('res :: '+res);
            system.debug('res.getBody() :: '+res.getBody());
            System.debug('res.getStatusCode() :: '+res.getStatusCode());
            if(res.getStatusCode() == 200){
                Dom.Document doc = res.getBodyDocument();
                system.debug('doc :: '+doc);
                Dom.XMLNode rootElement = doc.getRootElement(); 
                //system.debug('api version :: '+rootElement.getAttributeValue(rootElement.getAttributeKeyAt(0), rootElement.getAttributeKeyNsAt(0)));
                if(rootElement.getAttribute('api-version', null) != null){
                    wlsr_DB.get(0).api_version__c = rootElement.getAttributeValue('api-version', null);
                }
                for(Dom.XMLNode child : rootElement.getChildElements()){
                    System.debug('child :: '+child);
                    System.debug('child.getName() :: '+child.getName());
                    if(String.isNotEmpty(child.getName()) && child.getName().equals('entity')){                         
                        system.debug('child.getChildEle :: '+child.getChildElement('entity-name-details', null).getChildElements());
                        if(child.getChildElement('entity-name-details', null) != null){
                            for(Dom.XMLNode child1 : child.getChildElement('entity-name-details', null).getChildElements()){
                                system.debug('child1 :: '+child1.getName());
                                if(child1 != null && String.isNotBlank(child1.getName()) && child1.getName().equals('entity-names')){  
                                        system.debug('child1.getChildEleme:: '+child1.getChildElement('entity-name-value', null));                                    
                                        if(child1.getChildElement('entity-name-value', null) != null){
                                            system.debug('child1.getChildEleme111:: '+child1.getChildElement('entity-name-value', null).getAttribute('name-type', null)); 
                                            if(child1.getChildElement('entity-name-value', null).getAttribute('name-type', null) != null
                                               && child1.getChildElement('entity-name-value', null).getAttribute('name-type', null).equals('Primary Name')){
                                                   if(wlsr_DB.get(0).matched_name_primary_name__c != null){
                                                       system.debug('child1.getChildEleme222 if :: '+child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null));
                                                       if(child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null) != null){
                                                           wlsr_DB.get(0).matched_name_primary_name__c += '; '+child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null).getText();
                                                       }                                                       
                                                   }
                                                   else{
                                                       system.debug('child1.getChildEleme222 else :: '+child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null));                                                       
                                                       if(child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null) != null){
                                                           wlsr_DB.get(0).matched_name_primary_name__c = child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null).getText();
                                                       }                                                       
                                                   }
                                               }
                                            system.debug('wlsr_DB.get(0).matched_name_primary_name__c :: '+wlsr_DB.get(0).matched_name_primary_name__c);
                                            if(child1.getChildElement('entity-names-group', null) != null
                                              && child1.getChildElement('entity-names-group', null).getChildElement('entity-names', null) != null
                                              && child1.getChildElement('entity-names-group', null).getChildElement('entity-names', null).getChildElement('entity-name-value', null) != null){       
                                                  if(child1.getChildElement('entity-names-group', null).getChildElement('entity-names', null).getChildElement('entity-name-value', null).getAttribute('name-type', null) !=null
                                                    && child1.getChildElement('entity-names-group', null).getChildElement('entity-names', null).getChildElement('entity-name-value', null).getAttribute('name-type', null).equals('Original Script Name')){
                                                        if(child1.getChildElement('entity-names-group', null).getChildElement('entity-names', null).getChildElement('entity-name-value', null).getChildElement('original-script-name', null) != null){
                                                            if(wlsr_DB.get(0).matched_name_scripted__c   != null){   
                                                                wlsr_DB.get(0).matched_name_scripted__c += ';'+child1.getChildElement('entity-names-group', null).getChildElement('entity-names', null).getChildElement('entity-name-value', null).getChildElement('original-script-name', null).getText();
                                                            }
                                                            else{ 
                                                                wlsr_DB.get(0).matched_name_scripted__c = child1.getChildElement('entity-names-group', null).getChildElement('entity-names', null).getChildElement('entity-name-value', null).getChildElement('original-script-name', null).getText();   
                                                            }
                                                        }
                                                    }
                                            }
                                            system.debug('wlsr_DB.get(0).matched_name_scripted__c :: '+wlsr_DB.get(0).matched_name_scripted__c);
                                            if(child1 != null && String.isNotBlank(child1.getName()) && child1.getName().equals('entity-names')){                                      
                                                if(child1.getChildElement('entity-name-value', null) != null){
                                                    if(child1.getChildElement('entity-name-value', null).getAttribute('name-type', null) != null
                                                       && child1.getChildElement('entity-name-value', null).getAttribute('name-type', null).equals('Also Known As')){
                                                           if(wlsr_DB.get(0).matched_name_also_known_as__c != null){
                                                               if(child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null) != null){
                                                                   wlsr_DB.get(0).matched_name_also_known_as__c += '; '+child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null).getText();
                                                               }                                                               
                                                           } 
                                                           else{
                                                               if(child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null) != null){
                                                                   wlsr_DB.get(0).matched_name_also_known_as__c = child1.getChildElement('entity-name-value', null).getChildElement('entity-name', null).getText();
                                                               }                                                               
                                                           }
                                                       }
                                                }
                                            }    
                                            system.debug('wlsr_DB.get(0).matched_name_also_known_as__c :: '+wlsr_DB.get(0).matched_name_also_known_as__c);                                               
                                               
                                               if(child1.getChildElement('entity-name-value', null).getChildElement('suffix', null) != null){
                                                   if(wlsr_DB.get(0).suffix__c != null){
                                                       wlsr_DB.get(0).suffix__c +=  child1.getChildElement('entity-name-value', null).getChildElement('suffix', null).getText()+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).suffix__c =  child1.getChildElement('entity-name-value', null).getChildElement('suffix', null).getText()+';';
                                                   }
                                               }
                                               if(child1.getChildElement('entity-name-value', null).getAttribute('entity-name-value', null) != null){
                                                   if(wlsr_DB.get(0).name_type__c != null){
                                                       wlsr_DB.get(0).name_type__c += String.valueOf(child1.getChildElement('entity-name-value', null).getAttribute('entity-name-value', null))+';';
                                                   }
                                                   else{
                                                       wlsr_DB.get(0).name_type__c = String.valueOf(child1.getChildElement('entity-name-value', null).getAttribute('entity-name-value', null))+';';
                                                   }
                                               }
                                           }
                                    } 
                                //}
                            }
                            suffix = wlsr_DB.get(0).suffix__c;
                        }                        
                        system.debug('wlsr_DB.get(0) 1 :: '+wlsr_DB.get(0));
                        if(child.getChildElement('date-details', null) != null && child.getChildElement('date-details', null).getChildElement('date', null) != null){
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('date-type', null) != null){
                                wlsr_DB.get(0).date_type__c = child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('date-type', null);
                            }
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('day', null) != null){
                                wlsr_DB.get(0).day__c = child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('day', null);
                            }
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('month', null) != null){
                                wlsr_DB.get(0).month__c = child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('month', null);
                            }
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('year', null) != null){
                                wlsr_DB.get(0).year__c = child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('year', null);
                            }
                            if(child.getChildElement('date-details', null).getChildElement('date', null).getAttribute('date-notes', null) != null){
                                wlsr_DB.get(0).date_notes__c = child.getChildElement('date-details', null).getChildElement('date', null).getAttributeValue('date-notes', null);
                            }
                        }
                        if(wlsr_DB.get(0).day__c != null && wlsr_DB.get(0).month__c != null && wlsr_DB.get(0).year__c != null){
                            wlsr_DB.get(0).Date_of_Registration__c  = date.newInstance(Integer.valueOf(wlsr_DB.get(0).year__c), Integer.valueOf(wlsr_DB.get(0).month__c), Integer.valueOf(wlsr_DB.get(0).day__c));
                            dateOfRegistration = String.valueOf(wlsr_DB.get(0).Date_of_Registration__c);
                        }                        
                        /*if(child.getChildElement('birth-place-details', null) != null && child.getChildElement('birth-place-details', null).getChildElement('birth-place', null) != null){
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('place-name', null) != null ){
                                wlsr_DB.get(0).birth_place_name__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('place-name', null).getText();
                            }
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('region', null) != null ){
                                wlsr_DB.get(0).birth_place_region__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('region', null).getText();
                            }    
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('sub-region', null) != null ){
                                wlsr_DB.get(0).birth_place_sub_region__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('sub-region', null).getText();
                            }
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('sub-region', null) != null ){
                                wlsr_DB.get(0).birth_place_sub_region__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('sub-region', null).getText();
                            }
                            if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null) != null){
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('djii-region-code', null) != null){
                                    //String temp = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                    String temp = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getText();
                                    //dateOfBirthCountry = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                    system.debug('temp :: '+temp);
                                    if(!String.isEmpty(temp)){
                                        String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                        system.debug('temp2 :: '+temp2);
                                        wlsr_DB.get(0).birth_place_country_region_code__c = temp2.subString(0,1)+temp2.subString(1, temp2.length()).toLowerCase();
                                        system.debug('wlsr_DB.get(0).birth_place_country_region_code__c  :: '+wlsr_DB.get(0).birth_place_country_region_code__c );
                                        if(wlsr_DB.get(0).birth_place_country_region_code__c != null && wlsr_DB.get(0).birth_place_country_region_code__c.equalsIgnoreCase('United kingdom')){
                                            wlsr_DB.get(0).birth_place_country_region_code__c = 'United Kingdom';
                                        }
                                        dateOfBirthCountry = wlsr_DB.get(0).birth_place_country_region_code__c;
                                        system.debug('dateOfBirthCountry after  :: '+dateOfBirthCountry);                                        
                                    }                                    
                                }
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('iso2-country-code', null) != null){
                                    wlsr_DB.get(0).birth_place_country_iso2_code__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('iso2-country-code', null);
                                }
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('iso3-country-code', null) != null){
                                    wlsr_DB.get(0).birth_place_country_iso3_code__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('iso3-country-code', null);
                                }
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('is-territory', null) != null){
                                    wlsr_DB.get(0).is_birth_place_country_territory__c = Boolean.valueOf(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('is-territory', null));
                                }
                                if(child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttribute('country-profile', null) != null){
                                    wlsr_DB.get(0).birth_place_country_profile__c = child.getChildElement('birth-place-details', null).getChildElement('birth-place', null).getChildElement('country', null).getAttributeValue('country-profile', null);
                                }
                            }
                        }*/
                        if(child.getChildElement('country-details', null) != null){
                            for(Dom.XMLNode child1 : child.getChildElement('country-details', null).getChildElements()){
                                if(child1.getName().equals('country-value')){
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('djii-region-code', null) != null){
                                           if(wlsr_DB.get(0).country_region_code__c != null){
                                               wlsr_DB.get(0).country_region_code__c += child1.getChildElement('country', null).getAttributeValue('djii-region-code', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).country_region_code__c = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null)+';';
                                           } 
                                       }
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('iso2-country-code', null) != null){
                                           if(wlsr_DB.get(0).country_is02_code__c != null){
                                               wlsr_DB.get(0).country_is02_code__c += child1.getChildElement('country', null).getAttributeValue('iso2-country-code', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).country_is02_code__c = child1.getChildElement('country', null).getAttributeValue('iso2-country-code', null)+';';
                                           } 
                                       }
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('iso3-country-code', null) != null){
                                           if(wlsr_DB.get(0).country_iso3_code__c != null){
                                               wlsr_DB.get(0).country_iso3_code__c += child1.getChildElement('country', null).getAttributeValue('iso3-country-code', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).country_iso3_code__c = child1.getChildElement('country', null).getAttributeValue('iso3-country-code', null)+';';
                                           } 
                                       } 
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('is-territory', null) != null){
                                           if(wlsr_DB.get(0).is_Country_territory__c != null){
                                               wlsr_DB.get(0).is_Country_territory__c += child1.getChildElement('country', null).getAttributeValue('is-territory', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).is_Country_territory__c = child1.getChildElement('country', null).getAttributeValue('is-territory', null)+';';
                                           }
                                       }
                                    if(child1.getChildElement('country', null) != null
                                       && child1.getChildElement('country', null).getAttribute('country-profile', null) != null){
                                           if(wlsr_DB.get(0).country_profile__c != null){
                                               wlsr_DB.get(0).country_profile__c += child1.getChildElement('country', null).getAttributeValue('country-profile', null)+';';
                                           }
                                           else{
                                               wlsr_DB.get(0).country_profile__c = child1.getChildElement('country', null).getAttributeValue('country-profile', null)+';';
                                           } 
                                       }
                                    if(child1.getAttribute('country-type', null) != null){ 
                                           if(wlsr_DB.get(0).country_type__c != null){
                                               //wlsr_DB.get(0).country_type__c +=  ';'+child1.getAttributeValue('country-type', null);
                                               if (child1.getAttributeValue('country-type', null).startsWith('Country of Affiliation')){
                                                   //String temp = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null); 
                                                   String temp = child1.getChildElement('country', null).getText();                                                      
                                                   //String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                                   residentCountry = ';'+DDutility.capitalizeFirstCharacter(temp);//temp2.subString(0,1)+temp.subString(1,temp.length()).toLowerCase();
                                                   //wlsr_DB.get(0).Resident_Country__c = ';'+child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                               }
                                               else if(child1.getAttributeValue('country-type', null).startsWith('Country of Registration')){
                                                   //String temp = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                                   String temp = child1.getChildElement('country', null).getText();    
                                                   //String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                                   citizenshipCountry = ';'+DDutility.capitalizeFirstCharacter(temp);//temp2.subString(0,1)+temp.subString(1,temp.length()).toLowerCase();
                                                   //wlsr_DB.get(0).Citizenship_Country__c = ';'+child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                               }
                                           }
                                           else{
                                               //wlsr_DB.get(0).country_type__c = child1.getAttributeValue('country-type', null); 
                                               if(child1.getAttributeValue('country-type', null).startsWith('Country of Affiliation')){
                                                   //String temp = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                                   String temp = child1.getChildElement('country', null).getText();    
                                                   //String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                                   residentCountry = DDutility.capitalizeFirstCharacter(temp);//temp2.subString(0,1)+temp.subString(1,temp.length()).toLowerCase();
                                                   //wlsr_DB.get(0).Resident_Country__c = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                               }
                                               else if(child1.getAttributeValue('country-type', null).startsWith('Country of Registration')){
                                                   //String temp = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                                   String temp = child1.getChildElement('country', null).getText();    
                                                   //String temp2 = temp.subString(0,1).toUpperCase()+temp.subString(1,temp.length());
                                                   citizenshipCountry = DDutility.capitalizeFirstCharacter(temp);//temp2.subString(0,1)+temp.subString(1,temp.length()).toLowerCase();
                                                   //wlsr_DB.get(0).Citizenship_Country__c = child1.getChildElement('country', null).getAttributeValue('djii-region-code', null);
                                               }
                                           }  
                                       }
                                    /*if(residentCountry != null && residentCountry.equalsIgnorecase('United kingdom')){
                                        residentCountry = 'United Kingdom';
                                    }
                                    if(citizenshipCountry != null && citizenshipCountry.equalsIgnorecase('United kingdom')){
                                        citizenshipCountry = 'United Kingdom';
                                    }*/
                                    wlsr_DB.get(0).Resident_Country__c = DDutility.capitalizeFirstCharacter(residentCountry);
                                    wlsr_DB.get(0).Citizenship_Country__c = DDutility.capitalizeFirstCharacter(citizenshipCountry);
                                }
                            }
                              
                              if(child.getChildElement('address-details', null) != null){ 
                                  for(Dom.XMLNode child1 : child.getChildElement('address-details', null).getChildElements()){
                                      if(child1.getName().equals('address')){
                                          if(child1.getChildElement('address-line', null) != null){
                                              if(wlsr_DB.get(0).address_line__c != null){
                                                  wlsr_DB.get(0).address_line__c += ';'+child1.getChildElement('address-line', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_line__c = child1.getChildElement('address-line', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('city', null) != null){
                                              if(wlsr_DB.get(0).address_city__c != null){
                                                  wlsr_DB.get(0).address_city__c += ';'+child1.getChildElement('city', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_city__c = child1.getChildElement('city', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('region', null) != null){
                                              if(wlsr_DB.get(0).address_region__c != null){
                                                  wlsr_DB.get(0).address_region__c += ';'+child1.getChildElement('region', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_region__c = child1.getChildElement('region', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('sub-region', null) != null){
                                              if(wlsr_DB.get(0).address_sub_region__c != null){
                                                  wlsr_DB.get(0).address_sub_region__c += ';'+child1.getChildElement('sub-region', null).gettext(); 
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_sub_region__c = child1.getChildElement('sub-region', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('zip-code', null) != null){
                                              if(wlsr_DB.get(0).address_zip_code__c != null){
                                                  wlsr_DB.get(0).address_zip_code__c += ';'+child1.getChildElement('zip-code', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_zip_code__c = child1.getChildElement('zip-code', null).gettext();
                                              }
                                          }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('djii-region-code', null) != null){
                                                 if(wlsr_DB.get(0).address_country_region_code__c != null){
                                                     wlsr_DB.get(0).address_country_region_code__c += ';'+child1.getChildElement('country', null).getAttribute('djii-region-code', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).address_country_region_code__c = child1.getChildElement('country', null).getAttribute('djii-region-code', null);
                                                 }
                                             }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('iso2-country-code', null) != null){
                                                 if(wlsr_DB.get(0).address_country_iso2_code__c != null){
                                                     wlsr_DB.get(0).address_country_iso2_code__c += ';'+child1.getChildElement('country', null).getAttribute('iso2-country-code', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).address_country_iso2_code__c = child1.getChildElement('country', null).getAttribute('iso2-country-code', null);
                                                 }
                                             }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('iso3-country-code', null) != null){
                                                 if(wlsr_DB.get(0).address_country_iso3_code__c != null){
                                                     wlsr_DB.get(0).address_country_iso3_code__c += ';'+child1.getChildElement('country', null).getAttribute('iso3-country-code', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).address_country_iso3_code__c = child1.getChildElement('country', null).getAttribute('iso3-country-code', null);
                                                 }
                                             }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('is-territory', null) != null){
                                                 if(wlsr_DB.get(0).is_address_country_territory__c != null){
                                                     wlsr_DB.get(0).is_address_country_territory__c += ';'+child1.getChildElement('country', null).getAttribute('iso3-country-code', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).is_address_country_territory__c = child1.getChildElement('country', null).getAttribute('iso3-country-code', null);
                                                 }
                                             }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('country', null) != null
                                             && child1.getChildElement('country', null).getAttribute('country-profile', null) != null){
                                                 if(wlsr_DB.get(0).address_country_profile__c != null){
                                                     wlsr_DB.get(0).address_country_profile__c += ';'+child1.getChildElement('country', null).getAttribute('country-profile', null);
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).address_country_profile__c = child1.getChildElement('country', null).getAttribute('country-profile', null);
                                                 }
                                             }
                                          if(child1.getChildElement('address-line', null) != null && child1.getChildElement('address-url', null) != null){ 
                                              if(wlsr_DB.get(0).address_url__c != null){
                                                  wlsr_DB.get(0).address_url__c += ';'+child1.getChildElement('address-url', null).gettext();
                                              }
                                              else{
                                                  wlsr_DB.get(0).address_url__c = child1.getChildElement('address-url', null).gettext();
                                              }
                                          }
                                      }
                                  }
                                  if(!String.isEmpty(wlsr_DB.get(0).address_line__c)){
                                      addressLine = wlsr_DB.get(0).address_line__c/*','+wlsr_DB.get(0).address_city__c*/;
                                  }
                                  if(!String.isEmpty(addressLine) && !String.isEmpty(wlsr_DB.get(0).address_region__c)){
                                      addressLine += ','+wlsr_DB.get(0).address_region__c;                
                                  }
                                  else if(!String.isEmpty(wlsr_DB.get(0).address_region__c)) {
                                      addressLine = wlsr_DB.get(0).address_region__c;
                                  }
                                  //addressLine = wlsr_DB.get(0).address_line__c/*','+wlsr_DB.get(0).address_city__c*/+','+wlsr_DB.get(0).address_region__c;
                                  if(!String.isEmpty(wlsr_DB.get(0).address_city__c))
                                  city = wlsr_DB.get(0).address_city__c;
                                  if(!String.isEmpty(wlsr_DB.get(0).address_zip_code__c))
                                  zipcode = wlsr_DB.get(0).address_zip_code__c;
                                  if(!String.isEmpty(wlsr_DB.get(0).address_url__c))
                                  url = wlsr_DB.get(0).address_url__c;
                              }
                              
                            if(child.getChildElement('identification-details', null) != null){                                
                                String temp = '';
                                for(Dom.XMLNode child1 : child.getChildElement('identification-details', null).getChildElements()){
                                    if(child1.getName().equals('identification')){
                                        if(child1.getAttribute('identification-type', null) != null){
                                            if(child1.getAttributeValue('identification-type', null).contains('Company Identification')){
                                                cin = /*child1.getAttributeValue('identification-type', null)+':'+*/child1.gettext(); 
                                                wlsr_DB.get(0).Company_Identification_Number__c = cin;
                                            }
                                            else if(child1.getAttributeValue('identification-type', null).contains('Legal Entity')){
                                                lei = /*child1.getAttributeValue('identification-type', null)+':'+*/child1.gettext();      
                                                wlsr_DB.get(0).Legal_Entity_Identifier__c = lei;
                                            }
                                            else if(child1.getAttributeValue('identification-type', null).contains('National Tax')){
                                                ntn = /*child1.getAttributeValue('identification-type', null)+':'+*/child1.gettext();        
                                                wlsr_DB.get(0).National_Tax_No__c = ntn;
                                            }
                                            else {
                                                if(temp != null){
                                                    temp += child1.getAttributeValue('identification-type', null)+':'+child1.gettext();
                                                }
                                                else{
                                                    temp = child1.getAttributeValue('identification-type', null)+':'+child1.gettext();
                                                }
                                            }
                                        }                                        
                                    }
                                }
                                wlsr_DB.get(0).identification_type__c = cin+';'+lei+';'+ntn+';'+temp;
                            }
                            if(child.getChildElement('image-details', null) != null){                                  
                                for(Dom.XMLNode child1 : child.getChildElement('image-details', null).getChildElements()){
                                    if(child1.getName().equals('image-url')){
                                        if(wlsr_DB.get(0).image_url__c != null){
                                            wlsr_DB.get(0).image_url__c += child1.getText()+';';
                                        }
                                        else{
                                            wlsr_DB.get(0).image_url__c = child1.getText()+';';
                                        }
                                    }
                                }
                            }
                            if(child.getChildElement('watchlist-content', null) != null
                               && child.getChildElement('watchlist-content', null).getChildElement('content-notice', null) != null){
                                   wlsr_DB.get(0).watchlist_content_notice__c = child.getChildElement('watchlist-content', null).getChildElement('content-notice', null).getText();
                               }
                              if(child.getChildElement('watchlist-content', null) != null
                                && child.getChildElement('watchlist-content', null).getChildElement('active-status', null) != null){
                                    wlsr_DB.get(0).watchlist_content_active_status__c = child.getChildElement('watchlist-content', null).getChildElement('active-status', null).getText();
                              }
                              if(child.getChildElement('watchlist-content', null) != null){
                                    for(Dom.XMLNode child1 : child.getChildElement('watchlist-content', null).getChildElements()){
                                        if(child1.getName().equals('description')){
                                            if(child1.getChildElement('description', null).getAttribute('description1', null) != null){
                                                if(wlsr_DB.get(0).watchlist_content_descriptions__c != null){
                                                    wlsr_DB.get(0).watchlist_content_descriptions__c += child1.getChildElement('description', null).getAttribute('description1', null)+';';
                                                }
                                                else{
                                                    wlsr_DB.get(0).watchlist_content_descriptions__c = child1.getChildElement('description', null).getAttribute('description1', null)+';';
                                                }
                                            }
                                            if(child1.getChildElement('description', null).getAttribute('description2', null) != null){
                                                if(wlsr_DB.get(0).watchlist_content_descriptions2__c != null){
                                                    wlsr_DB.get(0).watchlist_content_descriptions2__c += child1.getChildElement('description', null).getAttribute('description2', null)+';';
                                                }
                                                else{
                                                    wlsr_DB.get(0).watchlist_content_descriptions2__c = child1.getChildElement('description', null).getAttribute('description2', null)+';';
                                                }
                                            }
                                            if(child1.getChildElement('description', null).getAttribute('description3', null) != null){
                                                if(wlsr_DB.get(0).watchlist_content_descriptions3__c != null){
                                                    wlsr_DB.get(0).watchlist_content_descriptions3__c += child1.getChildElement('description', null).getAttribute('description3', null)+';';
                                                }
                                                else{
                                                    wlsr_DB.get(0).watchlist_content_descriptions3__c = child1.getChildElement('description', null).getAttribute('description3', null)+';';
                                                }
                                            }
                                        }
                                    }                                    
                                }                                                        
                            if(child.getChildElement('adverse-media-content', null) != null){
                                wlsr_DB.get(0).Adverse_media__c = true;
                                adversemedia = true;
                            }
                            system.debug('child.getChildElement associates  :: '+child.getChildElement('associates', null));
                            if(child.getChildElement('associates', null) != null){
                                for(Dom.XMLNode child1 : child.getChildElement('associates', null).getChildElements()){
                                    system.debug('child1.getName() :: '+child1.getName());
                                    Watchlist_Search_Result_Associate__c wlsra = new Watchlist_Search_Result_Associate__c();                                    
                                    if(child1.getName().equals('associate')){
                                        wlsra.Watchlist_Search_Result__c = wlsr.Id;
                                        if(child1.getAttribute('peid', null) != null){
                                            wlsra.peid__c = child1.getAttribute('peid', null);
                                            /*if(wlsr_DB.get(0).associate_peid__c != null){
                                                wlsr_DB.get(0).associate_peid__c += child1.getChildElement('associate', null).getAttribute('peid', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_peid__c = child1.getChildElement('associate', null).getAttribute('peid', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('primary-name', null) != null){
                                            wlsra.primary_name__c = child1.getAttribute('primary-name', null);
                                            /*if(wlsr_DB.get(0).associate_primary_name__c != null){
                                                wlsr_DB.get(0).associate_primary_name__c += child1.getChildElement('associate', null).getAttribute('primary-name', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_primary_name__c = child1.getChildElement('associate', null).getAttribute('primary-name', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('relationship', null) != null){
                                            wlsra.relationship__c = child1.getAttribute('relationship', null);
                                            /*if(wlsr_DB.get(0).associate_relationship__c != null){
                                                wlsr_DB.get(0).associate_relationship__c += child1.getChildElement('associate', null).getAttribute('relationship', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_relationship__c = child1.getChildElement('associate', null).getAttribute('relationship', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('description1', null) != null){
                                            wlsra.description1__c = child1.getAttribute('description1', null);
                                            /*if(wlsr_DB.get(0).associate_description__c != null){
                                                wlsr_DB.get(0).associate_description__c += child1.getChildElement('associate', null).getAttribute('description1', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_description__c = child1.getChildElement('associate', null).getAttribute('description1', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('description2', null) != null){
                                            wlsra.description2__c = child1.getAttribute('description2', null);
                                            /*if(wlsr_DB.get(0).associate_description2__c != null){
                                                wlsr_DB.get(0).associate_description2__c += child1.getChildElement('associate', null).getAttribute('description2', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_description2__c = child1.getChildElement('associate', null).getAttribute('description2', null);    
                                            }*/
                                        }
                                        if(child1.getAttribute('ex', null) != null){
                                            wlsra.ex__c = child1.getAttribute('ex', null);
                                            /*if(wlsr_DB.get(0).associate_ex__c != null){
                                                wlsr_DB.get(0).associate_ex__c += child1.getChildElement('associate', null).getAttribute('ex', null);
                                            }
                                            else{
                                                wlsr_DB.get(0).associate_ex__c = child1.getChildElement('associate', null).getAttribute('ex', null);    
                                            }*/
                                        }
                                    }
                                    watchlistsearchresultassociatelist.add(wlsra);
                                }
                            }
                            system.debug('watchlistsearchresultassociatelist :: '+watchlistsearchresultassociatelist);
                            if(!watchlistsearchresultassociatelist.isEmpty()){
                                insert watchlistsearchresultassociatelist;
                            }
                            
                              if(child.getChildElement('watchlist-content', null) != null
                                 && child.getChildElement('watchlist-content', null).getChildElement('role-details', null) != null){
                                     for(Dom.XMLNode child1 : child.getChildElement('watchlist-content', null).getChildElement('role-details', null).getChildElements()){                                        
                                         Watchlist_Search_Result_Role__c wlsrr = new Watchlist_Search_Result_Role__c();
                                         if(child1.getName().equals('role')){                                               
                                             wlsrr.Watchlist_Search_Result__c = wlsr.Id;
                                             if(child1.getChildElement('occupation-title', null).getAttribute('occupation-category', null) != null){
                                                 wlsrr.occupation_category_value__c = child1.getChildElement('occupation-title', null).getText();
                                                 wlsrr.Occupation_category__c = child1.getChildElement('occupation-title', null).getAttribute('occupation-category', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occupation_cat__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occupation_cat__c += child1.getChildElement('occupation-title', null).getAttribute('occupation-category', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occupation_cat__c = child1.getChildElement('occupation-title', null).getAttribute('occupation-category', null)+';';
                                                 } */
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('since-day', null) != null){
                                                 wlsrr.since_day__c = child1.getChildElement('occupation-title', null).getAttribute('since-day', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_start_day__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_day__c += child1.getChildElement('occupation-title', null).getAttribute('since-day', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_day__c = child1.getChildElement('occupation-title', null).getAttribute('since-day', null)+';';
                                                 } */
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('since-month', null) != null){
                                                 wlsrr.since_month__c = child1.getChildElement('occupation-title', null).getAttribute('since-month', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_start_month__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_month__c += child1.getChildElement('occupation-title', null).getAttribute('since-month', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_month__c = child1.getChildElement('occupation-title', null).getAttribute('since-month', null)+';';
                                                 } */
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('since-year', null) != null){
                                                 wlsrr.since_year__c = child1.getChildElement('occupation-title', null).getAttribute('since-year', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_start_year__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_year__c += child1.getChildElement('occupation-title', null).getAttribute('since-year', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_start_year__c = child1.getChildElement('occupation-title', null).getAttribute('since-year', null)+';';
                                                 }*/
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('to-day', null) != null){
                                                 wlsrr.to_day__c = child1.getChildElement('occupation-title', null).getAttribute('to-day', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_end_day__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_day__c += child1.getChildElement('occupation-title', null).getAttribute('to-day', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_day__c = child1.getChildElement('occupation-title', null).getAttribute('to-day', null)+';';
                                                 }*/
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('to-month', null) != null){
                                                 wlsrr.to_month__c = child1.getChildElement('occupation-title', null).getAttribute('to-month', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_end_month__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_month__c += child1.getChildElement('occupation-title', null).getAttribute('to-month', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_month__c = child1.getChildElement('occupation-title', null).getAttribute('to-month', null)+';';
                                                 }*/
                                             }
                                             if(child1.getChildElement('occupation-title', null).getAttribute('to-year', null) != null){
                                                 wlsrr.to_year__c = child1.getChildElement('occupation-title', null).getAttribute('to-year', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_occup_end_year__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_year__c += child1.getChildElement('occupation-title', null).getAttribute('to-year', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_occup_end_year__c = child1.getChildElement('occupation-title', null).getAttribute('to-year', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('role-type', null) != null){
                                                 wlsrr.role_type__c = child1.getAttribute('role-type', null);
                                                 /*if(wlsr_DB.get(0).watchlist_content_role_type__c != null){
                                                     wlsr_DB.get(0).watchlist_content_role_type__c += child1.getAttribute('role-type', null)+';'; 
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).watchlist_content_role_type__c = child1.getAttribute('role-type', null)+ ';'; 
                                                 }*/
                                             }
                                         }
                                         watchlistsearchresultrolelist.add(wlsrr);
                                     }                                            
                                 }
                            if(!watchlistsearchresultrolelist.isEmpty()){
                                insert watchlistsearchresultrolelist;
                            }
                              if(child.getChildElement('watchlist-content', null) != null
                                 && child.getChildElement('watchlist-content', null).getChildElement('sanctions-reference-details', null) != null){
                                     for(Dom.XMLNode child1 : child.getChildElement('watchlist-content', null).getChildElement('sanctions-reference-details', null).getChildElements()){   
                                         Watchlist_Search_Result_SR__c wlsrsr = new Watchlist_Search_Result_SR__c();
                                         system.debug('child1.getName() :: '+child1.getName());
                                         system.debug('child1.getText() :: '+child1.getText());
                                         system.debug('child1 fff :: '+child1.getAttribute('list-provider-code', null));
                                         wlsrsr.Watchlist_Search_Result__c = wlsr.Id;
                                         if(child1.getName().equals('sanctions-reference')){
                                             wlsrsr.value__c = child1.getText();
                                             if(child1.getAttribute('list-provider-name', null) != null){
                                                 wlsrsr.List_Provider_Name__c = child1.getAttribute('list-provider-name', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_list_prov_name__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_list_prov_name__c += child1.getAttribute('list-provider-name', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_list_prov_name__c = child1.getChildElement('sanctions-reference', null).getAttribute('list-provider-name', null)+';';
                                                 }*/
                                             }                                             
                                             if(child1.getAttribute('list-provider-code', null) != null){
                                                 wlsrsr.List_Provider_Code__c = child1.getAttribute('list-provider-code', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_list_prov_code__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_list_prov_code__c += child1.getChildElement('sanctions-reference', null).getAttribute('list-provider-code', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_list_prov_code__c = child1.getChildElement('sanctions-reference', null).getAttribute('list-provider-code', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('description2', null) != null){
                                                 wlsrsr.Description2__c = child1.getAttribute('description2', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_desc2__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_desc2__c += child1.getChildElement('sanctions-reference', null).getAttribute('description2', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_desc2__c = child1.getChildElement('sanctions-reference', null).getAttribute('description2', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('status', null) != null){
                                                 wlsrsr.status__c = child1.getAttribute('status', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_status__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_status__c += child1.getChildElement('sanctions-reference', null).getAttribute('status', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_status__c = child1.getChildElement('sanctions-reference', null).getAttribute('status', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('since-day', null) != null){
                                                 wlsrsr.Since_Day__c = child1.getAttribute('since-day', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_start_day__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_day__c += child1.getChildElement('sanctions-reference', null).getAttribute('since-day', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_day__c = child1.getChildElement('sanctions-reference', null).getAttribute('since-day', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('since-month', null) != null){
                                                 wlsrsr.since_month__c = child1.getAttribute('since-month', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_start_month__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_month__c += child1.getChildElement('sanctions-reference', null).getAttribute('since-month', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_month__c = child1.getChildElement('sanctions-reference', null).getAttribute('since-month', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('since-year', null) != null){
                                                 wlsrsr.since_year__c = child1.getAttribute('since-year', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_start_year__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_year__c += child1.getChildElement('sanctions-reference', null).getAttribute('since-year', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_start_year__c = child1.getChildElement('sanctions-reference', null).getAttribute('since-year', null)+';';
                                                 }*/
                                             }                                         
                                             if(child1.getAttribute('to-day', null) != null){
                                                 wlsrsr.to_day__c = child1.getAttribute('to-day', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_end_day__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_day__c += child1.getChildElement('sanctions-reference', null).getAttribute('to-day', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_day__c = child1.getChildElement('sanctions-reference', null).getAttribute('to-day', null)+';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('to-month', null) != null){
                                                 wlsrsr.to_month__c = child1.getAttribute('to-month', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_end_month__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_month__c += child1.getChildElement('sanctions-reference', null).getAttribute('to-month', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_month__c = child1.getChildElement('sanctions-reference', null).getAttribute('to-month', null) +';';
                                                 }*/
                                             }
                                             if(child1.getAttribute('to-year', null) != null){
                                                 wlsrsr.to_year__c = child1.getAttribute('to-year', null);
                                                 /*if(wlsr_DB.get(0).wl_content_sanc_ref_end_year__c != null){
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_year__c += child1.getChildElement('sanctions-reference', null).getAttribute('to-year', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).wl_content_sanc_ref_end_year__c = child1.getChildElement('sanctions-reference', null).getAttribute('to-year', null)+';';
                                                 }*/
                                             }
                                             watchlistsearchresultsanctionreferencelist.add(wlsrsr);
                                         }                                         
                                     }                                     
                                 }
                            if(!watchlistsearchresultsanctionreferencelist.isEmpty()){
                                insert watchlistsearchresultsanctionreferencelist;
                            }  
                            
                            if(child.getChildElement('watchlist-content', null) != null
                               && child.getChildElement('watchlist-content', null).getChildElement('profile-notes', null) != null){
                                   String temp = child.getChildElement('watchlist-content', null).getChildElement('profile-notes', null).getText();
                                   if(temp.length() > 131000){
                                       wlsr_DB.get(0).wl_content_profile_notes__c = temp.substring(0, 131000);
                                       wlsr_DB.get(0).watckist_content_profile_notes__c = temp.substring(131001, temp.length());
                                   }
                                   else{
                                       wlsr_DB.get(0).wl_content_profile_notes__c = child.getChildElement('watchlist-content', null).getChildElement('profile-notes', null).getText();
                                   }
                               }
                            if(child.getChildElement('watchlist-content', null) != null
                               && child.getChildElement('watchlist-content', null).getChildElement('source-details', null) != null){
                                   for(Dom.XMLNode child1 : child.getChildElement('watchlist-content', null).getChildElement('source-details', null).getChildElements()){ 
                                       Watchlist_Search_Result_Source__c wlsrs = new Watchlist_Search_Result_Source__c();
                                       wlsrs.Watchlist_Search_Result__c =  wlsr.Id;
                                       if(child1.getName().equals('source')){
                                           if(!String.isEmpty(child1.getText())){
                                               wlsrs.value__c = child1.getText();
                                               if(child1.getText().startsWith('http')){
                                                   wlsrs.link__c = true;
                                               }
                                           }
                                           
                                              /*if(wlsr_DB.get(0).wl_content_source__c != null){
                                                  wlsr_DB.get(0).wl_content_source__c += ';'+child1.getText();
                                              }
                                              else{
                                                  wlsr_DB.get(0).wl_content_source__c = child1.getText();
                                              }*/
                                          }
                                       watchlistsearchresultsourcelist.add(wlsrs);
                                   }
                               }
                            if(!watchlistsearchresultsourcelist.isEmpty()){
                                insert watchlistsearchresultsourcelist;
                            } 
                            /*if(child.getChildElement('state-owned-companies-content', null) != null
                               && child.getChildElement('state-owned-companies-content', null).getChildElement('content-notice', null) != null){
                                   wlsr_DB.get(0).so_content_notice__c = child.getChildElement('state-owned-companies-content', null).getChildElement('content-notice', null).getText();
                               }
                            if(child.getChildElement('state-owned-companies-content', null) != null
                               && child.getChildElement('state-owned-companies-content', null).getChildElement('active-status', null) != null){
                                   wlsr_DB.get(0).so_active_status__c = child.getChildElement('state-owned-companies-content', null).getChildElement('active-status', null).getText();
                               }*/
                            /*if(child.getChildElement('state-owned-companies-content', null) != null
                               && child.getChildElement('state-owned-companies-content', null).getChildElement('descriptions', null) != null){
                                   for(Dom.XMLNode child1 : child.getChildElement('state-owned-companies-content', null).getChildElements()){                                       
                                       if(child1.getName().equals('descriptions')){
                                           if(child1.getChildElement('description', null).getAttribute('description1', null) != null){
                                               if(wlsr_DB.get(0).so_descriptions__c != null){
                                                   wlsr_DB.get(0).so_descriptions__c += child1.getChildElement('description', null).getAttribute('description1', null)+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_descriptions__c = child1.getChildElement('description', null).getAttribute('description1', null)+';';
                                               }
                                           }
                                           if(child1.getChildElement('description', null).getAttribute('description2', null) != null){
                                               if(wlsr_DB.get(0).so_descriptions2__c != null){
                                                   wlsr_DB.get(0).so_descriptions2__c += child1.getChildElement('description', null).getAttribute('description2', null)+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_descriptions2__c = child1.getChildElement('description', null).getAttribute('description2', null)+';';
                                               }
                                           }
                                           if(child1.getChildElement('description', null).getAttribute('description2', null) != null){
                                               if(wlsr_DB.get(0).so_descriptions3__c != null){
                                                   wlsr_DB.get(0).so_descriptions3__c += child1.getChildElement('description', null).getAttributeValue(child1.getChildElement('description', null).getAttributeKeyAt(2), child1.getChildElement('description', null).getAttributeKeyNsAt(2))+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_descriptions3__c = child1.getChildElement('description', null).getAttributeValue(child1.getChildElement('description', null).getAttributeKeyAt(2), child1.getChildElement('description', null).getAttributeKeyNsAt(2))+';';
                                               } 
                                           }
                                       }
                                   }
                               }*/
                            /*if(child.getChildElement('state-owned-companies-content', null) != null
                               && child.getChildElement('state-owned-companies-content', null).getChildElement('djii-industry-details', null) != null){
                                   for(Dom.XMLNode child1 : child.getChildElement('state-owned-companies-content', null).getChildElement('djii-industry-details', null).getChildElements()){
                                       if(child1.getName().equals('djii-industry')){
                                           if(child1.getAttribute('djii-industry-id', null) != null){
                                               if(wlsr_DB.get(0).so_djii_industry_Id__c != null){
                                                   wlsr_DB.get(0).so_djii_industry_Id__c += child1.getAttribute('djii-industry-id', null)+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_djii_industry_Id__c = child1.getChildElement('djii-industry', null).getAttributeValue(child1.getChildElement('djii-industry', null).getAttributeKeyAt(0), child1.getChildElement('djii-industry', null).getAttributeKeyNsAt(0))+';';
                                               }
                                           }
                                           if(child1.getAttribute('description', null) != null){
                                               if(wlsr_DB.get(0).so_djii_industry_description__c != null){
                                                   wlsr_DB.get(0).so_djii_industry_description__c += child1.getAttribute('description', null)+';';
                                               }
                                               else{
                                                   wlsr_DB.get(0).so_djii_industry_description__c = child1.getAttribute('description', null)+';';
                                               }
                                           }
                                       }
                                   }
                               }*/
                            system.debug(' dddd :: '+child.getChildElement('state-owned-companies-content', null));
                            //system.debug(' eeee :: '+child.getChildElement('state-owned-companies-content', null).getChildElement('stake-level-details', null));
                              if(child.getChildElement('state-owned-companies-content', null) != null 
                                 && child.getChildElement('state-owned-companies-content', null).getChildElement('stake-level-details', null) != null){
                                     for(Dom.XMLNode child1 : child.getChildElement('state-owned-companies-content', null).getChildElement('stake-level-details', null).getChildElements()){
                                         Watchlist_Search_Result_SOC__c wlsrsoc = new Watchlist_Search_Result_SOC__c();
                                         wlsrsoc.Watchlist_Search_Result__c =  wlsr.Id;
                                         system.debug('stake level :: '+child1.getName());
                                         if(child1.getName().equals('stake-level')){
                                             /*if(child1.getChildElement('ownership-percentage', null) != null){
                                                 if(wlsr_DB.get(0).so_stake_level_ownership_percentage__c != null){
                                                     wlsr_DB.get(0).so_stake_level_ownership_percentage__c += child1.getChildElement('ownership-percentage', null).getText()+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_ownership_percentage__c = child1.getChildElement('ownership-percentage', null).getText()+';';    
                                                 }
                                             }*/
                                             if(child1.getChildElement('stake-level-notes', null) != null){
                                                 wlsrsoc.Notes__c = child1.getChildElement('stake-level-notes', null).getText();
                                                 /*if(wlsr_DB.get(0).so_stake_level_notes__c != null){
                                                     wlsr_DB.get(0).so_stake_level_notes__c += child1.getChildElement('stake-level-notes', null).getText()+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_notes__c = child1.getChildElement('stake-level-notes', null).getText()+';';    
                                                 }*/
                                             }
                                             if(child1.getChildElement('since-date', null) != null){
                                                 if(child1.getChildElement('since-date', null).getAttribute('day', null) != null){
                                                     wlsrsoc.Since_day__c = child1.getChildElement('since-date', null).getAttribute('day', null);
                                                     /*if(wlsr_DB.get(0).so_stake_level_start_day__c != null){
                                                         wlsr_DB.get(0).so_stake_level_start_day__c += child1.getChildElement('since-date', null).getAttribute('day', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_start_day__c = child1.getChildElement('since-date', null).getAttribute('day', null)+';';
                                                     }*/
                                                 }
                                                 if(child1.getChildElement('since-date', null).getAttribute('month', null) != null){
                                                     wlsrsoc.Since_month__c = child1.getChildElement('since-date', null).getAttribute('month', null);
                                                     /*if(wlsr_DB.get(0).so_stake_level_start_month__c != null){
                                                         wlsr_DB.get(0).so_stake_level_start_month__c += child1.getChildElement('since-date', null).getAttribute('month', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_start_month__c = child1.getChildElement('since-date', null).getAttribute('month', null)+';';
                                                     }*/
                                                 }
                                                 if(child1.getChildElement('since-date', null).getAttribute('year', null) != null){
                                                     wlsrsoc.Since_year__c = child1.getChildElement('since-date', null).getAttribute('year', null);
                                                     /*if(wlsr_DB.get(0).so_stake_level_start_year__c != null){
                                                         wlsr_DB.get(0).so_stake_level_start_year__c += child1.getChildElement('since-date', null).getAttribute('year', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_start_year__c = child1.getChildElement('since-date', null).getAttribute('year', null)+';';
                                                     }*/
                                                 }
                                             }
                                             if(child1.getChildElement('to-date', null) != null){
                                                 if(child1.getChildElement('to-date', null).getAttribute('day', null) != null){
                                                     wlsrsoc.to_day__c = child1.getChildElement('to-date', null).getAttribute('day', null);
                                                     /*if(wlsr_DB.get(0).so_stake_level_end_day__c != null){
                                                         wlsr_DB.get(0).so_stake_level_end_day__c += child1.getChildElement('to-date', null).getAttribute('day', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_end_day__c = child1.getChildElement('stake-level', null).getChildElement('to-date', null).getChildElement('day', null).getText()+';';
                                                     }*/
                                                 }
                                                 if(child1.getChildElement('to-date', null).getAttribute('month', null) != null){
                                                     wlsrsoc.to_month__c = child1.getChildElement('to-date', null).getAttribute('month', null);
                                                     /*if(wlsr_DB.get(0).so_stake_level_end_month__c != null){
                                                         wlsr_DB.get(0).so_stake_level_end_month__c += child1.getChildElement('to-date', null).getAttribute('month', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_end_month__c = child1.getChildElement('to-date', null).getAttribute('month', null)+';';
                                                     }*/
                                                 }
                                                 if(child1.getChildElement('to-date', null).getAttribute('year', null) != null){
                                                     wlsrsoc.to_year__c = child1.getChildElement('to-date', null).getAttribute('year', null);
                                                     /*if(wlsr_DB.get(0).so_stake_level_end_year__c != null){
                                                         wlsr_DB.get(0).so_stake_level_end_year__c += child1.getChildElement('to-date', null).getAttribute('year', null)+';';
                                                     }
                                                     else{
                                                         wlsr_DB.get(0).so_stake_level_end_year__c = child1.getChildElement('to-date', null).getAttribute('year', null)+';';
                                                     }*/
                                                 } 
                                             }
                                             if(child1.getAttribute('stake-level-1', null) != null){
                                                 wlsrsoc.Control__c = child1.getAttribute('stake-level-1', null);
                                                 /*if(wlsr_DB.get(0).so_stake_level_1__c != null){
                                                     wlsr_DB.get(0).so_stake_level_1__c += child1.getAttribute('stake-level-1', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_1__c = child1.getAttribute('stake-level-1', null)+';';
                                                 }*/
                                             }    
                                             if(child1.getAttribute('stake-level-2', null) != null){
                                                 wlsrsoc.stake_level_2__c = child1.getAttribute('stake-level-2', null);
                                             }
                                             if(child1.getAttribute('stake-level-3', null) != null){
                                                 wlsrsoc.stake_level_3__c = child1.getAttribute('stake-level-3', null);
                                             }
                                             if(child1.getChildElement('ownership-percentage', null) != null){
                                                 wlsrsoc.Ownership_percentage__c = ' - '+child1.getChildElement('ownership-percentage', null).getText();
                                             }
                                             /*if(child1.getAttribute('stake-level-2', null) != null){
                                                 if(wlsr_DB.get(0).so_stake_level_2__c != null){
                                                     wlsr_DB.get(0).so_stake_level_2__c += child1.getAttribute('stake-level-2', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_2__c = child1.getAttribute('stake-level-2', null)+';';
                                                 }
                                             }
                                             if(child1.getAttribute('stake-level-3', null) != null){
                                                 if(wlsr_DB.get(0).so_stake_level_3__c != null){
                                                     wlsr_DB.get(0).so_stake_level_3__c += child1.getAttribute('stake-level-3', null)+';';
                                                 }
                                                 else{
                                                     wlsr_DB.get(0).so_stake_level_3__c = child1.getAttribute('stake-level-3', null)+';';
                                                 } 
                                             }*/
                                         }  
                                         watchlistsearchresultsoclist.add(wlsrsoc);
                                     }
                                     if(watchlistsearchresultsoclist.size() > 0){
                                         insert watchlistsearchresultsoclist;
                                     }
                                     /*if(child.getChildElement('state-owned-companies-content', null) != null 
                                        && child.getChildElement('state-owned-companies-content', null).getChildElement('source-details', null) != null){
                                            wlsr_DB.get(0).so_source_details__c += child.getChildElement('state-owned-companies-content', null).getChildElement('source-details', null).getText();
                                     } 
                                     if(child.getChildElement('state-owned-companies-content', null) != null 
                                        && child.getChildElement('state-owned-companies-content', null).getChildElement('profile-notes', null) != null){
                                            wlsr_DB.get(0).so_profile_notes__c += child.getChildElement('state-owned-companies-content', null).getChildElement('profile-notes', null).getText();
                                     }   */                                   
                                 }
                          }
                    }
                }                
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,res.getStatus()));
            }
                wlsr_DB.get(0).API_call_2__c = true; 
                matchedPrimaryName = wlsr_DB.get(0).matched_name_primary_name__c;
                matchedScriptName = wlsr_DB.get(0).matched_name_scripted__c;
                matchedAlsoKnownAsName = wlsr_DB.get(0).matched_name_also_known_as__c;
                update wlsr_DB.get(0);                
            }
            /*List<Watchlist_Search_Result__c> wlsrVal1_DB = [select Id, identification_type__c,wl_content_profile_notes__c,
                                                             (Select Id, OwnerId, Name,  Watchlist_Search_Result__c, List_Provider_Name__c, 
                                                              List_Provider_Code__c, Description2__c, status__c,
                                                              Since_Day__c, Since_Month__c, Since_Year__c, To_Day__c, To_Month__c, To_Year__c, 
                                                              Value__c From Watchlist_Search_Result_SR__r), 
                                                            (Select Id, OwnerId, Name, peid__c, primary_name__c, relationship__c, 
                                                             description2__c, ex__c, Watchlist_Search_Result__c From Watchlist_Search_Result_Associates__r),
                                                             (Select Value__c, Watchlist_Search_Result__c From Watchlist_Search_Result_Sources__r) , 
                                                            (Select Id, OwnerId, Name, role_type__c, Occupation_category__c,  
                                                             occupation_category_value__c, since_day__c, since_month__c, since_year__c, 
                                                             to_day__c, to_month__c, to_year__c, Watchlist_Search_Result__c 
                                                             From Watchlist_Search_Result_Roles__r) from Watchlist_Search_Result__c where Id =: wlsr.Id];
                system.debug('wlsrVal1_DB :: '+wlsrVal1_DB);*/
                for(Watchlist_Search_Result__c wlsrVal2_DB : [select Id, identification_type__c,wl_content_profile_notes__c, matched_name_primary_name__c, watckist_content_profile_notes__c,
                                                              matched_name_scripted__c, matched_name_also_known_as__c,
                                                             (Select Id, Name,  Watchlist_Search_Result__c, List_Provider_Name__c, 
                                                              List_Provider_Code__c, Description2__c, status__c,
                                                              Since_Day__c, Since_Month__c, Since_Year__c, To_Day__c, To_Month__c, To_Year__c, 
                                                              Value__c From Watchlist_Search_Result_SR__r), 
                                                            (Select Id, OwnerId, Name, peid__c, primary_name__c, relationship__c, 
                                                             description2__c, type__c, ex__c, Watchlist_Search_Result__c From Watchlist_Search_Result_Associates__r limit 1000),
                                                             (Select Value__c, link__c, Watchlist_Search_Result__c From Watchlist_Search_Result_Sources__r) , 
                                                            (Select Id, Name, role_type__c, Occupation_category__c,  
                                                             occupation_category_value__c, since_day__c, since_month__c, since_year__c, 
                                                             to_day__c, to_month__c, to_year__c, Watchlist_Search_Result__c 
                                                             From Watchlist_Search_Result_Roles__r), 
                                                             (Select Id, Name, Control__c, Since_day__c, Since_month__c, 
                                                              since_year__c, To_month__c, To_Day__c, To_Year__c, 
                                                              Watchlist_Search_Result__c, Notes__c, Active__c, stake_level_2__c, stake_level_3__c, Ownership_percentage__c
                                                              From Watchlist_Search_Result_SOCs__r order by To_Year__c desc, Control__c) from Watchlist_Search_Result__c where Id =: wlsr.Id]){
                        matchedPrimaryName = wlsrVal2_DB.matched_name_primary_name__c;
                        matchedScriptName = wlsrVal2_DB.matched_name_scripted__c;
                        matchedAlsoKnownAsName = wlsrVal2_DB.matched_name_also_known_as__c; 
                       if(wlsrVal2_DB != null ){
                        List<String> multipleIdentificationList;
                        if(wlsrVal2_DB.identification_type__c != null){
                            multipleIdentificationList = wlsrVal2_DB.identification_type__c.split(';');
                        }
                        system.debug('multipleIdentificationList :: '+multipleIdentificationList); 
                        if(multipleIdentificationList != null && !multipleIdentificationList.isEmpty()){                             
                            for(String multipleIdentificationVal : multipleIdentificationList){                                
                                List<String> keyValList = multipleIdentificationVal.split(':');
                                system.debug('keyValList :: '+keyValList);
                                if(keyValList != null && !keyValList.isEmpty() && keyValList.size() > 1){
                                    identificationDetails_identificationtype_Map.put(keyValList[1], keyValList[0]);    
                                    system.debug('identificationDetails_identificationtype_Map inside :: '+identificationDetails_identificationtype_Map);
                                    searchResultId_identificationDetails_identificationtype_Map.put(wlsrVal2_DB.Id, identificationDetails_identificationtype_Map);
                                }     
                            } 
                        }
                    }
                                                                 if(wlsrVal2_DB.wl_content_profile_notes__c != null){
                                                                     profileNotes = wlsrVal2_DB.wl_content_profile_notes__c;
                                                                 }
                                                                 if(wlsrVal2_DB.watckist_content_profile_notes__c != null){
                                                                     profileNotes += wlsrVal2_DB.watckist_content_profile_notes__c;  
                                                                 }  
                    for(Watchlist_Search_Result_Role__c role : wlsrVal2_DB.Watchlist_Search_Result_Roles__r){
                         rolesList.add(role);                                         
                    }
                    for(Watchlist_Search_Result_Associate__c associate : wlsrVal2_DB.Watchlist_Search_Result_Associates__r){
                         associatesList.add(associate);                                         
                    }
                    for(Watchlist_Search_Result_Source__c source : wlsrVal2_DB.Watchlist_Search_Result_Sources__r){ 
                         sourcesList.add(source);                                         
                    }
                    for(Watchlist_Search_Result_SR__c sr : wlsrVal2_DB.Watchlist_Search_Result_SR__r){
                         sanctionReferenceList.add(sr);                                         
                    }
                    for(Watchlist_Search_Result_SOC__c soc : wlsrVal2_DB.Watchlist_Search_Result_SOCs__r){
                         socList.add(soc);                                         
                    }
                    //rolesList = wlsrVal2_DB.Watchlist_Search_Result_Roles__r;
                    //associatesList = wlsrVal2_DB.Watchlist_Search_Result_Associates__r;
                    //sourcesList = wlsrVal2_DB.Watchlist_Search_Result_Sources__r;
                    //sanctionReferenceList = wlsrVal2_DB.Watchlist_Search_Result_SR__r;      
                }
            system.debug('sanctionReferenceList :: '+sanctionReferenceList);
            system.debug('identificationDetails_identificationtype_Map :: '+identificationDetails_identificationtype_Map);
            system.debug('searchResultId_identificationDetails_identificationtype_Map :: '+searchResultId_identificationDetails_identificationtype_Map);
            //return wlsr_DB;
        }
        catch(Exception ex){
            system.debug('Exception getCause :: '+ex.getCause());
            system.debug('Exception getMessage :: '+ex.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            //return null;
        } 
        system.debug('wlsr_DB.get(0) :: '+wlsr_DB.get(0));
        //return wlsr_DB;
    }            
}