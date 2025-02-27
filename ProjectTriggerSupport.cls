/**
    @author Andrey Gavrikov (westbrook)
    @date 02/05/2010
    @description:
        Helper methods and tests for Project[Before/After] triggers
        
    @version history
        ~ 0.1 - 2010-05-02 - AG - original version
          Tests for Roll-up count of all projects associated to an Account
          @see ProjectAfter.trigger for more details        
        ~ 0.2 - 2012-02-16 - AG
          Rollup shall only be calculated for Projects which meet condition
          proj.Invoice_Company_Approved__c && Projects_Read_Only_Record_Type == proj.RecordTypeId
*/
public without sharing class ProjectTriggerSupport {
    public static final Id Projects_Read_Only_Record_Type = '01230000000YtIS'; 
    /////////////////////////////////////////////////////////////////////
    private static testMethod void testRollUp() {
        Account client = new Account(Name = String.valueOf(Math.random()) + 'acc1');
        System.debug('#rand=' + client.Name);
        String subString = String.valueOf(Math.random()).substring(0,5);
        client.Client_Code__c = subString;
        Database.insert(client);
         
        TriggerUtils.clearStatics();
        //count must be null or 0
        client = [select Id, Project_Count__c from Account where id =: client.Id];
        System.assert(null == client.Project_Count__c || 0.0 == client.Project_Count__c, 'Expected blank value');
        
        TriggerUtils.clearStatics();
        //test increment for Blank counter
        Projects__c proj1 = createTestProject(client.Id, null);
        Projects__c proj2 = createTestProject(client.Id, null);
        Projects__c proj3 = createTestProject(client.Id, null);
        proj3.Invoice_Company_Approved__c = false;//non rollup condition
        Database.insert(new Projects__c[] {proj1, proj2, proj3});
        
        //count must be 2
        System.assertEquals(2.0, [select Id, Project_Count__c from Account where id =: client.Id].Project_Count__c);
        
        TriggerUtils.clearStatics();
        //count must be 1 because 1 project has just been deleted
        Database.delete(proj1);
        System.assertEquals(1.0, [select Id, Project_Count__c from Account where id =: client.Id].Project_Count__c);


        TriggerUtils.clearStatics();
		//make proj3 meet rollup criteria
		proj3.Invoice_Company_Approved__c = true;
		proj3.RecordTypeId = Projects_Read_Only_Record_Type;
        Database.update(proj3);
		//check if Account now counts Proj1 and Proj3
        System.assertEquals(2, [select Id, Project_Count__c from Account where id =: client.Id].Project_Count__c);
        
        
        TriggerUtils.clearStatics();
        //test that Project_Count never goes below 0
        client.Project_Count__c = 0;
        Database.update(client);
        TriggerUtils.clearStatics();
        //delete proj2 - we expect that counter does not go below 0
        Database.delete(proj2);
        System.assertEquals(0, [select Id, Project_Count__c from Account where id =: client.Id].Project_Count__c);


		//test undelete
        TriggerUtils.clearStatics();
		Database.undelete(proj2);
        System.assertEquals(1, [select Id, Project_Count__c from Account where id =: client.Id].Project_Count__c);



    } 

	/**
	 * 
	 */
	static testMethod void testRollUpDown () {
		//test simultaneous increment and decrement
        Account client = new Account(Name = String.valueOf(Math.random()) + 'acc1');
        System.debug('#rand=' + client.Name);
        String subString = String.valueOf(Math.random()).substring(0,5);
        client.Client_Code__c = subString;
        Database.insert(client);
         
        TriggerUtils.clearStatics();
        //count must be null or 0
        client = [select Id, Project_Count__c from Account where id =: client.Id];
        System.assert(null == client.Project_Count__c || 0.0 == client.Project_Count__c, 'Expected blank value');
        
        TriggerUtils.clearStatics();
        //test increment for Blank counter
        Projects__c proj1 = createTestProject(client.Id, null);
        Projects__c proj2 = createTestProject(client.Id, null);
        Projects__c proj3 = createTestProject(client.Id, null);
        proj3.Invoice_Company_Approved__c = false;//non rollup condition
        Database.insert(new Projects__c[] {proj1, proj2, proj3});

        TriggerUtils.clearStatics();
		//change proj1 & proj2 to no longer meet Rollup criteria
        proj1.Invoice_Company_Approved__c = false;//non rollup condition
        proj2.Invoice_Company_Approved__c = false;//non rollup condition
		//change proj3 to meet Rollup criteria
        proj3.Invoice_Company_Approved__c = true;//Rollup condition
        Database.update(new Projects__c[] {proj1, proj2, proj3});

		
		//only proj3 shall be registered, i.e. total is 1
        System.assertEquals(1, [select Id, Project_Count__c from Account where id =: client.Id].Project_Count__c);
	}
	

	/**
	 * Test data creation methods
	 */
    private static Projects__c createTestProject(final Id accId, final String projName) {
        String projectName = projName != null? projName : 'Project ' + String.valueOf(Math.random());
        Projects__c proj = new Projects__c(Client__c = accId, Name = projectName);
    
        proj.Start_Date__c = System.today();
        proj.Department__c = 'Test';
        proj.CurrencyIsoCode = 'GBP';
        proj.Invoice_Company_Approved__c = true;
        proj.RecordTypeId = Projects_Read_Only_Record_Type;
        
        return proj;    
    }
    
}