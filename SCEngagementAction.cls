public class SCEngagementAction {
    
    private ApexPages.StandardController StdController {get;set;}
    public SubcontractorEngagement__c scEngagement {get;set;}
    public Pagereference pr ;
    
    public SCEngagementAction (ApexPages.StandardController stdController) {                
        system.debug('SCEngagementAction :: SCEngagementAction :: start');
        try{
            this.StdController = stdController;            
            Id scEngagementId = stdController.getRecord().Id;        
            scEngagement = [Select Id, Status__c from SubcontractorEngagement__c  where id =:  scEngagementId];
            system.debug('scEngagement :: '+scEngagement);            
        }catch(Exception e){
            scEngagement.addError(e.getMessage());
        }
        system.debug('SCEngagementAction :: SCEngagementAction :: End');
    }
    
    public pagereference acceptEngagement(){  
        if(scEngagement.Status__c == 'Approved'){
            scEngagement.Status__c = 'Accepted';
            update scEngagement;
            pr = new Pagereference('/'+scEngagement.Id);
            pr.setRedirect (true);
            return pr;
        }
        else{
            scEngagement.addError(Label.SCAcceptDenyError);
        }
        
        return null;
    }
    
    public pagereference denyEngagement(){   
        
        if(scEngagement.Status__c == 'Approved'){
            scEngagement.Status__c = 'Declined';
            update scEngagement;
            pr = new Pagereference('/'+scEngagement.Id);
            pr.setRedirect (true);
            return pr;
        }
        else{
            scEngagement.addError(Label.SCAcceptDenyError);
        }
		
		return null;        
    }    
}