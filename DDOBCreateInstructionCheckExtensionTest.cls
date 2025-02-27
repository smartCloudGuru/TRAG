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

public class DDOBCreateInstructionCheckExtensionTest {
    
    static testMethod void createInstructionCheckLevelTest() { 
        DDOBCreateInstructionCheckExtension iclfa;                
        Account acc = TestDataHelper.createAccount();
        insert acc;
        Instruction_Check_Level_Type__c icl = TestDataHelper.createInstructionCheckLevel();             
        insert icl;
        Test.setCurrentPageReference(new PageReference('Page.DDOBInstructionCheckCreate'));
		System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);
        System.currentPageReference().getParameters().put('showPreviousButton', 'true');
        System.currentPageReference().getParameters().put('retURL', '/apex/DDOBControlMeasureCreate');  
        Apexpages.standardController cont = new Apexpages.standardController(icl);
        iclfa = new DDOBCreateInstructionCheckExtension(cont);	
        iclfa.Save();        
        system.assertEquals(true, iclfa.requiredFieldMissing);        
        icl.Account__c = acc.Id;
        icl.DDPrice__c = 10.00;
        update icl;
        Apexpages.standardController cont1 = new Apexpages.standardController(icl);
        iclfa = new DDOBCreateInstructionCheckExtension(cont1);	
        iclfa.Save();        
        system.assertEquals(false, iclfa.requiredFieldMissing);
        iclfa.prev();
        system.assertEquals(true, String.valueOf(iclfa.prevPage).contains('/apex/DDOBControlMeasureCreate'));    	
        iclfa.selectedRowIndex = '1';
        iclfa.Del();        
        system.assertEquals(0, iclfa.count);
        iclfa.add();        
        system.assertEquals(1, iclfa.lstInner.size());
    }

}