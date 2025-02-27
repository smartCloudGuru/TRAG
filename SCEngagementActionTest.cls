@isTest(SeeAllData=true) 
public class SCEngagementActionTest {    
    
    static testMethod void subcontractorAcceptEngagementTest() {    
        SCEngagementAction sea;
        SubcontractorEngagement__c scengagement;   
        Pagereference pr1;
        pse__Region__c en;
        pse__Proj__c proj ;
        pse__Practice__c pr;
        Account acc;
        Opportunity opp;
        c2g__codaCompany__c  com;
        system.debug('SCEngagementActionTest :: subcontractorAcceptEngagementTest :: start');
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
            scengagement.Status__c = 'Approved';
            scengagement.CurrencyIsoCode = 'GBP';
            scengagement.IsPublished__c = true;
            scengagement.Industry_ies__c  = 'Accountancy';
            insert scengagement;
            Test.stopTest();
        }
        User u4 = TestDataHelper.createSCCommunityuser(acc);
        system.runAs(u4){
            ppi = new Proxy_Payable_Invoice__c();
            ppi.Name = 'testppi';
            ppi.Subcontractor_Engagement__c = scengagement.Id;
            ppi.Invoice_date__c = system.today();
            ppi.Fees__c = 50.00;
            ppi.Status__c = 'Submitted';
            insert ppi;
            Apexpages.standardController cont = new Apexpages.standardController(scengagement);
            sea = new SCEngagementAction(cont);
            sea.scEngagement = scEngagement;
            sea.acceptEngagement();  
            SubcontractorEngagement__c scengagement1 = [select Id, Status__c from  SubcontractorEngagement__c where Id =: scengagement.Id];
            system.assertEquals('Accepted', scengagement1.Status__c);
        }         
        system.debug('SCEngagementActionTest :: subcontractorAcceptEngagementTest :: end');
    } 
    
    static testMethod void subcontractorRejectEngagementTest() {    
        SCEngagementAction sea;
        SubcontractorEngagement__c scengagement;   
        Pagereference pr1;
        pse__Region__c en;
        pse__Proj__c proj ;
        pse__Practice__c pr;
        Account acc;
        Opportunity opp;
        c2g__codaCompany__c  com;
        system.debug('SCEngagementActionTest :: subcontractorAcceptEngagementTest :: start');
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
            scengagement.Status__c = 'Approved';
            scengagement.CurrencyIsoCode = 'GBP';
            scengagement.IsPublished__c = true;
            scengagement.Industry_ies__c  = 'Accountancy';
            insert scengagement;
            Test.stopTest();
        }
        User u4 = TestDataHelper.createSCCommunityuser(acc);
        system.runAs(u4){
            ppi = new Proxy_Payable_Invoice__c();
            ppi.Name = 'testppi';
            ppi.Subcontractor_Engagement__c = scengagement.Id;
            ppi.Invoice_date__c = system.today();
            ppi.Fees__c = 50.00;
            ppi.Status__c = 'Submitted';
            insert ppi;
            Apexpages.standardController cont = new Apexpages.standardController(scengagement);
            sea = new SCEngagementAction(cont);
            sea.scEngagement = scEngagement;
            sea.denyEngagement();  
            SubcontractorEngagement__c scengagement1 = [select Id, Status__c from  SubcontractorEngagement__c where Id =: scengagement.Id];
            system.assertEquals('Declined', scengagement1.Status__c);
        }         
        system.debug('SCEngagementActionTest :: subcontractorAcceptEngagementTest :: end');
    } 
}