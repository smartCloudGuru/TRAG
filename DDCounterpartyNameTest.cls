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

public class DDCounterpartyNameTest {
    
    /**
        Test if Invitation record is updated correctly with the chosen Counterparty Name
    */
    static testMethod void counterPartyNameSaveTest() {
        
        system.debug('DDCounterpartyNameTest ::  counterPartyNameSaveTest :: start');
        User u1;
        User u2;
        User u3;
        DD_Counterparty_Type__c cpType1;
        DD_Counterparty_Type__c cpType2;
        DD_Counterparty_Type__c cpType3;
        Case cs; 
        DDCounterpartyName cpType;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRoleWithVerificationPermSet();                  
        }
        system.runas(u1){
            u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            cpType1 = TestDataHelper.createCounterPartyType();
            cpType1.Name = 'CPTest1'; 
            cpType1.Account__c = u3.contact.AccountId;
            cpType1.Questionnaire_URL__c = 'testQuestionnaireURL1';
            insert cpType1;
            cpType2 = TestDataHelper.createCounterPartyType();
            cpType2.Account__c = u3.contact.AccountId;
            cpType2.Name = 'CPTest2';    
            cpType2.Questionnaire_URL__c = 'testQuestionnaireURL2';
            insert cpType2;
            cpType3 = TestDataHelper.createCounterPartyType();
            cpType3.Account__c = u3.contact.AccountId;
            cpType3.Name = 'CPTest3';    
            cpType3.Questionnaire_URL__c = 'testQuestionnaireURL3';
            insert cpType3;
       }
       system.runas(u2){
            Account acc = TestDataHelper.createAccount();
            acc.parentId = u3.contact.AccountId; 
            insert acc;
           	cs = TestDataHelper.createCase();
            cs.accountId = acc.Id;
            cs.DD_Counterparty_Type__c = 'CPTest1';
            insert cs;
            ApexPages.currentPage().getParameters().put('id', cs.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(cs);
            cpType = new DDCounterpartyName(sc);
            //cpType.testAcctId = u3.contact.AccountId;
            cpType.obj = cs;
            SelectOption[] selOpt = cpType.getCounterpartyList();
            system.assertEquals(4, selOpt.size());
            //system.assertEquals(cmType1.Id, selOpt.get(0).value.subString(0,15));
            Pagereference pg = cpType.save();
            Case cs1 = [select Id, DD_Questionnaire_URL__c from Case where Id =: cs.Id];
            system.assertEquals(cs1.DD_Questionnaire_URL__c , 'http://www.clicktools.com/survey?iv=2iwy6qq4kgmjx');
        }
        system.debug('DDCounterpartyNameTest ::  counterPartyNameSaveTest :: end');
    }
 }