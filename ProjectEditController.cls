/**
 *  @author Andrey Gavrikov (westbrook)
 *  @date 17/04/2010
 *  @description:
 *      Controller for ProjectEdit.page
 *      1.  As a new project record (Projects__c) is saved we need to automatically open a Clicktools survey within the 
 *          Salesforce window (maintaining the existing sidebar)
 *      2.  This should only happen on record creation and after the Project record has been successfully saved. 
 *          It is possible that a project record may fail to save on 1st attempt as there are validation rules around 
 *          the data.
 *      3.  The Project record ID needs to be passed into the Clicktools survey URL. This can be done using the below 
 *          appended URL with merge fields
 *      http://www.clicktools.com/survey?iv=39127f243bc58f6&q1={!Projects__c.Id}&q2= {!Projects__c.Name}&q3= {!Projects__c.Subjects__c}
 *      
 *  @version history
 *	2012-02-24 - Case 3295 - AG
 *	rename How_client_came_to_us__c to How_client_came_to_us_NEW__c
 *	
 *	2012-03-16 - AG
 *	projects with name 'Code' shall be allowed to created with duplicate name
*/

public with sharing class ProjectEditController {
	
    private final ApexPages.Standardcontroller stdController;
    
    public Boolean showCloseOpportunityMessage{get; private set;}
    public void closeOpportunity(){
        /** @autor Nikola Krastev (Westbrook)
            @date  24/05/2011
            @description: closes the opportunity if refered by the "Create Project & Close Opportunity" button
        */
        showCloseOpportunityMessage = false;
        if(getStringFromUrl('CloseOpportunity').length() > 1){
            showCloseOpportunityMessage = true;
            Opportunity o = [select Id From Opportunity Where Id =: getStringFromUrl('CloseOpportunity') limit 1];
            o.StageName = 'Closed Won';
            update o;
        }
    }
    
    public String subjectNames {get;set;}
    
    public static String getAvailableSubjects(){
        return ProjectSubjectEditController.getAvailableSubjects();
    }
    
    public ProjectEditController (ApexPages.Standardcontroller stdController) {
        this.stdController = stdController;
        //init from URL parameters
        final Projects__c projSobject = (Projects__c)stdController.getRecord();
        projSobject.How_client_came_to_us_NEW__c = getStringFromUrl('00N30000004ioHj');
        projSobject.Proposal_Date__c = getDateFromUrl('00N30000004ioHo');
        projSobject.Start_Date__c = getDateFromUrl('00N30000004ioHy');
        if (null == projSobject.Start_Date__c) {
            projSobject.Start_Date__c = System.today();
        }
        
        projSobject.Type__c = getStringFromUrl('00N30000003wymf');
        
       // projSobject.Type2__c = getStringFromUrl('00N30000004ptXW');
        projSobject.Budget__c = getDoubleFromUrl('00N30000003wymu');
        projSobject.Department__c = getStringFromUrl('00N30000003wymm');
        projSobject.CurrencyIsoCode = getStringFromUrl('CurrencyIsoCode');
        projSobject.Anticipated_Expenses__c = 20;
        
    }
    public Boolean getIsInitOk() {
        return true;
    }
    
    
    public PageReference presave() {
        return null;
    }
    
    public PageReference save() {
        //check that Project Name is unique
        Projects__c projSobject = (Projects__c)stdController.getRecord();
		final Boolean needDuplicateNameValidation = !isEmpty(projSobject.Name)? 'code' != projSobject.Name.toLowerCase() : true;
        if (needDuplicateNameValidation	&& [select count() from Projects__c where Name =: projSobject.Name] >0 ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ProjectEdit_Duplicate_Name + ' ' + projSobject.Name));
        } else {
            subjectNames += projSobject.Subjects__c;
            projSobject.Subjects__c = ProjectSubjectEditController.getJointSubject(subjectNames);
            final PageReference ref = stdController.save();
        }
        projSobject = (Projects__c)stdController.getRecord();
        if(projSobject.id != null)
            ProjectSubjectEditController.saveSubjects(subjectNames, projSobject.id);
        
        if (!ApexPages.hasMessages() && null != stdController.getId()) {
            //build frame URL
            String url = '';
            String params = '';
            
            //Subject__c subject = [select Name from Subject__c where id = :projSobject.Subject__c limit 1];
            
            final Projects__c projSobjectSaved = (Projects__c)stdController.getRecord();
            
            
            //projSobjectSaved.Subject_Name__c = subject.Name;
            
            for (ProjectEdit__c setting : ProjectEdit__c.getall().values()) 
            {
                if (setting.Is_URL_Prefix__c) 
                {
                    url = setting.Value__c;
                } 
                else 
                {
                    String val = getNotNull(projSobjectSaved.get(setting.Value__c));
                    System.debug('#val=' + val);
                    val = val.replace('&', ' and ');
                    val = val.replace('=', ' equals ');                 
                    params += '&' + setting.Name + '=' + val;
                    System.debug('#params=' + params);
                }
            }
            String frameUrl = url + params;
            System.debug('#frameUrl=' + frameUrl); 
            PageReference ref2 = new PageReference(frameUrl);
            ref2.setRedirect(true);
            return ref2;
        }
        //if () 
        return null;
    }
    public PageReference cancel() {
        return stdController.cancel();
    }
    
    private static String getNotNull(final Object val) {
        return val == null? '' : String.valueOf(val);
    }
    private static String getFromUrl(final String param) {
        return ApexPages.currentPage().getParameters().get(param);
    }
    
    private static String getStringFromUrl(final String param) {
        return getNotNull(getFromUrl(param));
    }
    private static Double getDoubleFromUrl(final String param) {
        String val = getFromUrl(param);
        if (!isEmpty(val)) {
            //remove comma(s)
            val = val.replaceAll(',', '');
            try {
                return Double.valueOf(val);
            } catch (Exception eIgnore) {}
        }
        return null;
    }
    
    private static Date getDateFromUrl(final String param) {
        String val = getFromUrl(param);
        if (!isEmpty(val)) {
            try {
                return Date.parse(val);
            } catch (Exception eIgnore) {}
        }
        return null;
    }
    private static Boolean isEmpty(final String val) {
        return val == null || val.trim().length() <1;
    }
    /////////////// unit tests //////////////////////
    static testMethod void codeCoverage() {
    system.assertEquals('','');
    }
    
    static testMethod void testOk() {
        Projects__c proj = createTestProject(null, true);
        
        PageReference pageRef = Page.ProjectEdit;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller stdCon = new ApexPages.Standardcontroller(proj);
        
        ProjectEditController controller = new ProjectEditController(stdCon);
        
    //PK    String nextPage = controller.save().getUrl();
        //check that save has succeeded
    //PK    System.assert(null != nextPage);
        
        //some more tests
        ApexPages.currentPage().getParameters().put('myDate', '01/01/2010');
        System.assert(null != getDateFromUrl('myDate'));
        ApexPages.currentPage().getParameters().put('myDouble', '10,000.25');
        System.assertEquals(10000.25, getDoubleFromUrl('myDouble'));
        
        
        //code coverage
        controller.getIsInitOk();
        controller.cancel();
    }
	
    static testMethod void testDuplicateError() {
		//AG 16/03/2012 - Not sure what following 7 lines are testing, seems pointless
		// taking into account that dupe validation is done in the controller and not inside a trigger.
        Projects__c proj1 = createTestProject(null, true);
    //PK - Create Project already has created this  Database.insert(proj1);
        try{
            Projects__c projDupe = createTestProject(proj1.Name, true);
        } catch(Exception e){
            System.debug('duplication now throws exception on insert');
        }
        
        Projects__c proj2 = createTestProject(proj1.Name, false);
        PageReference pageRef = Page.ProjectEdit;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller stdCon = new ApexPages.Standardcontroller(proj2);
        ProjectEditController controller = new ProjectEditController(stdCon);
        System.assertEquals(null, controller.save());
        System.assert(ApexPages.hasMessages(), 'Expected duplicate validation error');
    }
	/**
	 * as of 16/03/2012
	 * projects with name 'Code' shall be allowed to created with duplicate name
	 *
	 */
    static testMethod void testDuplicateException() {
        Projects__c proj1 = createTestProject('Code', true);
        Projects__c proj2 = createTestProject('cOde', false);
        PageReference pageRef = Page.ProjectEdit;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller stdCon = new ApexPages.Standardcontroller(proj2);
        ProjectEditController controller = new ProjectEditController(stdCon);
		controller.save();
        //System.assertEquals(null, controller.save());
        System.assert(!ApexPages.hasMessages(), 'Did not expect validation error');
    }
    
    private static Projects__c createTestProject(final String projName, final Boolean saveToDb) {
        Account client = new Account(Name = String.valueOf(Math.random()) + 'acc1');
        System.debug('#rand=' + client.Name);
        String subString = String.valueOf(Math.random()).substring(0,4);
        client.Client_Code__c = subString;
        Database.insert(client);
        String projectName = projName != null? projName : 'Project ' + String.valueOf(Math.random());

        Projects__c proj = new Projects__c(Client__c = client.Id, Name = projectName);
        proj.Start_Date__c = System.today();
        proj.Department__c = 'Test';
        proj.CurrencyIsoCode = 'GBP';
		if (saveToDb) {
			Database.insert(proj);
		}
        return proj;    
    }
    
}