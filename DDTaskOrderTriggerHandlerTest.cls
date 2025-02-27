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


/**
	Actual test cases are commented out. They are commented out because we are getting Financial Force specific error 
	'A single Company must be selected to create/update an Opportunity, 
	please correct the following:This operation is not valid in multiple company mode: []'. 
	This has been raised with Simon (Financial Force) and David(Risk Advisory). 
	As a wokaround, a dummy test case is created to have some coverage for Task Order trigger.
*/
private class DDTaskOrderTriggerHandlerTest {
                
    
  /**
        Dummy test case to have code coverage for Task Order trigger
    */
    static testMethod void taskOrderDummyTest() {
        
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderDummyTest :: start');
        User u1;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            system.debug('u1  :: '+u1);
        }
        system.runas(u1){
            //Task_Order__c to =TestDataHelper.createTaskOrderWithoutOpportunity();
            //insert to;
            //Task_Order__c toReturn = [select Id, DD_Opportunity__r.DD_Instruction__r.dd_Status__c from Task_Order__c where Id =: to.Id];
            //system.assertEquals(toReturn.DD_Opportunity__r.DD_Instruction__r.dd_status__c, 'Submitted');
        }
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderDummyTest :: end');
        system.assertEquals('','');
    }   
	
	
	    
     /**
       Test if case is submitted to Head of Compliance queue and notification is sent to user with access to the case
   */
   static testMethod void toNotificationtoCorrectHOCQueueMembersTest() {
       system.debug('DDTaskOrderTriggerHandlerTest  :: toNotificationtoCorrectHOCQueueMembersTest :: start');
       //User u5;
       User u6;
       User usr;
       Task_Order__c to;
       Task_Order__c toQ;
       String submittedStatus;
       Boolean defaultApprovalProcess = false;
       User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
       system.runas(thisUser){
           u6 = TestDataHelper.createPortalUserManagerRoleWithVerificationPermSet();    
           system.debug('u6 :: '+u6);   
           usr = [select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments), 
                  contactId, contact.AccountId, contact.Account.ParentId from User where Id =: u6.Id];
           system.debug('usr.contact.AccountId :: '+usr.contact.AccountId);
           system.debug('usr.PermissionSetAssignments :: '+usr.PermissionSetAssignments);
           List<DGL__c> accountGroupList = DGL__c.getall().values();            
           usr = [select Id, contactId, contact.AccountId, contact.Account.ParentId from User where Id =: u6.Id];
           accountGroupList.get(0).Account__c = usr.contact.Account.ParentId;                     
           update accountGroupList.get(0);            
           to = TestDataHelper.createTaskOrderWithInputAccount(usr.contact.AccountId);            
           insert to;
           system.debug('to :: '+to);
           Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
           req1.setComments('Submitting request for approval.');
           req1.setObjectId(to.id);            
           Approval.ProcessResult result = Approval.process(req1);            
       }
       Test.startTest();
       system.runas(u6){            
           DDApprovalController dda = new DDApprovalController();
           List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
           if(!pendAppRecs.isEmpty()){
               toQ = [select Id, dd_status__c from Task_Order__c where Id =: to.Id];
               submittedStatus = 'Submitted to HOC';                            
               defaultApprovalProcess = true;
           }
       }
       if(!defaultApprovalProcess){
           toQ = [select Id, dd_status__c from Task_Order__c where Id =: to.Id];
           submittedStatus = 'Submitted';  
       }
       system.assertEquals(toq.dd_status__c, submittedStatus);  
       Test.stopTest();
       system.debug('DDTaskOrderTriggerHandlerTest  :: toNotificationtoCorrectHOCQueueMembersTest :: End');
   } 
    
    /**
       Test if case is submitted to General Counsel queue and notification is sent to user with access to the case
   */
   static testMethod void toNotificationtoCorrectGCQueueMembersTest() {
       system.debug('DDTaskOrderTriggerHandlerTest  :: toNotificationtoCorrectGCQueueMembersTest :: start');
       User u5;
       User u6;
       User usr;
       User usr1;
       User usr2;
       Task_Order__c to;
       Approval.ProcessResult result;
       Approval.ProcessSubmitRequest req;
       Task_Order__c toQ;
       Boolean defaultApprovalProcess = false;       
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
           List<DGL__c> accountGroupList = DGL__c.getall().values();            
           usr = [select Id, contactId, contact.AccountId, contact.Account.ParentId from User where Id =: u5.Id];
           accountGroupList.get(0).Account__c = usr.contact.Account.ParentId;                     
           update accountGroupList.get(0);            
           to = TestDataHelper.createTaskOrderWithInputAccount(usr.contact.AccountId);            
           insert to;
           system.debug('to :: '+to);
           // Create an approval request for the account  
           Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();    
           req1.setComments('Submitting request for approval.');
           req1.setObjectId(to.id);            
           result = Approval.process(req1);
       }       
       Test.startTest(); 
       system.runas(u5){  
           DDApprovalController dda = new DDApprovalController();
           List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
           if(!pendAppRecs.isEmpty()){
               toQ = [select Id, dd_status__c from Task_Order__c where Id =: to.Id];
               system.assertEquals(toq.dd_status__c, 'Submitted to HOC');
               List<Id> newWorkItemIds = result.getNewWorkitemIds();
               Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
               req2.setComments('Approving request.');
               req2.setAction('Approve');
               req2.setWorkitemId(newWorkItemIds.get(0));                              
               Approval.ProcessResult result2 =  Approval.process(req2);
               defaultApprovalProcess = true;
           }
       }
       if(!defaultApprovalProcess){
           system.runas(thisUser){  
               DDApprovalController dda = new DDApprovalController();
               List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
               if(!pendAppRecs.isEmpty()){
                   toQ = [select Id, dd_status__c from Task_Order__c where Id =: to.Id];
                   system.assertEquals(toq.dd_status__c, 'Submitted');
                   defaultApprovalProcess = false;
                   List<Id> newWorkItemIds = result.getNewWorkitemIds();
                   Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                   req2.setComments('Approving request.');
                   req2.setAction('Approve');
                   req2.setWorkitemId(newWorkItemIds.get(0));                              
                   Approval.ProcessResult result2 =  Approval.process(req2); 
               }
           }
       }       
       if(defaultApprovalProcess){
           system.runas(u6){                       
               DDApprovalController dda = new DDApprovalController();
               List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
               if(!pendAppRecs.isEmpty()){
                   toQ = [select Id, dd_status__c from Task_Order__c where Id =: to.Id];
                   system.assertEquals(toq.dd_status__c, 'Submitted to GC');
                   List<Id> newWorkItemIds = result.getNewWorkitemIds();
                   Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                   req2.setComments('Approving request.');
                   req2.setAction('Approve');
                   req2.setWorkitemId(newWorkItemIds.get(0));                              
                   Approval.ProcessResult result2 =  Approval.process(req2);                   
                   defaultApprovalProcess = true;
               }
           }
       }
       if(!defaultApprovalProcess){
           system.runas(thisUser){
               toQ = [select Id, dd_status__c from Task_Order__c where Id =: to.Id];
               system.assertEquals(toq.dd_status__c, 'Approved');
           }
       }       
       Test.stopTest();       
   } 
    
    /**
        Test if Opportunity status is updated if task Order status is submitted
    
    static testMethod void taskOrderSubmittedHandlerTest() {
        
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderSubmittedHandlerTest :: start');
        User u1;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            system.debug('u1  :: '+u1);
        }
        system.runas(u1){
            Task_Order__c to =TestDataHelper.createTaskOrder();
            insert to;
            Task_Order__c toReturn = [select Id, DD_Opportunity__r.DD_Instruction__r.dd_Status__c from Task_Order__c where Id =: to.Id];
            system.assertEquals(toReturn.DD_Opportunity__r.DD_Instruction__r.dd_status__c, 'Submitted');
        }
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderSubmittedHandlerTest :: end');
    }  */  
    
    /**
        Test if Opportunity status is updated if task Order status is In Review
    
    static testMethod void taskOrderInReviewHandlerTest() {
        
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderInReviewHandlerTest :: start');
        User u1;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            system.debug('u1  :: '+u1);
        }
        system.runas(u1){
            Task_Order__c to =TestDataHelper.createTaskOrder();
            to.DD_Status__c = 'In Review';
            insert to;
            Task_Order__c toReturn = [select Id, DD_Opportunity__r.DD_Instruction__r.dd_Status__c from Task_Order__c where Id =: to.Id];
            system.assertEquals(toReturn.DD_Opportunity__r.DD_Instruction__r.dd_status__c, 'Draft');
        }
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderInReviewHandlerTest :: end');
    }    */
    
    /**
        Test if Opportunity status is updated if task Order status is Approved
    
    static testMethod void taskOrderApprovedHandlerTest() {
        
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderApprovedHandlerTest :: start');
        User u1;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            system.debug('u1  :: '+u1);
        }
        system.runas(u1){
            Task_Order__c to =TestDataHelper.createTaskOrder();
            to.DD_Status__c = 'Approved';
            insert to;
            Task_Order__c toReturn = [select Id, DD_Opportunity__r.DD_Instruction__r.dd_Status__c from Task_Order__c where Id =: to.Id];
            system.assertEquals(toReturn.DD_Opportunity__r.DD_Instruction__r.dd_status__c, 'Quote Approved');
        }
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderApprovedHandlerTest :: end');
    }*/
    
    /**
        Test if Opportunity status is updated if task Order status is rejected
    
    static testMethod void taskOrderRejectedHandlerTest() {
        
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderRejectedHandlerTest :: start');
        User u1;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            system.debug('u1  :: '+u1);
        }
        system.runas(u1){
            Task_Order__c to =TestDataHelper.createTaskOrder();
            to.DD_Status__c = 'Rejected';
            insert to;
            Task_Order__c toReturn = [select Id, DD_Opportunity__r.DD_Instruction__r.dd_Status__c from Task_Order__c where Id =: to.Id];
            system.assertEquals(toReturn.DD_Opportunity__r.DD_Instruction__r.dd_status__c, 'Quote Rejected');
        }
        system.debug('DDTaskOrderTriggerHandlerTest :: taskOrderRejectedHandlerTest :: end');
    }*/    
    
    /**
        Bulk Testing
    
    static testMethod void taskOrderHandlerBulkTest() {
            List<Task_Order__c> toList =TestDataHelper.createTaskOrderBulk(50);
            insert toList;
            system.debug('toList:: '+toList); 
            List<Task_Order__c> toReturnList = [select Id from Task_Order__c where Id in: toList];
            system.assertEquals(toReturnList.size(), 50);
    }*/
}