public class DDLUMABillingAccount {
    
    public DD_Instruction__c obj;
    public Boolean refreshPage { get; set; }
    public String currentURL{ get; set; }
    public ApexPages.StandardController stdController { get; set; }
    public String testAcctId {get;set;}
    public Id accId;
    public String defaultValue{ get; set; }
    
    public SelectOption[] billingAccountList { //this is where we're going to pull the list
        public get;
        private set;
    }
    
    /**
        Constructor
    */
    public DDLUMABillingAccount(ApexPages.StandardController controller) {
        system.debug('DDLUMABillingAccount :: DDLUMABillingAccount :: start');
        refreshPage = false;
        stdController = controller;
        obj = (DD_Instruction__c) controller.getRecord();
        defaultValue = 'Choose Billing Account';
        getBillingAccountList();
        system.debug('DDLUMABillingAccount :: DDLUMABillingAccount :: end');
    }

    /**
        This method saves the check level type chosen by client on the Instruction record
    */
    public PageReference save() {
        
        system.debug('DDLUMABillingAccount :: save :: start');
        system.debug('obj in save :: '+obj);
        List<DD_Instruction__c> ins = [select Id, DD_Check_Level__c, Billing_Account__c, currencyISOCode, DD_Currency__c,
                                       DD_Client_Commissioner__r.Account.LUMA_Account__c,
                                       DD_Client_Commissioner__r.AccountId from  DD_Instruction__c where Id =: obj.Id];
        system.debug('ins in save :: '+ins);        
        /*if(obj.Billing_Account__c == accId){
            Pagereference pgRef = new Pagereference('/apex/DDLUMANewInvoicingAccount?retURL=/'+obj.Id);
            pgRef.setRedirect(true);
            return pgRef;
        }
        else{*/
            ins.get(0).Billing_Account__c = defaultValue;// obj.Billing_Account__c;      
            update ins.get(0);                               
            User usr = [select contact.Account.IsPartner from User where Id =: UserInfo.getUserId()];
            if(!usr.contact.Account.IsPartner){
                currentURL = '/'+obj.Id;
            }
            else{
                 currentURL = '/client/'+obj.Id;   
            }
            refreshPage = true;
            //stdController.save();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Saved');
            ApexPages.addMessage(myMsg);
        //}        
        system.debug('DDLUMABillingAccount :: save :: end');
        return null;
    }
   
    /**
        This method fetches all the Instruction check level specific to Client
    */
    public  SelectOption[] getBillingAccountList(){            
            system.debug('DDInstructionCheckLevel :: getBillingAccountList :: start');
        AccountStructure.ObjectStructureMap[] accountHierarchyDetailsList;
            List<DD_Instruction__c> ins = [select Id, DD_Check_Level__c, Billing_Account__c, currencyISOCode, DD_Currency__c,
                                           DD_Client_Commissioner__r.AccountId,
                                           DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c
                                           from  DD_Instruction__c where Id =: obj.Id];
            accId = ins.get(0).DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c;
        system.debug('accId :: '+accId);
            if(Test.isRunningTest()){
                accId = testAcctId;
            }
            AccountStructure acc = new AccountStructure();
        if(accId!=null){
            accountHierarchyDetailsList = acc.formatObjectStructure(accId);
        }           
            system.debug('accountHierarchyDetailsList :: '+accountHierarchyDetailsList);
            //List<Account> accList = [select Id from Account where Id =: accId];
            this.billingAccountList = new SelectOption[]{};
            if(accountHierarchyDetailsList!=null && accountHierarchyDetailsList.size()>0){
                billingAccountList.add(new SelectOption('','Choose Billing Account'));
                for(AccountStructure.ObjectStructureMap accountHierarchyDetailsVal : accountHierarchyDetailsList){
                   system.debug('accountHierarchyDetailsVal :: '+accountHierarchyDetailsVal);
                   billingAccountList.add(new SelectOption(accountHierarchyDetailsVal.Account.Id,accountHierarchyDetailsVal.Account.name));
                }                
            }
        //billingAccountList.add(new SelectOption(accId,'New Invoicing Account'));
            system.debug('DDInstructionCheckLevel :: getBillingAccountList :: end');
            return billingAccountList;
    }

}