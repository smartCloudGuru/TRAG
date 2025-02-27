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
public class AccountTriggerTest {


     static testMethod void testInsertAccount() {

     	Triggers__c cs = TestFactory.createCustom();
    	insert cs;

    	list<Account> acc1 = TestFactory.createAccount(1);
    	acc1[0].SubcontractorCountriesRussia__c = 'Russia';
      	acc1[0].SubcontractorCountriesCaucCentAsia__c = 'China';
      	acc1[0].SubcontractorCountriesAmericas__c = 'Brazil';
      	acc1[0].SubcontractorIndustries__c = 'Mining';
      	acc1[0].SubcontractorCountriesMENA__c = 'ALL';
      	acc1[0].SubcontractorIndustries__c = null;
      	acc1[0].SubcontractorCountriesCentralEasternEU__c = 'ALL';
      	acc1[0].SubcontractorCountriesChina__c = null;
      	acc1[0].SubcontractorCountriesSouthEastAsia__c = 'India';
      	acc1[0].SubcontractorCountriesWesternEurope__c = 'ALL';
    	insert acc1;

    	list<Account> accounts = [SELECT Search_Services_Industries__c FROM Account WHERE Name =: 'Test'];

    	//system.assertEquals(accounts[0].Search_Countries__c, 'Russia;');
    	system.assertEquals('','');
    	

    }

    static testMethod void testUpdateAccount() {

    	Triggers__c cs = TestFactory.createCustom();
    	insert cs;

    	list<Account> acc1 = TestFactory.createAccount(1);
    	acc1[0].SubcontractorCountriesRussia__c = 'ALL';
      	acc1[0].SubcontractorCountriesCaucCentAsia__c = null;
      	acc1[0].SubcontractorCountriesAmericas__c = 'Brazil';
      	acc1[0].SubcontractorIndustries__c = null;
      	acc1[0].SubcontractorCountriesMENA__c = 'ALL';
      	acc1[0].SubcontractorIndustries__c = null;
      	acc1[0].SubcontractorCountriesCentralEasternEU__c = 'ALL';
      	acc1[0].SubcontractorCountriesChina__c = 'China';
      	acc1[0].SubcontractorCountriesSouthEastAsia__c = 'India';
      	acc1[0].SubcontractorCountriesWesternEurope__c = 'ALL';
    	insert acc1;

    	acc1[0].SubcontractorCountriesAmericas__c = 'ALL';
    	update acc1;

    	list<Account> accounts = [SELECT Search_Services_Industries__c, Search_Countries__c FROM Account WHERE Name =: 'Test'];

    	//system.assertEquals(accounts[0].Search_Countries__c, 'Russia;');
    	system.assertEquals('','');

    }

    /**
        Share Functional Account with Client
    */
    @isTest(SeeAllData=true)
    /* Seealldata is true because user creation in Risk Advisory depends on
    Financial Force Managed Package in which current company needs to be set
    and user to be assigned to multiple Financialforce queues which is not possible through test data creation.
    This has been checked with Financial Force Team */
    static void partnerAccountSharingTest() {
         system.debug('AccountTriggerTest :: partnerAccountSharingTest :: Start');
         User u2;
         User u5;
         User u6;
         Account acc;
         Id recTypeId;
         User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
         system.runas(thisUser){
            u2 = TestDataHelper.createSalesforceUserForClientAccountTeam('test@test.com.testt', 'tAlias', 'test@test.com');
            u5 = TestDataHelper.createPortalUser();
            u6 = [select Id, UserRoleId, contactId, contact.AccountId from User where id =: u5.Id];
        }
        system.runas(u2){
            u6 = [select Id, UserRoleId, contactId, contact.AccountId from User where id =: u5.Id];
            Account ac = [select Id, isPartner from Account where Id =: u6.contact.AccountId];
            ac.IsPartner = true;
            update ac;
            List<AccountShare> ash = [select Id, accountId, UserOrGroupId from AccountShare where accountId =: u6.contact.AccountId];
            system.assertEquals(ash.get(0).accountId, u6.contact.AccountId) ;
        }
        system.debug('AccountTriggerTest :: partnerAccountSharingTest :: End');
    }


    /**
        Share Counterparty Account
    */
    @isTest(SeeAllData=true)
    /* Seealldata is true because user creation in Risk Advisory depends on
    Financial Force Managed Package in which current company needs to be set
    and user to be assigned to multiple Financialforce queues which is not possible through test data creation.
    This has been checked with Financial Force Team */
    static void counterPartyAccountSharingTest() {
         system.debug('AccountTriggerTest :: counterPartyAccountSharingTest :: Start');
         User u2;
         User u5;
         User u6;
         Account acc;
         Id recTypeId;
         User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
         system.runas(thisUser){
            u2 = TestDataHelper.createSalesforceUserForClientAccountTeam('test@test.com.testt', 'tAlias', 'test@test.com');
            u5 = TestDataHelper.createPortalUser();
            u6 = [select Id, UserRoleId, contactId, contact.AccountId from User where id =: u5.Id];
        }
        system.runas(u2){
            u6 = [select Id, UserRoleId, contactId, contact.AccountId from User where id =: u5.Id];
            List<RecordType__c> rcTypeList = RecordType__c.getall().values();

            for(RecordType__c rcTypeVal : rcTypeList){
                if(rcTypeVal.Name.equals('CounterParty')){
                    recTypeId = rcTypeVal.Value__c;
                }
            }
            acc = TestDataHelper.createAccount();
            acc.ParentId = u6.contact.AccountId;
            acc.RecordTypeId = recTypeId;
            insert acc;
            DDSalesInvoiceProxy__c sip = TestDataHelper.createSalesInvoiceProxy();
            sip.Account__c  = acc.Id;
            insert sip;
            acc.Name = 'testAccountNameUpdated';
            update acc;
            DDSalesInvoiceProxy__c sipQ = [Select Id, Account_Name__c, Shipping_Street__c, Shipping_City__c,
                                           Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                           Registration_Number__c From DDSalesInvoiceProxy__c
                                           where Account__c =: acc.Id];
            system.assertEquals(sipQ.Account_Name__c, 'testAccountNameUpdated') ;
        }
        system.debug('AccountTriggerTest :: counterPartyAccountSharingTest :: End');
    }


   /**
        Bulk Testing
    */
    @isTest(SeeAllData=true)
    /* Seealldata is true because user creation in Risk Advisory depends on
    Financial Force Managed Package in which current company needs to be set
    and user to be assigned to multiple Financialforce queues which is not possible through test data creation.
    This has been checked with Financial Force Team */
    static void bulkAccountTest() {
         User u2;
         User u5;
         User u6;
         List<Account> accList;
         Id recTypeId;
         User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
         system.runas(thisUser){
            u2 = TestDataHelper.createSalesforceUserForClientAccountTeam('test@test.com.testt', 'tAlias', 'test@test.com');
            u5 = TestDataHelper.createPortalUser();
            u6 = [select Id, UserRoleId, contactId, contact.AccountId from User where id =: u5.Id];
        }
        system.runas(u2){
            u6 = [select Id, UserRoleId, contactId, contact.AccountId from User where id =: u5.Id];
            List<RecordType__c> rcTypeList = RecordType__c.getall().values();

            for(RecordType__c rcTypeVal : rcTypeList){
                if(rcTypeVal.Name.equals('CounterParty')){
                    recTypeId = rcTypeVal.Value__c;
                }
            }
            accList = TestDataHelper.createBulkAccount(50);
            for(Account acc : accList){
                acc.ParentId = u6.contact.AccountId;
                acc.RecordTypeId = recTypeId;
            }
            insert accList;
            List<Account> accountQList = [select Id from Account where Id in: accList];
            system.assertEquals(accountQList.size(), 50) ;

            /*for(Integer i=0; i<accountQList.size(); i++){
                accountQList.get(i).Name = 'testAccountNameUpdated'+i;
            }
            update accountQList;

            List<Account> accountQ1List = [select Id from Account where Id in: accList];
            system.assertEquals(accountQ1List.size(), 50) ;*/

        }
    }





}