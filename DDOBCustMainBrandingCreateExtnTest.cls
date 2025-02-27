@isTest(SeeAllData=true) 
public class DDOBCustMainBrandingCreateExtnTest {
    
    static testMethod void mainBrandingSuccessTest() { 
        Apexpages.standardController cont1;
        DDOBCustomerMainBrandingCreateExtension param;  
        Apexpages.standardController cont;
        Account acc = TestDataHelper.createAccount();
        insert acc;
        Test.setCurrentPageReference(new PageReference('Page.DOBClientQuickActionBrandingCreate'));
        System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);   
        System.currentPageReference().getParameters().put('showPreviousButton', 'false');   
    	DDOBClientQuickActionCreateExtension param1 = new DDOBClientQuickActionCreateExtension(cont1);
        param1.save();        
        DDCustomerBrandingParameters__c param2 = [select Id, PartnerAccountId__c from DDCustomerBrandingParameters__c where PartnerAccountId__c =: acc.Id];
        system.assertEquals(true, param2!=null);  
        Test.setCurrentPageReference(new PageReference('Page.DDOBCustomerMainBrandingCreate'));
        System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name);        
        cont = new Apexpages.standardController(param2);
        param = new DDOBCustomerMainBrandingCreateExtension(cont);
        param.save();        
        DDCustomerHomePageComponent__c hpc = [select Id, DDPartnerAccountId__c from DDCustomerHomePageComponent__c where DDPartnerAccountId__c =: acc.Id];
        system.assertEquals(true, hpc!=null);          
    }      
    
    static testMethod void mainBrandingNegativeTest() { 
    	DDOBCustomerMainBrandingCreateExtension param;  
        Apexpages.standardController cont;
        Account acc = TestDataHelper.createAccount();
        insert acc;
        Test.setCurrentPageReference(new PageReference('Page.DDOBCustomerMainBrandingCreate'));
        System.currentPageReference().getParameters().put('accId', null);
        System.currentPageReference().getParameters().put('accName', null);        
        param = new DDOBCustomerMainBrandingCreateExtension(cont);
        param.save();
        List<DDCustomerBrandingParameters__c> param2List = [select Id, PartnerAccountId__c from DDCustomerBrandingParameters__c where PartnerAccountId__c =: acc.Id];
        system.assertEquals(true, param2List.isEmpty());          
    }      

}