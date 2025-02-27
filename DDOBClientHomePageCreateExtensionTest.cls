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

public class DDOBClientHomePageCreateExtensionTest {
	
    static testMethod void homePageSuccessTest() { 
    	DDOBBackgroundParameterSuccessController param;  
        DDOBClientMainBrandingCreateExtension mbp;
        DDOBClientHomePageCreateExtension hpp;
        Apexpages.standardController cont;
        Apexpages.standardController cont1;        
        
        Account acc = TestDataHelper.createAccount();
        insert acc;
        Test.setCurrentPageReference(new PageReference('Page.DDOBBackgroundParameterCreate'));
        System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);        
        param = new DDOBBackgroundParameterSuccessController();
        param.continueToBrandingParam();
        DDBrandingParameters__c param2 = [select Id, PartnerAccountId__c from DDBrandingParameters__c where PartnerAccountId__c =: acc.Id];
        system.assertEquals(true, param2!=null);  
        Test.setCurrentPageReference(new PageReference('Page.DDOBClientMainBrandingCreate'));
        System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);  
        System.currentPageReference().getParameters().put('retURL', '/apex/DDOBBackgroundParameterCreate');  
        cont = new Apexpages.standardController(param2);
        mbp = new DDOBClientMainBrandingCreateExtension(cont);
        mbp.Save();
        system.assertEquals(true, mbp.mainBrandingUpdateSuccess);
        DDClientHomePageComponents__c hpc = [select Id, PartnerAccountId__c from DDClientHomePageComponents__c where PartnerAccountId__c =: acc.Id];
        system.assertEquals(true, hpc!=null); 
        Test.setCurrentPageReference(new PageReference('Page.DDOBClientHomePageBrandingCreate'));
        System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);  
        System.currentPageReference().getParameters().put('retURL', '/apex/DDOBClientMainBrandingCreate');  
        System.currentPageReference().getParameters().put('showPreviousButton', 'true');  
        cont1 = new Apexpages.standardController(hpc);
        hpp = new DDOBClientHomePageCreateExtension(cont1);
        hpp.Save();
        DDQuickActionPageComponents__c qap = [select Id, DDPartnerAccountId__c from DDQuickActionPageComponents__c where DDPartnerAccountId__c =: acc.Id];
        system.assertEquals(true, qap!=null); 
        hpp.prev();
        system.assertEquals(true, String.valueOf(hpp.prevPage).contains('DDOBClientMainBrandingCreate')); 
        hpp.Save();
        system.assertEquals(true, hpp.val!=null);
    } 
    
    static testMethod void homePageNegativeTest() { 
    	DDOBBackgroundParameterSuccessController param;  
        DDOBClientMainBrandingCreateExtension mbp;
        DDOBClientHomePageCreateExtension hpp;
        Apexpages.standardController cont;
        Apexpages.standardController cont1;        
        
        Account acc = TestDataHelper.createAccount();
        insert acc;
        Test.setCurrentPageReference(new PageReference('Page.DDOBBackgroundParameterCreate'));
        System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);        
        param = new DDOBBackgroundParameterSuccessController();
        param.continueToBrandingParam();
        DDBrandingParameters__c param2 = [select Id, PartnerAccountId__c from DDBrandingParameters__c where PartnerAccountId__c =: acc.Id];
        system.assertEquals(true, param2!=null);  
        Test.setCurrentPageReference(new PageReference('Page.DDOBClientMainBrandingCreate'));
        System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);  
        System.currentPageReference().getParameters().put('retURL', '/apex/DDOBBackgroundParameterCreate');  
        cont = new Apexpages.standardController(param2);
        mbp = new DDOBClientMainBrandingCreateExtension(cont);
        mbp.Save();
        system.assertEquals(true, mbp.mainBrandingUpdateSuccess);
        DDClientHomePageComponents__c hpc = [select Id, PartnerAccountId__c from DDClientHomePageComponents__c where PartnerAccountId__c =: acc.Id];
        system.assertEquals(true, hpc!=null); 
        Test.setCurrentPageReference(new PageReference('Page.DDOBClientHomePageBrandingCreate'));
        //System.currentPageReference().getParameters().put('accId', acc.Id);
        //System.currentPageReference().getParameters().put('accName', acc.Name);  
        System.currentPageReference().getParameters().put('retURL', '/apex/DDOBClientMainBrandingCreate');  
        System.currentPageReference().getParameters().put('showPreviousButton', 'true');  
        cont1 = new Apexpages.standardController(hpc);
        hpp = new DDOBClientHomePageCreateExtension(cont1);
        hpp.Save();
        List<DDQuickActionPageComponents__c> qapList = [select Id, DDPartnerAccountId__c from DDQuickActionPageComponents__c where DDPartnerAccountId__c =: acc.Id];
        system.assertEquals(0, qapList.size());         
    } 
}