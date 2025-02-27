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

 Code purpose  : This is a controller working on a 'DD_InstructionNewButton' button to calculate default record type and Client commissioner field
 


 Birthday      : 2014-04-01
 Api version   : v29

 ****************************************************************************************************************************/


public with sharing class DD_ListInstructionsController {

    private static String controlMeasureName;
    private static String instructionName; 
    public boolean isControlMeasureTypeChosen;
    public boolean isPlatform;
    private static String otherInformation;        
    public String testUserId {get;set;}
    private List<DD_Control_Measure__c> controlMeasureList;
    
    // Default Constructor to fetch the current control measure record
    public DD_ListInstructionsController(ApexPages.StandardSetController controller) {
        system.debug('DD_ListInstructionsController :: DD_ListInstructionsController :: start');        
        Pagereference pg;
        isControlMeasureTypeChosen = false;
        String controlMeasureId = ApexPages.currentPage().getParameters().get('id');
        if(controlMeasureId!=null){
            controlMeasureList = [select Id, DD_Type__c, DD_Assessment__r.DD_Other_Information__c, DD_Assessment__r.Account.Name, Name from DD_Control_Measure__c where Id =: controlMeasureId];
        }
        if(controlMeasureList!=null && controlMeasureList.size()>0){
            isPlatform = false;
            if(controlMeasureList.get(0).DD_Type__c != null && controlMeasureList.get(0).DD_Type__c != ''){
                controlMeasureName = controlMeasureList.get(0).Name;
                instructionName = controlMeasureList.get(0).DD_Assessment__r.Account.Name;
                if(controlMeasureList.get(0).DD_Assessment__r.DD_Other_Information__c != null){
                	otherInformation = controlMeasureList.get(0).DD_Assessment__r.DD_Other_Information__c;
                }
                else{
                    otherInformation = '';
                }
                isControlMeasureTypeChosen = true;
            }
            else{
                isControlMeasureTypeChosen = false;
                //controlMeasureList.get(0).addError('You have not selected Control Measure Type');                                
            }
        }
        else{
            isPlatform = true;
        }
        system.debug('DD_ListInstructionsController :: DD_ListInstructionsController :: end');
    }

    /**
        This method get data from the custom setting and populates it on the
        new Instruction record creation page
    */
    Public Pagereference newButtonRedirect(){
        
        system.debug('DD_ListInstructionsController :: newButtonRedirect :: start');
        List<Contact> contactList;
        String contactName='';
        Integer taskOrderRequired;
        String recordTypeId;
        String instructionObjectId;
        String userType;
        String loggedInUserName;
        String InstructionEnvironmentValue;
        String name = UserInfo.getName();
        String loggedInUserType= UserInfo.getUserType();
        String userId = UserInfo.getUserId();
        String contactPageId;
        Pagereference pg;
        String controlMeasurePageId;
        String taskOrderRequiredPageId;
        String primarySubjectPageId;
        String otherInformationPageId;
        List<New_Button_Override__c> newButtonOverrideListPlatform;
        List<New_Button_Override__c> newButtonOverrideList;
        
        if(Test.isRunningTest()){
            userId = testUserId;
        }
        List<User> userList = [select Id, ContactId from User where Id=: userId];
                
        // Get related contact of logged in user 
        if(userList!=null && userList.size()>0){
           contactList = [select Id, Name, Account.DD_Task_Order_Required__c from Contact where Id=: userList.get(0).ContactId];
        }        
        if(contactList!=null && contactList.size()>0){
            contactName = contactList.get(0).Name;
            if(contactList.get(0).Account.DD_Task_Order_Required__c){
                taskOrderRequired = 1;
            }
            else{
                taskOrderRequired = 0;
            }
            if(contactName==null){
                contactName = '';
            }
        }
        
        String domainName = URL.getSalesforceBaseUrl().toExternalForm();
        
        // Get values from Custom setting which contains id of custom object, record type Id and visualforce page id for client commissioner field
        
        if(isPlatform){
            newButtonOverrideListPlatform = New_Button_Override__c.getall().values();
            for(New_Button_Override__c newButtonOverrideVal : newButtonOverrideListPlatform){
                if(newButtonOverrideVal.Name.equals('New Button Over Ride')){
                    instructionObjectId = newButtonOverrideVal.Instruction_Object_Page_Id__c;
                    recordTypeId = newButtonOverrideVal.Record_Type_Page_Id__c;
                    contactPageId = newButtonOverrideVal.Logged_In_User_Contact_Page_Id__c;
                    taskOrderRequiredPageId = newButtonOverrideVal.Task_Order_Required__c;
                    InstructionEnvironmentValue = newButtonOverrideVal.InstructionEnvironmentValue__c;
                }            
            }
        }
        else{
            newButtonOverrideList = New_Button_Override__c.getall().values();
            for(New_Button_Override__c newButtonOverrideVal : newButtonOverrideList){
                if(newButtonOverrideVal.Name.equals('New List Button Over Ride')){
                    instructionObjectId = newButtonOverrideVal.Instruction_Object_Page_Id__c;
                    recordTypeId = newButtonOverrideVal.Record_Type_Page_Id__c;
                    contactPageId = newButtonOverrideVal.Logged_In_User_Contact_Page_Id__c;
                    controlMeasurePageId = newButtonOverrideVal.Control_Measure_Page_Id__c;
                    taskOrderRequiredPageId = newButtonOverrideVal.Task_Order_Required__c;
                    InstructionEnvironmentValue = newButtonOverrideVal.InstructionEnvironmentValue__c;
                    primarySubjectPageId = newButtonOverrideVal.Primary_Subject_Page_Id__c;
                    otherInformationPageId = newButtonOverrideVal.Other_Information_Page_Id__c;
                }            
            }
        }
            system.debug('controlMeasureList :: '+controlMeasureList);
            // Dynamically generating URL depending on user type (Standard salesforce user or Portal User)
            if(isControlMeasureTypeChosen || isPlatform){
                if(loggedInUserType.equals('Standard')){
                    pg = new Pagereference(domainName+'/'+InstructionEnvironmentValue+'/e?retURL=/'+InstructionEnvironmentValue+'/o&RecordType='+recordTypeId+'&ent='+instructionObjectId+'&'+contactPageId+'='+contactName+'&nooverride=1&'+controlMeasurePageId+'='+controlMeasureName+'&'+taskOrderRequiredPageId+'='+taskOrderRequired+'&'+primarySubjectPageId+'='+instructionName+'&'+otherInformationPageId+'='+otherInformation); //userType=PartnerUserLookup&
                    pg.setRedirect(true);
                }
                else if(loggedInUserType.equals('PowerPartner')){
                    pg = new Pagereference(domainName+'/client/'+InstructionEnvironmentValue+'/e?retURL=/'+InstructionEnvironmentValue+'/o&RecordType='+recordTypeId+'&ent='+instructionObjectId+'&'+contactPageId+'='+contactName+'&nooverride=1&'+controlMeasurePageId+'='+controlMeasureName+'&'+taskOrderRequiredPageId+'='+taskOrderRequired+'&'+primarySubjectPageId+'='+instructionName+'&'+otherInformationPageId+'='+otherInformation); //userType=PartnerUserLookup&            
                    pg.setRedirect(true);
                }
            }
            else{
                system.debug('controlMeasureList.get(0) :: '+controlMeasureList.get(0));
                controlMeasureList.get(0).addError('You have not chosen Control Measure type');
            }
            
            system.debug('DD_ListInstructionsController :: newButtonRedirect :: end');
            return pg;
    }

}