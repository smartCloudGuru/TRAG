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

public class DDSalesInvoiceCreateProxyTriggerTest {

    /**
       Test if the ProxySalesInvoice is created on insert or update of Sales Invoice 
    */
    static testMethod void salesInvoiceCreateProxyTriggerTest() {
         
         system.debug('DDSalesInvoiceCreateProxyTriggerTest :: salesInvoiceCreateProxyTriggerTest :: start');
         Account acc = TestDataHelper.createAccount();
         acc.c2g__CODAAccountTradingCurrency__c = 'GBP';
         acc.c2g__CODAVATStatus__c = 'Home';
         insert acc;
         c2g__codaInvoice__c  si = TestDataHelper.createSalesInvoice();
        Id periodId = TestDataHelper.getSalesInvoicePeriod(); 
        List<c2g__codaAccountingCurrency__c> getAccountingCurrency = TestDataHelper.getAccountingCurrency();
        si.c2g__InvoiceCurrency__c = getAccountingCurrency.get(0).Id;
        si.c2g__Account__c = acc.Id;
        si.c2g__Period__c = periodId;
        
         insert si;
         si.c2g__InvoiceDescription__c = 'test Update Description';
         update si;

         /**
         - Commented out by KC Thiruchelvam @ Tquila in response to the Recurring Invoices error caused by the salesInvoiceCreateProxy.trigger
         - this is a TEMPORARY measure
         - Date : 11/03/2015
         **/
         /** Uncommented the code **/
         List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Invoice_Description__c From DDSalesInvoiceProxy__c 
                                               where Sales_Invoice__c  =: si.Id];
         system.assertEquals(sipQ.size(), 1) ;
         system.assertEquals(sipQ.get(0).Invoice_Description__c, 'test Update Description') ;
         si.c2g__InvoiceDescription__c = 'test Update Description2';
         update si;
         List<DDSalesInvoiceProxy__c> sipQ1 = [Select Id, Invoice_Description__c From DDSalesInvoiceProxy__c 
                                               where Sales_Invoice__c  =: si.Id];
         system.assertEquals(sipQ1.get(0).Invoice_Description__c, 'test Update Description2') ;
         system.debug('DDSalesInvoiceCreateProxyTriggerTest :: salesInvoiceCreateProxyTriggerTest :: end');
         
    } 
    
    /**
        Bulk Testing
    */
    /*static testMethod void bulkSalesInvoiceCreateProxyTriggerTest() {
    
         system.debug('DDSalesInvoiceCreateProxyTriggerTest :: salesInvoiceCreateProxyTriggerTest :: start');
         Account acc = TestDataHelper.createAccount();
         acc.c2g__CODAAccountTradingCurrency__c = 'GBP';
         acc.c2g__CODAVATStatus__c = 'Home';
        test.startTest(); 
        insert acc;
         List<c2g__codaInvoice__c>  siList = TestDataHelper.bulkCreateSalesInvoice(50);
         
        Id periodId = TestDataHelper.getSalesInvoicePeriod();
        List<c2g__codaAccountingCurrency__c> getAccountingCurrency = TestDataHelper.getAccountingCurrency();
        
        for(c2g__codaInvoice__c sival : siList){ 
             sival.c2g__Account__c = acc.Id;     
             sival.c2g__Period__c = periodId;
            sival.c2g__InvoiceCurrency__c = getAccountingCurrency.get(0).Id; 
         }
         insert siList;
         for(c2g__codaInvoice__c sival : siList){
             sival.c2g__InvoiceDescription__c = 'test Update Description';
         }     
        
         update siList;
         List<c2g__codaInvoice__c> siQList = [Select Id From c2g__codaInvoice__c 
                                               where Id in: siList];*/
         /**
         - Commented out by KC Thiruchelvam @ Tquila in response to the Recurring Invoices error caused by the salesInvoiceCreateProxy.trigger
         - this is a TEMPORARY measure
         - Date : 11/03/2015 
         **/
          /** Uncommented the code **/                                     
         /*system.assertEquals(siQList.size(), 50) ;
         test.stopTest();
         system.debug('DDSalesInvoiceCreateProxyTriggerTest :: salesInvoiceCreateProxyTriggerTest :: end');
    }*/
}