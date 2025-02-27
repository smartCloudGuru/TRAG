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

public class DDOBPartnerContactCreateExtensionTest {
    
	static testMethod void createPartnerContactTest() {     
    	DDOBPartnerContactCreateExtension pcic;        
        Contact con = TestDataHelper.createContact();          
        Account acc = [select Id, Name, DD_Due_Diligence_Portal_Licence__c from Account where Id =: con.AccountId];
        Test.setCurrentPageReference(new PageReference('Page.DDOBCreatePartnerContact'));
		System.currentPageReference().getParameters().put('accountId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);
        System.currentPageReference().getParameters().put('accLicense', 'Platform');
        System.currentPageReference().getParameters().put('retURL', '/apex/DDOnboardingFunctionalAccountCreate');
        System.currentPageReference().getParameters().put('showPreviousButton', 'true');
        Apexpages.standardController cont = new Apexpages.standardController(con);
        pcic = new DDOBPartnerContactCreateExtension(cont);	
        pcic.saveandnext();        
        system.assertEquals(true, String.valueOf(pcic.nextPage).contains('/apex/DDOBCreatePartnerAdminUser'));
        pcic.prev();
        system.assertEquals(true, String.valueOf(pcic.prevPage).contains('/apex/DDOnboardingFunctionalAccountCreate'));
    }
    
    static testMethod void createPartnerContactNegativeTest() {     
    	DDOBPartnerContactCreateExtension pcic;        
        Contact con = TestDataHelper.createContact();          
        Account acc = [select Id, Name, DD_Due_Diligence_Portal_Licence__c from Account where Id =: con.AccountId];
        Test.setCurrentPageReference(new PageReference('Page.DDOBCreatePartnerContact'));
		System.currentPageReference().getParameters().put('accountId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);
        System.currentPageReference().getParameters().put('accLicense', 'Platform');
        System.currentPageReference().getParameters().put('retURL', '/apex/DDOnboardingFunctionalAccountCreate');
        System.currentPageReference().getParameters().put('showPreviousButton', 'true');
        con.lastName = null;
        Apexpages.standardController cont = new Apexpages.standardController(con);
        pcic = new DDOBPartnerContactCreateExtension(cont);	
        pcic.saveandnext();        
        system.assertEquals(false, String.valueOf(pcic.nextPage).contains('conSalutation'));        
    }
}