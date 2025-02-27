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

public with sharing class CommunitiesSelfRegControllerTest {
    
    /**
        Test the data inserted by user for registration
    */
    public static void testCommunitiesSelfRegController() {
        
        system.debug('CommunitiesSelfRegControllerTest :: testCommunitiesSelfRegController :: start');
        User u2;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u2 = TestDataHelper.createPortaluser();            
        }
        system.runas(u2){
            CounterParty_Invite__c cpi = TestDataHelper.createCounterPartyInvite();
            insert cpi;
            ApexPages.currentPage().getParameters().put('cpInviteId', cpi.Id);
            CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
            controller.populateFields();
            System.assert(controller.registerUser() == null);
            controller.password = 'Hello123$';
            controller.confirmPassword = 'Hello123$';
            System.assert(controller.registerUser() == null);
         }
         system.debug('CommunitiesSelfRegControllerTest :: testCommunitiesSelfRegController :: end');
    }
    
    /**
        Test if password and confirm password matches
    */
    public static void testInvalidPassword() {
        
        system.debug('CommunitiesSelfRegControllerTest :: testInvalidPassword :: start');
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'Bob';
        controller.lastName = 'Jones';
        controller.email = 'bob@jones.com';
        controller.password = '8yhMsHDN&ituQgO$WO';
        controller.confirmPassword = 'not the same';
        controller.communityNickname = 'bob-jones-testing';
        PageReference pageRef = controller.registerUser();
        System.assert(pageRef == null, 'The returned page reference should be null');
        system.debug('CommunitiesSelfRegControllerTest :: testInvalidPassword :: end');
      }
}