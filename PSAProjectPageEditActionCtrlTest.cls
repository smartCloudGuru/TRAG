@isTest(SeeAllData=true)
private class PSAProjectPageEditActionCtrlTest {

	static User testUser;
    static pse__Practice__c testpractice;
    static pse__Region__c testregion;
    static pse__Grp__c testGroup;
    static final String DEFAULT_COMPANY_NAME = 'Janusian Saudi Ltd Co';
    static final String DEFAULT_PRACTICE_NAME = 'Admin-UK';
    static final String DEFAULT_REGION_NAME = 'Janusian Saudi Ltd Co';
    static final String DEFAULT_GROUP_NAME = 'London';
	
	@isTest static void test_checkDuplicatedProjectName() {
		//create test data
		pse__Proj__c testProject = createTestProject('TestProject', false);

		Test.startTest();
		ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(testProject);
		PSAProjectPageForEditActionController controller = new PSAProjectPageForEditActionController(stdController);
		PageReference pageRef = Page.PSAProjectPageForEditAction;
		Test.setCurrentPage(pageRef);
		pse__Proj__c projectForEdit = (pse__Proj__c) controller.stdController.getRecord();
		System.assertEquals('TestProject', projectForEdit.Name);
		projectForEdit.Name = 'Existed Name';
		Boolean nameExisted = controller.checkDuplicatedProjectName(projectForEdit.Id, projectForEdit.Name);
		System.assertEquals(false, nameExisted);
		Test.stopTest();
	}
	
	@isTest static void test_saveEditedProject() {
		//create test data
		pse__Proj__c testProject = createTestProject('TestProject', false);

		Test.startTest();
		ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(testProject);
		PSAProjectPageForEditActionController controller = new PSAProjectPageForEditActionController(stdController);
		PageReference pr = controller.save();
		System.assertNotEquals(NULl, pr);
		controller.cancel();
		Test.stopTest();
	}


	private static pse__Proj__c createTestProject(String projName, final Boolean saveToDb) {
 
        pse__Proj__c proj;
        testPractice = [SELECT Id FROM pse__Practice__c WHERE Name = :DEFAULT_PRACTICE_NAME LIMIT 1];
        testRegion = [SELECT Id FROM pse__Region__c WHERE Name = :DEFAULT_REGION_NAME LIMIT 1];
        testGroup = [SELECT Id FROM pse__Grp__c WHERE Name = :DEFAULT_GROUP_NAME LIMIT 1];
        
        Account client = new Account(Name = String.valueOf(Math.random()) + 'acc1');
        System.debug('#rand=' + client.Name);
        String subString = String.valueOf(Math.random()).substring(0, 4);
        client.Client_Code__c = subString;
        Database.insert(client);
        String projectName = projName != NULL ? projName : 'Project ' + String.valueOf(Math.random());

        proj = new pse__Proj__c(Name = projectName);
        proj.pse__Billing_Type__c = 'Admin';
        proj.pse__Start_Date__c = System.today();
        proj.pse__Stage__c = 'Draft';
        proj.pse__Practice__c = testPractice.Id;
        proj.pse__Region__c=testRegion.Id;
        proj.pse__Group__c = testGroup.Id;
        proj.pse__Account__c = client.Id;
        
        if (saveToDb) {
            Database.insert(proj);
        }
                
        return proj;    
    
    }
	
}