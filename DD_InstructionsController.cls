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
 


 Birthday      : 2014-03-31
 Api version   : v29

 ****************************************************************************************************************************/

public with sharing class DD_InstructionsController {

    public String testUserId {get;set;}
    // Default Constructor
    public DD_InstructionsController(ApexPages.StandardController controller) {}
    
    // This is action method on load of page which calculates default record type and Client commissioner field
    Public Pagereference newButtonRedirect(){
        
        system.debug('DD_InstructionsController :: newButtonRedirect :: start');
        List<Contact> contactList;
        String contactName='';
        Integer taskOrderRequired;
        String recordTypeId;
        String InstructionEnvironmentValue;
        String instructionObjectId;
        String userType;
        String loggedInUserName;
        
        String name = UserInfo.getName();
        String loggedInUserType= UserInfo.getUserType();
        String userId = UserInfo.getUserId();        
        String contactPageId;
        Pagereference pg;
        String taskOrderRequiredPageId;
        
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
        List<New_Button_Override__c> newButtonOverrideList = New_Button_Override__c.getall().values();
        for(New_Button_Override__c newButtonOverrideVal : newButtonOverrideList){
            if(newButtonOverrideVal.Name.equals('New Button Over Ride')){
                instructionObjectId = newButtonOverrideVal.Instruction_Object_Page_Id__c;
                recordTypeId = newButtonOverrideVal.Record_Type_Page_Id__c;
                contactPageId = newButtonOverrideVal.Logged_In_User_Contact_Page_Id__c;
                taskOrderRequiredPageId = newButtonOverrideVal.Task_Order_Required__c;
                InstructionEnvironmentValue = newButtonOverrideVal.InstructionEnvironmentValue__c;
            }            
        }
        // Dynamically generating URL depending on user type (Standard salesforce user or Portal User)        
            if(loggedInUserType.equals('Standard')){
                pg = new Pagereference(domainName+'/'+InstructionEnvironmentValue+'/e?retURL=/'+InstructionEnvironmentValue+'/o&RecordType='+recordTypeId+'&ent='+instructionObjectId+'&'+contactPageId+'='+contactName+'&nooverride=1'+'&'+taskOrderRequiredPageId+'='+taskOrderRequired); //userType=PartnerUserLookup&
            }
            else if(loggedInUserType.equals('PowerPartner')){
                pg = new Pagereference(domainName+'/client/'+InstructionEnvironmentValue+'/e?retURL=/'+InstructionEnvironmentValue+'/o&RecordType='+recordTypeId+'&ent='+instructionObjectId+'&'+contactPageId+'='+contactName+'&nooverride=1'+'&'+taskOrderRequiredPageId+'='+taskOrderRequired); //userType=PartnerUserLookup&            
            }
            pg.setRedirect(true);
            system.debug('DD_InstructionsController :: newButtonRedirect :: end');
            return pg;
       
    }
    
}