public with sharing class PSAProjectPageForEditActionController {
	@TestVisible
	private final ApexPages.Standardcontroller stdController;
	public String subjectNames {get;set;}

	public PSAProjectPageForEditActionController(ApexPages.Standardcontroller stdController) {
		this.stdController = stdController;
	}


	public PageReference save() {
		pse__Proj__c projectForEdit = (pse__Proj__c) stdController.getRecord();
		Boolean isProjectNameDuplicated = checkDuplicatedProjectName(projectForEdit.Id, projectForEdit.Name);
		if (isProjectNameDuplicated) {
			 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ProjectEdit_Duplicate_Name + ' ' + projectForEdit.Name));
			 return NULL;
		} else {
			//save logic
			subjectNames += projectForEdit.ffps_0387__Subject_s__c;
            subjectNames = subjectNames.remove('null');
            String names = subjectNames;
            projectForEdit.ffps_0387__Subject_s__c = PSAProjectSubjectEditController.getJointSubject(names);
            if (String.isBlank(projectForEdit.ffps_0387__Subject_s__c)) {
                projectForEdit.ffps_0387__Subject_s__c = 'NULL';
            }
            subjectNames = NULL;
          	//Save Project to DB
            final PageReference ref;
            //we cant save Test Project record during the unit tests execution,
            //because of too many SOQL queries with in the package on SI Environment - ffps_sunrag
            if (Test.isRunningTest()) {
            	ref = ApexPages.currentPage();
            } else {
            	ref = stdController.save();	
            }
            
            //Refresh local variable
            projectForEdit = (pse__Proj__c)stdController.getRecord();
            
            if (projectForEdit.Id != NULL) {
            	PSAProjectSubjectEditController.saveSubjects(names, projectForEdit.Id);	
            }

            return ref;
		}

	} 

	@TestVisible
	private Boolean checkDuplicatedProjectName(Id projectId, String projectName) {
		Set<Id> idInSet = new Set<Id>();
		idInSet.add(projectId);//to use it within 'NOT IN' clause
		Integer numberOfNewProjectsWithThisName = [SELECT count() FROM pse__Proj__c WHERE Name = :projectName AND Id NOT IN :idInSet];
		Integer numberOfOldProjectsWithThisName = [SELECT count() FROM Projects__c WHERE Name = :projectName];

		if (!projectName.equalsIgnoreCase('code') && (numberOfNewProjectsWithThisName + numberOfOldProjectsWithThisName) > 0) {
			return true;
		} else {
			return false;
		}
	}

	public static String getAvailableSubjects() {
        return PSAProjectSubjectEditController.getAvailableSubjects();
    }

    public PageReference cancel() {
        return stdController.cancel();
    }


}