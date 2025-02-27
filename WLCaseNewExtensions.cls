public class WLCaseNewExtensions {
    
    public ApexPages.StandardController StdController {get;set;}
    public Case cs;
    public Pagereference pageRef; 
    public String searchResult {get;set;}
    public String searchId {get;set;}
    public String cpAccId {get;set;}
    
    public WLCaseNewExtensions(ApexPages.StandardController stdController) {             
        searchResult = ApexPages.currentPage().getParameters().get('searchResult');
        system.debug('searchResult :: '+searchResult);
        searchId = ApexPages.currentPage().getParameters().get('searchId');
        system.debug('searchId :: '+searchId);
        cpAccId = ApexPages.currentPage().getParameters().get('cpAccountId'); 
        system.debug('cpAccId :: '+cpAccId);
        this.StdController = StdController;
        cs = (Case) stdController.getRecord();
        if(cpAccId != null){
            cs.AccountId = cpAccId; 
        }        
    }
    
    public pagereference continueToSave(){
        List<Account> cpAccount = [select id, Sanofi_LE_for_contracting__c , Business_justification__c  from Account
                                   where id =: cpAccId];
        boolean isError = false;
        Contact con = new Contact();
        con.firstName = cs.first_Name__c;
        con.lastName = cs.Last_Name__c;
        con.AccountId = cpAccId;
        con.Email = cs.CounterpartyAccountEmailWL__c;
        try{
            if(cpAccount != null && cpAccount.size() == 1){
                if(cpAccount.get(0).Business_justification__c == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.WL_Sanofi_Counterparty_Engagement_Justification));
                    isError = true;
                }
                if(cpAccount.get(0).Sanofi_LE_for_contracting__c == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.WL_Sanofi_LE_Contracting_Error));
                    isError = true;
                }
                if(isError){
                    return null;
                }
                else{
                    insert con;
                    cs.ContactId = con.Id;
                    cs.DD_Contact__c =  con.Id;        
                    insert cs;                     
                }                  
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
        }
        pageRef = new pagereference('/'+cs.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
}