public class WLPostSearchAnalysisController {
    
    public String searchResult {get;set;}
    public String searchId {get;set;}
    public String cpAccId {get;set;}
    public Boolean isTrial {get;set;}
    public String loggedInUserId {get;set;}
    public Pagereference pgRef;
    
    public WLPostSearchAnalysisController() {        
        isTrial = false;
        searchResult = ApexPages.currentPage().getParameters().get('searchResult');
        system.debug('searchResult :: '+searchResult);
        searchId = ApexPages.currentPage().getParameters().get('searchId');
        system.debug('searchId :: '+searchId);
        cpAccId = ApexPages.currentPage().getParameters().get('cpAccId');
        system.debug('cpAccId :: '+cpAccId);
        isTrial = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isTrial'));
        system.debug('isTrial :: '+isTrial);
        loggedInUserId = ApexPages.currentPage().getParameters().get('loggedInUserId');
        system.debug('loggedInUserId :: '+loggedInUserId);
    }
    
    public pagereference submitForApproval(){        
        try{ 
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            system.debug('cpAccId :: '+cpAccId);
            system.debug('loggedInUserId :: '+loggedInUserId);
            req1.setObjectId(cpAccId);
            req1.setSubmitterId(loggedInUserId);
            req1.setProcessDefinitionNameOrId(Label.WLAccountApprovalProcessId);
			req1.setSkipEntryCriteria(false);
            system.debug('req1 :: '+req1); 
            Approval.ProcessResult result = Approval.process(req1);
            pgRef = new Pagereference('/client/'+cpAccId);
            pgRef.setRedirect(true);
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to submit : '+ex.getMessage())); 
            return null;
        }
        return pgRef;
    }  
    
    public pagereference rejectCounterparty(){
        List<Account> accList;
        try{ 
            accList = [select Id, Counterparty_progress_status__c, IsCounterpartyValid__c from Account where Id =: cpAccId];
            system.debug('accList :: '+accList);
            if(!accList.isEmpty() && accList.size() == 1){
                if(accList.get(0).Counterparty_progress_status__c != 'Pending Approval' && accList.get(0).Counterparty_progress_status__c != 'Accepted'){
                    accList.get(0).Counterparty_progress_status__c = 'Rejected';
                    accList.get(0).IsCounterpartyValid__c = false;
                    update accList;
                    pgRef = new Pagereference('/client/'+cpAccId);
                    pgRef.setRedirect(true);
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to Reject : Record already approved or pending for approval')); 
                    return null;
                }
            }        
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to Reject : '+ex.getMessage())); 
            return null;
        }
        return pgRef;
    }
}