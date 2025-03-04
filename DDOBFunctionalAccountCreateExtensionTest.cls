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

public class DDOBFunctionalAccountCreateExtensionTest {
	
    static testMethod void createPartnerAccountTest() {        
        DDOBFunctionalAccountCreateExtension faic;
        Test.setCurrentPageReference(new PageReference('Page.DDOnboardingFunctionalAccountCreate'));
		System.currentPageReference().getParameters().put('showPreviousButton', 'true');
        System.currentPageReference().getParameters().put('retURL', '/apex/DDOnboardingWelcome');
        Account acc = TestDataHelper.createAccount();
        acc.name = 'lessthan15';
        insert acc;  
    	Apexpages.standardController cont = new Apexpages.standardController(acc);
        faic = new DDOBFunctionalAccountCreateExtension(cont);	
        faic.saveandnext();
        system.assertEquals(true, acc.IsPartner);
        system.assertEquals(false, String.valueOf(faic.nextPage).contains('&Id='));
        faic.prev();
        system.assertEquals(true, String.valueOf(faic.prevPage).contains('DDOnboardingWelcome'));
    }
    
    static testMethod void createPartnerAccountNegativeTest() {        
        DDOBFunctionalAccountCreateExtension faic;        
        Test.setCurrentPageReference(new PageReference('Page.DDOnboardingFunctionalAccountCreate'));
		System.currentPageReference().getParameters().put('showPreviousButton', 'true');
        Account acc = TestDataHelper.createAccount();
        insert acc;  
        acc.Name = null;
    	Apexpages.standardController cont = new Apexpages.standardController(acc);
        faic = new DDOBFunctionalAccountCreateExtension(cont);	
        faic.saveandnext();        
        system.assertEquals(null, faic.nextPage);        
    }
}