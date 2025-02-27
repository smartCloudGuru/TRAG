@isTest(SeeAllData=true)
public class RiskModel2QuestionTriggerHandlerTest {
    
    static testMethod void newRiskModel2QuestionTest() {
             
         system.debug('RiskModel2QuestionTriggerHandlerTest :: newRiskModel2QuestionTest :: start');
         User u5;
         User thisUser = [select Id from User where Id = :UserInfo.getUserId() ];
         system.runas(thisUser){
            u5 = TestDataHelper.createPortalUser();
          }
        system.runas(u5){ 
            Risk_Model_2_Questionnaire_Response__c rm2qr = TestDataHelper.getRiskModel2QuestionnaireResponse();
            insert rm2qr;
            Risk_Model_2_Question__c rm2q = TestDataHelper.getRiskModel2Question(rm2qr);
            insert rm2q;
        }
    }
}