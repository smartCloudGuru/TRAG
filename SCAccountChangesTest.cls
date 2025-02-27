@isTest
private class SCAccountChangesTest {

	static SCTestData tdata;

	static void startTest(Boolean doStart){

		if (tdata == null)
		{
			tdata = new SCTestData();
			tdata.setup();
		}

		if (doStart)
		{
			Test.startTest();
		}
	}


	/**
	 *  approvalController => SCAccountChangesApprovalController
	 */
	static testMethod void approvalController(){

		startTest(true);

		SubcontractorAccountChanges__c record = tdata.getChanges();

		SCAccountChangesApprovalController con =
			new SCAccountChangesApprovalController(new ApexPages.StandardController(record));

		// successful test
		con.reject();
		con.approve();

		system.assertEquals(
			  SCAccountDataService.STATUS_APPLY_SUCCESS
			, [select Status__c from SubcontractorAccountChanges__c where Id =: record.Id].Status__c
			, 'trigger should be executed successfully');

		// make stdCon null to cause catch
		con.stdCon = null;
		con.approve();

		Test.stopTest();
	}

}