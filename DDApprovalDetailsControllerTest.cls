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

private class DDApprovalDetailsControllerTest {

    /**
        This method tests if the submitted task order is approved by correct user
    */
    static testMethod void recordApprovedTest() {
        
        system.debug('DDApprovalDetailsControllerTest :: recordApprovedTest :: start');
        boolean pendApproval = false;
        Task_Order__c to;
        User u2;
        User u1;
        List<GroupMember> gmList;
        Id groupId;
        List<ProcessInstanceHistory> pih;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.debug('thisUser :: '+thisUser);
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            system.debug('u1 :: '+u1);
            u2 = TestDataHelper.createPortalUserManagerRole();      
            system.debug('u2 :: '+u2);
        }
        system.runas(thisUser){
            to = TestDataHelper.createTaskOrder();
            system.debug('to :: '+to);
            Opportunity opp = TestDataHelper.createOpportunity();
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            system.debug('u3 :: '+u3);
            opp.AccountId = u3.Contact.AccountId;
            insert opp;
            system.debug('opp :: '+opp);
            DD_Instruction__c ins = [select Id, DD_Client_Commissioner__c from DD_Instruction__c where Id =: opp.DD_Instruction__c];
            ins.DD_Client_Commissioner__c = u3.ContactId;
            update ins;
            to.DD_Opportunity__c = opp.Id;
            insert to;
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = 
                new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(to.id);
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            system.debug('result :: '+result);            
            gmList = [select GroupId , UserOrGroupId, Group.Type from GroupMember where UserOrGroupId =: u2.Id];
            system.debug('gmList :: '+gmList);
            for(GroupMember gmVal : gmList){
                system.debug('gmVal :: '+gmVal);
                system.debug('gmVal.Group.Type :: '+gmVal.Group.Type);
                if(gmVal.Group.Type.equals('Queue')){
                    groupId = gmVal.GroupId;
                    break;
                }
            }            
        }
        test.startTest();
        system.runas(u2){            
            DDApprovalController dda = new DDApprovalController();
            List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
            if(!pendAppRecs.isEmpty()){
                Id processID = pendAppRecs.get(0).proInstce.ProcessInstanceId;
                Id processTargetObjectID = pendAppRecs.get(0).proInstce.ProcessInstance.TargetObjectId;
                DD_ApproveDetailsController ddad = new DD_ApproveDetailsController();
                ApexPages.currentPage().getParameters().put('pid', String.valueOf(processID));
                ApexPages.currentPage().getParameters().put('id', processTargetObjectID);
                ddad.initialize();
                List<DD_ApproveDetailsController.PendingAppRecs> par = ddad.getProsInsts();
                pih = ddad.getApprovalHistory();                                
                pendApproval = true;
            }
        }
        if(!pendApproval){
            system.runas(thisUser){            
                DDApprovalController dda = new DDApprovalController();
                List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
                if(!pendAppRecs.isEmpty()){
                    Id processID = pendAppRecs.get(0).proInstce.ProcessInstanceId;
                    Id processTargetObjectID = pendAppRecs.get(0).proInstce.ProcessInstance.TargetObjectId;
                    DD_ApproveDetailsController ddad = new DD_ApproveDetailsController();
                    ApexPages.currentPage().getParameters().put('pid', String.valueOf(processID));
                    ApexPages.currentPage().getParameters().put('id', processTargetObjectID);
                    ddad.initialize();
                    List<DD_ApproveDetailsController.PendingAppRecs> par = ddad.getProsInsts();
                    pih = ddad.getApprovalHistory();                
                    pendApproval = true;
                }
            }  
        }
        system.assertEquals(pih.get(0).StepStatus, pendApproval ? 'Started' : 'Pending'); 
        test.stopTest();
        system.debug('DDApprovalDetailsControllerTest :: recordApprovedTest :: end');
    }
    
    /**
        This method tests if the submitted task order is rejected by correct user
    */
    static testMethod void recordRejectedTest() {
        
        system.debug('DDApprovalDetailsControllerTest :: recordRejectedTest :: start');
        boolean pendApproval = false;
        Task_Order__c to;
        User u2;
        User u1;
        List<GroupMember> gmList;
        Id groupId;
        List<ProcessInstanceHistory> pih;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRole();            
        }
        system.runas(thisUser){
            to = TestDataHelper.createTaskOrder();
            Opportunity opp = TestDataHelper.createOpportunity();
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            opp.AccountId = u3.Contact.AccountId;
            insert opp;
            DD_Instruction__c ins = [select Id, DD_Client_Commissioner__c from DD_Instruction__c where Id =: opp.DD_Instruction__c];
            ins.DD_Client_Commissioner__c = u3.ContactId;
            update ins;
            to.DD_Opportunity__c = opp.Id;
            insert to;
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = 
                new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(to.id);
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            gmList = [select GroupId , UserOrGroupId, Group.Type from GroupMember where UserOrGroupId =: u2.Id];
            for(GroupMember gmVal : gmList){
                if(gmVal.Group.Type.equals('Queue')){
                    groupId = gmVal.GroupId;
                    break;
                }
            }            
        }
        test.startTest();
        system.runas(u2){            
            DDApprovalController dda = new DDApprovalController();
            List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
            if(!pendAppRecs.isEmpty()){
                Id processID = pendAppRecs.get(0).proInstce.ProcessInstanceId;
                Id processTargetObjectID = pendAppRecs.get(0).proInstce.ProcessInstance.TargetObjectId;
                DD_ApproveDetailsController ddad = new DD_ApproveDetailsController();
                ApexPages.currentPage().getParameters().put('pid', String.valueOf(processID));
                ApexPages.currentPage().getParameters().put('id', processTargetObjectID);
                ddad.initialize();    
                pih = ddad.getApprovalHistory();
                pendApproval = true;                
                List<ProcessInstanceHistory> pih1 = ddad.getApprovalHistory();
            }            
        }
        if(!pendApproval){
            system.runas(thisUser){            
            DDApprovalController dda = new DDApprovalController();
            List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
            if(!pendAppRecs.isEmpty()){
                Id processID = pendAppRecs.get(0).proInstce.ProcessInstanceId;
                Id processTargetObjectID = pendAppRecs.get(0).proInstce.ProcessInstance.TargetObjectId;
                DD_ApproveDetailsController ddad = new DD_ApproveDetailsController();
                ApexPages.currentPage().getParameters().put('pid', String.valueOf(processID));
                ApexPages.currentPage().getParameters().put('id', processTargetObjectID);
                ddad.initialize();    
                pih = ddad.getApprovalHistory();
                pendApproval = true;
                List<ProcessInstanceHistory> pih1 = ddad.getApprovalHistory();
            }            
            }
        }
        system.assertEquals(pih.get(0).StepStatus, pendApproval ? 'Started' : 'Pending');
        test.stopTest();
        system.debug('DDApprovalDetailsControllerTest :: recordRejectedTest :: end');
    }
    
    /**
        This method tests if the user has clicked cancelled and redirected back to Approval Details page
    */
    static testMethod void recordCancelTest() {
        
        system.debug('DDApprovalDetailsControllerTest :: recordCancelTest :: start');
        boolean pendApproval = false;
        Task_Order__c to;
        User u2;
        User u1;
        List<ProcessInstanceHistory> pih;
        List<ProcessInstanceHistory> pih1;
        List<GroupMember> gmList;
        Pagereference pr;
        Id groupId;
        //User u1 = [select Id from User where Username = 'msharma@tquila.com.ra.tqpartial'];
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRole();            
        }
        system.runas(thisUser){
            to = TestDataHelper.createTaskOrder();
            Opportunity opp = TestDataHelper.createOpportunity();
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            opp.AccountId = u3.Contact.AccountId;
            insert opp;
            DD_Instruction__c ins = [select Id, DD_Client_Commissioner__c from DD_Instruction__c where Id =: opp.DD_Instruction__c];
            ins.DD_Client_Commissioner__c = u3.ContactId;
            update ins;
            to.DD_Opportunity__c = opp.Id;
            insert to;
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = 
                new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(to.id);
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            gmList = [select GroupId , UserOrGroupId, Group.Type from GroupMember where UserOrGroupId =: u2.Id];
            for(GroupMember gmVal : gmList){
                if(gmVal.Group.Type.equals('Queue')){
                    groupId = gmVal.GroupId;
                    break;
                }
            }            
        }
        test.startTest();
        system.runas(u2){            
            DDApprovalController dda = new DDApprovalController();
            List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
            if(!pendAppRecs.isEmpty()){
                Id processID = pendAppRecs.get(0).proInstce.ProcessInstanceId;
                Id processTargetObjectID = pendAppRecs.get(0).proInstce.ProcessInstance.TargetObjectId;
                DD_ApproveDetailsController ddad = new DD_ApproveDetailsController();
                ApexPages.currentPage().getParameters().put('pid', String.valueOf(processID));
                ApexPages.currentPage().getParameters().put('id', processTargetObjectID);
                ddad.initialize();    
                pih = ddad.getApprovalHistory();
                pendApproval = true;                
                pr = ddad.cancel();
                pih1 = ddad.getApprovalHistory();                
            }            
        }
        if(!pendApproval){
            system.runas(thisUser){            
                DDApprovalController dda = new DDApprovalController();
                List<DDApprovalController.PendingAppRecs> pendAppRecs = dda.getProsInsts();
                if(!pendAppRecs.isEmpty()){
                    Id processID = pendAppRecs.get(0).proInstce.ProcessInstanceId;
                    Id processTargetObjectID = pendAppRecs.get(0).proInstce.ProcessInstance.TargetObjectId;
                    DD_ApproveDetailsController ddad = new DD_ApproveDetailsController();
                    ApexPages.currentPage().getParameters().put('pid', String.valueOf(processID));
                    ApexPages.currentPage().getParameters().put('id', processTargetObjectID);
                    ddad.initialize();    
                    pih = ddad.getApprovalHistory();
                    pendApproval = true;
                    pr = ddad.cancel();
                    pih1 = ddad.getApprovalHistory();
                }            
            }
        }
        system.assertEquals(pih.get(0).StepStatus, pendApproval ? 'Started' : 'Pending');
        system.assertEquals(pih1.get(0).StepStatus, pendApproval ? 'Started' : 'Pending');
        system.assertEquals(pr.getURL(), '/apex/DD_Approvals');
        test.stopTest();
        system.debug('DDApprovalDetailsControllerTest :: recordCancelTest :: end');
    }
    
}