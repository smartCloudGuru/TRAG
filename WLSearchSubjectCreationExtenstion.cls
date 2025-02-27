public class WLSearchSubjectCreationExtenstion {
    
    public Watchlist_Search_Subject__c wlSubject;
    public String accId;
    public Pagereference pageRef; 
    
    public WLSearchSubjectCreationExtenstion(ApexPages.StandardController controller) {
        system.debug('WLSearchSubjectCreationExtenstion :: constructor :: start ');
        accId = ApexPages.currentPage().getParameters().get('accId'); 
        system.debug('accId :: '+accId);
        pageRef = new Pagereference('/client/'+accId);
        wlSubject = (Watchlist_Search_Subject__c)controller.getSubject();
        system.debug('wlSubject in constructor :: '+wlSubject);
        system.debug('WLSearchSubjectCreationExtenstion :: constructor :: end ');
    }
    
    public void createSearchSubject(){  
        try{             
            wlSubject.Account__c = accId;
            upsert wlSubject;            
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to create/update Primary Risk Model : '+ex.getMessage()));
        }
    }

    public pagereference prev(){   
        pageRef.setRedirect(true);
        return pageRef;
    }    

}