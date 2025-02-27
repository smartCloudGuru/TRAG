public class WLSearchExtension {
    
    public Watchlist_Search_Subject__c wls;
    public Map<String, Datetime> peid_CreatedDate_Map;
    public Watchlist_Search__c wlsearch {get;set;}
    public String searchSubject;
    public String accId {get;set;}
    public String lumaAccountId;
    public Pagereference pageRef;
    public Pagereference srPage;
    public String contentset {get;set;}
    public Date dateOfBirth{get;set;} 
    public boolean dateOfBirthStrict {get;set;}
    public boolean excludeDeceased {get;set;}
    public String filteramc {get;set;}
    public String filteramcoperator {get;set;} 
    public Date filterlrdfrom {get;set;}
    public Date filterlrdto {get;set;}
    public String filteroel {get;set;}
    public Date filteroellrdfrom {get;set;}
    public Date filteroellrdto {get;set;}
    public String filteroeloperator {get;set;}
    public String filterool {get;set;}
    public Date filteroollrdfrom {get;set;}
    public Date filteroollrdto {get;set;}
    public String filterooloperator {get;set;}
    public String filterpep {get;set;}
    public boolean filterpepexcludeadsr {get;set;}
    public String filterpepoperator {get;set;}
    public String filterregion {get;set;}
    public String filterregionkeys {get;set;}
    public String filterregionkeysoperator {get;set;}
    public String filterregionoperator {get;set;}
    public String filtersic {get;set;}
    public String filtersicoperator {get;set;}
    public String filtersl {get;set;}
    public Date filtersllrdfrom {get;set;}
    public Date filtersllrdto {get;set;}
    public String filtersloperator {get;set;}
    public String filtersoc {get;set;}
    public String filtersocincludeunknown {get;set;}
    public Decimal hitsfrom {get;set;}
    public Decimal hitsto {get;set;}
    public String recordtype {get;set;}
    public String searchtype {get;set;}
    public String searchCategory2;
    public String searchCategoryToInsert;
    public static String searchCategory {get;set;}
    public List <DDUtility.addName> addNames {get; set;}
    public String bulkSearchSubjectName {get;set;} 
    public Integer count {get; set;}
    public List<DDUtility.RelatedSearchSubjects> relatedWatchlistSearchSubjects {get;set;}
    public String searchCategory1 {get;set;}    
    public List<String> searchType1;
    public String searchtypeVal1; 
    public String contentSet1;
    public String contentSetToInsert;
    //public String searchPrecision get{if(searchPrecision==null)searchPrecision='broad';}set;
    public Integer yearStartRange{get;set;}
    public Integer yearEndRange{get;set;}
    public Integer outstandingAlerts {get;set;}
    //public List<SelectOption> checkList {get;set;}
    public Integer totalHits {get; set;}
    public Map<Id, Watchlist_Search_Subject__c> id_searchSubject_Map {get; set;}
    public Integer totalFlaggedAccounts {get; set;}
    public Map<Account, Integer> account_Hits_Map {get; set;}   
    public boolean isResultFound = false;
    public String name;
    public String multipleCountries;
    public Datetime dt;
    public boolean searchLimitReached {get;set;}
    public boolean isAdvanceSearch;
    public Account loggedinUserLUMAAccount;
    User loggedInUser;
    
    public String[] countryList {get;set;}
	
    public void enableAdvance(){
        isAdvanceSearch = true;
    }
    
    public void disableAdvance(){
        isAdvanceSearch = false;
    }
    
    /*public List<String> getSearchType1() {
        if(searchType1 == null){
            searchType1[0] = '02';
        }
        return searchType1;
    }
    
    public void setSearchType1(List<String> val) { 
        this.searchType1 = val;
    }*/
        
    public String searchPrecision{
        get{
            if(searchPrecision==null)
                searchPrecision='near';
            return searchPrecision;
        }
        set;
    }
    
    /*public List<String> searchType1 {
        get{
            if(searchCategory1 == '02'){
                searchType1 = new List<String>{'Watchlist'};
                    }
            else{
                searchType1 = new List<String>{'Watchlist','StateOwnedCompanies','AdverseMediaEntities' };
            }
            return searchType1;
        } 
        set;
    }*/
    
    public List<String> getsearchType1() {
        if(searchCategory1 == '02'){
            this.searchType1 = new List<String>{'Watchlist'};
                }
        else{
            this.searchType1 = new List<String>{'Watchlist','StateOwnedCompanies','AdverseMediaEntities' };
                }
        String searchType4 = ApexPages.currentPage().getParameters().get('searchType4');     
        system.debug('searchType4 :: '+searchType4);
        if(searchType4 != null){
            List<String> searchType5 = searchType4.split(',');
            system.debug('searchType5 :: '+searchType5);
            this.searchType1.clear();
            this.searchType1 = searchType5;            
        }
        system.debug('Inside getter :: '+this.searchType1);
        return this.searchType1;
    }
    
    public void setsearchType1(List<String> searchType1) {
        system.debug('Inside setter :: '+searchType1);
        this.searchType1 = searchType1;
    }

    
    public List<SelectOption> getCheckList(){
        List<SelectOption> checkList = new List<SelectOption>();
        checkList.add(new selectOption('Watchlist','Watchlist'));
        checkList.add(new selectOption('StateOwnedCompanies','State Owned Companies'));
        checkList.add(new selectOption('AdverseMediaEntities','Adverse Media Entities'));
        return checkList;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options = DDUtility.getItems();        
        return options;
    }
    
    public List<SelectOption> getPrecision() {
        List<SelectOption> options = new List<SelectOption>();
        options = DDUtility.getPrecision();        
        return options;
    }
    
    /*public String[] getsearchCategory() {
        return searchCategory;
    }
            
    public void setsearchCategory(String[] searchCategory) {
        this.searchCategory = searchCategory;
    }    */        
    
    public WLSearchExtension() {
        peid_CreatedDate_Map = new Map<String,Datetime>();
        
    }
    
    public WLSearchExtension(ApexPages.StandardController controller) {
        system.debug('WLSearchExtension :: constructor :: start ');    
        wls = (Watchlist_Search_Subject__c)controller.getSubject();
        system.debug('wls in constructor :: '+wls);
        searchLimitReached = false;
        searchSubject = ApexPages.currentPage().getParameters().get('Id'); 
        accId = ApexPages.currentPage().getParameters().get('accId'); 
        searchCategory1 = ApexPages.currentPage().getParameters().get('searchCategory1');            
        String dateOfBirth1 = ApexPages.currentPage().getParameters().get('date-of-birth');
        system.debug('dateOfBirth1 :: '+dateOfBirth1);
        //dateOfBirth = Date.valueOf(datetime.newInstance(2016, 01, 01).format('yyyy-MM-dd'));
        if(dateOfBirth1 != 'null' && dateOfBirth1 != ''){
            wls.Date_of_Birth__c = Date.valueOf(datetime.newInstance(2016, 01, 01).format('yyyy-MM-dd'));
            //dateOfBirth = wls.Date_of_Birth__c;
        }
        /*else{            
            wls.Date_of_Birth__c = Date.valueOf(dateOfBirth1);
            //dateOfBirth = wls.Date_of_Birth__c;
        }*/
        isAdvanceSearch = false;
        User usr = [select Id, ContactId, Contact.AccountId, Contact.Account.Prospective_Client__c,Contact.Account.Searches_Performed__c, Contact.Account.Allowed_Searches__c
                   from User where Id =: userinfo.getUserId()]; 
        loggedinUserLUMAAccount = usr.Contact.Account;
        if(usr.Contact.Account.Prospective_Client__c && (usr.Contact.Account.Searches_Performed__c - usr.Contact.Account.Allowed_Searches__c >= 0)){
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Reached Search Limit ')); 
            searchLimitReached = true;
        }  
        //system.debug('dateOfBirth in resp :: '+ApexPages.currentPage().getParameters().get('date-of-birth'));
        system.debug('wls.Date_of_Birth__c in resp :: '+ApexPages.currentPage().getParameters().get('date-of-birth'));
        
        if(ApexPages.currentPage().getParameters().get('date-of-birth') != null 
           && !ApexPages.currentPage().getParameters().get('date-of-birth').equals('null')
          && !ApexPages.currentPage().getParameters().get('date-of-birth').equals('')){
        	//dateOfBirth = Date.valueOf(ApexPages.currentPage().getParameters().get('date-of-birth'));
            wls.Date_of_Birth__c = Date.valueOf(ApexPages.currentPage().getParameters().get('date-of-birth'));
            isAdvanceSearch = true;
        }         
        if(ApexPages.currentPage().getParameters().get('yearStartRange') != null){
            yearStartRange = Integer.valueOf(ApexPages.currentPage().getParameters().get('yearStartRange'));
            isAdvanceSearch = true;
        }        
        if(ApexPages.currentPage().getParameters().get('yearEndRange') != null){
            yearEndRange = Integer.valueOf(ApexPages.currentPage().getParameters().get('yearEndRange'));
            isAdvanceSearch = true;
        } 
        //country = ApexPages.currentPage().getParameters().get('country');
        
        multipleCountries = ApexPages.currentPage().getParameters().get('country');
        system.debug('multipleCountries :: '+multipleCountries);
        if(!String.isEmpty(multipleCountries)){
            countryList = multipleCountries.split(',');
            isAdvanceSearch = true;
        }                
        system.debug('countryList :: '+countryList);
        if(searchCategory1 == null){
            searchCategory1 = '02';
        }
        name = ApexPages.currentPage().getParameters().get('name');
        searchPrecision = ApexPages.currentPage().getParameters().get('searchPrecision');
        /*String searchType4 = ApexPages.currentPage().getParameters().get('searchType4');        
        if(searchType4 != null){
            List<String> searchType5 = searchType4.split(',');
            searchType1 = new List<String>();
            searchType1 = searchType5;            
        }*/
        //else{
           // searchType1 = new List<String>{'Watchlist'};
        //}        
        if(accId == null){
            this.accId = Label.Watchlist_Temp_Account_Id;
        }
        if(accId!=null){
            this.lumaAccountId = [Select Id, Prospective_Client__c, Allowed_Searches__c, Searches_Performed__c, ParentId From Account a where Id=: accId].ParentId;        
        }        
        totalHits = 0;
        totalFlaggedAccounts = 0;
        if(yearStartRange == null){
            this.yearStartRange = 1850; 
        }    
        else{
            this.yearStartRange = Integer.valueOf(yearStartRange);
        }        
        if(yearEndRange == null){
            this.yearEndRange = 2018;
        }
        else{
            this.yearEndRange = Integer.valueOf(yearEndRange);
        }
        id_searchSubject_Map = new Map<Id, Watchlist_Search_Subject__c>();  
        peid_CreatedDate_Map = new Map<String,Datetime>();
        relatedWatchlistSearchSubjects = new List<DDUtility.RelatedSearchSubjects>();
        account_Hits_Map = new Map<Account, Integer>();
        pageRef = new Pagereference('/client/'+searchSubject);
        
        wls.Account__c = accId;
        count = 1;                
        DDUtility.addName addN = new DDUtility.addName();
        if(name != null){
            addN.firstName = name;
        }
        addNames = new List <DDUtility.addName>();
        addNames.add(addN);
        getCheckList();
        countOutstandingAlerts();        
        //populatePredefinedSearchParameters();
        countHitsAndFlaggedAccounts();
        system.debug('WLSearchExtension :: constructor :: end ');
    }
    
    public pagereference redirectToSearchResult(){  
        pagereference pg = new pagereference('/client/WLSearchResult?Id='+wlsearch.Id+'&searchSubjectId='+searchSubject+'&accId='+accId);
        pg.setRedirect(true);
        return pg;
    } 
    
    public void countOutstandingAlerts(){
        outstandingAlerts = 0;
        loggedInUser = [select Id, contactId, contact.AccountId from User where Id =: userinfo.getUserId()];                
        List<Watchlist_Search__c> wlSearchList_DB = [Select Id, Analysis_completed__c,  temp__c, total_hits__c,
                               (Select Id, temp__c From Watchlist_Search_Results__r where temp__c = false) 
                               From Watchlist_Search__c w where Account__r.ParentId =: loggedInUser.contact.AccountId 
                                                     and total_hits__c > 0 and is_Recurring_Search__c = true
                                                     and Analysis_completed__c = false and temp__c = false];
        for(Watchlist_Search__c wlSearchVal_DB : wlSearchList_DB){
            if(!wlSearchVal_DB.Watchlist_Search_Results__r.isEmpty() && !wlSearchVal_DB.Analysis_completed__c && wlSearchVal_DB.total_hits__c	 > 0 ){
                outstandingAlerts+=1;
            }            
        }
    }
    
    public void countHitsAndFlaggedAccounts(){         
        User loggedInUser = [select Id, contactId, contact.AccountId from User where Id =: userinfo.getUserId()];                
        List<Account> accList = [Select Id, name, (Select Id, Name , Total_Hits__c From Watchlist_Search_Subject__r where Total_Hits__c > 0) From Account where parentId =: loggedInUser.contact.AccountId];
        for(Account accVal : accList){
            Integer totalHitsForAccount = 0;
            List<Watchlist_Search_Subject__c> wlssList = accVal.Watchlist_Search_Subject__r;            
            if(!wlssList.isEmpty()){
                totalFlaggedAccounts += 1;
                for(Watchlist_Search_Subject__c wlssVal : wlssList){
                    totalHitsForAccount += Integer.valueOf(wlssVal.Total_Hits__c);
                    id_searchSubject_Map.put(wlssVal.Id, wlssVal);
                    totalHits += Integer.valueOf(wlssVal.Total_Hits__c);
                }                
            }
            if(totalHitsForAccount >0){
                account_Hits_Map.put(accVal, totalHitsForAccount);
            }
        }
    }
         
        
     public List<SelectOption> getcountryOptions() {
            List<SelectOption> countryOptions = new List<SelectOption>();                     
            countryOptions = DDUtility.getcountryOptions();            
            return countryOptions;
     }
    
    public void getRelatedSearchSubjects(){
        system.debug('wls.Account__c  :: '+wls.Account__c );
        relatedWatchlistSearchSubjects = DDUtility.getRelatedSearchSubjects(wls.Account__c);
    }
        
    public void addNewName(){
        count = count+1;
        system.debug('count in addname :: '+count);
        DDUtility.addName addN = new DDUtility.addName();
        addNames.add(addN);
        system.debug('addNames :: '+addNames);
    }
    public void removeNewName(){
        addNames.remove(count-1);
        count = count - 1;
    }
        
    public void subjectSearch(){  
        try{ 
            system.debug('WLSearchExtension :: subjectSearch :: start ');            
            constructAPIQuery();            
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Watchlist_Search_Error)); 
        }
    }
    
    public Pagereference constructAPIQuery(){
        boolean errorPresent = false;
        String dowjonesEndPont = Label.Watch_List_Dowjones_Server;
        String searchCategoryValue;
        String parameters = '?';
        String apiCallQuery;           
        multipleCountries='';
        system.debug('searchCategory1 :: ');
        system.debug('searchCategory1 :: '+searchCategory1);
        system.debug('searchType1 :: '+searchType1);
        system.debug('isAdvanceSearch :: '+isAdvanceSearch);
        if(String.isEmpty(addNames.get(0).firstName)){
            errorPresent = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Watchlist_Name_mandatory)); 
        } 
        if(searchType1.isEmpty()) {
            errorPresent = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Watchlist_search_type_mandatory)); 
        }        
        if(searchType1 != null && !searchType1.isEmpty()){
            for(String searchtypeVal : searchType1){
                if(searchtypeVal == 'Watchlist'){
                    searchtypeVal1 = 'WL';                       
                }         
                else if(searchtypeVal == 'StateOwnedCompanies'){
                    searchtypeVal1 = 'SOC';    
                } 
                else if(searchtypeVal == 'AdverseMediaEntities'){
                    searchtypeVal1 = 'AM';    
                } 
                if(contentSetToInsert == null){      
                    contentSetToInsert = searchtypeVal;
                }
                else{
                    contentSetToInsert = contentSetToInsert+','+searchtypeVal;
                }
                if(contentSet1 == null){      
                    contentSet1 = searchtypeVal1;
                }
                else{
                    contentSet1 = contentSet1+','+searchtypeVal1;
                }
            }
            parameters = parameters+'content-set='+contentSet1;
        }
        system.debug('parameters after content set :: '+parameters);
        //searchCategoryValue = Label.Watchlist_Name_Search;   
        if(String.isNotEmpty(searchCategory1)){
            if(searchCategory1.equals('02')){
                searchCategory2 = 'P';
                searchCategoryToInsert = 'Person';
            }
            else if(searchCategory1.equals('03')){
                searchCategory2 = 'E';
                searchCategoryToInsert = 'Entity';
            }
        }
        parameters = parameters+'&record-type='+searchCategory2; 
        
        system.debug('country 1 :: '+countryList);
        if(isAdvanceSearch && !countryList.isEmpty()){
            //multipleCountries = country.replace('[', '').replace(']', '').replaceAll( '\\s+', '');
            //String[] countryList = country.split(',');
            for(String countryVal : countryList){ 
                if(!String.isEmpty(multipleCountries)){
                    multipleCountries +=  ','+countryVal;
                }
                else{
                    multipleCountries =  countryVal; 
                }
            }                                                 
            system.debug('multipleCountries in param :: '+multipleCountries);
            parameters = parameters+'&filter-region='+multipleCountries;
            parameters = parameters+'&filter-region-operator=OR';
        }        
        system.debug('parameters after record-type :: '+parameters);        
        system.debug('addNames.get(0).firstName :: '+addNames.get(0).firstName);
        system.debug('addNames.get(0).firstName :: '+addNames.get(0).firstName);
        //system.debug('dateOfBirth :: '+dateOfBirth);
        system.debug('wls.Date_of_Birth__c :: '+wls.Date_of_Birth__c);
            if(searchCategory1.equals(Label.WLNameTypeKey)){
            searchCategoryValue = Label.Watchlist_Name_Search;                        
            if(String.isNotEmpty(searchPrecision)){
                parameters = parameters+'&search-type='+searchPrecision;
            }
            if(!addNames.isEmpty() && addNames.get(0) != null && addNames.get(0).firstName != null){ 
                parameters = parameters+'&name='+EncodingUtil.urlEncode(addNames.get(0).firstName, 'UTF-8')/*wls.First_name__c+'%20'+wls.Last_Name__c*/;
            }
            if(isAdvanceSearch){
                if(yearStartRange != 1850 || yearEndRange != 2018){
                    if(yearStartRange > system.today().year() || yearEndRange > system.today().year()){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Year range can not be in future'));
                        return null;
                    }
                    else{
                        parameters = parameters+'&date-of-birth='+yearStartRange+'-'+yearEndRange;
                    }
                }
                else {
                    /*if(dateOfBirth != null && dateOfBirth != Date.valueOf(datetime.newInstance(2016, 01, 01).format('yyyy-MM-dd'))){
                        dt = datetime.newInstance(dateOfBirth.year(), dateOfBirth.month(), dateOfBirth.day());
                        parameters = parameters+'&date-of-birth='+dt.format('yyyy-MM-dd');
                        parameters = parameters+'&date-of-birth-strict=false';
                    }*/
                    if(wls.Date_of_Birth__c != null && wls.Date_of_Birth__c != Date.valueOf(datetime.newInstance(2016, 01, 01).format('yyyy-MM-dd'))){
                        dt = datetime.newInstance(wls.Date_of_Birth__c.year(), wls.Date_of_Birth__c.month(), wls.Date_of_Birth__c.day());
                        if(dt > system.today()){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Date of birth cannot be in future'));
                            return null;
                        }
                        else{
                            parameters = parameters+'&date-of-birth='+dt.format('yyyy-MM-dd');
                            parameters = parameters+'&date-of-birth-strict=false';
                        }                        
                    }
                }
            }
            //if(dateOfBirthStrict != null){
                
            //}
            /*if(excludeDeceased != null){
                parameters = parameters+'&exclude-deceased='+excludeDeceased;
            }*/                                    
            
        }
        /*else if(searchCategory1.equals(Label.WLPersonnametypekey)){
            searchCategoryValue = Label.Watchlist_Person_Name_Search;
            if(String.isNotEmpty(searchPrecision)){
                parameters = parameters+'&search-type='+searchPrecision;
            }
            if(String.isNotEmpty(wls.First_name__c)){
                parameters = parameters+'&first-name='+wls.First_name__c;
            }
            if(String.isNotEmpty(wls.Middle_name__c)){
                parameters = parameters+'&middle-name='+wls.Middle_name__c;
            }
            if(String.isNotEmpty(wls.last_name__c)){
                parameters = parameters+'&surname='+wls.last_name__c;
            }
            if(wls.Date_of_Birth__c != null){
                parameters = parameters+'&date-of-birth='+dateValue(wls.Date_of_Birth__c);
            }
            if(dateOfBirthStrict != null){
                parameters = parameters+'&date-of-birth-strict='+dateOfBirthStrict;
            }
            if(excludeDeceased != null){
                parameters = parameters+'&exclude-deceased='+excludeDeceased;
            }
        }*/
        else if(searchCategory1.equals(Label.wlentitynamekey)){
            searchCategoryValue = Label.Watchlist_Entity_Name_Search;
            if(String.isNotEmpty(searchPrecision)){
                parameters = parameters+'&search-type='+searchPrecision;
            }
            if(!addNames.isEmpty() && addNames.get(0) != null && addNames.get(0).firstName != null){
                parameters = parameters+'&entity-name='+EncodingUtil.urlEncode(addNames.get(0).firstName, 'UTF-8')/*wls.entity_name__c*/;
            }
        }
        /*else if(searchCategory1.equals(Label.WLIdtypekey)){
            searchCategoryValue = Label.Watchlist_ID_Type_Search;
            if(String.isNotEmpty(wls.id_type_key__c)){
                parameters = parameters+'&id-type-key='+wls.id_type_key__c;
            }
            if(String.isNotEmpty(wls.id_type_value__c)){
                parameters = parameters+'&id-type-value='+wls.id_type_value__c;
            }
        }*/        
        apiCallQuery = dowjonesEndPont+searchCategoryValue+parameters; 
        system.debug('apiCallQuery :: '+apiCallQuery);        
        system.debug('errorPresent :: '+errorPresent); 
        if(!errorPresent){
            callAndHandleResults(searchCategoryValue, parameters);   
        }
        return srPage;
    }
    
    
    public HttpResponse callAndHandleResults(String searchCategoryValue, String parameters){ 
        wlsearch = new Watchlist_Search__c();
        HttpResponse res;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        Pagereference pg;
        String ownerId;
        String ownerQueue;
        String watchListAnalysisQueueId;
        String clientWLQueueId;
        List<Account> accList;
        List<DGL__c> accountGroupList;
        User usr;
        system.debug('wls inside callAndHandleResults :: '+ wls);
        system.debug('searchCategoryValue after name :: '+searchCategoryValue);
        system.debug('parameters after name :: '+parameters);       
        if(loggedInUser != null && loggedInUser.contact.AccountId != null){
            if(String.valueOf(loggedInUser.contact.AccountId).subString(0,15).equals(Label.WLSanofiaccountId)
              || String.valueOf(loggedInUser.contact.AccountId).subString(0,15).equals(Label.WL_Sanofi_Demo_Account_Id)){
                system.debug('Sanofi end point :: '+Label.WLSearchEndpoint+searchCategoryValue+parameters);
                req.setEndpoint(Label.WLSanofiSearchEndpoint +searchCategoryValue+parameters); 
            }
            else{
                system.debug('Generic end point :: '+Label.WLSearchEndpoint+searchCategoryValue+parameters);
                req.setEndpoint(Label.WLSearchEndpoint+searchCategoryValue+parameters); 
            }
        }
        else{
                system.debug('Non Partner end point :: '+Label.WLSearchEndpoint+searchCategoryValue+parameters);
                req.setEndpoint(Label.WLSearchEndpoint+searchCategoryValue+parameters); 
            }
        
        req.setMethod('GET');
        try{
            system.debug('req :: '+req);
            res = h.send(req);
            system.debug('res :: '+res);  
            system.debug('res.getBody() :: '+res.getBody());
            System.debug('res.getStatusCode() :: '+res.getStatusCode());
            System.debug('res.getStatusCode() :: '+res.getStatusCode());
            if(res.getStatusCode() == 200){
                usr = [select Id, UserType, contact.AccountId from User where Id =: Userinfo.getUserId()];
                accList = [select Id, parent.Id, parent.Watchlist_Analysis_By_Client_Only__c , parent.Watchlist_Client__c  from Account where Id =: accId];
                accountGroupList = DGL__c.getall().values(); 
                if(!accList.isEmpty() && accList.size() == 1){
                    if(accList.get(0).parent.Watchlist_Client__c){
                        if(usr.UserType != null && usr.UserType.equals('PowerPartner')){                        
                            ownerQueue = '__CL_WL_TEAM_QUE';
                        }
                        else{
                            ownerQueue = '__RAG_WL_TEAM_QUE';
                        }
                    }
                    
                    system.debug('ownerQueue :: '+ownerQueue);
                    system.debug('accList.get(0).parent.Id :: '+accList.get(0).parent.Id);
                    for(DGL__c dglVal : accountGroupList){
                        system.debug('dglVal.Account__c :: '+dglVal.Account__c);
                        if(usr.UserType != null && usr.UserType.equals('PowerPartner')){
                            if(dglVal.Account__c.equals(String.valueOf(usr.contact.AccountId).subString(0,15)+ownerQueue)){
                                system.debug('Inside watchListAnalysisQueueId :: ');
                                watchListAnalysisQueueId = dglVal.Group__c;
                            }
                        }
                        else{
                            if(dglVal.Account__c.equals(String.valueOf(accList.get(0).parent.Id).subString(0,15)+ownerQueue)){
                                system.debug('Inside watchListAnalysisQueueId :: ');
                                watchListAnalysisQueueId = dglVal.Group__c;
                            }
                        }                    
                        if(dglVal.Account__c.equals(String.valueOf(accList.get(0).parent.Id).subString(0,15)+'__CL_WL_TEAM_QUE')){
                            clientWLQueueId = dglVal.Group__c;
                        }
                    }                        
                    system.debug('watchListAnalysisQueueId :: '+watchListAnalysisQueueId);
                    system.debug('clientWLQueueId :: '+clientWLQueueId);         
                }
                if(wls != null ){
                    //wls = new Watchlist_Search_Subject__c();
                    if(accList.get(0).Id == Label.Watchlist_Temp_Account_Id){
                        wls.temp__c = true;
                    }
                    
                    /*if(watchListAnalysisQueueId == null){
                        wls.ownerId = Label.Watchlist_Temp_Owner_Id;     
                    }                        
                    else{*/
                    wls.ownerId = watchListAnalysisQueueId;                            
                    //}  
                    if(addNames != null && !addNames.isEmpty()){
                        wls.Name = addNames.get(0).firstName;
                    }
                    else{
                        wls.Name = bulkSearchSubjectName;
                    }
                    wls.Account__c = accId;       
                    wls.Status__c = 'Pending';
                    wls.Last_searched__c = DDUtility.drop_leading_zeros(system.now().format('dd MMMM yyyy'));
                    wls.Last_Searched_Date__c = system.today();
                    wls.Searched_Query_parameter__c = parameters;
                    wls.Search_Category__c = searchCategoryValue;
                    wls.contentSetToInsert__c = contentSetToInsert;
                    wls.searchCategoryToInsert__c = searchCategoryToInsert;
                    //wls.Date_of_Birth__c = this.wls.Date_of_Birth__c;
                    insert wls;
                    if(loggedinUserLUMAAccount != null){
                        loggedinUserLUMAAccount.Searches_Performed__c += 1;
                        update loggedinUserLUMAAccount;
                    }                    
                }
                system.debug('wls after insert :: '+wls);
                Dom.Document doc = res.getBodyDocument();
                system.debug('doc :: '+doc);
                Dom.XMLNode rootElement = doc.getRootElement();
                //system.debug('address :: '+address);
                for(Dom.XMLNode child : rootElement.getChildElements()) {
                    System.debug('child.getChildElementHead :: '+child.getName());
                    if(String.isNotEmpty(child.getName()) && child.getName().equals('head')){                        
                        wlsearch.Name = wls.Name +' '+ system.now().format('dd MMMM yyyy');
                        wlsearch.Name__c = wls.Name+' '+ system.now().format('dd MMMM yyyy');
                        system.debug('wls.temp__c :: '+wls.temp__c);
                        wlsearch.temp__c = wls.temp__c;
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
                            if(Decimal.valueOf(child.getChildElement('total-hits', null).getText()) > 0){
                                isResultFound = true;
                            }
                        }
                        system.debug('isResultFound :: '+isResultFound);
                        if(Decimal.valueOf(child.getChildElement('hits-from', null).getText()) != null){
                           wlsearch.hits_from__c = Decimal.valueOf(child.getChildElement('hits-from', null).getText()); 
                        }      
                        if(Decimal.valueOf(child.getChildElement('hits-to', null).getText()) != null){
                            wlsearch.hits_to__c = Decimal.valueOf(child.getChildElement('hits-to', null).getText());
                        } 
                        if(Boolean.valueOf(child.getChildElement('truncated', null).getText()) != null){
                            wlsearch.truncated__c = Boolean.valueOf(child.getChildElement('truncated', null).getText());
                        } 
                        wlsearch.Account__c = wls.Account__c; 
                        wlsearch.Last_searched__c = system.now();
                        wlsearch.content_set__c = contentSetToInsert;                        
                        wlsearch.record_type__c = searchCategoryToInsert;
                        wlsearch.search_type__c = searchPrecision;
                        wlsearch.Watchlist_Search_Subject__c = wls.Id;
                        System.debug('child elements :: '+child.getChildElement('api-version', null).getText());
                    }
                }
                wlsearch.lastmodifieddate__c = DDUtility.drop_leading_zeros(system.now().format('dd MMMM yyyy'));
                upsert wlsearch;
                handleSearchResults(wlsearch, rootElement.getChildElements() , wls, false);                                
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,res.getStatus()+' : '+Label.Watchlist_Search_Error));
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()+' : '+Label.Watchlist_Search_Error));
        }
        return res;
    }
    
    public Pagereference handleSearchResults(Watchlist_Search__c wlsearch, List<Dom.XMLNode> childList, Watchlist_Search_Subject__c wls, boolean isRecurringSearch){
        List<Watchlist_Search_Result__c> wlSearchResultList = new List<Watchlist_Search_Result__c>();         
        Pagereference pg;
        system.debug('wlsearch :: '+wlsearch);
        system.debug('wls :: '+wls);
        system.debug('childList ::'+childList);
        Set<String> wlsr_peid_Set = new Set<String>();
        List<Watchlist_Search_Result__share> wlsrShareList = new List<Watchlist_Search_Result__share>();        
        List<Watchlist_Search_Result__c> wlsList_DB;
        Map<String, String> peid_ExistingStatus_Map = new Map<String, String>();
        system.debug('isResultFound 2 ::'+isResultFound);        
        wlsList_DB = [select Id, createddate, Outcome__c, Watchlist_Search__c, peid__c from Watchlist_Search_Result__c 
                      where Watchlist_Search__r.Watchlist_Search_Subject__c =: wls.Id];
        for(Watchlist_Search_Result__c wlsVal : wlsList_DB){
            peid_CreatedDate_Map.put(wlsVal.peid__c, wlsVal.createddate);
            peid_ExistingStatus_Map.put(wlsVal.peid__c, wlsVal.Outcome__c);
            wlsr_peid_Set.add(wlsVal.peid__c);
        }
            
            for(Dom.XMLNode child : childList) {            
                if(String.isNotEmpty(child.getName()) && child.getName().equals('body')){                
                    for(Dom.XMLNode child1 : child.getChildElements()) { 
                        system.debug('peid_CreatedDate_Map :: '+peid_CreatedDate_Map);
                        system.debug('peid_CreatedDate_Map.get(chil :: '+peid_CreatedDate_Map.get(child1.getAttribute('peid', null)));
                        system.debug('Date.valueOf(child1.getAttributeV :: '+Date.valueOf(child1.getAttributeValue('revision', null)));
                        if(String.isNotEmpty(child1.getName()) && child1.getName().equals('match')
                           && (peid_CreatedDate_Map.size() == 0 || (peid_CreatedDate_Map.get(child1.getAttribute('peid', null)) < Date.valueOf(child1.getAttributeValue('revision', null))
                           && peid_ExistingStatus_Map.get(child1.getAttribute('peid', null)) == 'Match'))){
                               Watchlist_Search_Result__c sr = new Watchlist_Search_Result__c();
                               /*if(watchListAnalysisQueueId == null){
                                   sr.ownerId = Label.Watchlist_Temp_Owner_Id;                               
                               }                        
                               else{
                                   sr.ownerId = watchListAnalysisQueueId;
                                   sr.temp__c = wlsearch.temp__c;
                               }  */    
                               sr.ownerId = wls.OwnerId;  
                               system.debug('wls.temp__c inside handle :: '+wls.temp__c);
                               sr.temp__c = wls.temp__c;    
                               sr.Date_Of_birth__c = ''; 
                               sr.country_details__c = '';
                               if(child1.getAttribute('peid', null) != null){
                                   sr.peid__c = child1.getAttribute('peid', null);
                               }
                               if(child1.getAttribute('revision', null) != null){
                                   sr.revision__c = child1.getAttributeValue('revision', null);
                                   sr.dowjones_last_reviewed_date__c = DDUtility.drop_leading_zeros(Datetime.valueOf(child1.getAttributeValue('revision', null)).format('dd MMMM yyyy'));                              
                               }
                               /*if(child1.getAttribute('revision', null) != null){
                                   sr.dowjones_last_reviewed_date__c = DDUtility.drop_leading_zeros(Datetime.valueOf(child1.getAttributeValue('revision', null)).format('dd MMMM yyyy'));
                               }*/
                               if(child1.getAttribute('record-type', null) != null){
                                   String temp = child1.getAttributeValue(child1.getAttributeKeyAt(2), child1.getAttributeKeyNsAt(2));
                                   sr.record_type__c = temp.toLowerCase();
                               }
                               system.debug('sr.record_type__c :: '+sr.record_type__c);
                               if(child1.getChildElement('score', null) != null){
                                   sr.score__c = Decimal.valueOf(child1.getChildElement('score', null).getText());
                               }
                               if(child1.getChildElement('match-type', null) != null){
                                   if(child1.getChildElement('match-type', null).getAttribute('linguistic-variation', null) != null){
                                       sr.linguistic_variation__c = Boolean.valueOf(child1.getChildElement('match-type', null).getAttributeValue('linguistic-variation', null));                        
                                   }
                                   if(child1.getChildElement('match-type', null).getAttribute('non-linguistic-variation', null) != null){
                                       sr.non_linguistic_variation__c = Boolean.valueOf(child1.getChildElement('match-type', null).getAttributeValue('non-linguistic-variation', null));
                                   }
                                   if(child1.getChildElement('match-type', null).getAttribute('structural-variation', null) != null){
                                       sr.structural_variation__c = Boolean.valueOf(child1.getChildElement('match-type', null).getAttributeValue('structural-variation', null));
                                   }
                               }
                               if(child1.getChildElement('payload', null) != null){
                                   if(child1.getChildElement('payload', null).getChildElement('risk-icons', null) != null){
                                       for(Dom.XMLNode child2 : child1.getChildElement('payload', null).getChildElement('risk-icons', null).getChildElements()) { 
                                           if(child2.getText() != null){
                                               if(child2.getText().startswithignorecase('SI')){
                                                   sr.risk_icon__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('ECR')){
                                                   sr.risk_icon_ecr__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('PEP')){
                                                   sr.risk_icon_pep__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('RCA')){
                                                   sr.risk_icon_rca__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('SAN')){
                                                   sr.risk_icon_san__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('OOL')){
                                                   sr.risk_icon_ool__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('OEL')){
                                                   sr.risk_icon_oel__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('SOR')){
                                                   sr.risk_icon_sor__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('SOC')){
                                                   sr.risk_icon_soc__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('BRD')){
                                                   sr.risk_icon_brd__c = child2.getText();
                                               }
                                               else if(child2.getText().startswithignorecase('AM')){
                                                   sr.risk_icon_am__c = child2.getText();
                                               }
                                               
                                           }
                                           /*else{
										sr.risk_icon__c =  child2.getText()+';'; 
										}*/
                                       }
                                   }
                                   if(child1.getChildElement('payload', null).getChildElement('primary-name', null) != null){
                                       sr.primary_name__c = child1.getChildElement('payload', null).getChildElement('primary-name', null).getText();
                                   }
                                   if(child1.getChildElement('payload', null).getChildElement('country-code', null) != null){
                                       if(child1.getChildElement('payload', null).getChildElement('country-code', null).getText() != null){
                                           sr.primary_country_code__c = getCountry(child1.getChildElement('payload', null).getChildElement('country-code', null).getText()); 
                                       }
                                       else{
                                           sr.primary_country_code__c = child1.getChildElement('payload', null).getChildElement('country-code', null).getText();   
                                       }                                       
                                   }
                                   if(child1.getChildElement('payload', null).getChildElement('title', null) != null){
                                       sr.title__c = child1.getChildElement('payload', null).getChildElement('title', null).getText();
                                   }
                                   if(child1.getChildElement('payload', null).getChildElement('subsidiary', null) != null){
                                       sr.subsidiary__c = Boolean.valueOf(child1.getChildElement('payload', null).getChildElement('subsidiary', null).getText());
                                   }
                                   /*if(child1.getChildElement('payload', null).getChildElement('matched-name', null).getAttribute('name-type', null) != null){
                                       if(child1.getChildElement('payload', null).getChildElement('matched-name', null).getAttributeValue('name-type', null).equals('Primary Name')){
                                           sr.matched_name__c = child1.getChildElement('payload', null).getChildElement('matched-name', null).getText();
                                       }
                                       if(child1.getChildElement('payload', null).getChildElement('matched-name', null).getAttributeValue('name-type', null).equals('Also Known As')){
                                           sr.matched_name_also_known_as__c = child1.getChildElement('payload', null).getChildElement('matched-name', null).getText();
                                       }                                
                                       if(child1.getChildElement('payload', null).getChildElement('matched-name', null).getAttributeValue('name-type', null).equals('Scripted Name')){
                                           sr.matched_name_scripted__c = child1.getChildElement('payload', null).getChildElement('matched-name', null).getText();
                                       }
                                   } */
                                   /*if(child1.getChildElement('payload', null).getChildElement('matched-name', null) != null 
                                    && child1.getChildElement('payload', null).getChildElement('matched-name', null).getText() != null){
                                    sr.matched_name__c = child1.getChildElement('payload', null).getChildElement('matched-name', null).getText();
                                    }*/
                                   if(child1.getChildElement('payload', null).getChildElement('matched-date-of-birth', null) != null){                                
                                       //sr.matched_date_of_birth__c = Date.valueOf(child1.getChildElement('payload', null).getChildElement('matched-date-of-birth', null).getText());
                                   }                            
                                   if(child1.getChildElement('payload', null).getChildElement('dates-of-birth', null) != null){
                                       for(Dom.XMLNode child3 : child1.getChildElement('payload', null).getChildElement('dates-of-birth', null).getChildElements()){                                     
                                           if(child3 != null && child3.getChildElement('day', null) != null){
                                               if(sr.day__c != null){
                                                   sr.day__c += ';'+child3.getChildElement('day', null).getText();
                                               }
                                               else{
                                                   sr.day__c = child3.getChildElement('day', null).getText();
                                               }
                                           }
                                           if(child3 != null && child3.getChildElement('month', null) != null){
                                               if(sr.month__c != null){
                                                   sr.month__c += ';'+child3.getChildElement('month', null).getText();
                                               }
                                               else{
                                                   sr.month__c = child3.getChildElement('month', null).getText();
                                               }
                                           }
                                           if(child3 != null && child3.getChildElement('year', null) != null){
                                               if(sr.year__c != null){
                                                   sr.year__c += ';'+child3.getChildElement('year', null).getText();
                                               }
                                               else{
                                                   sr.year__c = child3.getChildElement('year', null).getText();
                                               }
                                           }
                                       }
                                   }       
                                   if(child1.getChildElement('payload', null).getChildElement('countries', null) != null){
                                       for(Dom.XMLNode country : child1.getChildElement('payload', null).getChildElement('countries', null).getChildElements()){
                                           if(sr.country_details__c != null){
                                               sr.country_details__c += country.getChildElement('country-type', null).getText() + ','+country.getChildElement('country-code', null).getText()+';';
                                           }                                    
                                           else{
                                               sr.country_details__c = country.getChildElement('country-type', null).getText() + ','+country.getChildElement('country-code', null).getText()+';';
                                           } 
                                       }
                                   }                        
                                   if(child1.getChildElement('payload', null).getChildElement('gender', null) != null){
                                       String temp = child1.getChildElement('payload', null).getChildElement('gender', null).getText();
                                       sr.gender__c = temp.toLowerCase();   
                                   }     
                               }
                               system.debug('sr.gender__c :: '+sr.gender__c);    
                               sr.lastmodifieddateformatted__c = DDUtility.drop_leading_zeros(system.now().format('dd MMMM yyyy'));
                               sr.Watchlist_Search__c = wlsearch.Id;
                               system.debug('sr :: '+sr);
                               wlSearchResultList.add(sr);
                           }
                    }
                }        
                try{
                    system.debug('wlSearchResultList before insert :: '+wlSearchResultList);
                    upsert wlSearchResultList; 
                    wlsearch.total_hits__c = wlSearchResultList.size();
                    update wlsearch;
                    /*if(!accList.isEmpty() && accList.size() == 1 && !accList.get(0).parent.Watchlist_Analysis_By_Client_Only__c){
                        for(Watchlist_Search_Result__c wlSearchResultVal : wlSearchResultList){
                            Watchlist_Search_Result__share shr = new Watchlist_Search_Result__share(UserOrGroupId=clientWLQueueId, ParentId = wlSearchResultVal.id, AccessLevel = 'read');
                            wlsrShareList.add(shr);
                        }
                    }                
                    if(!wlsrShareList.isEmpty()){
                        system.debug('wlsrShareList before insert :: '+wlsrShareList);
                        insert wlsrShareList;                    
                    }*/
                    //pg = new Pagereference('/client/WLSearchResults?Id='+wlsearch.Id+'&searchSubjectId='+wls.Id+'&accId='+accId+'&resultFound=true');
                    //return pg;
                    
                }
                catch(Exception ex){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                    return null;
                }                     
            }
        //}
        //else{isResultFound
            //pg = new Pagereference('/client/WLSearchResults?Id='+wlsearch.Id+'&searchSubjectId='+wls.Id+'&accId='+accId+'&resultFound=false');
            //return pg;
        //}
        system.debug('wls.Date_of_Birth__c inside recurring :: '+wls.Date_of_Birth__c);
        if(!isRecurringSearch){
            /*String retURL = '/client/WLSearch?accId='+accId+'&searchCategory1='+searchCategory1+'&searchPrecision='
                +searchPrecision+'&searchType4='+contentSetToInsert+'&name='+EncodingUtil.urlEncode(addNames.get(0).firstName, 'UTF-8')
                ;*/
            String retURL = '/client/WLSearch?accId='+accId+'&searchCategory1='+searchCategory1+'&searchPrecision='
                +searchPrecision+'&searchType4='+contentSetToInsert+'&name='+EncodingUtil.urlEncode(wls.Name, 'UTF-8')+'&country='
                +multipleCountries+'&date-of-birth='+wls.Date_of_Birth__c/*dateOfBirth*/+'&yearStartRange='+yearStartRange+'&yearEndRange='+yearEndRange;
            srPage = new Pagereference('/client/WLSearchResults?Id='+wlsearch.Id+'&searchSubjectId='+wls.Id+'&accId='+accId);              
            srPage.getParameters().put('resultFound',String.valueOf(isResultFound));     
            srPage.getParameters().put('searchURL',retURL);          
            srPage.setRedirect(true);            
            return srPage;
        }
        return null;
    }
    
    public String getCountry(String countryCode){
        String mappedCountryName = '';
        WL_Dowjones_Country_mapping__c countryMappedVal = WL_Dowjones_Country_mapping__c.getAll().get(countryCode);
        if(countryMappedVal != null){
            mappedCountryName = countryMappedVal.Country_name__c;
        }
        return mappedCountryName;
    }
    
    public List<SelectOption> getcategory() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.WLNameTypeKey,'Name'));
        options.add(new SelectOption(Label.WLPersonnametypekey,'Person'));
        options.add(new SelectOption(Label.wlentitynamekey,'Entity'));
        options.add(new SelectOption(Label.WLIdtypekey,'ID Type'));
        return options;
    } 
        
    private String dateValue(Date dt){
        return Datetime.newInstance(dt.year(), dt.month(), dt.day()).format('YYYY-MM-dd');
    }
    
    /*public void populatePredefinedSearchParameters(){
        WatchList_Search_Parameters__c wlSearchParam;
        if(accId != null){
            wlSearchParam = WatchList_Search_Parameters__c.getAll().get(lumaAccountId.substring(0, 15));
            contentset = wlSearchParam.content_set__c;
            dateOfBirthStrict = wlSearchParam.date_of_birth_strict__c;
            excludeDeceased = wlSearchParam.exclude_deceased__c;
            filteramc = wlSearchParam.filter_amc__c;
            filteramcoperator = wlSearchParam.filter_amc_operator__c;
            filterlrdfrom = wlSearchParam.filter_lrd_from__c;
            filterlrdto = wlSearchParam.filter_lrd_to__c;
            filteroel = wlSearchParam.filter_oel__c;
            filteroellrdfrom = wlSearchParam.filter_oel_lrd_from__c;
            filterlrdto = wlSearchParam.filter_oel_lrd_to__c;
            filteroeloperator = wlSearchParam.filter_oel_operator__c;
            filterool = wlSearchParam.filter_ool__c;
            filteroollrdfrom = wlSearchParam.filter_ool_lrd_from__c;
            filteroollrdto = wlSearchParam.filter_ool_lrd_to__c;
            filterooloperator = wlSearchParam.filter_ool_operator__c;
            filterpep = wlSearchParam.filter_pep__c;
            filterpepexcludeadsr = wlSearchParam.filter_pep_exclude_adsr__c;
            filterpepoperator = wlSearchParam.filter_pep_operator__c;
            filterregion = wlSearchParam.filter_region__c;
            filterregionkeys = wlSearchParam.filter_region_keys__c;
            filterregionkeysoperator = wlSearchParam.filter_region_keys_operator__c;
            filterregionoperator = wlSearchParam.filter_region_operator__c;
            filtersic = wlSearchParam.filter_sic__c;
            filtersicoperator = wlSearchParam.filter_sic_operator__c;
            filtersl = wlSearchParam.filter_sl__c;
            filtersllrdfrom = wlSearchParam.filter_sl_lrd_from__c;
            filtersllrdto = wlSearchParam.filter_sl_lrd_to__c;
            filtersloperator = wlSearchParam.filter_sl_operator__c;
            filtersoc = wlSearchParam.filter_soc__c;
            filtersocincludeunknown = wlSearchParam.filter_soc_include_unknown__c;
            hitsfrom = wlSearchParam.hits_from__c;
            hitsto = wlSearchParam.hits_to__c;
            recordtype = wlSearchParam.record_type__c;
            searchtype = wlSearchParam.search_type__c;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to load search parameters : AccId missing '));
        }
    }*/
}