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

public class UserTriggerHandlerTest{

    /**
        Test if client has platform license then no permission set is added
    */     
    static testMethod void userTriggerHandlerNoPermissionSetTest() {
        
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerNoPermissionSetTest :: start');
        User u1;
        User u2;
        User u4;
        String temp;
        boolean isCounterParty=false;
        boolean isQuestionnaire=false;
        boolean isVerification=false;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRole();
            u4 = TestDataHelper.createPortalUserExecutiveRole();        
        }
        system.runAs(u1){
            User u3 = [select Id, UserRoleId, UserRole.Name,  contact.AccountId, contact.Account.name from User where id =: u2.Id];
            User u5 = [select Id, UserRoleId, UserRole.Name,  contact.AccountId, contact.Account.name from User where id =: u4.Id];
            User uQ = [Select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments) From User u where Id =: u1.id];
            List<PermissionSetAssignment> pmaList = uQ.PermissionSetAssignments;
            Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
            for(DD_Module_Permission_Sets_List__c ps : modulePermissionMap.values()){
                for(PermissionSetAssignment pmaVal : pmaList){                
                        temp = String.valueOf(pmaVal.PermissionSetId).subString(0,15);                    
                        if(ps.UserModule__c.equals('ADMIN__Counterparty') && ps.PermissionSetId__c.equals(temp) && !isCounterParty){                        
                            isCounterParty = true;
                            break;
                        }
                        else if(ps.UserModule__c.equals('ADMIN__Questionnaire') && ps.PermissionSetId__c.equals(temp) && !isQuestionnaire){
                            isQuestionnaire = true;
                            break;
                        }
                        else if(ps.UserModule__c.equals('ADMIN_Verification') && ps.PermissionSetId__c.equals(temp) && !isVerification){
                            isVerification = true;
                            break;
                        }
                }
            } 
            system.assertEquals(isCounterParty, false);
            system.assertEquals(isQuestionnaire, false);
            system.assertEquals(isVerification, false);
            update u3;
        }
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerNoPermissionSetTest :: end');
    }
    
    
    /**
        Test if client has platform license for portal profile then no permission set is added
    */ 
    static testMethod void userTriggerHandlerNoPermissionSetPortalProfileTest() {
        
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerNoPermissionSetPortalProfileTest :: start');
        User u1;
        User u2;
        String temp;
        boolean isCounterParty=false;
        boolean isQuestionnaire=false;
        boolean isVerification=false;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRolePortalProfile();            
        }
        system.runAs(u1){
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            User uQ = [Select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments) From User u where Id =: u1.id];
            List<PermissionSetAssignment> pmaList = uQ.PermissionSetAssignments;
            Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
            for(DD_Module_Permission_Sets_List__c ps : modulePermissionMap.values()){
                for(PermissionSetAssignment pmaVal : pmaList){                    
                    temp = String.valueOf(pmaVal.PermissionSetId).subString(0,15);
                    if(ps.UserModule__c.equals('ADMIN__Counterparty') && ps.PermissionSetId__c.equals(temp) && !isCounterParty){
                        isCounterParty = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN__Questionnaire') && ps.PermissionSetId__c.equals(temp) && !isQuestionnaire){
                        isQuestionnaire = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN_Verification') && ps.PermissionSetId__c.equals(temp) && !isVerification){
                        isVerification = true;
                        break;
                    }
                }
            } 
            system.assertEquals(isCounterParty, false);
            system.assertEquals(isQuestionnaire, false);
            system.assertEquals(isVerification, false);
        }
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerNoPermissionSetPortalProfileTest :: end');
    }
           
     /**
        Test if client has counterparty license then counterparty permission set is added
    */
     static testMethod void userTriggerHandlerCounterPartyPermissionSetTest() {
        
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerCounterPartyPermissionSetTest :: start');
        User u1;
        User u2;
        String temp;
        boolean isCounterParty=false;
        boolean isQuestionnaire=false;
        boolean isVerification=false;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRoleWithCounterpartyPermSet();
        }
        system.runAs(u1){
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            User uQ = [Select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments) From User u where Id =: u2.id];
            List<PermissionSetAssignment> pmaList = uQ.PermissionSetAssignments;
            Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
            for(DD_Module_Permission_Sets_List__c ps : modulePermissionMap.values()){               
                for(PermissionSetAssignment pmaVal : pmaList){                    
                    temp = String.valueOf(pmaVal.PermissionSetId).subString(0,15);
                    if(ps.UserModule__c.equals('ADMIN__Counterparty') && ps.PermissionSetId__c.equals(temp) && !isCounterParty){
                        isCounterParty = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN__Questionnaire') && ps.PermissionSetId__c.equals(temp) && !isQuestionnaire){
                        isQuestionnaire = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN_Verification') && ps.PermissionSetId__c.equals(temp) && !isVerification){
                        isVerification = true;
                        break;
                    }
                }
            } 
            system.assertEquals(isCounterParty, true);
            system.assertEquals(isQuestionnaire, false);
            system.assertEquals(isVerification, false);
        }
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerCounterPartyPermissionSetTest :: end');
    }
    
    /**
        Test if client with portal profile has counterparty license then counterparty permission set is added
    */
    static testMethod void userTriggerHandlerCounterPartyPermissionSetPortalProfileTest() {
        
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerCounterPartyPermissionSetPortalProfileTest :: start');
        User u1;
        User u2;
        String temp;
        boolean isCounterParty=false;
        boolean isQuestionnaire=false;
        boolean isVerification=false;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRoleWithCounterpartyPermSetPortalProfile();            
        }
        system.runAs(u1){
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            User uQ = [Select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments) From User u where Id =: u2.id];
            List<PermissionSetAssignment> pmaList = uQ.PermissionSetAssignments;
            Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
            for(DD_Module_Permission_Sets_List__c ps : modulePermissionMap.values()){
                for(PermissionSetAssignment pmaVal : pmaList){
                    temp = String.valueOf(pmaVal.PermissionSetId).subString(0,15);
                    if(ps.UserModule__c.equals('ADMIN__Counterparty') && ps.PermissionSetId__c.equals(temp) && !isCounterParty){
                        isCounterParty = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN__Questionnaire') && ps.PermissionSetId__c.equals(temp) && !isQuestionnaire){
                        isQuestionnaire = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN_Verification') && ps.PermissionSetId__c.equals(temp) && !isVerification){
                        isVerification = true;
                        break;
                    }
                }
            } 
            system.assertEquals(isCounterParty, true);
            system.assertEquals(isQuestionnaire, false);
            system.assertEquals(isVerification, false);
        }
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerCounterPartyPermissionSetPortalProfileTest :: end');
    }
    
    /**
        Test if client has counterparty with questionnaire license 
        then counterparty and questionnaire permission sets are added
    */
    static testMethod void userTriggerHandlerQuestionnairePermissionSetTest() {
        
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerQuestionnairePermissionSetTest :: start');
        User u1;
        User u2;
        String temp;
        boolean isCounterParty = false;
        boolean isQuestionnaire = false;
        boolean isVerification = false;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRoleWithQuestionnairePermSet();            
        }
        system.runAs(u1){
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            User uQ = [Select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments) From User u where Id =: u2.id];
            List<PermissionSetAssignment> pmaList = uQ.PermissionSetAssignments;
            Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
            for(DD_Module_Permission_Sets_List__c ps : modulePermissionMap.values()){
                for(PermissionSetAssignment pmaVal : pmaList){
                    temp = String.valueOf(pmaVal.PermissionSetId).subString(0,15);
                    if(ps.UserModule__c.equals('ADMIN__Counterparty') && ps.PermissionSetId__c.equals(temp) && !isCounterParty){
                        isCounterParty = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN__Questionnaire') && ps.PermissionSetId__c.equals(temp) && !isQuestionnaire){
                        isQuestionnaire = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN_Verification') && ps.PermissionSetId__c.equals(temp) && !isVerification){
                        isVerification = true;
                        break;
                    }
                }
            } 
            system.assertEquals(isCounterParty, true);
            system.assertEquals(isQuestionnaire, true);
            system.assertEquals(isVerification, false);
        }
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerQuestionnairePermissionSetTest :: end');
    }
    
    /**
        Test if client with portal profile has counterparty with questionnaire license 
        then counterparty and questionnaire permission sets are added
    */
    static testMethod void userTriggerHandlerQuestionnairePermissionSetPortalProfileTest() {
        
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerQuestionnairePermissionSetPortalProfileTest :: start');
        User u1;
        User u2;
        String temp;
        boolean isCounterParty = false;
        boolean isQuestionnaire = false;
        boolean isVerification = false;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRoleWithQuestionnairePermSetPortalProfile();            
        }
        system.runAs(u1){
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            User uQ = [Select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments) From User u where Id =: u2.id];
            List<PermissionSetAssignment> pmaList = uQ.PermissionSetAssignments;
            Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
            for(DD_Module_Permission_Sets_List__c ps : modulePermissionMap.values()){
                for(PermissionSetAssignment pmaVal : pmaList){                    
                    temp = String.valueOf(pmaVal.PermissionSetId).subString(0,15);
                    if(ps.UserModule__c.equals('ADMIN__Counterparty') && ps.PermissionSetId__c.equals(temp) && !isCounterParty){
                        isCounterParty = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN__Questionnaire') && ps.PermissionSetId__c.equals(temp) && !isQuestionnaire){
                        isQuestionnaire = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN_Verification') && ps.PermissionSetId__c.equals(temp) && !isVerification){
                        isVerification = true;
                        break;
                    }
                }
            } 
            system.assertEquals(isCounterParty, true);
            system.assertEquals(isQuestionnaire, true);
            system.assertEquals(isVerification, false);
        }
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerQuestionnairePermissionSetPortalProfileTest :: end');
    }
    
   
   /**
        Test if client has verification license 
        then counterparty, questionnaire  and verification permission sets are added
    */
   static testMethod void userTriggerHandlerVerificationPermissionSetTest() {
        
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerVerificationPermissionSetTest :: start');
        User u1;
        User u2;
        String temp;
        boolean isCounterParty=false;
        boolean isQuestionnaire=false;
        boolean isVerification=false;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRoleWithVerificationPermSet();            
        }
        system.runAs(u1){
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            User uQ = [Select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments) From User u where Id =: u2.id];
            List<PermissionSetAssignment> pmaList = uQ.PermissionSetAssignments;
            Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
            for(DD_Module_Permission_Sets_List__c ps : modulePermissionMap.values()){
                for(PermissionSetAssignment pmaVal : pmaList){                    
                    temp = String.valueOf(pmaVal.PermissionSetId).subString(0,15);
                    if(ps.UserModule__c.equals('ADMIN__Counterparty') && ps.PermissionSetId__c.equals(temp) && !isCounterParty){
                        isCounterParty = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN__Questionnaire') && ps.PermissionSetId__c.equals(temp) && !isQuestionnaire){
                        isQuestionnaire = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN_Verification') && ps.PermissionSetId__c.equals(temp) && !isVerification){
                        isVerification = true;
                        break;
                    }
                }
            } 
            system.assertEquals(isCounterParty, true);
            system.assertEquals(isQuestionnaire, true);
            system.assertEquals(isVerification, true);
        }
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerVerificationPermissionSetTest :: end');
    } 
    
    /**
        Test if client with Portal profile has verification license 
        then counterparty, questionnaire  and verification permission sets are added
    */
    static testMethod void userTriggerHandlerVerificationPermissionSetPortalProfileTest() {
    
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerVerificationPermissionSetPortalProfileTest :: start');
        User u1;
        User u2;
        String temp;
        boolean isCounterParty=false;
        boolean isQuestionnaire=false;
        boolean isVerification=false;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRoleWithVerificationPermSetPortalProfile();
        }
        system.runAs(u1){
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            User uQ = [Select Id,  (Select Id, PermissionSetId, AssigneeId From PermissionSetAssignments) From User u where Id =: u2.id];
            List<PermissionSetAssignment> pmaList = uQ.PermissionSetAssignments;
            Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
            for(DD_Module_Permission_Sets_List__c ps : modulePermissionMap.values()){                
                for(PermissionSetAssignment pmaVal : pmaList){                    
                    temp = String.valueOf(pmaVal.PermissionSetId).subString(0,15);
                    if(ps.UserModule__c.equals('ADMIN__Counterparty') && ps.PermissionSetId__c.equals(temp) && !isCounterParty){
                        isCounterParty = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN__Questionnaire') && ps.PermissionSetId__c.equals(temp) && !isQuestionnaire){
                        isQuestionnaire = true;
                        break;
                    }
                    else if(ps.UserModule__c.equals('ADMIN_Verification') && ps.PermissionSetId__c.equals(temp) && !isVerification){
                        isVerification = true;
                        break;
                    }
                }
            } 
            system.assertEquals(isCounterParty, true);
            system.assertEquals(isQuestionnaire, true);
            system.assertEquals(isVerification, true);
        }
        system.debug('UserTriggerHandlerTest :: userTriggerHandlerVerificationPermissionSetPortalProfileTest :: end');
    } 
    
    /**
        Bulk Testing
    */
    static testMethod void bulkUserTest() {
    
        system.debug('UserTriggerHandlerTest :: bulkUserTest :: start');
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            List<User> userList = TestDataHelper.bulkCreateSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com', 50);
            List<User> userQList = [select Id,lastname from User where Id in: userList];
            for(User userQVal : userQList){
                userQVal.lastname += 'updated';
            }
            update userQList;
            system.assertEquals(userQList.size(), 50);
        }
        system.debug('UserTriggerHandlerTest :: bulkUserTest :: end');
    }     
}