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

public class CustomerCommunityControllerTest {

    /**
        Test if the customer communities styling data is loaded correctly in the constructor
    */
    static testMethod void initializeCustomerCommunityVariableTest() {
        
        system.debug('CustomerCommunityControllerTest :: initializeCustomerCommunityVariableTest :: start');
        User u1;
        User u5;
        User u6;
        Id accId;
        List<DDCustomerBrandingParameters__c> customerBrandingParamentersList = DDCustomerBrandingParameters__c.getall().values();
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            u1 = TestDataHelper.createPortalUserManagerRolePortalProfile();
            User u4 = [select Id, UserRoleId, contact.AccountId from User where id =: u1.Id];
            accId = u4.contact.AccountId;
            u5 = TestDataHelper.createCPPortalUserWithoutVerificationAccount();
            u6 = [select Id, contact.Account.ParentId, contact.AccountId from User where id =: u5.Id];
            u6.contact.Account.ParentId = accId;
            update u6.contact.Account;                
        }
        system.runas(u6){
            customerBrandingParamentersList.get(0).PartnerAccountId__c = String.valueOf(accId).subString(0,15);
            update customerBrandingParamentersList.get(0);
            CustomerCommunityController cust = new CustomerCommunityController();
            cust.initializeBrandingParameters();
            system.assertEquals(cust.BodyBodyDivBFilterViewFontSize, customerBrandingParamentersList.get(0).BodyBodyDivBFilterViewFontSize__c);
        }        
        system.debug('CustomerCommunityControllerTest :: initializeCustomerCommunityVariableTest :: end');
    }
}