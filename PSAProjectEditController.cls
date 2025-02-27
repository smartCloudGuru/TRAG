public with sharing class PSAProjectEditController {
                
    private final ApexPages.Standardcontroller stdController;
     
     //public pse__Proj__c projSobject{get;set;}
    public Boolean showCloseOpportunityMessage{get; private set;}
    
   // public String getContactId(){
        
        
       // return null;
  //  }
    public void closeOpportunity(){
        showCloseOpportunityMessage = false;
        if(getStringFromUrl('CloseOpportunity').length() > 1){            
            Opportunity o = [select Id, StageName, DD_Instruction__c, DD_Instruction__r.DD_Status__c, DD_Task_Order_Required__c From Opportunity Where Id =: getStringFromUrl('CloseOpportunity') limit 1];
            if(o.DD_Task_Order_Required__c 
               && o.DD_Instruction__c != null
               && ((o.StageName != 'Closed Won' && o.DD_Instruction__r.DD_Status__c != 'Quote Approved')
               || (o.StageName == 'Closed Won' && o.DD_Instruction__r.DD_Status__c != 'Assigned'))){
                   o.addError('Opportunity not Closed. LUMA Opportunity requires approved Task Order. Click Cancel to go back to Opportunity.');                   
               }
            else{
                showCloseOpportunityMessage = true;
                o.ffps_0387__Locked__c = true;
                o.StageName = 'Closed Won';
                update o;
            }                        
        }
    }
    public String subjectNames {get;set;}
    
    public static String getAvailableSubjects(){
        return PSAProjectSubjectEditController.getAvailableSubjects();
    }
   
    
    public PSAProjectEditController (ApexPages.Standardcontroller stdController) {
        
        
        
        this.stdController = stdController;
        //init from URL parameters
        OppFieldIds__c instance = [select howClientCameToUs__c,Subject__c, expenseBudget__c,otherPracticesInvolved__c,originatingOffice__c,practice__c,proposedDate__c,startDate__c,Type__c from OppFieldIds__c where Name='Opportunity Ids'];
        final pse__Proj__c projSobject = (pse__Proj__c)stdController.getRecord();
        //projSobject1= (pse__Proj__c)stdController.getRecord();
        projSobject.ffps_0387__How_client_came_to_us_NEW__c = getStringFromUrl(instance.howClientCameToUs__c);
        projSobject.Originating_Office__c = getStringFromUrl(instance.originatingOffice__c);
        projSobject.PSA_Proposed_Date__c = getDateFromUrl(instance.proposedDate__c);
        projSobject.pse__Start_Date__c = getDateFromUrl(instance.startDate__c);
        projSobject.ffps_0387__Subject_s__c = getStringFromUrl(instance.Subject__c);
        if (null == projSobject.pse__Start_Date__c) {
            projSobject.pse__Start_Date__c = System.today();
        }
        
        projSobject.PSA_Type__c = getStringFromUrl(instance.Type__c );
        projSobject.pse__Expense_Budget__c = getDoubleFromUrl(instance.expenseBudget__c);
        String pracParam = getStringFromUrl(instance.practice__c);
        projSobject.Department__c = pracParam != null && pracParam.length() > 0 ? pracParam : null;
         
        String currParam = getStringFromUrl('CurrencyIsoCode');
        projSobject.CurrencyIsoCode = currParam != null && currParam.length() > 0 ? currParam : UserInfo.getDefaultCurrency();
       
        projSobject.ffps_0387__Other_practices_involved__c = getStringFromUrl(instance.otherPracticesInvolved__c); // added by Tquila - Carmine Barbuto
        
        System.DEbug('#########'+projSobject.pse__Opportunity__c);

    }
    
    public Boolean getIsInitOk() {
        return true;
    }
    
    public PageReference presave() {
        return null;
    }
    
    public PageReference save() {
        //check that Project Name is unique
        pse__Proj__c projSobject = (pse__Proj__c)stdController.getRecord();
        final Boolean needDuplicateNameValidation = !isEmpty(projSobject.Name)? 'code' != projSobject.Name.toLowerCase() : true;
         
        if (projSobject.id == null && needDuplicateNameValidation && ([select count() from pse__Proj__c where Name =: projSobject.Name] >0 ||  [select count() from Projects__c where Name =: projSobject.Name] >0) ) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ProjectEdit_Duplicate_Name + ' ' + projSobject.Name));
            
        } else {
        
            subjectNames += projSobject.ffps_0387__Subject_s__c;
            subjectNames = subjectNames.remove('null');
            String names = subjectNames;
            projSobject.ffps_0387__Subject_s__c = PSAProjectSubjectEditController.getJointSubject(names);
            if(projSobject.ffps_0387__Subject_s__c==''||projSobject.ffps_0387__Subject_s__c==null)
            {
                projSobject.ffps_0387__Subject_s__c = 'NULL';
                //System.assertEquals(projSobject.ffps_0387__Subject_s__c,'b');
            }
            subjectNames = null;
          	projSobject.Invoicing_Contact__c = projSobject.ffps_0387__Client_Contact__c;
            final PageReference ref = stdController.save();
            projSobject = (pse__Proj__c)stdController.getRecord();
            
            if(projSobject.id != null)
            PSAProjectSubjectEditController.saveSubjects(names, projSobject.id);         
         }
        
        if (!ApexPages.hasMessages() && null != stdController.getId()) {
            //build frame URL
            String url = '';
            String params = '';
            //already commented, ignore
           // Subject__c subject = [select Name from Subject__c where id = :projSobject.ffps_0387__Subject_s__c limit 1];
            
            final pse__Proj__c projSobjectSaved = (pse__Proj__c)stdController.getRecord();
            
            //projSobjectSaved.Subject_Name__c = subject.Name;
            
            for (PSAProjectEdit__c setting : PSAProjectEdit__c.getall().values()) 
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
    
}