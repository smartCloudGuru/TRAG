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

public class DD_InviteSentControllerTest {
    
    /**
        Test if invitation is send or not
    */
    static testMethod void sendInviteTest() {
    
        system.debug('DD_InviteSentControllerTest :: sendInviteTest :: start');
        DD_InviteSentController ddsi; 
        CounterParty_Invite__c cpi;
        Pagereference pr;
        Pagereference pr2;
        Id queueId;     
        User u2; 
        User u5;
        User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u2 = TestDataHelper.createSalesforceUserForClientAccountTeam('test@test.com.testt', 'tAlias', 'test@test.com');
            u5 = TestDataHelper.createPortalUser();
        }
        system.runas(u2){ 
            User u6 = [select Id, UserRoleId, contactId, contact.name, contact.AccountId, contact.Account.DD_Task_Order_Required__c from User where id =: u5.Id];
            cpi = TestDataHelper.createCounterPartyInvite();
            insert cpi;
            Apexpages.currentPage().getParameters().put('counterPartyInviteId', cpi.Id);
            ddsi = new DD_InviteSentController();
            Pagereference pr1 = ddsi.sendEmail();
            system.assertEquals(pr1.getUrl(), '/client/'+cpi.Id);
            CounterParty_Invite__c cpiQ = [select Id, DD_Send_Invite__c, DD_First_Name__c, DD_Last_Name__c, DD_Email__c, DD_Account__c from CounterParty_Invite__c where Id =: cpi.Id];
            system.assert(cpiQ.DD_Send_Invite__c);
        }
        system.debug('DD_InviteSentControllerTest :: sendInviteTest :: end');
    }    
}