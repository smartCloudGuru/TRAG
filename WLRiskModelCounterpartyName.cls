public class WLRiskModelCounterpartyName {

    public Case obj;
    public Boolean refreshPage { get; set; }
    public String currentURL{ get; set; }
    public ApexPages.StandardController stdController { get; set; }
    //public String testAcctId {get;set;}
    
    public WLRiskModelCounterpartyName(ApexPages.StandardController controller) {
            refreshPage = false;
            stdController = controller;
            obj = (Case) controller.getRecord();
            system.debug('obj  :: '+obj );
            getWLCounterpartyList();
    }

    public PageReference save() {
        system.debug('objddd :: '+obj );
        List<Case> csList = [select Id, Account.DD_Validity_in_months__c, Account.ParentId,
                             Account.WL_Risk_Model_Questionnaire__c, WL_Risk_Model_Counterparty_Type__c, WL_Risk_Model_Questionnaire__c, 
                             (Select Id, dd_Questionnaire_Response_ID__c From Questionnaire_Responses__r), Account.DD_Questionaire__c, DD_Questionnaire_URL__c, DD_Counterparty_Type__c from Case where Id =: obj.Id];
        system.debug('csList :: '+csList);
        //String qResponseId = String.valueOf(csList.get(0).Questionnaire_Responses__r.get(0).Id).subString(0,15);
        List<Risk_model_2_counterparty_type__c> wlcpType = [select Id, Name, Questionnaire_Name__c, Questionnaire_URL__c from  Risk_model_2_counterparty_type__c where Name =: obj.DD_Counterparty_Type__c
                                                           and Account__c =: csList.get(0).Account.parentId];
        system.debug('wlcpType :: '+wlcpType);
        
        csList.get(0).WL_Risk_Model_Counterparty_Type__c = wlcpType.get(0).Name; 
        csList.get(0).Account.WL_Risk_Model_Questionnaire__c = wlcpType.get(0).Questionnaire_URL__c; 
        csList.get(0).WL_Risk_Model_Questionnaire__c = wlcpType.get(0).Questionnaire_URL__c; 
        system.debug('csList.get(0) :: '+csList.get(0));
        update csList.get(0);
        update csList.get(0).Account;
        User usr = [select contact.Account.IsPartner from User where Id =: UserInfo.getUserId()];
        system.debug('usr :: '+usr);
        //currentURL = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/client/'+obj.Id;
        if(!usr.contact.Account.IsPartner){
            currentURL = '/'+obj.Id;
        }
        else{
             currentURL = '/client/'+obj.Id;   
        }
            system.debug('currentURL  :: '+currentURL );
            refreshPage = true;
        stdController.save();
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Saved');
        //ApexPages.addMessage(myMsg);
        return null;
    }


    public SelectOption[] wlcounterpartyList { //this is where we're going to pull the list
        public get;
        private set;
    }
   
    public  SelectOption[] getWLCounterpartyList(){
            Id userId = UserInfo.getUserId();
            system.debug('userId  :: '+userId );
            User usr = [select contact.AccountId from User where Id =: userId];
            system.debug('usr :: '+usr);
            Id accId = usr.contact.AccountId;
            /*if(Test.isRunningTest()){
               accId = testAcctId;
            }*/
            system.debug('accId :: '+accId);
            List<Account> accList = [select Id, (Select Id, Name From Risk_model_2_counterparty_types__r) from Account where Id =: accId];
            system.debug('accList :: '+accList);
            this.wlcounterpartyList= new SelectOption[]{};
            if(accList!=null && accList.size()>0){
                wlcounterpartyList.add(new SelectOption('','None'));
                for(Risk_model_2_counterparty_type__c wlcpType : accList.get(0).Risk_model_2_counterparty_types__r){
                   system.debug('wlcpType :: '+wlcpType);
                   wlcounterpartyList.add(new SelectOption(wlcpType.name,wlcpType.name));
                }
            }
            system.debug('wlcounterpartyList:: '+wlcounterpartyList);
            return wlcounterpartyList;
    }

}