public class DDCaseActions {
    
    private Case currentCase;
    
    public DDCaseActions(ApexPages.StandardController ctlr){  
        this.currentCase = (Case)ctlr.getRecord();
    }
    
    public pagereference sendQuestionnaire(){
        Pagereference pg;
        
        List<Case> csList = [select Id, DD_Counterparty_Type__c, WL_Risk_Model_Counterparty_Type__c from Case where Id =: this.currentCase.Id];      
        
        if(csList.get(0).DD_Counterparty_Type__c!= null && csList.get(0).DD_Counterparty_Type__c != ''){
            csList.get(0).Send_Questionnaire__c = true;
            update csList.get(0);
            pg = new Pagereference('/client/'+currentCase.Id);
            pg.setRedirect(true);
        }
        else{
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have not selected counterparty type');
            ApexPages.addMessage(myMsg1);
            return null;
        }
          return pg;          
    }
    
    public pagereference sendWLRMQuestionnaire(){
        Pagereference pg;
        
        List<Case> csList = [select Id, DD_Counterparty_Type__c, Send_Questionnaire_WLRM__c, WL_Risk_Model_Counterparty_Type__c from Case where Id =: this.currentCase.Id];      
        
        if(csList.get(0).WL_Risk_Model_Counterparty_Type__c!= null && csList.get(0).WL_Risk_Model_Counterparty_Type__c != ''){
            csList.get(0).Send_Questionnaire_WLRM__c = true;
            update csList.get(0);
            pg = new Pagereference('/client/'+currentCase.Id);
            pg.setRedirect(true);
        }
        else{
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'You have not selected questionnaire type');
            ApexPages.addMessage(myMsg1);
            return null;
        }
          return pg;          
    }

}