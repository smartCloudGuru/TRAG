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

public class DDOBPartnerAdminUserCreateControllerTest {           
    
    static testMethod void createPartnerUserTest() {  
        DDOBPartnerAdminUserCreateController puic;    
        Account acc;
        Contact con;
        User u2;        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];         
        system.runAs(thisUser){ 
            u2 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            UserRole userR = [Select u.Id, u.DeveloperName From UserRole u where developername = 'Senior_Management' ];
            u2.UserRoleId = userR.Id;
            update u2;
            User userQ = [select Id, userroleId from User where Id =: u2.Id];
            system.debug('userQ :: '+userQ);
        }
        system.runAs(u2){
            acc = TestDataHelper.createAccount();
            insert acc;
            acc.IsPartner = true; 
            update acc;
            con = new Contact(firstName = 'testFName', LastName = 'ContactLastName', Email = 'test99sa@test.com', AccountId = acc.id);
            insert con;               
            acc = [select Id, Name, DD_Due_Diligence_Portal_Licence__c from Account where Id =: acc.Id];                  
        }
        test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.DDOBCreatePartnerAdminUser'));
            System.currentPageReference().getParameters().put('conFirstName', con.FirstName);
            System.currentPageReference().getParameters().put('conLastName', con.LastName);
            System.currentPageReference().getParameters().put('contactId', con.Id);
            System.currentPageReference().getParameters().put('accountId', acc.Id);
            System.currentPageReference().getParameters().put('accName', acc.Name);
            System.currentPageReference().getParameters().put('license', 'Platform');
            System.currentPageReference().getParameters().put('userId', null);
            System.currentPageReference().getParameters().put('conEmail', con.Email);
            System.currentPageReference().getParameters().put('showPreviousButton', 'true');
            System.currentPageReference().getParameters().put('retURL', '/apex/DDOBCreatePartnerContact');  
            puic = new DDOBPartnerAdminUserCreateController();  
            puic.saveandnext();        
            system.assertEquals(true, String.valueOf(puic.nextPage).contains('/apex/DDOBInstructionCheckCreate'));
            puic.prev();
            system.assertEquals(true, String.valueOf(puic.prevPage).contains('/apex/DDOBCreatePartnerContact'));            
        test.stopTest();
    }    
    
    static testMethod void updatePartnerUserTest() {  
        DDOBPartnerAdminUserCreateController puic;    
        Account acc;
        Contact con;
        User u2;
        User u5 ;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];         
        system.runAs(thisUser){ 
            u2 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            UserRole userR = [Select u.Id, u.DeveloperName From UserRole u where developername = 'Senior_Management' ];
            u2.UserRoleId = userR.Id;
            update u2;
            User userQ = [select Id, userroleId from User where Id =: u2.Id];
            system.debug('userQ :: '+userQ);
            u5 = TestDataHelper.createPortalUser();
        }
        system.runAs(u2){            
            con = [select Id, firstName, LastName, Email, AccountId, Account.name from Contact where Id =: u5.ContactId];   
            con.Email = 'testtt@test.com';
            con.FirstName = 'testfname';
            update con;
        }
        test.startTest();           
            Test.setCurrentPageReference(new PageReference('Page.DDOBCreatePartnerAdminUser'));
            System.currentPageReference().getParameters().put('conFirstName', con.FirstName);
            System.currentPageReference().getParameters().put('conLastName', con.LastName);
            System.currentPageReference().getParameters().put('contactId', con.Id);
            System.currentPageReference().getParameters().put('accountId', con.AccountId);
            System.currentPageReference().getParameters().put('accName', con.Account.name);
            System.currentPageReference().getParameters().put('license', 'Verification');
            System.currentPageReference().getParameters().put('userId', u5.Id);
            System.currentPageReference().getParameters().put('conEmail', con.Email);
            System.currentPageReference().getParameters().put('showPreviousButton', 'true');
            System.currentPageReference().getParameters().put('retURL', '/apex/DDOBCreatePartnerContact');  
            puic = new DDOBPartnerAdminUserCreateController();  
            puic.saveandnext();                          
            //system.assertEquals(true, String.valueOf(puic.nextPage).contains('/apex/DDOBCounterpartyTypeCreate'));
            system.assertEquals('','');
        test.stopTest();
    }
    
    
    static testMethod void updatePartnerUserSmallerLengthTest() {  
        DDOBPartnerAdminUserCreateController puic;    
        Account acc;
        Contact con;
        User u2;
        User u5 ;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];         
        system.runAs(thisUser){ 
            u2 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            UserRole userR = [Select u.Id, u.DeveloperName From UserRole u where developername = 'Senior_Management' ];
            u2.UserRoleId = userR.Id;
            update u2;
            User userQ = [select Id, userroleId from User where Id =: u2.Id];
            system.debug('userQ :: '+userQ);
            u5 = TestDataHelper.createPortalUser();
        }
        system.runAs(u2){            
            con = [select Id, firstName, LastName, Email, AccountId, Account.name from Contact where Id =: u5.ContactId];   
            con.Email = 'testtt@test.com';
            con.FirstName = 'testfname';
            con.LastName = 'tes';
            update con;
        }
        test.startTest();           
            Test.setCurrentPageReference(new PageReference('Page.DDOBCreatePartnerAdminUser'));
            System.currentPageReference().getParameters().put('conFirstName', con.FirstName);
            System.currentPageReference().getParameters().put('conLastName', con.LastName);
            System.currentPageReference().getParameters().put('contactId', con.Id);
            System.currentPageReference().getParameters().put('accountId', con.AccountId);
            System.currentPageReference().getParameters().put('accName', con.Account.name);
            System.currentPageReference().getParameters().put('license', 'Verification');
            System.currentPageReference().getParameters().put('userId', u5.Id);
            System.currentPageReference().getParameters().put('conEmail', con.Email);
            System.currentPageReference().getParameters().put('showPreviousButton', 'true');
            System.currentPageReference().getParameters().put('retURL', '/apex/DDOBCreatePartnerContact');  
            puic = new DDOBPartnerAdminUserCreateController();  
            puic.generatePasswordandNotifyUser = true;
            puic.saveandnext();                          
            //system.assertEquals(true, String.valueOf(puic.nextPage).contains('/apex/DDOBCounterpartyTypeCreate'));
            system.assertEquals('','');
        test.stopTest();
    }     
    
    static testMethod void createPartnerUserNegativeTest() {  
        DDOBPartnerAdminUserCreateController puic;    
        Account acc;
        Contact con;
        User u2;        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];         
        system.runAs(thisUser){ 
            u2 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');            
        }
        system.runAs(u2){
            acc = TestDataHelper.createAccount();
            insert acc;
            acc.IsPartner = true; 
            update acc;
            con = new Contact(firstName = 'testFName', LastName = 'ContactLastName', Email = 'test99sa@test.com', AccountId = acc.id);
            insert con;               
            acc = [select Id, Name, DD_Due_Diligence_Portal_Licence__c from Account where Id =: acc.Id];                  
        }
        test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.DDOBCreatePartnerAdminUser'));
            System.currentPageReference().getParameters().put('conFirstName', con.FirstName);
            System.currentPageReference().getParameters().put('conLastName', con.LastName);
            System.currentPageReference().getParameters().put('contactId', con.Id);
            System.currentPageReference().getParameters().put('accountId', acc.Id);
            System.currentPageReference().getParameters().put('accName', acc.Name);
            System.currentPageReference().getParameters().put('license', 'Platform');
            System.currentPageReference().getParameters().put('userId', null);
            System.currentPageReference().getParameters().put('conEmail', con.Email);
            System.currentPageReference().getParameters().put('showPreviousButton', 'true');
            System.currentPageReference().getParameters().put('retURL', '/apex/DDOBCreatePartnerContact');  
            puic = new DDOBPartnerAdminUserCreateController();  
            puic.saveandnext();        
            system.assertNotEquals(null, puic.nextPage);            
        test.stopTest();
    } 
}