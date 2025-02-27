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

public class DDAssessmentViewControllerTest {

    /**
        Test if the contact is updated with the same Questionnaire URL as that of Assessment
    */
    static testMethod void getquestionnaireURLTest() {
        
        system.debug('DDAssessmentViewControllerTest :: getquestionnaireURLTest :: start');
        User u2;
        User u4;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u4 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRole();            
        }
        system.runas(u4){
            User u3 = [select Id, UserRoleId, contactId from User where id =: u2.Id];
            Case cs = TestDataHelper.createCase();
            cs.ContactId = u3.ContactId;
            insert cs;
            String csIdAPI = String.valueOf(cs.Id).subString(0,15);
            DDAssessmentViewController cont = new DDAssessmentViewController();
            cont.testUserId = u3.Id;
            cont.assessmentURL();
            system.assert(cont.questionnaireURL.contains(cs.DD_Questionnaire_URL__c));
        }
        system.debug('DDAssessmentViewControllerTest :: getquestionnaireURLTest :: end');
    }
}