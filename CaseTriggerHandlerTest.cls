/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true) 
/* Seealldata is true because user creation in Risk Advisory depends on 
Financial Force Managed Package in which current company needs to be set 
and user to be assigned to multiple Financialforce queues which is not possible through test data creation. 
This has been checked with Financial Force Team */
public class CaseTriggerHandlerTest {
    
  /**
       Test if last assessment date on contact changes if it is less than closed date on assessment
   */
   static testMethod void caseTriggerHandlerTest() {
        system.debug('CaseTriggerHandlerTest  :: caseTriggerHandlerTest :: start');
        User u5;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            u5 = TestDataHelper.createCPPortaluser();            
        }
        system.runas(u5){
            List<DGL__c> accountGroupList = DGL__c.getall().values();            
            User usr = [select Id, contactId, contact.AccountId, contact.Account.ParentId from User where Id =: u5.Id];
            accountGroupList.get(0).Account__c = usr.contact.Account.ParentId;
            update accountGroupList.get(0);
            Case cs = TestDataHelper.createCase();
            cs.DD_Closed_Date__c = system.today();
            cs.ContactId = usr.ContactId;
            insert cs;            
            cs.DD_Closed_Date__c = system.today().addDays(1);
            cs.Send_Questionnaire__c = true;
            update cs;
            Case csQ = [select Id, status, Contact.DD_Date_of_Last_Assessment__c from Case where Id =: cs.Id];
            system.assertEquals(csq.Contact.DD_Date_of_Last_Assessment__c, cs.DD_Closed_Date__c);
            system.assertEquals(csq.Status, 'Open');
        }
        system.debug('CaseTriggerHandlerTest  :: caseTriggerHandlerTest :: End');
   }  
    
     /**
       Bulk Testing
   */         
   static testMethod void bulkCaseTriggerHandlerTest() {
        system.debug('CaseTriggerHandlerTest  :: bulkCaseTriggerHandlerTest :: Start');
        User u5;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            u5 = TestDataHelper.createCPPortaluser();                
        }
        system.runas(u5){
            List<DGL__c> accountGroupList = DGL__c.getall().values();                
            User usr = [select Id, contactId, contact.AccountId, contact.Account.ParentId from User where Id =: u5.Id];
            accountGroupList.get(0).Account__c = usr.contact.Account.ParentId;
            update accountGroupList.get(0);
            List<Case> csList = TestDataHelper.bulkCreateCase(10);
            for(Case csVal : csList){
                csVal.DD_Closed_Date__c = system.today();
                csVal.ContactId = usr.ContactId;
            }
            insert csList;
            for(Case csVal : csList){
                csVal.DD_Closed_Date__c = system.today().addDays(1);
                csVal.Send_Questionnaire__c = true;
            }
            update csList;
            List<Case> csQList = [select Id, status, Contact.DD_Date_of_Last_Assessment__c from Case where Id in: csList];
            system.assertEquals(csQList.size(), 10);
        }
        system.debug('CaseTriggerHandlerTest  :: bulkCaseTriggerHandlerTest :: End');
   } 
    
    /**
       Test if case is submitted to Head of Compliance queue and notification is sent to user with access to the case
   */
   /*static testMethod void caseNotificationtoCorrectHOCQueueMembersTest() {
        system.debug('CaseTriggerHandlerTest  :: caseSubmittedToHOCQueueTest :: start'); 
        //User u5;
        User u6;
        User usr;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            u6 = TestDataHelper.createPortalUserManagerRoleWithVerificationPermSet();    
            system.debug('u6 :: '+u6);                        
        }
        system.runas(u6){
            List<DGL__c> accountGroupList = DGL__c.getall().values();            
            usr = [select Id, contactId, contact.AccountId, contact.Account.ParentId from User where Id =: u6.Id];
            accountGroupList.get(0).Account__c = usr.contact.Account.ParentId;                     
            update accountGroupList.get(0);            
            Case cs = TestDataHelper.createCase();
            cs.DD_Closed_Date__c = system.today();
            cs.ContactId = usr.ContactId;
			cs.Status = 'Ready For Submission';
            insert cs;
            system.debug('cs :: '+cs);
            // Create an approval request for the account
            Test.startTest();
                Approval.ProcessSubmitRequest req1 = 
                    new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(cs.id);            
                Approval.ProcessResult result = Approval.process(req1);
            Test.stopTest();
            Case csQ = [select Id, status, Contact.DD_Date_of_Last_Assessment__c from Case where Id =: cs.Id];
            system.assertEquals(csq.Contact.DD_Date_of_Last_Assessment__c, cs.DD_Closed_Date__c);
            system.assertEquals(csq.Status, 'Submitted to HOC');
        }
        system.debug('CaseTriggerHandlerTest  :: caseTriggerHandlerTest :: End');
   }   */
   
    /**
       Test if case is submitted to General Counsel queue and notification is sent to user with access to the case
   */
   static testMethod void caseNotificationtoCorrectGCQueueMembersTest() {
        system.debug('CaseTriggerHandlerTest  :: caseSubmittedToHOCQueueTest :: start');
        User u5;
        User u6;
        User usr;
        User usr1;
        User usr2;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            u5 = TestDataHelper.createPortalUserManagerRoleWithVerificationPermSet();
            system.debug('u5 :: '+u5);
            usr = [select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments), 
                   contactId, contact.AccountId, contact.Account.ParentId from User where Id =: u5.Id];
            system.debug('usr.contact.AccountId :: '+usr.contact.AccountId);
            system.debug('usr.PermissionSetAssignments :: '+usr.PermissionSetAssignments);
            u6 = TestDataHelper.createPortalUserExecutiveRoleWithVerificationPermSet();    
            system.debug('u6 :: '+u6);
            usr1 = [select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments), 
                    contactId, contact.AccountId, contact.Account.ParentId from User where Id =: u6.Id];
            system.debug('usr1.PermissionSetAssignments :: '+usr1.PermissionSetAssignments);
            usr1.contact.AccountId = usr.contact.AccountId;
            update usr1.contact;
            usr2 = [select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments), 
                    contactId, contact.AccountId, contact.Account.ParentId from User where Id =: usr1.Id];
            system.debug('usr2.contact.AccountId :: '+usr2.contact.AccountId);
            system.debug('usr2.PermissionSetAssignments :: '+usr2.PermissionSetAssignments);
        }
        system.runas(u5){
            List<DGL__c> accountGroupList = DGL__c.getall().values();            
            usr = [select Id, contactId, contact.AccountId, contact.Account.ParentId from User where Id =: u5.Id];
            accountGroupList.get(0).Account__c = usr.contact.Account.ParentId;                     
            update accountGroupList.get(0);            
            Case cs = TestDataHelper.createCase();
            cs.DD_Closed_Date__c = system.today();
            cs.ContactId = usr.ContactId;
			cs.Status = 'Ready For Submission';
            insert cs; 
            system.debug('cs :: '+cs);
            // Create an approval request for the account
            Test.startTest();
                Approval.ProcessSubmitRequest req1 = 
                    new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(cs.id);
                        
            // Submit the approval request for the account
                Approval.ProcessResult result = Approval.process(req1);
            Test.stopTest();
            Case csQ = [select Id, status, Contact.DD_Date_of_Last_Assessment__c from Case where Id =: cs.Id];
            system.assertEquals(csq.Contact.DD_Date_of_Last_Assessment__c, cs.DD_Closed_Date__c);
            system.assertEquals(csq.Status, 'Submitted to HOC');
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setWorkitemId(newWorkItemIds.get(0));
            Approval.ProcessResult result2 =  Approval.process(req2);
            Case csQ1 = [select Id, status, Contact.DD_Date_of_Last_Assessment__c from Case where Id =: cs.Id];
            system.assertEquals(csQ1.Contact.DD_Date_of_Last_Assessment__c, cs.DD_Closed_Date__c);
            //system.assertEquals(csQ1.Status, 'Submitted to HOC');
        }             
        system.debug('CaseTriggerHandlerTest  :: caseTriggerHandlerTest :: End');
   } 
  
   

}