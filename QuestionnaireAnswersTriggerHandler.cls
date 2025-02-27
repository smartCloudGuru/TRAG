/************************************************************************************************************************                                                                                         
 
              ***                                                            ***          *****                          
            ****                                                            *****       *****                            
          ****                                                                         *****                             
    ****************         **********         ****       *****        *****       *****             ************      
       ****             *****                *****       *****       *****       ******         *******                
      ***            ****       ****       *****       *****        ****        *****        ******      *****         
    ****           *****       ****       *****       *****       *****       *****        *****        ****           
   ****       ********       ****     *******       *****      ******       ******      *******       *****      ***** 
  *************** ***** *********  **********************************************************************************   
   ********          *****************     *******      ******     ********     *******       *******    *******         
                           ******                                                                                        
                         ******                                                                                          
                        ****                                                                          
                       ***                                                                         SOCIAL | MOBILE | WEB  
  
 
  
 Crafted by    : Mayank Sharma
               : msharma@tquila.com 
               : www.tquila.com

 Code purpose  : Update the assessment last submitted date from questionnaire answer completion date


 Birthday      : 01/07/2014
 Api version   : v30

 ****************************************************************************************************************************/
public with sharing class QuestionnaireAnswersTriggerHandler{

    /**
        After update on Questionnaire Answer
        This method updates the questionnaire last submitted date on the assessment from the questionniare answer record
        if last submitted date on the assessment is less than completion date on the questionnaire answer
    */
    public void afterUpdate(list<Questionnaire_Answers__c> qAnsList){
        
        system.debug('QuestionnaireAnswersTriggerHandler :: afterUpdate :: start');
        List<Id> qAnsIdList = new List<Id>();
        List<Case> caseToBeUpdatedList = new List<Case>();
        
        for(Questionnaire_Answers__c qAnsVal : qAnsList){
            qAnsIdList.add(qAnsVal.Id);
        }
        
        List<Questionnaire_Answers__c> queriedQAnsList = [select Id, DD_Completion_Date__c, 
                                                            DD_AssessmentId__r.DD_Questionnaire_Last_Submitted__c 
                                                            from Questionnaire_Answers__c 
                                                            where DD_Completion_Date__c!= null 
                                                            and Id in: qAnsIdList];
        
        for(Questionnaire_Answers__c queriedQAnsVal : queriedQAnsList){
            if(queriedQAnsVal.DD_AssessmentId__r.DD_Questionnaire_Last_Submitted__c == null 
                    || queriedQAnsVal.DD_AssessmentId__r.DD_Questionnaire_Last_Submitted__c < queriedQAnsVal.DD_Completion_Date__c){
                    queriedQAnsVal.DD_AssessmentId__r.DD_Questionnaire_Last_Submitted__c = queriedQAnsVal.DD_Completion_Date__c;
                    caseToBeUpdatedList.add(queriedQAnsVal.DD_AssessmentId__r); 
            }
        }
        
        if(caseToBeUpdatedList.size()>0){
            try{
                update caseToBeUpdatedList;
            }
            catch(Exception ex){
                //queriedCaseVal.addError('Exception while trying to update related contact');
                system.debug('Exception while trying to update related contact ');
            }
        }
        system.debug('QuestionnaireAnswersTriggerHandler :: afterUpdate :: end');
    }
}