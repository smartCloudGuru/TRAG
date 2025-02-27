public class WLPrimaryRiskModelCreationExtension {
    
    
    public Primary_Risk_Model__c prm;
    public String accId;
    public Pagereference pageRef; 
    public Boolean displayAccountCreation {get;set;}
    
    public WLPrimaryRiskModelCreationExtension(ApexPages.StandardController controller) {
        system.debug('WLPrimaryRiskModelCreationExtension :: constructor :: start ');
        accId = ApexPages.currentPage().getParameters().get('accId'); 
        system.debug('accId :: '+accId);
        Account acc = [Select Id, (Select Id From Primary_Risk_Models__r) From Account a where Id=: accId];
        if(!acc.Primary_Risk_Models__r.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Already having Risk Model'));
            displayAccountCreation = false;
        }
        else{
            displayAccountCreation = true;
            pageRef = new Pagereference('/client/'+accId);
            prm = (Primary_Risk_Model__c)controller.getSubject();
            system.debug('prm in constructor :: '+prm);
            system.debug('WLPrimaryRiskModelCreationExtension :: constructor :: end ');
        }
    }
    
    public void createPrimaryRiskModel(){  
        try{             
            prm.Account__c = accId;
            upsert prm;
            //pageRef.setRedirect(true);
            //return pageRef;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to create/update Primary Risk Model : '+ex.getMessage()));
            //return null;
        }
    }

    public pagereference prev(){   
        pageRef.setRedirect(true);
        return pageRef;
    }    

}