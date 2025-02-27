public class WLRiskModelCounterpartyType {
    
    public CounterParty_Invite__c obj;
    public Boolean refreshPage { get; set; }
    public String currentURL{ get; set; }
    public ApexPages.StandardController stdController { get; set; }
    public String testAcctId {get;set;}
    public String defaultValue{ get; set; }
    
    public WLRiskModelCounterpartyType(ApexPages.StandardController controller) {
    
        system.debug('WLRiskModelCounterpartyType :: WLRiskModelCounterpartyType :: start');
        refreshPage = false;
        stdController = controller;
        obj = (CounterParty_Invite__c) controller.getRecord();
        system.debug('obj  :: '+obj );
        defaultValue = 'Choose Counterparty Type';
        getWLCounterpartyList();
        system.debug('WLRiskModelCounterpartyType :: WLRiskModelCounterpartyType :: end');
    }

	public SelectOption[] wlcounterpartyList { 
        public get;
        private set;
    }  
    
    public PageReference save() {
        
        system.debug('WLRiskModelCounterpartyType :: save :: start');
        List<CounterParty_Invite__c> cp = [select Id, DD_Account__r.parentId, DD_Account__r.DD_Validity_in_months__c, DD_Account__r.DD_Questionaire__c, 
                                           DD_Account__r.WL_Risk_Model_Questionnaire__c, WL_Risk_Model_Counterparty_Type__c, WL_Risk_Model_Questionnaire__c, 
                                           DD_Counterparty_Type__c from  CounterParty_Invite__c where Id =: obj.Id];
        
        List<Risk_model_2_counterparty_type__c> wlcpType = [select Id, Name, Questionnaire_Name__c, Questionnaire_URL__c, Account__c                                                            
                                                from  Risk_model_2_counterparty_type__c 
                                                where Name =: defaultValue and Account__c =: cp.get(0).DD_Account__r.parentId];        
        if(!wlcpType.isEmpty()){
            cp.get(0).WL_Risk_Model_Counterparty_Type__c = wlcpType.get(0).Name; 
            cp.get(0).DD_Account__r.WL_Risk_Model_Questionnaire__c = wlcpType.get(0).Questionnaire_URL__c; 
            cp.get(0).WL_Risk_Model_Questionnaire__c = wlcpType.get(0).Questionnaire_URL__c;
        }
        else{
            cp.get(0).WL_Risk_Model_Counterparty_Type__c = null; 
            cp.get(0).DD_Account__r.WL_Risk_Model_Questionnaire__c = null; 
            cp.get(0).WL_Risk_Model_Questionnaire__c = null;
        }        
        update cp.get(0);
        update cp.get(0).DD_Account__r;
        User usr = [select contact.Account.IsPartner from User where Id =: UserInfo.getUserId()];
        if(!usr.contact.Account.IsPartner){
            currentURL = '/'+obj.Id;
        }
        else{
             currentURL = '/client/'+obj.Id;   
        }
        refreshPage = true;
        stdController.save();
        system.debug('WLRiskModelCounterpartyType :: save :: end');
        return null;
    }
    
    /**
        This method fetches list of counterparties specific to client
    */    
    public  SelectOption[] getWLCounterpartyList(){
            system.debug('WLRiskModelCounterpartyType :: getWLCounterpartyList :: start');
            Id userId = UserInfo.getUserId();
            User usr = [select contact.AccountId from User where Id =: userId];
            Id accId = usr.contact.AccountId;
            if(Test.isRunningTest()){
                accId = testAcctId;
            }
            List<Account> accList = [select Id, (Select Id, Name From Risk_model_2_counterparty_types__r) from Account where Id =: accId];
            this.wlcounterpartyList= new SelectOption[]{};
            if(accList!=null && accList.size()>0){
                wlcounterpartyList.add(new SelectOption('','Choose Counterparty Type'));
                for(Risk_model_2_counterparty_type__c wlcpType : accList.get(0).Risk_model_2_counterparty_types__r){
                   wlcounterpartyList.add(new SelectOption(wlcpType.name,wlcpType.name));
                }
            }
            system.debug('WLRiskModelCounterpartyType :: getWLCounterpartyList :: end');
            return wlcounterpartyList;
    }

}