public with sharing class DDQuestionnaireResponseTabController {
    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
        
    public ApexPages.StandardSetController standardSetCtrl  {
        get{
            if(standardSetCtrl == null){
                size = Integer.valueOf(Label.DDQuestionnaireResponsePageSize);
                string queryString = 'Select Name, Counterparty_Account_Name__c, Questionnaire_Response_Name_CF__c, DD_Submitted_Time__c, dd_Status__c from dd_Questionnaire_Response__c order by Counterparty_Account_Name__c asc';
                standardSetCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                standardSetCtrl.setPageSize(size);
                noOfRecords = standardSetCtrl.getResultSize();
            }
            return standardSetCtrl;
        }set;
    }
     
    Public List<dd_Questionnaire_Response__c> getQuestionnaireResponse(){
        List<dd_Questionnaire_Response__c> qrList = new List<dd_Questionnaire_Response__c>();
        for(dd_Questionnaire_Response__c qr : (List<dd_Questionnaire_Response__c>)standardSetCtrl.getRecords())
            qrList.add(qr);
        return qrList;
    }
     
    public pageReference refresh() {
        standardSetCtrl = null;
        getQuestionnaireResponse();
        standardSetCtrl.setPageNumber(1);
        return null;
    }
     
    public Boolean hasNext {
        get {
            return standardSetCtrl.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return standardSetCtrl.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {
            return standardSetCtrl.getPageNumber();
        }
        set;
    }
  
    public void first() {
		//any custom logic
        standardSetCtrl.first();
    }
  
    public void last() {
		//any custom logic
        standardSetCtrl.last();
    }
  
    public void previous() {
		//any custom logic
        standardSetCtrl.previous();
    }
  
    public void next() {
		//any custom logic
        standardSetCtrl.next();
    }
}