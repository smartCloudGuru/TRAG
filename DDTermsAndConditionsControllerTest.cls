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

public class DDTermsAndConditionsControllerTest {
    
    
    /**
        Test if user details ae updated if CLient accepts the terms and conditions
    */
    static testMethod void sendInviteTest() {
             
         system.debug('DDTermsAndConditionsControllerTest :: sendInviteTest :: start');
         DDTermsAndConditionsController ddtc;
         User u2; 
         User u5;
         User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
         system.runas(thisUser){
            u2 = TestDataHelper.createSalesforceUserForClientAccountTeam('test@test.com.testt', 'tAlias', 'test@test.com');
            u5 = TestDataHelper.createPortalUser();
          }
        system.runas(u5){ 
            User u6 = [select Id, UserRoleId, DD_T_C_s_Accepted__c, contact.Account.Name, contactId, contact.name, contact.AccountId, contact.Account.DD_Task_Order_Required__c from User where id =: u5.Id];
            ddtc = new DDTermsAndConditionsController();
            ddtc.usr = u6;
            ddtc.checkbox01 = true;
            Pagereference pr1 = ddtc.saveTermsAndConditionsPref();
            system.assertEquals(pr1.getUrl(), '/client/home/home.jsp');
            system.assertEquals(ddtc.termsAndConditionsNotAccepted, false);
            User u7 = [select Id, UserRoleId, contact.Account.Name, DD_T_C_s_Accepted__c, contactId, contact.name, contact.AccountId, contact.Account.DD_Task_Order_Required__c from User where id =: u5.Id];
            system.assertEquals(u7.DD_T_C_s_Accepted__c, true);
            ddtc.userDetails();
            system.assertEquals(u7.contact.Account.Name, ddtc.accountName);
        }
        system.debug('DDTermsAndConditionsControllerTest :: sendInviteTest :: end');
     }    
    
    /**
        Test if user details are not updated if CLient does not accepts the terms and conditions
    */
    static testMethod void sendInviteTestNegative() {
            
        system.debug('DDTermsAndConditionsControllerTest :: sendInviteTestNegative :: start');
        DDTermsAndConditionsController ddtc;
        User u2; 
        User u5;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u2 = TestDataHelper.createSalesforceUserForClientAccountTeam('test@test.com.testt', 'tAlias', 'test@test.com');
            u5 = TestDataHelper.createPortalUser();
        }
        system.runas(u5){ 
            User u6 = [select Id, UserRoleId, DD_T_C_s_Accepted__c, contact.Account.Name, contactId, contact.name, contact.AccountId, contact.Account.DD_Task_Order_Required__c from User where id =: u5.Id];
            system.debug('u6 :: '+u6);
            ddtc = new DDTermsAndConditionsController();
            ddtc.usr = u6;
            ddtc.checkbox01 = false;
            Pagereference pr1 = ddtc.saveTermsAndConditionsPref();
            system.assertEquals(ddtc.termsAndConditionsNotAccepted, true);
        }
        system.debug('DDTermsAndConditionsControllerTest :: sendInviteTestNegative :: end');
    }    
}