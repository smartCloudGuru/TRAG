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

 Code purpose  : This is a controller working on a 'DDInstructionCheckLevel' page to calculate related types of Instruction check level
 


 Birthday      : 2014-07-03
 Api version   : v29

 ****************************************************************************************************************************/


public with sharing class DDInstructionCheckLevel{

    public DD_Instruction__c obj;
    public Boolean refreshPage { get; set; }
    public String currentURL{ get; set; }
    public ApexPages.StandardController stdController { get; set; }
    public String testAcctId {get;set;}
    public String defaultValue{ get; set; }
    
    public SelectOption[] instructionCheckLevelList { //this is where we're going to pull the list
        public get;
        private set;
    }
    
    /**
        Constructor
    */
    public DDInstructionCheckLevel(ApexPages.StandardController controller) {
        system.debug('DDInstructionCheckLevel :: DDInstructionCheckLevel :: start');
        refreshPage = false;
        stdController = controller;
        obj = (DD_Instruction__c) controller.getRecord();
        defaultValue = 'Choose Check Level';
        getInstructionCheckLevelList();
        system.debug('DDInstructionCheckLevel :: DDInstructionCheckLevel :: end');
    }

    /**
        This method saves the check level type chosen by client on the Instruction record
    */
    public PageReference save() {
        
        system.debug('DDInstructionCheckLevel :: save :: start');
        system.debug('obj in save :: '+obj);
        system.debug('defaultValue :: '+defaultValue);
        if(Test.isRunningTest()){
            defaultValue = obj.DD_Check_Level__c;
        }
        List<DD_Instruction__c> ins = [select Id, DD_Check_Level__c, currencyISOCode, DD_Currency__c,
                                       DD_Expenses__c, DD_Expenses_Cap__c, DD_Timescale_working_days__c,
                                       DD_Client_Commissioner__r.AccountId from  DD_Instruction__c where Id =: obj.Id];
        system.debug('ins in save :: '+ins);
        List<Instruction_Check_Level_Type__c> iclType = [select Id, Name, CurrencyIsoCode, DDPrice__c, 
                                                         Expense__c, Expense_Cap__c, Timescale__c from  Instruction_Check_Level_Type__c where 
                                                         Name =: defaultValue  and Account__c =: ins.get(0).DD_Client_Commissioner__r.AccountId];
        system.debug('iclType in save :: '+iclType);
        if(iclType!=null && iclType.size()>0){
            ins.get(0).DD_Check_Level__c = iclType.get(0).Name;
            ins.get(0).DD_Price_Formula__c = iclType.get(0).DDPrice__c;
            ins.get(0).DD_Expenses__c = iclType.get(0).Expense__c;
            ins.get(0).DD_Expenses_Cap__c = iclType.get(0).Expense_Cap__c;
            ins.get(0).DD_Timescale_working_days__c = iclType.get(0).Timescale__c;
            ins.get(0).currencyISOCode = iclType.get(0).CurrencyIsoCode;
            ins.get(0).DD_Currency__c  = iclType.get(0).CurrencyIsoCode;
        }
        else{
             ins.get(0).DD_Check_Level__c = null;   
             ins.get(0).DD_Price_Formula__c = null;
        }
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
        system.debug('DDInstructionCheckLevel :: save :: end');
        return null;
    }
   
    /**
        This method fetches all the Instruction check level specific to Client
    */
    public  SelectOption[] getInstructionCheckLevelList(){
            
            system.debug('DDInstructionCheckLevel :: getInstructionCheckLevelList :: start');
            List<DD_Instruction__c> ins = [select Id, DD_Check_Level__c, currencyISOCode, DD_Currency__c,
                                           DD_Client_Commissioner__r.AccountId from  DD_Instruction__c where Id =: obj.Id];
            Id accId = ins.get(0).DD_Client_Commissioner__r.AccountId;
            if(Test.isRunningTest()){
                accId = testAcctId;
            }
            List<Account> accList = [select Id, (Select Id, currencyISOCode, 
                                                 Name From Instruction_Check_Level_Types__r) from Account where Id =: accId];
            this.instructionCheckLevelList = new SelectOption[]{};
            if(accList!=null && accList.size()>0){
                instructionCheckLevelList.add(new SelectOption('','Choose Check Level'));
                for(Instruction_Check_Level_Type__c iclType : accList.get(0).Instruction_Check_Level_Types__r){
                   system.debug('iclType :: '+iclType);
                   instructionCheckLevelList.add(new SelectOption(iclType.name,iclType.name));
                }
            }
            system.debug('DDInstructionCheckLevel :: getInstructionCheckLevelList :: end');
            return instructionCheckLevelList;
    }
}