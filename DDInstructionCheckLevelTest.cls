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

public class DDInstructionCheckLevelTest {

    /**
        Test if Instruction record is updated correctly with the chosen check level
    */
    static testMethod void InstructionCheckLevelSaveTest() {
        
        system.debug('DDInstructionCheckLevelTest :: InstructionCheckLevelSaveTest :: start');
        User u1;
        User u2;
        User u3;
        Instruction_Check_Level_Type__c clType1;
        Instruction_Check_Level_Type__c clType2;
        Instruction_Check_Level_Type__c clType3;
        DD_Instruction__c ins; 
        DDInstructionCheckLevel insType;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRoleWithVerificationPermSet();                        
        }
        system.runas(u1){
            u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            clType1 = TestDataHelper.createInstructionCheckLevel();
            clType1.Name = 'insChkLevel1'; 
            clType1.Account__c = u3.contact.AccountId;
            insert clType1;
            clType2 = TestDataHelper.createInstructionCheckLevel();
            clType2.Account__c = u3.contact.AccountId;
            clType2.Name = 'insChkLevel2';    
            insert clType2;
            clType3 = TestDataHelper.createInstructionCheckLevel();
            clType3.Account__c = u3.contact.AccountId;
            clType3.Name = 'insChkLevel2';    
            insert clType3;
       }
       system.runas(u2){
            ins = TestDataHelper.createInstructions();
            ins.DD_Check_Level__c = 'insChkLevel1';
           	ins.DD_Client_Commissioner__c = u3.contactId;
            insert ins;
            ApexPages.currentPage().getParameters().put('id', ins.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(ins);
            insType = new DDInstructionCheckLevel(sc);
            insType.testAcctId = u3.contact.AccountId;
            insType.obj = ins;
            SelectOption[] selOpt = insType.getInstructionCheckLevelList();
            system.assertEquals(4, selOpt.size());
            //system.assertEquals(cmType1.Id, selOpt.get(0).value.subString(0,15));
            Pagereference pg = insType.save();
            DD_Instruction__c ins1 = [select Id, DD_Check_Level__c from DD_Instruction__c where Id =: ins.Id];
            system.assertEquals(ins1.DD_Check_Level__c, 'insChkLevel1');
        }
        system.debug('DDInstructionCheckLevelTest :: InstructionCheckLevelSaveTest :: end');
    }
 }