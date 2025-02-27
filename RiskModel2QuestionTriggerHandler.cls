public class RiskModel2QuestionTriggerHandler {
    
    public void beforeInsert(List<Risk_Model_2_Question__c> newRiskModel2QuestionList, Map<Id, Risk_Model_2_Question__c> newRiskModel2QuestionMap){
        
        List<String> questionIdList = new List<String>();
        Map<String, Decimal> uniqueQuestionIdentifier_Score_Map = new Map<String, Decimal>();
        
        for(Risk_Model_2_Question__c newRiskModel2QuestionVal : newRiskModel2QuestionList){
            questionIdList.add(newRiskModel2QuestionVal.Question_Id__c);
        }
        system.debug('questionIdList :: '+questionIdList);
        
        List<Risk_Model_2_Question_Score__c> questionScoreList = [select Id, Question_Id__c, Value__c, Answer__c, Score__c, Account__c from Risk_Model_2_Question_Score__c
                                                                 where Question_Id__c in: questionIdList];
        system.debug('questionScoreList :: '+questionScoreList);
        
        for(Risk_Model_2_Question_Score__c questionScoreVal : questionScoreList){
            uniqueQuestionIdentifier_Score_Map.put(questionScoreVal.Question_Id__c+questionScoreVal.Value__c+questionScoreVal.Answer__c, questionScoreVal.Score__c);
        }
        system.debug('uniqueQuestionIdentifier_Score_Map :: '+uniqueQuestionIdentifier_Score_Map);    
        for(Risk_Model_2_Question__c newRiskModel2QuestionVal : newRiskModel2QuestionList){
            newRiskModel2QuestionVal.Score__c = uniqueQuestionIdentifier_Score_Map.get(newRiskModel2QuestionVal.Question_Id__c+newRiskModel2QuestionVal.Question__c+newRiskModel2QuestionVal.Answer__c);
        }
    }

}