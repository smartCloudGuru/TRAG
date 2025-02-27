/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class QuestionnaireAnswersTriggerHandlerTest{
            
    /**
        Test if Last Submitted date on the Assessment is equal to Completion date on Questionnaire Answer 
        if completion date is greater thanLast Submitted Date
    */
    static testMethod void QuestionnaireAnswersTriggerHandlerTest() {
          
      system.debug('QuestionnaireAnswersTriggerHandlerTest :: QuestionnaireAnswersTriggerHandlerTest :: Start');
      Case cs = TestDataHelper.createCase();
      insert cs;
      Questionnaire_Answers__c qAns1 = new Questionnaire_Answers__c();
      qAns1.DD_Completion_Date__c = system.today();
      qAns1.DD_AssessmentID__c = cs.Id;
      insert qAns1;
      qAns1.DD_Completion_Date__c = system.today().addDays(1);
      update qAns1;
      Questionnaire_Answers__c qAns1Q = [select Id, DD_Completion_Date__c, DD_AssessmentId__r.DD_Questionnaire_Last_Submitted__c from Questionnaire_Answers__c where Id =: qAns1.Id];
      system.assertEquals(qAns1Q.DD_AssessmentId__r.DD_Questionnaire_Last_Submitted__c, qAns1Q.DD_Completion_Date__c);
      system.debug('QuestionnaireAnswersTriggerHandlerTest :: QuestionnaireAnswersTriggerHandlerTest :: End');    
   }      

}