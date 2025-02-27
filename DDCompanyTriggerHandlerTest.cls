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
 
@isTest
public class DDCompanyTriggerHandlerTest {

    /**
       Test if the ProxySalesInvoice is updated on changing relevant fields on Company object
    */
    static testMethod void companyTriggerTest() {
         c2g__codaCompany__c com = TestDataHelper.createCompany();
         insert com;
         com.c2g__ContactEmail__c = 'testupdate@test.com';
         DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy(); 
         sip.Company__c   = com.Id;
         insert sip;   
         update com;
         List<DDSalesInvoiceProxy__c> sipQ = [Select Id, Company_Contact_Email__c, Name, Account_Name__c, Project_Code__c, Shipping_Street__c, Shipping_City__c, 
                                               Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                               Registration_Number__c From DDSalesInvoiceProxy__c 
                                               where Company__c =: com.Id];
         system.assertEquals(sipQ.get(0).Company_Contact_Email__c, 'testupdate@test.com') ;
    }
    
    /**
        Bulk Testing
    */ 
    static testMethod void bulkCompanyTriggerTest() {
         List<c2g__codaCompany__c> comList = TestDataHelper.bulkCreateCompany(50);
         insert comList;
         for(c2g__codaCompany__c comVal : comList){
             comVal.c2g__ContactEmail__c = 'testupdate@test.com';
         }
         test.startTest();
        update comList;
        
         List<c2g__codaCompany__c> comQList = [Select Id From c2g__codaCompany__c 
                                             where Id in: comList];
         system.assertEquals(comQList.size(), 50) ;
        test.stopTest();
    }

}