@isTest(SeeAllData=true) 
public class DDOBCustomerHomePageCreateExtnTest {
    
    static testMethod void mainBrandingSuccessTest() { 
        Apexpages.standardController cont1;
        DDOBCustomerHomePageCreateExtension param;  
        Apexpages.standardController cont;
        Account acc = TestDataHelper.createAccount();
        insert acc;
        Test.setCurrentPageReference(new PageReference('Page.DDOBCustomerMainBrandingCreate'));
        System.currentPageReference().getParameters().put('accId', acc.Id);
        System.currentPageReference().getParameters().put('accName', acc.Name+'1221');   
        System.currentPageReference().getParameters().put('showPreviousButton', 'false');   
    	DDOBCustomerMainBrandingCreateExtension param1 = new DDOBCustomerMainBrandingCreateExtension(cont1);
        test.startTest();
        param1.save();        
        List<DDCustomerBrandingParameters__c> param2List = [select Id, PartnerAccountId__c from DDCustomerBrandingParameters__c where PartnerAccountId__c =: acc.Id];
        if(!param2List.isEmpty() && param2List.size() == 1){
            system.assertEquals(true, param2List.get(0)!=null);  
            Test.setCurrentPageReference(new PageReference('Page.DDOBCustomerMainBrandingCreate'));
            System.currentPageReference().getParameters().put('accId', acc.Id);
            System.currentPageReference().getParameters().put('accName', acc.Name+'1221');        
            cont = new Apexpages.standardController(param2List.get(0));
            param = new DDOBCustomerHomePageCreateExtension(cont);
            param.save();        
            DDCustomerHomePageComponent__c hpc = [select Id, DDPartnerAccountId__c from DDCustomerHomePageComponent__c where DDPartnerAccountId__c =: acc.Id];
            system.assertEquals(true, hpc!=null);   
            param.prev();
            system.assertEquals(true, String.valueOf(param.prevPage).contains('DDOBCustomerMainBrandingCreate')); 
            test.stopTest();
        }
    }      
    
    static testMethod void mainBrandingNegativeTest() { 
    	DDOBCustomerHomePageCreateExtension param;  
        Apexpages.standardController cont;
        Account acc = TestDataHelper.createAccount();
        insert acc;
        Test.setCurrentPageReference(new PageReference('Page.DDOBCustomerMainBrandingCreate'));
        System.currentPageReference().getParameters().put('accId', null);
        System.currentPageReference().getParameters().put('accName', null);    
        System.currentPageReference().getParameters().put('showPreviousButton', 'false');   
        param = new DDOBCustomerHomePageCreateExtension(cont);
        param.save();
        List<DDCustomerHomePageComponent__c> hpcList = [select Id, DDPartnerAccountId__c from DDCustomerHomePageComponent__c where DDPartnerAccountId__c =: acc.Id];
        system.assertEquals(true, hpcList.isEmpty());        
    } 

}