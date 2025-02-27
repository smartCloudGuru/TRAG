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
public class DDClientHomePageControllerTest {

    /* Seealldata is true because user creation in Risk Advisory depends on 
    Financial Force Managed Package in which current company needs to be set 
    and user to be assigned to multiple Financialforce queues which is not possible through test data creation. 
    This has been checked with Financial Force Team */
    /**
        Test if submitted approval are assigned to correct queue
    */
    @isTest(SeeAllData=true)    
    static void getPendingApprovalsTest() {
        
        system.debug('DDClientHomePageControllerTest :: getPendingApprovalsTest :: start');
        boolean pendApproval = false;
        Task_Order__c to;
        User u2;
        User u1;
        List<GroupMember> gmList;
        Id groupId;
        List<DDClientHomePageController.PendingAppRecs> par;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRole();            
        }
        system.runas(thisUser){
            to = TestDataHelper.createTaskOrder();
            Opportunity opp = TestDataHelper.createOpportunity();
            User u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            opp.AccountId = u3.Contact.AccountId;
            insert opp;
            DD_Instruction__c ins = [select Id, DD_Client_Commissioner__c from DD_Instruction__c where Id =: opp.DD_Instruction__c];
            ins.DD_Client_Commissioner__c = u3.ContactId;
            update ins;
            to.DD_Opportunity__c = opp.Id;
            insert to;
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(to.id);
            Approval.ProcessResult result = Approval.process(req1);
            gmList = [select GroupId , UserOrGroupId, Group.Type from GroupMember where UserOrGroupId =: u2.Id];
            for(GroupMember gmVal : gmList){
                if(gmVal.Group.Type.equals('Queue')){
                    groupId = gmVal.GroupId;
                    break;
                }
            }            
        }
        test.starttest();
        system.runas(u2){
            DDClientHomePageController ddad = new DDClientHomePageController();            
            par = ddad.getProsInsts();
            if(!par.isEmpty()){
                pendApproval = true;
                system.assertEquals(par.get(0).proInstce.OriginalActorId, groupId);
                
            }                        
        }
        if(!pendApproval){
            system.runas(thisUser){
                DDClientHomePageController ddad = new DDClientHomePageController();            
                par = ddad.getProsInsts();
                if(!par.isEmpty()){
                    pendApproval = true;                    
                }                        
            }
        }
        system.assertEquals(par.size(), 1);        
        test.stoptest();
        system.debug('DDClientHomePageControllerTest :: getPendingApprovalsTest :: end');
    }
    
    /* Seealldata is true because user creation in Risk Advisory depends on 
    Financial Force Managed Package in which current company needs to be set 
    and user to be assigned to multiple Financialforce queues which is not possible through test data creation. 
    This has been checked with Financial Force Team */
    /**
        Tests if styling related to home page is loaded correctly
    */    
    @isTest(SeeAllData=true)
    static void initializeBrandingParametersTest() {
        
        system.debug('DDClientHomePageControllerTest :: initializeBrandingParametersTest :: start');
        User u1;
        Id accId;
        Id conId;
        
        List<DDClientHomePageComponents__c> clientHomePageParamentersList = DDClientHomePageComponents__c.getall().values();
        List<DDQuickActionPageComponents__c> clientQuickActionParamentersList = DDQuickActionPageComponents__c.getall().values();
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            u1 = TestDataHelper.createPortalUserManagerRole();
            User u4 = [select Id, UserRoleId, contactId, contact.AccountId from User where id =: u1.Id];
            accId = u4.contact.AccountId;
            conId = u4.contactId;
            List<AccountShare> accS = [Select a.UserOrGroupId, a.OpportunityAccessLevel, a.Id, a.AccountId, a.AccountAccessLevel From AccountShare a where AccountId =: accId];
            List<ContactShare> conS = [Select a.UserOrGroupId, a.Id, a.ContactId From ContactShare a where ContactId =: u4.contactId];            
        }
        system.runas(u1){
            List<AccountShare> accSAsPartner = [Select a.UserOrGroupId, a.OpportunityAccessLevel, a.Id, a.AccountId, a.AccountAccessLevel From AccountShare a where AccountId =: accId];
            List<ContactShare> conSAsPartner = [Select a.UserOrGroupId, a.Id, a.ContactId From ContactShare a where ContactId =: conId];
            DDClientHomePageController ddad = new DDClientHomePageController();
            clientHomePageParamentersList.get(0).PartnerAccountId__c = String.valueOf(accId).subString(0,15);
            update clientHomePageParamentersList.get(0);
            clientQuickActionParamentersList.get(0).DDPartnerAccountId__c  = String.valueOf(accId).subString(0,15);
            update clientQuickActionParamentersList.get(0);
            ddad.initializeBrandingParameters();
            system.assertEquals(ddad.topLeftImage, clientHomePageParamentersList.get(0).TopLeftImage__c);
        }        
        system.debug('DDClientHomePageControllerTest :: initializeBrandingParametersTest :: end');
    }
    
    /**
        Test if the inserted Instruction is available as the home page component
    */
    static testMethod void getPendingInstructionsTest() {
        
        system.debug('DDClientHomePageControllerTest :: getPendingInstructionsTest :: start');        
        DDClientHomePageController ddad = new DDClientHomePageController();
        DD_Instruction__c  ins = TestDataHelper.createInstructions();
        insert ins;
        List<DD_Instruction__c> insList = ddad.getInstructions();
        system.assertEquals(insList.size(), 1);
        system.assertEquals(insList.get(0).Id, ins.Id);
        system.debug('DDClientHomePageControllerTest :: getPendingInstructionsTest :: end');        
    }
    
    /**
        Test if the inserted Assessment is available as the home page component
    */
    /*static testMethod void getPendingCasesTest() {        
            
            system.debug('DDClientHomePageControllerTest :: getPendingCasesTest :: start');        
            DDClientHomePageController ddad = new DDClientHomePageController();
            Case  cs = TestDataHelper.createCase();
            cs.status = 'In Progress';
            insert cs;
            List<Case> csList = ddad.getAssessments();
            system.assertEquals(csList.size(), 1);
            system.assertEquals(csList.get(0).Id, cs.Id);
            system.debug('DDClientHomePageControllerTest :: getPendingCasesTest :: end');        
    }*/
}