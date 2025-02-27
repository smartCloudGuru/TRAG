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

private class DDPIAActionsTest {

    /**
        Test if submitted Instruction (with task order) is assigned to the correct queue and if accepted test if
        an opportunity is created
    */
    static testMethod void submitInstructionWithTaskOrderTest() {
         
         system.debug('DDPIAActionsTest :: submitInstructionWithTaskOrderTest :: start');
         DDPIAActions ddpi;
         DD_Instruction__c ins;   
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
            User u6 = [select Id, UserRoleId, contactId, contact.AccountId from User where id =: u5.Id];
            system.debug('u6 :: '+u6);
            Account billAccount = TestDataHelper.createAccount();
            insert billAccount;
            ins = TestDataHelper.createInstructions();
            ins.DD_Client_Commissioner__c = u6.contactId;
            ins.Billing_Account__c  = billAccount.Id;
            insert ins;
            Apexpages.standardController cont = new Apexpages.standardController(ins);
            ddpi = new DDPIAActions(cont);
            Pagereference pr1 = ddpi.returnToRecord();
            ddpi.TestInstr = ins;
            pr = ddpi.submitToRag();
            system.assertEquals(pr.getURL(), '/'+String.valueOf(ins.Id).subString(0, String.valueOf(ins.Id).length()-3));
            pr2 = ddpi.accept();
            //Temp Fix 
            /*Opportunity opp = [select Id, DD_Instruction__c, StageName from Opportunity where DD_Instruction__c  =: ins.Id];
            system.assertEquals(opp.DD_Instruction__c, ins.Id);
            system.assertEquals(opp.StageName, 'Proposal Preparation');
            ddpi.cancelInstruction();
            DD_Instruction__c insQ = [select Id, DD_Status__c from DD_Instruction__c where Id =: ins.Id];
            system.assertEquals(insQ.DD_Status__c, 'Cancelled');*/ 
        }
        system.debug('DDPIAActionsTest :: submitInstructionWithTaskOrderTest :: end');
    }
    
    /**
        Test if submitted Instruction (without task order) is assigned to the correct queue and if accepted test if
        an opportunity is created
    */
    /*static testMethod void submitInstructionWithoutTaskOrderTest() {
         
         system.debug('DDPIAActionsTest :: submitInstructionWithoutTaskOrderTest :: start ');
         DDPIAActions ddpi;
         DD_Instruction__c ins;   
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
            User u6 = [select Id, UserRoleId, contactId, contact.AccountId from User where id =: u5.Id];
            ins = TestDataHelper.createInstructions();
            ins.DD_Client_Commissioner__c = u6.contactId;
            ins.DD_Task_Order_Required__c = false;
            insert ins;
            Apexpages.standardController cont = new Apexpages.standardController(ins);
            ddpi = new DDPIAActions(cont);        
            Pagereference pr1 = ddpi.returnToRecord();
            ddpi.TestInstr = ins;
            pr = ddpi.submitToRag();
            system.debug('pr :: '+pr );   
            system.assertEquals(pr.getURL(), '/'+String.valueOf(ins.Id).subString(0, String.valueOf(ins.Id).length()-3));
            pr2 = ddpi.accept();
            Opportunity opp = [select Id, DD_Instruction__c, StageName from Opportunity where DD_Instruction__c  =: ins.Id];
            system.assertEquals(opp.DD_Instruction__c, ins.Id);
            system.assertEquals(opp.StageName, 'Proposal Sent / Price Quoted'); 
        }
        system.debug('DDPIAActionsTest :: submitInstructionWithoutTaskOrderTest :: end ');
     }*/
}