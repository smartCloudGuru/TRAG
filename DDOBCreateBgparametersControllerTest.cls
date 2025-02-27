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

public class DDOBCreateBgparametersControllerTest {    
    
    static testMethod void createQueueAndGroupTest() { 
        DDOBCreateBackgroundparametersController param;        
        User u1;
        User u2;  
        User userQ1;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];         
        system.runAs(thisUser){ 
            u1 = TestDataHelper.createPortaluser();
            userQ1 = [select Id, contactId, contact.AccountId, Contact.Account.Name from User where Id =: u1.Id];
            u2 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            UserRole userR = [Select u.Id, u.DeveloperName From UserRole u where developername = 'Senior_Management' ];
            u2.UserRoleId = userR.Id;
            update u2;
            User userQ = [select Id, userroleId from User where Id =: u2.Id];
            system.debug('userQ :: '+userQ);
        }
        system.runAs(u2){
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.DDOBBackgroundParameterCreate'));
            System.currentPageReference().getParameters().put('accId', userQ1.contact.AccountId);
            System.currentPageReference().getParameters().put('accName', userQ1.Contact.Account.Name);
            System.currentPageReference().getParameters().put('showPreviousButton', 'true');
            System.currentPageReference().getParameters().put('retURL', '/apex/DDOBInstructionCheckCreate');  
            param = new DDOBCreateBackgroundparametersController();
            param.createMandatoryBackgroundParameters();        
            system.assertEquals(true, param.bgParamSuccess);  
            param.bgParamSuccess = false;
            param.createMandatoryBackgroundParameters(); 
            system.assertEquals(true, param.bgParamSuccess);   
            param.prev();
            system.assertEquals(true, String.valueOf(param.prevPage).contains('/apex/DDOBInstructionCheckCreate'));    
            test.stopTest();
        }
    }
    
    static testMethod void createCustomSettingTest() { 
        DDOBCreateBackgroundparametersController param;        
        User u1;
        User u2;  
        User userQ1;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];         
        system.runAs(thisUser){ 
            u1 = TestDataHelper.createPortaluser();
            userQ1 = [select Id, contactId, contact.AccountId, Contact.Account.Name from User where Id =: u1.Id];
            u2 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            UserRole userR = [Select u.Id, u.DeveloperName From UserRole u where developername = 'Senior_Management' ];
            u2.UserRoleId = userR.Id;
            update u2;
            User userQ = [select Id, userroleId from User where Id =: u2.Id];
            system.debug('userQ :: '+userQ);
        }
        system.runAs(u2){
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.DDOBBackgroundParameterCreate'));
            System.currentPageReference().getParameters().put('accId', userQ1.contact.AccountId);
            System.currentPageReference().getParameters().put('accName', userQ1.Contact.Account.Name);
            System.currentPageReference().getParameters().put('showPreviousButton', 'true');
            System.currentPageReference().getParameters().put('retURL', '/apex/DDOBInstructionCheckCreate');  
            param = new DDOBCreateBackgroundparametersController();
            param.createMandatoryBackgroundParameters();     
            param.createCustomSetting();        
            system.assertEquals(true, param.customSettingSuccess);  
            param.customSettingSuccess = false;
            param.continueToSuccessPage();
            system.assertEquals(true, String.valueOf(param.pr).contains('DDOBCreateQueueMember'));  
            test.stopTest();
        }
    }
    
    static testMethod void createQueueAndGroupNegativeTest() { 
        DDOBCreateBackgroundparametersController param;        
        User u1;
        User u2;  
        User userQ1;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];         
        system.runAs(thisUser){ 
            u1 = TestDataHelper.createPortaluser();
            userQ1 = [select Id, contactId, contact.AccountId, Contact.Account.Name from User where Id =: u1.Id];
            u2 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            UserRole userR = [Select u.Id, u.DeveloperName From UserRole u where developername = 'Senior_Management' ];
            u2.UserRoleId = userR.Id;
            update u2;
            User userQ = [select Id, userroleId from User where Id =: u2.Id];
            system.debug('userQ :: '+userQ);
        }
        system.runAs(u2){
            test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.DDOBBackgroundParameterCreate'));
            System.currentPageReference().getParameters().put('accId', userQ1.contact.AccountId);
            System.currentPageReference().getParameters().put('accName', userQ1.Contact.Account.Name+'negative');
            System.currentPageReference().getParameters().put('showPreviousButton', 'true');
            System.currentPageReference().getParameters().put('retURL', '/apex/DDOBInstructionCheckCreate');  
            param = new DDOBCreateBackgroundparametersController();
            param.createMandatoryBackgroundParameters();    
            system.assertEquals(false, param.bgParamSuccess);              	
            test.stopTest();
        }
    }
}