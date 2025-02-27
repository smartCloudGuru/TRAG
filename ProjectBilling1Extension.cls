public with sharing class ProjectBilling1Extension {
    
    public pse__Proj__c proj;
    
    public ProjectBilling1Extension (ApexPages.StandardController stdController) {    
        proj = (pse__Proj__c)stdController.getRecord(); 
    }
    
    public Pagereference validateLUMA(){
        Pagereference pg;
        List<pse__Proj__c> queriedProjectList = [Select Id, Draft_Report__c,
                                                 Final_Report__c, DDInstruction__c
                                                 from pse__Proj__c where Id =: proj.Id];        
        if(!(queriedProjectList.get(0).Draft_Report__c 
                          || queriedProjectList.get(0).Final_Report__c) 
           && (queriedProjectList.get(0).DDInstruction__c != null)){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Draft or Final Report selection missing for LUMA project'));
               return null;
           }
        else{
            pg = new Pagereference(Label.Project_Billing_Domain+proj.Id);
            pg.setRedirect(true);
            return pg;
        }
        return pg;
    }

}