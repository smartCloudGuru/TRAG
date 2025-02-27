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

public class DDOBCreateCounterpartyTypeExtensionTest {
    
    static testMethod void createCounterPartyTest() { 
        DDOBCreateCounterpartyTypeExtension cpfa;                
        Account acc = TestDataHelper.createAccount();
        acc.DD_Due_Diligence_Portal_Licence__c = 'Verification';
        insert acc;
        DD_Counterparty_Type__c cpType = TestDataHelper.createCounterPartyType();
        cpType.Questionnaire_Name__c = 'testQName';
        cpType.Questionnaire_URL__c = 'https://riskadvisory.tfaforms.net/27';              
        insert cpType;
        Test.setCurrentPageReference(new PageReference('Page.DDOBCounterpartyTypeCreate'));
        System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);
        System.currentPageReference().getParameters().put('showPreviousButton', 'true');
        System.currentPageReference().getParameters().put('retURL', '/apex/DDOBCreatePartnerAdminUser');  
        Apexpages.standardController cont = new Apexpages.standardController(cpType);
        cpfa = new DDOBCreateCounterpartyTypeExtension(cont);   
        cpfa.Save();        
        system.assertEquals(true, cpfa.requiredFieldMissing);        
        cpType.Account__c = acc.Id;
        cpType.DD_validity_in_months__c = 12;  
        update cpType;
        Apexpages.standardController cont1 = new Apexpages.standardController(cpType);
        cpfa = new DDOBCreateCounterpartyTypeExtension(cont1);  
        cpfa.Save();        
        system.assertEquals(false, cpfa.requiredFieldMissing);
        cpfa.prev();
        system.assertEquals(true, String.valueOf(cpfa.prevPage).contains('/apex/DDOBCreatePartnerAdminUser'));      
        cpfa.selectedRowIndex = '1';
        cpfa.Del();        
        system.assertEquals(0, cpfa.count);
        cpfa.add();        
        system.assertEquals(1, cpfa.lstInner.size());
    }

}