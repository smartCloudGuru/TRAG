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

public class DD_ListInstructionsControllerTest {
    
    /**
        Test if user is not redirected to the overridden page if logged in user neither Partner User nor Salesforce user
    */
    static testMethod void newInstructionButtonWithPartnerUserTest() {
         
         system.debug('DD_ListInstructionsControllerTest :: newInstructionButtonWithPartnerUserTest :: start');
         DD_ListInstructionsController ddlic; 
         List<DD_Control_Measure__c> controlMeasureList = new List<DD_Control_Measure__c>();
         DD_Control_Measure__c cm;   
         String recordTypeId;
         String instructionObjectId;
         String contactPageId;
         String domainName;
         String taskOrderRequiredPageId;
         Pagereference pr;
         Pagereference pr2;
         Id queueId;     
         User u2; 
         User u5;
         User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
         system.runas(thisUser){
            u2 = TestDataHelper.createSalesforceUserForClientAccountTeam('test@test.com.testt', 'tAlias', 'test@test.com');
            u5 = TestDataHelper.createPortalUser();
          }
         system.runas(u2){ 
            User u6 = [select Id, UserRoleId, contactId, contact.name, contact.AccountId, contact.Account.DD_Task_Order_Required__c from User where id =: u5.Id];
            cm = TestDataHelper.createControlMeasure();
            insert cm;
            controlMeasureList.add(cm);
            ApexPages.StandardSetController cont = new ApexPages.StandardSetController(controlMeasureList);
            ddlic = new DD_ListInstructionsController(cont);
            ddlic.testUserId = u6.Id;
            ddlic.isControlMeasureTypeChosen = true;
            Pagereference pr1 = ddlic.newButtonRedirect();
            system.assertEquals(String.valueOf(pr1.getURL()).contains('client'), false);
        }
        system.debug('DD_ListInstructionsControllerTest :: newInstructionButtonWithPartnerUserTest :: end');
    }
    
    /**
        Test if user is not redirected to the overridden page if logged in user is Partner User
    */
    static testMethod void newInstructionButtonWithPartnerUserLoginTest() {
         
         system.debug('DD_ListInstructionsControllerTest :: newInstructionButtonWithPartnerUserLoginTest :: start');
         DD_ListInstructionsController ddlic; 
         List<DD_Control_Measure__c> controlMeasureList = new List<DD_Control_Measure__c>();
         DD_Control_Measure__c cm;   
         String recordTypeId;
         String instructionObjectId;
         String contactPageId;
         String domainName;
         String taskOrderRequiredPageId;
         Pagereference pr;
         Pagereference pr2;
         Id queueId;     
         User u2; 
         User u5;
         User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
         system.runas(thisUser){
            u2 = TestDataHelper.createSalesforceUserForClientAccountTeam('test@test.com.testt', 'tAlias', 'test@test.com');
            u5 = TestDataHelper.createPortalUser();
          }
         system.runas(u5){ 
            User u6 = [select Id, UserRoleId, contactId, contact.name, contact.AccountId, contact.Account.DD_Task_Order_Required__c from User where id =: u5.Id];
            cm = TestDataHelper.createControlMeasure();
            insert cm;
            controlMeasureList.add(cm);
            ApexPages.StandardSetController cont = new ApexPages.StandardSetController(controlMeasureList);
            ddlic = new DD_ListInstructionsController(cont);
            ddlic.testUserId = u6.Id;
            ddlic.isControlMeasureTypeChosen = true;
            Pagereference pr1 = ddlic.newButtonRedirect();
            system.assertEquals(String.valueOf(pr1.getURL()).contains('client'), true);
        }
        system.debug('DD_ListInstructionsControllerTest :: newInstructionButtonWithPartnerUserLoginTest :: end');
    }
    
    /**
        Test if user is not redirected to the overridden page if logged in user is Salesforce User
    */
    static testMethod void newInstructionButtonWithSalesforceUserTest() {
         
         system.debug('DD_ListInstructionsControllerTest :: newInstructionButtonWithSalesforceUserTest :: start');
         DD_ListInstructionsController ddlic; 
         List<DD_Control_Measure__c> controlMeasureList = new List<DD_Control_Measure__c>();
         DD_Control_Measure__c cm;   
         String recordTypeId;
         String instructionObjectId;
         String contactPageId;
         String domainName;
         String taskOrderRequiredPageId;
         Pagereference pr;
         Pagereference pr2;
         Id queueId;     
         User u2; 
         User u5;
         User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
         system.runas(thisUser){
            u2 = TestDataHelper.createSalesforceUserForClientAccountTeam('test@test.com.testt', 'tAlias', 'test@test.com');
            u5 = TestDataHelper.createPortalUser();
          }
         system.runas(u2){ 
            User u6 = [select Id, UserRoleId, contactId, contact.name, contact.AccountId, contact.Account.DD_Task_Order_Required__c from User where id =: u5.Id];
            cm = TestDataHelper.createControlMeasure();
            insert cm;
            Apexpages.currentPage().getParameters().put('id', cm.Id);
            controlMeasureList.add(cm);
            ApexPages.StandardSetController cont = new ApexPages.StandardSetController(controlMeasureList);
            ddlic = new DD_ListInstructionsController(cont);
            ddlic.testUserId = u2.Id;
            Pagereference pr1 = ddlic.newButtonRedirect();
            system.assertEquals(String.valueOf(pr1.getURL()).contains('client'), false);
        }
        system.debug('DD_ListInstructionsControllerTest :: newInstructionButtonWithSalesforceUserTest :: end');
     }
}