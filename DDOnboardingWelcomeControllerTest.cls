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
public class DDOnboardingWelcomeControllerTest {
    
    static testMethod void welcomePageTest() {
        DDOnboardingWelcomeController wc = new DDOnboardingWelcomeController();        
        wc.functionalAccount = 'invalid';
        wc.nextPage();        
        system.assertEquals(true, wc.pgRef==null);
        wc.functionalAccount = null;
        wc.nextPage();
        system.assertEquals(true, wc.pgRef!=null);
        system.assertEquals(false, String.valueOf(wc.pgRef).contains('&Id='));   
        wc.dispText();
        system.assertEquals(null, wc.functionalAccount);
        Account acc = TestDataHelper.createAccount();
        insert acc;                
        wc.dispTextBox = true;
        wc.dispText();
        system.assertEquals('Parent Account ID', wc.functionalAccount);        
        wc.functionalAccount = acc.Id;
        wc.nextPage();        
        system.assertEquals(true, wc.pgRef!=null);
        system.assertEquals(true, String.valueOf(wc.pgRef).contains(acc.Id));                   
    }

}