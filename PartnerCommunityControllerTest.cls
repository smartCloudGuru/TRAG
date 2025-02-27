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

public class PartnerCommunityControllerTest {

    /**
        Test if the client portal styling data is loaded correctly
    */
    static testMethod void initializePartnerCommunityVariableTest() {
    
    
        system.debug('PartnerCommunityControllerTest :: initializePartnerCommunityVariableTest :: start ');
        User u1;
        Id accId;
        List<DDBrandingParameters__c> brandingParamentersList = DDBrandingParameters__c.getall().values();
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            u1 = TestDataHelper.createPortalUserManagerRolePortalProfile();
            system.debug('u1  :: '+u1);              
        }
        system.runas(u1){
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u1.Id];
            brandingParamentersList.get(0).PartnerAccountId__c = String.valueOf(u3.contact.AccountId).subString(0,15);
            update brandingParamentersList.get(0);
            PartnerCommunityController pt = new PartnerCommunityController();
            pt.initializeBrandingParameters();
            system.assertEquals(pt.BodyBodyDivBFilterViewFontSize, brandingParamentersList.get(0).BodyBodyDivBFilterViewFontSize__c);
        }        
        system.debug('PartnerCommunityControllerTest :: initializePartnerCommunityVariableTest :: end ');
    }
}