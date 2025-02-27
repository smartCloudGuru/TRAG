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

 Code purpose  : This is a controller working on a 'DDControlMeasureType' page to calculate related control measure
 


 Birthday      : 2014-07-01
 Api version   : v30

 ****************************************************************************************************************************/


public with sharing class DDControlMeasureType{

    public DD_Control_Measure__c obj;
    public Boolean refreshPage { get; set; }
    public String currentURL{ get; set; }
    public ApexPages.StandardController stdController { get; set; }
    public String testAcctId {get;set;}
    public String defaultValue{ get; set; }
    
    public SelectOption[] controlMeasureList { 
        public get;
        private set;
    }
    
    // Constructor
    public DDControlMeasureType(ApexPages.StandardController controller) {
        system.debug('DDControlMeasureType :: DDControlMeasureType :: start');
        refreshPage = false;
        stdController = controller;
        obj = (DD_Control_Measure__c) controller.getRecord();
        defaultValue = 'Choose Control Measure';
        getcontrolMeasureList();
        system.debug('DDControlMeasureType :: DDControlMeasureType :: end');
    }

    /**
        This method saves the control measure chosen by client from Control measure layout
    */
    public PageReference save() {
        system.debug('DDControlMeasureType :: save :: start');
        List<DD_Control_Measure__c> cm = [select Id, DD_Assessment__r.Account.ParentId, DD_Type__c, RecordType.name from  DD_Control_Measure__c where Id =: obj.Id];
        List<Control_Measure_Type__c> cmType = [select Id, Name from  Control_Measure_Type__c where Name =: defaultValue 
                                               and DDAccount__c =: cm.get(0).DD_Assessment__r.Account.ParentId];
        if(!cmType.isEmpty()){
            cm.get(0).DD_Type__c = cmType.get(0).Name;
        }
        else{
            cm.get(0).DD_Type__c = null;
        }
        
        update cm.get(0);
        User usr = [select contact.Account.IsPartner from User where Id =: UserInfo.getUserId()];
        if(!usr.contact.Account.IsPartner){
            currentURL = '/'+obj.Id;
        }
        else{
             currentURL = '/client/'+obj.Id;   
        }
        refreshPage = true;
        stdController.save();
        system.debug('DDControlMeasureType :: save :: end');
        return null;
    }
    
    /**
        This method fetches all the control measure specific to client
    */
    public  SelectOption[] getcontrolMeasureList(){
        
        system.debug('DDControlMeasureType :: getcontrolMeasureList :: start'); 
        List<DD_Control_Measure__c> cm = [select Id, RecordTypeId, DD_Type__c, RecordType.name from  DD_Control_Measure__c where Id =: obj.Id];
        RecordType rec = [Select r.Name, r.Id From RecordType r where Id =: cm.get(0).RecordTypeId];
        Id userId = UserInfo.getUserId();
        User usr = [select contactId, contact.AccountId from User where Id =: userId];
        List<Contact> accL = [select Id, AccountId from Contact where Id =: usr.ContactId];
        Id accId = usr.contact.AccountId;
        if(Test.isRunningTest()){
            accId = testAcctId;
        }
        List<Account> accList = [select Id, (Select Id, Name, Type__c From Control_Measure_Types__r) from Account where Id =: accId];
        this.controlMeasureList = new SelectOption[]{};
        if(accList!=null && accList.size()>0){
            controlMeasureList.add(new SelectOption('','Choose Control Measure'));
            for(Control_Measure_Type__c cmType : accList.get(0).Control_Measure_Types__r){
                if(rec.Name.equals(cmType.Type__c)){
                   controlMeasureList.add(new SelectOption(cmType.name,cmType.name));
                }
            }
        }
        system.debug('DDControlMeasureType :: getcontrolMeasureList :: start'); 
        return controlMeasureList;
    }
}