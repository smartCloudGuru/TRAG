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





public class DDPSEProjectTriggerHandlerTestTwo {


        /*
     Project count and Group couont testmethod
     */
 /**
        Test the Project count and group project count when a Project is created/updated
    */
    static testMethod void ProjectAndGroupCount() {

         system.debug('DDPSEProjectTriggerHandlerTest :: completeProjectTriggerTest :: start');
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         Opportunity opp = TestDataHelper.createOpportunity();

         DD_Instruction__c ins = TestDataHelper.createInstructions();
         ins.DD_Status__c  = 'Closed and Billed ';
         insert ins;
         opp.DD_Instruction__c = ins.id;
         insert opp;

         Account acch = TestDataHelper.createAccount();
         insert acch;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         insert pr;
         pse__Proj__c proj = TestDataHelper.createProject();
         proj.pse__Is_Active__c  = false;
         proj.pse__Stage__c = 'Closed and Billed';
         proj.pse__Opportunity__c = opp.id;
         proj.pse__Region__c = en.id;
         proj.pse__Practice__c = pr.id;
         proj.pse__Start_Date__c = system.today();
         proj.pse__Account__c = acch.id;
         proj.Client__c = opp.accountId;
         proj.Draft_Report__c = true;
         system.debug('opp.accountId : ' +  opp.accountId);
         Test.startTest();
         insert proj;
         be.pse__Project__c = proj.id;
         insert be;
         Test.stopTest();
         //create child account
         /*Account acc2 = TestDataHelper.createAccount();
         acc2.ParentId=acch.Id;
         insert acc2;

         system.debug('acc2 : ' +  acc2);
         pse__Proj__c proj1 = TestDataHelper.createProject();
         proj1.pse__Is_Active__c  = false;
         proj1.pse__Stage__c = 'Closed and Billed';
         proj1.pse__Opportunity__c = opp.id;
         proj1.pse__Region__c = en.id;
         proj1.pse__Practice__c = pr.id;
         proj1.pse__Start_Date__c = system.today();
         proj1.Client__c = acc2.Id;
         proj1.pse__Account__c= acc2.Id;

         insert proj1;
        */
         system.debug('proj1 : ' +  proj);
         Account acc =[select ID,Hierarchy_Group_ID__c,Parent_Company__c,Group_project_count__c,New_Project_Count__c from Account where Id=:acch.Id];
         system.assertEquals(acc.New_Project_Count__c,1) ;
         //Account acch2=[select ID,Hierarchy_Group_ID__c,Parent_Company__c,Group_project_count__c,New_Project_Count__c from Account where Id=:acc2.Id];
         //system.assertEquals(acch2.New_Project_Count__c,1) ;

     }

      static testMethod void ProjectAndGroupCount2() {

         system.debug('DDPSEProjectTriggerHandlerTest :: completeProjectTriggerTest :: start');
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         Opportunity opp = TestDataHelper.createOpportunity();

         DD_Instruction__c ins = TestDataHelper.createInstructions();
         ins.DD_Status__c  = 'Closed and Billed ';
         insert ins;
         opp.DD_Instruction__c = ins.id;
         insert opp;

         Account acch = TestDataHelper.createAccount();
         insert acch;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         insert pr;
         pse__Proj__c proj = TestDataHelper.createProject();
         proj.pse__Is_Active__c  = false;
         proj.pse__Stage__c = 'Closed and Billed';
         proj.pse__Opportunity__c = opp.id;
         proj.pse__Region__c = en.id;
         proj.pse__Practice__c = pr.id;
         proj.pse__Start_Date__c = system.today();
         proj.pse__Account__c = acch.id;
         proj.Client__c = opp.accountId;
         proj.Draft_Report__c = true;
         system.debug('opp.accountId : ' +  opp.accountId);
         Test.startTest();
         insert proj;
         be.pse__Project__c = proj.id;
         insert be;
         proj.pse__Stage__c = 'Cancelled';
         update proj;
         Test.stopTest();

         system.debug('proj1 : ' +  proj);
         Account acc =[select ID,Hierarchy_Group_ID__c,Parent_Company__c,Group_project_count__c,New_Project_Count__c from Account where Id=:acch.Id];
         system.assertEquals(acc.New_Project_Count__c,1) ;
     }


        /*
     Project count and Group couont testmethod
     */
 /**
        Test the Project count and group project count when a Project is created/updated
    */
    static testMethod void DeleteProjectAndGroupCount() {

         system.debug('DDPSEProjectTriggerHandlerTest :: completeProjectTriggerTest :: start');
         pse__Billing_Event__c be = TestDataHelper.createBillingEvent();
         Opportunity opp = TestDataHelper.createOpportunity();

         DD_Instruction__c ins = TestDataHelper.createInstructions();
         ins.DD_Status__c  = 'Closed and Billed ';
         insert ins;
         opp.DD_Instruction__c = ins.id;
         insert opp;

         Account acch = TestDataHelper.createAccount();
         insert acch;
         c2g__codaCompany__c com = [select Id from c2g__codaCompany__c where Name = 'Janusian Saudi Ltd Co'];
         pse__Region__c en = TestDataHelper.createEntity();
         en.ffpsai__OwnerCompany__c = com.id;
         insert en;
         pse__Practice__c pr = TestDataHelper.createPractice();
         insert pr;
         pse__Proj__c proj = TestDataHelper.createProject();
         proj.pse__Is_Active__c  = false;
         proj.pse__Stage__c = 'Closed and Billed';
         proj.pse__Opportunity__c = opp.id;
         proj.pse__Region__c = en.id;
         proj.pse__Practice__c = pr.id;
         proj.pse__Start_Date__c = system.today();
         proj.Client__c = opp.accountId;
         proj.pse__Account__c= acch.Id;
         proj.Draft_Report__c = true;
         system.debug('opp.accountId : ' +  opp.accountId);
         Test.startTest();
         insert proj;
         be.pse__Project__c = proj.id;
         insert be;
         delete proj;
         Test.stopTest();
         Account accPrDelete=[select ID,Hierarchy_Group_ID__c,Parent_Company__c,Group_project_count__c,New_Project_Count__c from Account where Id=:acch.Id];
         system.debug('accPrDelete : ' +  accPrDelete);
         system.assertEquals(null, accPrDelete.Group_project_count__c) ;
         //create child account
         /*Account acc2 = TestDataHelper.createAccount();
         acc2.ParentId=acch.Id;
         Test.startTest();
         insert acc2;

         system.debug('acc2 : ' +  acc2);
         pse__Proj__c proj1 = TestDataHelper.createProject();
         proj1.pse__Is_Active__c  = false;
         proj1.pse__Stage__c = 'Closed and Billed';
         proj1.pse__Opportunity__c = opp.id;
         proj1.pse__Region__c = en.id;
         proj1.pse__Practice__c = pr.id;
         proj1.pse__Start_Date__c = system.today();
         proj1.Client__c = acc2.Id;
         proj1.pse__Account__c= acc2.Id;

         insert proj1;
         system.debug('proj1 : ' +  proj1);
         Test.stopTest();
         delete proj1;
         Account accPrDelete=[select ID,Hierarchy_Group_ID__c,Parent_Company__c,Group_project_count__c,New_Project_Count__c from Account where Id=:acc2.Id];
         system.debug('accPrDelete : ' +  accPrDelete);
         system.assertEquals(null, accPrDelete.Group_project_count__c) ;
        */
     }


     }