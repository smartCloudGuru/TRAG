public with sharing class PSAProjectSubjectEditController {
                
    private final ApexPages.Standardcontroller stdController;
    private final pse__Proj__c project;
    
    public String subjectNames {get;set;}
    
    public PSAProjectSubjectEditController (ApexPages.Standardcontroller stdController) {
        this.stdController = stdController;
        project = ((pse__Proj__c)stdController.getRecord());
        project.ffps_0387__Subject_s__c = '';
    }
  
    public PageReference save() {
        updateCurrentSubjects(subjectNames);
        subjectNames += project.ffps_0387__Subject_s__c;
        project.ffps_0387__Subject_s__c = maxSize(PSAProjectSubjectEditController.getJointSubject(subjectNames), 254);
        PSAProjectSubjectEditController.saveSubjectsOnEdit( subjectNames, project.id);
        return stdController.save();
    }        
  
    private List<String> updatedCurrentSubjects = null;

    public void updateCurrentSubjects(String Data){
        updatedCurrentSubjects = new List<String>(new Set<String>(data.split('__Separator__')));
    }
    
    public String getCurrentSubjects(){
        if(updatedCurrentSubjects != null)return arrayJSEncoding(updatedCurrentSubjects);
        Id ProjectID = ((pse__Proj__c)stdController.getRecord()).id;
        if(ProjectID == null) return '[]';
        Map<Id, String> subjectMap = null;
        List<Project_Subject__c> subjectList = [Select id, Subject__r.Name From Project_Subject__c Where Project__c = :ProjectID];
        subjectMap = new Map<Id, String>();
        for(Project_Subject__c s : subjectList)
            subjectMap.put(s.id, s.Subject__r.Name);
        return arrayJSEncoding(subjectMap.values());
    }     

    public static String getAvailableSubjects(){
        Map<Id, String> subjectMap = null;
        Date dt = system.today().addyears(-5);
        List<Subject__c> subjectList = [Select id, Name From Subject__c where (createddate >: dt) and (not name like 'a0A%')];
        subjectMap = new Map<Id, String>();
        for(Subject__c s : subjectList)
            subjectMap.put(s.id, s.Name);
        return arrayJSEncoding(subjectMap.values());
    }
    
    private static String arrayJSEncoding(List<String> values){
        String result = '[';
        for(String s : values){
            if(result.length() > 3)result += ' , ';
            result += '\'' + s.replace('\\', '\\\\').replace('\'', '\\\'') + '\'';
        }
        result += ']';
        return result;
    }
    
    public static String getJointSubject(String data){
        String result = data.replace('__Separator__', ', ').replace('null', '');
        if(result.length() > 2 && result.substring(result.length()-2, result.length()) == ', ')
            result = result.substring(0,result.length()-2);
        return result;
    }
    
    public static void saveSubjectsOnEdit(String data, Id projectId){
        List<Project_Subject__c> existingSubjectLinks = [Select id, Subject__r.Name From Project_Subject__c Where Project__c = :ProjectID];
        
        List<Subject__c> subjectsToAdd = new List<Subject__c>();
        List<Project_Subject__c> subjectLinksToAdd = new List<Project_Subject__c>();
        List<Project_Subject__c> subjectLinksToRemove = new List<Project_Subject__c>();
        Set<String> subjectNamesArray = new Set<String>(data.split('__Separator__'));
        subjectNamesArray.remove('');
        subjectNamesArray.remove(' '); 
        subjectNamesArray.remove('null'); 
        
        for(Project_Subject__c s : existingSubjectLinks){
            if(subjectNamesArray.contains(s.Subject__r.Name))
               subjectNamesArray.remove(s.Subject__r.Name);
            else
               subjectLinksToRemove.add(s);
        }
        
        delete subjectLinksToRemove;
                    
        saveSubjects(subjectNamesArray, projectId);
    }
       
    public static void saveSubjects(String data, Id projectId){
        if(data.contains('__Separator__'))
        {
            saveSubjects(new Set<String>(data.split('__Separator__')), projectId);
            
        } else {
        
            saveSubjects(new Set<String>(data.split(', ')), projectId);
        }
    }
    
    public static void saveSubjects(Set<String> subjectNamesArray, Id projectId){
        List<Subject__c> subjectsToAdd = new List<Subject__c>();
        List<PSA_Project_Subject__c> subjectLinksToAdd = new List<PSA_Project_Subject__c>();
        for(Subject__c s : [Select id, Name From Subject__c Where Name in: subjectNamesArray]){
            subjectLinksToAdd.add(
                new PSA_Project_Subject__c(
                    PSA_Project__c = projectId,
                    Subject__c = s.Id,
                    Name = maxSize(s.Name, 80)
                )
            );
            subjectNamesArray.remove(s.Name);
        }
        for(String s : subjectNamesArray)
            subjectsToAdd.add(new Subject__c(Name = maxSize(s, 80)));
        insert subjectsToAdd;
        
        for(Subject__c s : [Select id, Name From Subject__c Where Name in: subjectNamesArray]){
            subjectLinksToAdd.add(
                new PSA_Project_Subject__c(
                    PSA_Project__c = projectId,
                    Subject__c = s.Id,
                    Name = maxSize(s.Name, 80)
                )
            );
        }
        insert subjectLinksToAdd;
    }     

    private static String maxSize(String s, Integer size){
        if(s.length() <= size)return s;
        return s.substring(0, size - 1);
    }
}