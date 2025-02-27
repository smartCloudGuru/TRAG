@isTest(SeeAllData=true) 
public class SCPayableInvoiceActionTest {
    
    static testMethod void subcontractorInvoiceSubmitTest() {    
        SCPayableInvoiceAction sea;
        SubcontractorEngagement__c scengagement;   
        Pagereference pr1;
        pse__Region__c en;
        pse__Proj__c proj ;
        pse__Practice__c pr;
        Account acc;
        Opportunity opp;
        c2g__codaCompany__c  com;
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        ContentDocumentLink cdl;
        system.debug('SCPayableInvoiceActionTest :: subcontractorInvoiceSubmitTest :: start');
        User u1 = [select Id from User where Id =: userinfo.getUserId()];
        Proxy_Payable_Invoice__c ppi;
        system.runAs(u1){
            acc = TestDataHelper.createSubcontractorAccount();
            insert acc;
            opp = TestDataHelper.createOpportunity();
            insert opp;
            com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
            en = TestDataHelper.createEntity();
            en.ffpsai__OwnerCompany__c = com.id;
            insert en;
            pr = TestDataHelper.createPractice();
            Test.startTest();
            insert pr;
            proj = TestDataHelper.createProject();
            proj.pse__Is_Active__c  = false;
            proj.pse__Stage__c = 'Cancelled';
            proj.pse__Opportunity__c = opp.id;
            proj.pse__Region__c = en.id;
            proj.pse__Practice__c = pr.id;
            proj.pse__Start_Date__c = system.today();
            proj.Client__c = opp.Account_ID__c;
            proj.Draft_Report__c = true;
            insert proj;
            scengagement = TestDataHelper.createSubcontractorEngagement();
            scengagement.Subcontractor__c = acc.Id;
            scengagement.Project__c = proj.Id;
            scengagement.Status__c = 'Accepted';
            scengagement.CurrencyIsoCode = 'GBP';
            scengagement.IsPublished__c = true;
            insert scengagement;   
            ppi = new Proxy_Payable_Invoice__c();
            ppi.Name = 'testppi';
            ppi.Subcontractor_Engagement__c = scengagement.Id;
            ppi.Invoice_date__c = system.today();
            ppi.Fees__c = 50.00;            
            insert ppi;
            cdl = TestDataHelper.createContentDocumentLink(ppi);
            insert cdl;
            cdlList.add(cdl);
            Test.stopTest();
        }
        User u4 = TestDataHelper.createSCCommunityuser(acc);
        system.runAs(u4){                        
            Apexpages.standardController cont = new Apexpages.standardController(ppi);
            sea = new SCPayableInvoiceAction(cont);            
            //sea.payableInvoice = ppi;
            sea.sumbitInvoice();  
            Proxy_Payable_Invoice__c ppi1 = [select Id, Status__c from  Proxy_Payable_Invoice__c where Id =: ppi.Id];
            system.assertEquals('Submitted', ppi1.Status__c);            
            //sea.contDocList = cdlList;
            //sea.payableInvoice = ppi;
            //sea.sumbitInvoice();  
            //Proxy_Payable_Invoice__c ppi2 = [select Id, Status__c from  Proxy_Payable_Invoice__c where Id =: ppi.Id];
            //system.assertEquals('Submitted', ppi2.Status__c);
            sea.continueToEngagement();
        }         
        system.debug('SCPayableInvoiceActionTest :: subcontractorInvoiceSubmitTest :: end');
    } 

}