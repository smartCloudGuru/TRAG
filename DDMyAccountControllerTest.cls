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

public class DDMyAccountControllerTest {

    /**
        Test my account tab specific data (Outstanding balance, Instructions, Invoices)
    */
    static testMethod void getMyApprovalListTest() {
        
        system.debug('DDMyAccountControllerTest :: getMyApprovalListTest :: start');
        User u2;
        User u1;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRole();
        }
        system.runas(u1){            
            User u3 = [select Id, UserRoleId, contactId, contact.AccountId, contact.Account.LUMA_Account__c from User where id =: u2.Id];
            DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();            
            Account acc = TestDataHelper.createAccount();
            acc.LUMA_Account__c = u3.contact.AccountId;
            insert acc;
            sip.Account__c = acc.Id;//u3.contact.AccountId;            
            insert sip;
            DDMyAccountController cont = new DDMyAccountController(u3.Id);
            cont.getPaymentStatusOptions();
            cont.setPaymentStatus(new String[]{'Paid', 'Unpaid'});
            cont.getInvoiceFields();
            cont.getPaymentStatus();
            cont.getBalance();
            List<DDSalesInvoiceProxy__c> sipList = cont.getInvoices(acc.LUMA_Account__c);//cont.getInvoices(sip.Account__c);
            DDSalesInvoiceProxy__c sipQ = [select Id, Outstanding_Value__c from DDSalesInvoiceProxy__c where Id =: sip.Id];            
            system.assertEquals(sipList.get(0).Outstanding_Value__c , sipQ.Outstanding_Value__c);
        }
        system.debug('DDMyAccountControllerTest :: getMyApprovalListTest :: end');
    }
}