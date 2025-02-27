@isTest(SeeAllData=true) 

public class PayableInvoiceTriggerHandlerTest {
    
    static testMethod void updateProjectManagerOnPayableInvoiceOnCreationTest() {
        List<Account> invAccountList = [select Id from Account where name = 'Test Investigations'];
		system.debug('invAccountList :: '+invAccountList);
        Opportunity opp = TestDataHelper.createOpportunity();
        insert opp;
        c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
        pse__Region__c en = TestDataHelper.createEntity();
        en.ffpsai__OwnerCompany__c = com.id;
        insert en;
        pse__Practice__c pr = TestDataHelper.createPractice();
        test.startTest();
        insert pr;
        pse__Proj__c proj = TestDataHelper.getProjectWithManager(Userinfo.getUserId());
        proj.pse__Is_Active__c  = false;
        proj.pse__Stage__c = 'Cancelled';
        proj.pse__Opportunity__c = opp.id;
        proj.pse__Region__c = en.id;
        proj.pse__Practice__c = pr.id;
        proj.pse__Start_Date__c = system.today();
        proj.Client__c = opp.Account_ID__c;
        insert proj;
        c2g__codaDimension3__c dim3 = TestDataHelper.createDimension3();
        dim3.ffps_0387__Project__c = proj.Id;   
        insert dim3;
        c2g__codaPurchaseInvoice__c payableInvoice = TestDataHelper.createPayableInvoice();
        payableInvoice.c2g__Account__c = invAccountList.get(0).Id;
        payableInvoice.c2g__Dimension3__c = dim3.Id;                
        insert payableInvoice;        
        List<c2g__codaPurchaseInvoice__c> payableInvoiceList_DB = [select Id, Project_Manager__c from c2g__codaPurchaseInvoice__c where Id =: payableInvoice.Id];
        system.assertEquals(1, payableInvoiceList_DB.size());
        system.assertEquals(UserInfo.getUserId(), payableInvoiceList_DB.get(0).Project_Manager__c);        
        payableInvoice.c2g__Dimension3__c = null;
        update payableInvoice;
        List<c2g__codaPurchaseInvoice__c> payableInvoiceList_DB1 = [select Id, Project_Manager__c from c2g__codaPurchaseInvoice__c where Id =: payableInvoice.Id];
        system.assertEquals(1, payableInvoiceList_DB1.size());
        system.assertEquals(null, payableInvoiceList_DB1.get(0).Project_Manager__c);
        test.stopTest();
			
    }
    
    

}