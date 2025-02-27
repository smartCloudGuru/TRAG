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

public class BankDetailTriggerHandlerTest {
            
    /**
       Test if the ProxySalesInvoice is updated on changing relevant fields on Bank Account 
    */
    static testMethod void BankDetailTriggerHandlerTest() {
        
        system.debug('BankDetailTriggerHandlerTest :: BankDetailTriggerHandlerTest :: start');
        c2g__codaBankAccount__c bankAccount = TestDataHelper.createBankDetail();
        insert bankAccount;
        DDSalesInvoiceProxy__c salesProxy = TestDataHelper.createSalesInvoiceProxy();
        salesProxy.Bank_Account__c = bankAccount.Id;
        insert salesProxy;
        bankAccount.c2g__AccountName__c  = 'TestUpdatedAccountName';
        update bankAccount;
        List<DDSalesInvoiceProxy__c> sproxyQueriedList = [select Id, Bank_Account_Name__c from DDSalesInvoiceProxy__c where Id =: salesProxy.Id];
        system.assertEquals(sproxyQueriedList.get(0).Bank_Account_Name__c, bankAccount.c2g__AccountName__c);
        system.debug('BankDetailTriggerHandlerTest :: BankDetailTriggerHandlerTest :: End');
    }
    
    
    /**
        Bulk Testing
    */
    static testMethod void bulkBankDetailTriggerHandlerTest() {
        
        system.debug('BankDetailTriggerHandlerTest :: bulkBankDetailTriggerHandlerTest :: start');
        List<c2g__codaBankAccount__c> bankAccountList = TestDataHelper.bulkCreateBankDetail(50);
        insert bankAccountList;
        for(Integer i=0; i<bankAccountList.size(); i++){
            bankAccountList.get(i).c2g__AccountName__c  = 'TestUpdatedAccountName'+i;
        }
        test.startTest();
        update bankAccountList;
        
        List<c2g__codaBankAccount__c> bankDetailQueriedList = [select Id from c2g__codaBankAccount__c where Id in: bankAccountList];
        system.assertEquals(bankAccountList.size(), 50);
        test.stopTest();
        system.debug('BankDetailTriggerHandlerTest :: bulkBankDetailTriggerHandlerTest :: End');
    }
}