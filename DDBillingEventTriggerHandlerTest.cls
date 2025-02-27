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

public class DDBillingEventTriggerHandlerTest {

    /**
       Test if the ProxySalesInvoice is updated on changing relevant fields on Billing Event 
    */
    static testMethod void billingEventTriggerTest() {
    
         system.debug('DDBillingEventTriggerHandlerTest :: billingEventTriggerTest :: start');
         Opportunity opp = TestDataHelper.createOpportunity();
         insert opp;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         Test.startTest();
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
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         be.pse__Project__c = proj.Id;
         be.pse__Date__c = system.today();
         insert be;
         DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();
         sip.Billing_Event__c  = be.Id;
         insert sip;          
         proj.pse__Is_Active__c  = true;
         update proj;
         be.pse__Project__c = proj.Id; 
         be.pse__Date__c = system.today().addDays(1);
         update be;
         Test.stopTest();
         List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Account_Name__c, Project_Code__c, Shipping_Street__c, Shipping_City__c, 
                                               Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                               Registration_Number__c From DDSalesInvoiceProxy__c 
                                               where Billing_Event__c =: be.Id];
         system.assert(sipQ.size()>0) ;
         system.debug('DDBillingEventTriggerHandlerTest :: billingEventTriggerTest :: end');
    }
     
    /**
        Bulk Testing
    */
    /*static testMethod void bulkBillingEventTriggerTest() {
         
         system.debug('DDBillingEventTriggerHandlerTest :: bulkBillingEventTriggerTest :: start');
         Opportunity opp = TestDataHelper.createOpportunity();
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
         List<pse__Billing_Event__c> beList = TestDataHelper.bulkCreateBillingEvent(50);
         for(pse__Billing_Event__c beVal : beList){
             beVal.pse__Project__c = proj.Id;
             beVal.pse__Date__c = system.today();
         }
         insert beList;
         for(pse__Billing_Event__c beVal : beList){
             beVal.pse__Date__c = system.today().addDays(1);
         }
         update beList;
        test.startTest();
         List<pse__Billing_Event__c> beQList = [Select Id from pse__Billing_Event__c where Id in: beList];         
         system.assert(beQList.size()==50) ;
        test.stopTest();
         system.debug('DDBillingEventTriggerHandlerTest :: bulkBillingEventTriggerTest :: end');
    }*/
}