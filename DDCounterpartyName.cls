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
 Api version   : v29

 ****************************************************************************************************************************/


public with sharing class DDCounterpartyName{

    public Case obj;
    public Boolean refreshPage { get; set; }
    public String currentURL{ get; set; }
    public ApexPages.StandardController stdController { get; set; }
    //public String testAcctId {get;set;}
    
    public DDCounterpartyName(ApexPages.StandardController controller) {
            refreshPage = false;
            stdController = controller;
            obj = (Case) controller.getRecord();
            system.debug('obj  :: '+obj );
            getCounterpartyList();
    }


    //public DDCounterparty() {
        //getcontrolMeasureList();
    //}
    
    public PageReference save() {
        system.debug('objddd :: '+obj );
        List<Case> csList = [select Id, Account.DD_Validity_in_months__c, (Select Id, dd_Questionnaire_Response_ID__c From Questionnaire_Responses__r), Account.DD_Questionaire__c, DD_Questionnaire_URL__c, DD_Counterparty_Type__c,  
                            Account.parentId from Case where Id =: obj.Id];
        system.debug('csList :: '+csList);
        //String qResponseId = String.valueOf(csList.get(0).Questionnaire_Responses__r.get(0).Id).subString(0,15);
        List<DD_Counterparty_Type__c> cpType = [select Id, Name, Questionnaire_Name__c, DD_validity_in_months__c , Questionnaire_URL__c 
                                                from  DD_Counterparty_Type__c where Name =: obj.DD_Counterparty_Type__c
                                               and Account__c =: csList.get(0).Account.parentId];
        system.debug('cpType :: '+cpType);
        csList.get(0).DD_Counterparty_Type__c = cpType.get(0).Name; 
        csList.get(0).Account.DD_Questionaire__c = cpType.get(0).Questionnaire_URL__c; 
        csList.get(0).Account.DD_Validity_in_months__c = cpType.get(0).DD_validity_in_months__c ; 
        csList.get(0).DD_Questionnaire_URL__c = cpType.get(0).Questionnaire_URL__c; 
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


    public SelectOption[] counterpartyList { //this is where we're going to pull the list
        public get;
        private set;
    }
   
    public  SelectOption[] getCounterpartyList(){
            Id userId = UserInfo.getUserId();
            system.debug('userId  :: '+userId );
            User usr = [select contact.AccountId from User where Id =: userId];
            system.debug('usr :: '+usr);
            Id accId = usr.contact.AccountId;
            /*if(Test.isRunningTest()){
               accId = testAcctId;
            }*/
            system.debug('accId :: '+accId);
            List<Account> accList = [select Id, (Select Id, Name From Counterparty_Types__r) from Account where Id =: accId];
            system.debug('accList :: '+accList);
            this.counterpartyList= new SelectOption[]{};
            if(accList!=null && accList.size()>0){
                counterpartyList.add(new SelectOption('','None'));
                for(DD_Counterparty_Type__c cpType : accList.get(0).Counterparty_Types__r){
                   system.debug('cpType :: '+cpType);
                   counterpartyList.add(new SelectOption(cpType.name,cpType.name));
                }
            }
            system.debug('counterpartyList:: '+counterpartyList);
            return counterpartyList;
    }
}