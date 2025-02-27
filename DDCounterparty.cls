/************************************************************************************************************************                                                                                         
 
              ***                                                            ***          *****                          
            ****                                                            *****       *****                            
          ****                                                                         *****                             
    ****************         **********         ****       *****        *****       *****             ************      
       ****             *****                *****       *****       *****       ******         *******                
      ***            ****       ****       *****       *****        ****        *****        ******      *****         
    ****           *****       ****       *****       *****       *****       *****        *****        ****           
   ****       ********       ****     *******       *****      ******       ******      *******       *****      ***** 
  *************** ***** *********  **********************************************************************************   
   ********          *****************     *******      ******     ********     *******       *******    *******         
                           ******                                                                                        
                         ******                                                                                          
                        ****                                                                          
                       ***                                                                         SOCIAL | MOBILE | WEB  
  
 
 
 Crafted by    : Mayank Sharma
               : msharma@tquila.com 
               : www.tquila.com

 Code purpose  : This is a controller working on a 'DDCounterTypeType' page to calculate related counterparty type
 


 Birthday      : 2014-07-01
 Api version   : v30

 ****************************************************************************************************************************/


public with sharing class DDCounterparty{

    public CounterParty_Invite__c obj;
    public Boolean refreshPage { get; set; }
    public String currentURL{ get; set; }
    public ApexPages.StandardController stdController { get; set; }
    public String testAcctId {get;set;}
    public String defaultValue{ get; set; }
    
    public SelectOption[] counterpartyList { 
        public get;
        private set;
    }
    
    //Constructor
    public DDCounterparty(ApexPages.StandardController controller) {
    
        system.debug('DDCounterparty :: DDCounterparty :: start');
        refreshPage = false;
        stdController = controller;
        obj = (CounterParty_Invite__c) controller.getRecord();
        system.debug('obj  :: '+obj );
        defaultValue = 'Choose Counterparty Type';
        getCounterpartyList();
        system.debug('DDCounterparty :: DDCounterparty :: end');
    }
    
    /**
        This method saves the counterparty chosen by Client on the invitation record
    */
    public PageReference save() {
        
        system.debug('DDCounterparty :: save :: start');
        List<CounterParty_Invite__c> cp = [select Id, DD_Account__r.parentId, DD_Account__r.DD_Validity_in_months__c, DD_Account__r.DD_Questionaire__c, DD_Counterparty_Type__c from  CounterParty_Invite__c where Id =: obj.Id];
        List<DD_Counterparty_Type__c> cpType = [select Id, Name, Questionnaire_Name__c, Questionnaire_URL__c, DD_validity_in_months__c 
                                                from  DD_Counterparty_Type__c 
                                                where Name =: defaultValue and Account__c =: cp.get(0).DD_Account__r.parentId];        
        if(!cpType.isEmpty()){
            cp.get(0).DD_Counterparty_Type__c = cpType.get(0).Name; 
            cp.get(0).DD_Account__r.DD_Questionaire__c = cpType.get(0).Questionnaire_URL__c; 
            cp.get(0).DD_Account__r.DD_Validity_in_months__c = cpType.get(0).DD_validity_in_months__c; 
            cp.get(0).DD_Questionnaire__c = cpType.get(0).Questionnaire_URL__c;
        }
        else{
            cp.get(0).DD_Counterparty_Type__c = null; 
            cp.get(0).DD_Account__r.DD_Questionaire__c = null; 
            cp.get(0).DD_Account__r.DD_Validity_in_months__c = null; 
            cp.get(0).DD_Questionnaire__c = null;
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
        system.debug('DDCounterparty :: save :: end');
        return null;
    }

    /**
        This method fetches list of counterparties specific to client
    */    
    public  SelectOption[] getCounterpartyList(){
            system.debug('DDCounterparty :: getCounterpartyList :: start');
            Id userId = UserInfo.getUserId();
            User usr = [select contact.AccountId from User where Id =: userId];
            Id accId = usr.contact.AccountId;
            if(Test.isRunningTest()){
                accId = testAcctId;
            }
            List<Account> accList = [select Id, (Select Id, Name From Counterparty_Types__r) from Account where Id =: accId];
            this.counterpartyList= new SelectOption[]{};
            if(accList!=null && accList.size()>0){
                counterpartyList.add(new SelectOption('','Choose Counterparty Type'));
                for(DD_Counterparty_Type__c cpType : accList.get(0).Counterparty_Types__r){
                   counterpartyList.add(new SelectOption(cpType.name,cpType.name));
                }
            }
            system.debug('DDCounterparty :: getCounterpartyList :: end');
            return counterpartyList;
    }
}