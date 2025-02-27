public class DDInviationCreateExtension {
    
    public ApexPages.StandardController StdController {get;set;}
    public CounterParty_Invite__c invi;
    public boolean duplicateEmailExist {get;set;}
    public List<CounterParty_Invite__c> invitationList;
    pagereference pg;
    Id cpAccountId {get;set;}
    
     public DDInviationCreateExtension (ApexPages.StandardController stdController) {                
         system.debug('DDInviationCreateExtension :: start');
         cpAccountId = ApexPages.currentPage().getParameters().get('cpAccountId');
         duplicateEmailExist = false;
         try{
             this.StdController = stdController;    
             invi = (CounterParty_Invite__c) stdController.getRecord();
             if(cpAccountId != null){
                 invi.DD_Account__c = cpAccountId; 
             }
             
         }catch(Exception e){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
             //pr1 = null;            
         }
         system.debug('DDInviationCreateExtension :: End');
    }
    
    /*public pagereference cancel(){
        return StdController.cancel();
    }*/
    
    public pagereference checkExistingEmail(){
        
        system.debug('invi.DD_Email__c :: '+invi.DD_Email__c);        
        User user_DB = [select Id, contact.AccountId from User where Id =: Userinfo.getUserId()];
        system.debug('user_DB :: '+user_DB);
        system.debug('user_DB.contact.AccountId :: '+user_DB.contact.AccountId);
        invitationList = [select Id,  DD_Email__c from CounterParty_Invite__c where DD_Email__c =: invi.DD_Email__c
                          and DD_Account__r.parentId =: user_DB.contact.AccountId];
        system.debug('invitationList :: '+invitationList);
        if(!invitationList.isEmpty()){
            duplicateEmailExist = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.Duplicate_counterparty_message));
            return null;
        }
        else{            
            duplicateEmailExist= false;    
            upsert invi;
            pg = new pagereference('/'+invi.Id);
            pg.setRedirect(true);
            return pg;
        }            
    }
    
    public pagereference continueToSave(){
        upsert invi;        
        pg = new pagereference('/'+invi.Id);
        pg.setRedirect(true);
        return pg;
    }
}