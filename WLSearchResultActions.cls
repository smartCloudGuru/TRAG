public class WLSearchResultActions {
    
    public Watchlist_Search_Result__c searchResult;
    public Pagereference pageRef; 
    List<User> loggedInUser;
    
    public WLSearchResultActions(ApexPages.StandardController controller) {
        system.debug('WLSearchResultActions :: constructor :: start ');        
        searchResult = (Watchlist_Search_Result__c)controller.getSubject();   
        system.debug('wls in constructor :: '+searchResult);
        loggedInUser = [select Id, UserType from User where Id =: Userinfo.getUserId()];
        if(loggedInUser!=null && loggedInUser.size()>0){           
           if(loggedInUser.get(0).userType.equals('PowerPartner')){
               pageRef = new Pagereference('/client/'+searchResult.Id);
           }
            else{
                pageRef = new Pagereference('/'+searchResult.Id); 
            }
       }                     
        system.debug('WLSearchResultActions :: constructor :: end ');
    } 
    
    public pagereference markHit(){
        searchResult.Outcome__c = 'Match';
        try{
            update searchResult;
            return pageRef;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update : '+ex.getMessage())); 
            return null;
        }
        
    }
    
    public pagereference markNotaHit(){
        searchResult.Outcome__c = 'No Match';
        try{
            update searchResult;
            return pageRef;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update : '+ex.getMessage())); 
            return null;
        }
    }
    
    public pagereference markPotential(){
        searchResult.Outcome__c = 'Potential';
        try{
            update searchResult;
            return pageRef;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update : '+ex.getMessage())); 
            return null;
        }
    }
    
    public pagereference markComplete(){
        
        List<Watchlist_Search__c> searchList;
        Boolean isPendingAnalysis;
        Integer count;
        List<Watchlist_Search_Subject__c> wlssList = new List<Watchlist_Search_Subject__c>();
        List<Watchlist_Search_Result__c> srToUpdateList = new List<Watchlist_Search_Result__c>();
        List<Watchlist_Search_Result__c> srList = [select Id, Locked__c, outcome__c, Researcher_comments__c, 
                                                   Watchlist_Search__c from Watchlist_Search_Result__c where Id =: searchResult.Id];        
        if(!srList.isEmpty() && srList.size() == 1 && srList.get(0).Watchlist_Search__c != null){
            searchList = [Select Id, Watchlist_Search_Subject__c, Number_of_hits__c, Watchlist_Search_Subject__r.Hit__c, w.Analysis_completed__c,  Watchlist_Search_Subject__r.Account__c, 
                          Watchlist_Search_Subject__r.Analysed__c, Watchlist_Search_Subject__r.Status__c, 
                          (Select Id,  Outcome__c, Researcher_comments__c From Watchlist_Search_Results__r) From Watchlist_Search__c w 
                          where Id =: srList.get(0).Watchlist_Search__c ];        
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to complete : Missing Search Result')); 
        }
        
        for(Watchlist_Search__c searchVal : searchList){
            count = 0;
            isPendingAnalysis = false;
            searchVal.Watchlist_Search_Subject__r.Hit__c = false;
            for(Watchlist_Search_Result__c wlsrVal : searchVal.Watchlist_Search_Results__r){
                if(String.isEmpty(wlsrVal.Outcome__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Analysis pending on 1 or more related search results'));
                    isPendingAnalysis= true;
                    return null;
                }
            }
            if(!isPendingAnalysis){
                searchVal.Analysis_completed__c = true;                
                for(Watchlist_Search_Result__c wlsrVal1 : searchVal.Watchlist_Search_Results__r){
                	wlsrVal1.Locked__c = true;
                    srToUpdateList.add(wlsrVal1);
                    if(wlsrVal1.Outcome__c.equals('Match')){
                        count = count + 1;                        
                        searchVal.Watchlist_Search_Subject__r.Hit__c = true;
                    }
                }
                if(count == 0){
                    searchVal.Watchlist_Search_Subject__r.Status__c = 'Approved';
                }
                searchVal.Number_of_hits__c = count;
                searchVal.Watchlist_Search_Subject__r.Analysed__c = true;
                wlssList.add(searchVal.Watchlist_Search_Subject__r);
            }
        }
        
        try{    
            if(searchList.size() > 0){
                update searchList;
            }
            if(srToUpdateList.size() > 0){
                update srToUpdateList;
            }
            if(wlssList.size() > 0){
                update wlssList;
            }
            if(loggedInUser!=null && loggedInUser.size()>0){           
                if(loggedInUser.get(0).userType.equals('PowerPartner')){
                    pageRef = new Pagereference('/client/apex/WLPostSearchAnalysis?searchResult='+searchResult.Id+'&loggedInUserId='+loggedInUser.get(0).Id+'&searchId='+searchList.get(0).Id+'&cpAccId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c);
                }
                else{
                    pageRef = new Pagereference('/apex/WLPostSearchAnalysis?searchResult='+searchResult.Id+'&loggedInUserId='+loggedInUser.get(0).Id+'&searchId='+searchList.get(0).Id+'&cpAccId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c);
                }
            } 
            return pageRef;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update : '+ex.getMessage())); 
            return null;
        }
    }
    
}