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

public class DDPSEProjectTriggerHandlerTest {

      /**
          Test the status of related Instruction when Project status is changed to Rejected
      */
      static testMethod void rejectedProjectTriggerTest() {

             system.debug('DDPSEProjectTriggerHandlerTest :: rejectedProjectTriggerTest :: start');
             pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
             Opportunity opp = TestDataHelper.createOpportunity();
             DD_Instruction__c ins = TestDataHelper.createInstructions();
             ins.DD_Status__c  = 'Submitted ';
             insert ins;
             opp.DD_Instruction__c = ins.id;
             insert opp;
             c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
             pse__Region__c en = TestDataHelper.createEntity();
             en.ffpsai__OwnerCompany__c = com.id;
             insert en;
             pse__Practice__c pr = TestDataHelper.createPractice();
             insert pr;
             pse__Proj__c proj = TestDataHelper.createProject();
             proj.pse__Is_Active__c  = false;
             proj.pse__Stage__c = 'Rejected';
             proj.pse__Opportunity__c = opp.id;
             proj.pse__Region__c = en.id;
             proj.pse__Practice__c = pr.id;
             proj.pse__Start_Date__c = system.today();
             proj.Client__c = opp.Account_ID__c;
             proj.Draft_Report__c = true;
             insert proj;
             
             be.pse__Project__c = proj.id;
             insert be;
             proj.pse__Is_Active__c = true;
             DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();
             sip.Billing_Event__c  = be.Id;
             insert sip;
          Test.startTest();
             update proj;
             
             List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Subject__c, Account_Name__c, Project_Code__c, Shipping_Street__c, Shipping_City__c,
                                                   Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                                   Registration_Number__c From DDSalesInvoiceProxy__c
                                                   where Billing_Event__c =: be.Id];
             Opportunity oppQ = [select Id, DD_Instruction__r.DD_Status__c from Opportunity where Id =: opp.id];
             system.assertEquals(oppQ.DD_Instruction__r.DD_Status__c, 'In Progress') ;
          Test.stopTest();   
          //system.assertEquals(sipQ.get(0).Subject__c, proj.ffps_0387__Subject_s__c) ;
             system.debug('DDPSEProjectTriggerHandlerTest :: rejectedProjectTriggerTest :: end');
    }
    
    
    /**
        Test the status of related Instruction when Project status is changed to cancelled
    */
    static testMethod void cancelledProjectTriggerTest() {

         system.debug('DDPSEProjectTriggerHandlerTest :: cancelledProjectTriggerTest :: start');
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         Opportunity opp = TestDataHelper.createOpportunity();
         DD_Instruction__c ins = TestDataHelper.createInstructions();
         ins.DD_Status__c  = 'Submitted ';
         insert ins;
         opp.DD_Instruction__c = ins.id;
         insert opp;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         insert pr;
         pse__Proj__c proj = TestDataHelper.createProject();
         proj.pse__Is_Active__c  = false;
         proj.pse__Stage__c = 'Cancelled';
         proj.pse__Opportunity__c = opp.id;
         proj.pse__Region__c = en.id;
         proj.pse__Practice__c = pr.id;
         proj.pse__Start_Date__c = system.today();
         proj.Client__c = opp.Account_ID__c;
         proj.Draft_Report__c = true;
         insert proj;
         
         be.pse__Project__c = proj.id;
         insert be;
         proj.pse__Is_Active__c = true;
         DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();
         sip.Billing_Event__c  = be.Id;
         insert sip;
        Test.startTest();
         update proj;
        
         List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Subject__c, Account_Name__c, Project_Code__c, Shipping_Street__c, Shipping_City__c,
                                               Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                               Registration_Number__c From DDSalesInvoiceProxy__c
                                               where Billing_Event__c =: be.Id];
         Opportunity oppQ = [select Id, DD_Instruction__r.DD_Status__c from Opportunity where Id =: opp.id];
         system.assertEquals(oppQ.DD_Instruction__r.DD_Status__c, 'In Progress') ;
        Test.stopTest();    
        system.debug('DDPSEProjectTriggerHandlerTest :: cancelledProjectTriggerTest :: end');
    }

    /**
        Test the status of related Instruction when Project Interim Report status is ticked
    */
    static testMethod void interimReportProjectTriggerTest() {

         system.debug('DDPSEProjectTriggerHandlerTest :: interimReportProjectTriggerTest :: start');
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         Opportunity opp = TestDataHelper.createOpportunity();
         DD_Instruction__c ins = TestDataHelper.createInstructions();
         ins.DD_Status__c  = 'Submitted ';
         insert ins;
         opp.DD_Instruction__c = ins.id;
         insert opp;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         insert pr;
         pse__Proj__c proj = TestDataHelper.createProject();
         proj.pse__Is_Active__c  = false;
         //proj.pse__Stage__c = 'Cancelled';
         proj.pse__Opportunity__c = opp.id;
         proj.pse__Region__c = en.id;
         proj.pse__Practice__c = pr.id;
         proj.pse__Start_Date__c = system.today();
         proj.Client__c = opp.Account_ID__c;
         proj.Interim_Report__c = false;
         insert proj;
         
         be.pse__Project__c = proj.id;
         //insert be;
         proj.pse__Is_Active__c = true;
         proj.Interim_Report__c = true;
         //DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();
         //sip.Billing_Event__c  = be.Id;
         //insert sip;
         Test.startTest(); 
         update proj;
         /*List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Subject__c, Account_Name__c, Project_Code__c, Shipping_Street__c, Shipping_City__c,
                                               Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                               Registration_Number__c From DDSalesInvoiceProxy__c
                                               where Billing_Event__c =: be.Id];*/
        
        Opportunity oppQ = [select Id, DD_Instruction__r.DD_Status__c from Opportunity where Id =: opp.id];
         system.assertEquals(oppQ.DD_Instruction__r.DD_Status__c, 'In Progress') ;
        Test.stopTest();    
        system.debug('DDPSEProjectTriggerHandlerTest :: interimReportProjectTriggerTest :: end');
     }

    /**
        Test the status of related Instruction when Project Draft Report status is ticked
    */
    static testMethod void draftReportProjectTriggerTest() {

         system.debug('DDPSEProjectTriggerHandlerTest :: draftReportProjectTriggerTest :: start');
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         Opportunity opp = TestDataHelper.createOpportunity();
         DD_Instruction__c ins = TestDataHelper.createInstructions();
         ins.DD_Status__c  = 'Submitted ';
         insert ins;
         opp.DD_Instruction__c = ins.id;
         insert opp;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         insert pr;
         pse__Proj__c proj = TestDataHelper.createProject();
         proj.pse__Is_Active__c  = false;
         //proj.pse__Stage__c = 'Cancelled';
         proj.pse__Opportunity__c = opp.id;
         proj.pse__Region__c = en.id;
         proj.pse__Practice__c = pr.id;
         proj.pse__Start_Date__c = system.today();
         proj.Client__c = opp.Account_ID__c;
         proj.Interim_Report__c = true;
         proj.Draft_Report__c = false;
         insert proj;
         
         
         proj.pse__Is_Active__c = true;
         proj.Draft_Report__c = true;
        Test.startTest(); 
        update proj;
        //be.pse__Project__c = proj.id;
         //insert be;
         //DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();
         //sip.Billing_Event__c  = be.Id;
         //insert sip;
         
         /*List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Subject__c, Account_Name__c, Project_Code__c, Shipping_Street__c, Shipping_City__c,
                                               Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                               Registration_Number__c From DDSalesInvoiceProxy__c
                                               where Billing_Event__c =: be.Id];*/
        
        Opportunity oppQ = [select Id, DD_Instruction__r.DD_Status__c from Opportunity where Id =: opp.id];
         system.debug('oppQ :: '+oppQ);
         system.assertEquals(oppQ.DD_Instruction__r.DD_Status__c, 'In Progress') ;
        Test.stopTest();    
        system.debug('DDPSEProjectTriggerHandlerTest :: draftReportProjectTriggerTest :: end');
     }


    /**
        Test the status of related Instruction when Project Final Report status is ticked
    */
    static testMethod void finalReportProjectTriggerTest() {

         system.debug('DDPSEProjectTriggerHandlerTest :: finalReportProjectTriggerTest :: start');
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         Opportunity opp = TestDataHelper.createOpportunity();
         DD_Instruction__c ins = TestDataHelper.createInstructions();
         ins.DD_Status__c  = 'Submitted ';
         insert ins;
         opp.DD_Instruction__c = ins.id;
         insert opp;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         insert pr;
         pse__Proj__c proj = TestDataHelper.createProject();
         proj.pse__Is_Active__c  = false;
         //proj.pse__Stage__c = 'Cancelled';
         proj.pse__Opportunity__c = opp.id;
         proj.pse__Region__c = en.id;
         proj.pse__Practice__c = pr.id;
         proj.pse__Start_Date__c = system.today();
         proj.Client__c = opp.Account_ID__c;
         proj.Final_Report__c = false;      
         proj.Interim_Report__c = true;
         proj.Draft_Report__c = true;
         insert proj;
         
         be.pse__Project__c = proj.id;
         insert be;
         proj.pse__Is_Active__c = true;
         proj.Final_Report__c = true;
         DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();
         sip.Billing_Event__c  = be.Id;
         insert sip;
        Test.startTest();
         update proj;
        
         List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Subject__c, Account_Name__c, Project_Code__c, Shipping_Street__c, Shipping_City__c,
                                               Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                               Registration_Number__c From DDSalesInvoiceProxy__c
                                               where Billing_Event__c =: be.Id];
         Opportunity oppQ = [select Id, DD_Instruction__r.DD_Status__c from Opportunity where Id =: opp.id];
         system.debug('oppQ :: '+oppQ);
         system.assertEquals(oppQ.DD_Instruction__r.DD_Status__c, 'In Progress') ;
        Test.stopTest();    
        system.debug('DDPSEProjectTriggerHandlerTest :: finalReportProjectTriggerTest :: end');
     }


    /**
        Test the status of related Instruction when Project status is changed to Complete
    */
    static testMethod void completeProjectTriggerTest() {

         system.debug('DDPSEProjectTriggerHandlerTest :: completeProjectTriggerTest :: start');
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         Opportunity opp = TestDataHelper.createOpportunity();
         DD_Instruction__c ins = TestDataHelper.createInstructions();
         ins.DD_Status__c  = 'Closed and Billed ';
         insert ins;
         opp.DD_Instruction__c = ins.id;
         insert opp;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         insert pr;
         pse__Proj__c proj = TestDataHelper.createProject();
         proj.pse__Is_Active__c  = false;
         proj.pse__Stage__c = 'Closed and Billed';
         proj.pse__Opportunity__c = opp.id;
         proj.pse__Region__c = en.id;
         proj.pse__Practice__c = pr.id;
         proj.pse__Start_Date__c = system.today();
         proj.Client__c = opp.Account_ID__c;
         proj.Draft_Report__c = true;
         insert proj;
         
         be.pse__Project__c = proj.id;
         insert be;
         proj.pse__Is_Active__c = true;
         DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();
         sip.Billing_Event__c  = be.Id;
         insert sip;
        Test.startTest();
         update proj;
        
         List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Subject__c, Account_Name__c, Project_Code__c, Shipping_Street__c, Shipping_City__c,
                                               Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                               Registration_Number__c From DDSalesInvoiceProxy__c
                                               where Billing_Event__c =: be.Id];
         Opportunity oppQ = [select Id, DD_Instruction__r.DD_Status__c from Opportunity where Id =: opp.id];
         system.debug('oppQ :: '+oppQ);
         system.assertEquals(oppQ.DD_Instruction__r.DD_Status__c, 'In Progress') ;
        Test.stopTest();    
        system.debug('DDPSEProjectTriggerHandlerTest :: completeProjectTriggerTest :: end');
     }

     /**
     This test case ensures that Projects can be created without an Opportunity
     */
    static testMethod void createProjectWithoutOpportunityTest() {

             system.debug('DDPSEProjectTriggerHandlerTest :: createProjectWithoutOpportunityTest :: start');
             pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
             c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
             pse__Region__c en = TestDataHelper.createEntity();
             en.ffpsai__OwnerCompany__c = com.id;
             insert en;
             pse__Practice__c pr = TestDataHelper.createPractice();
             insert pr;
             pse__Proj__c proj = TestDataHelper.createProject();
             proj.pse__Is_Active__c  = false;
             proj.pse__Stage__c = 'Rejected';
             proj.pse__Region__c = en.id;
             proj.pse__Practice__c = pr.id;
             proj.pse__Start_Date__c = system.today();
             Account acc = TestDataHelper.createAccount();
             insert acc;
             proj.Client__c = acc.Id;   
             proj.Draft_Report__c = true;
             insert proj;
             Test.startTest();
             be.pse__Project__c = proj.id;
             insert be;
             proj.pse__Is_Active__c = true;
             DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();
             sip.Billing_Event__c  = be.Id;
             insert sip;
             update proj;
             List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Subject__c, Account_Name__c, Project_Code__c, Shipping_Street__c, Shipping_City__c,
                                                   Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                                   Registration_Number__c From DDSalesInvoiceProxy__c
                                                   where Billing_Event__c =: be.Id];
             //system.assertEquals(sipQ.get(0).Subject__c, proj.ffps_0387__Subject_s__c) ;
             system.assertEquals(proj.pse__Stage__c, 'Rejected') ;
        Test.stopTest();        
        system.debug('DDPSEProjectTriggerHandlerTest :: createProjectWithoutOpportunityTest :: end');
    }

     /**
         Bulk Testing
     */
     // Removed because of too many SOQL queries with in the package on SI Environment - ffps_sunrag
     /*static testMethod void bulkProjectTriggerTest() {

         system.debug('DDPSEProjectTriggerHandlerTest :: bulkProjectTriggerTest :: start');
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         Opportunity opp = TestDataHelper.createOpportunity();
         DD_Instruction__c ins = TestDataHelper.createInstructions();
         ins.DD_Status__c  = 'Closed and Billed ';
         insert ins;
         opp.DD_Instruction__c = ins.id;
         insert opp;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         insert pr;
         List<pse__Proj__c> projList = TestDataHelper.bulkCreateProject(50);
         for(pse__Proj__c projVal : projList){
             projVal.pse__Is_Active__c  = false;
             projVal.pse__Stage__c = 'Closed and Billed';
             projVal.pse__Opportunity__c = opp.id;
             projVal.pse__Region__c = en.id;
             projVal.pse__Practice__c = pr.id;
             projVal.pse__Start_Date__c = system.today();
             projVal.Client__c = opp.Account_ID__c;
          }
         insert projList;
         for(pse__Proj__c projVal : projList){
             projVal.pse__Is_Active__c = true;
         }
         update projList;
         List<pse__Proj__c> projQList = [Select Id From pse__Proj__c where Id in: projList];
         system.assertEquals(projQList.size(), 50) ;
         system.debug('DDPSEProjectTriggerHandlerTest :: bulkProjectTriggerTest :: end');
     }*/

}