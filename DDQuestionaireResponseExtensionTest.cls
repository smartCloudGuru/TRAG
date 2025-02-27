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
public class DDQuestionaireResponseExtensionTest {

    /**
        Test if Question are saved against the related questionnaire
    */
    static testMethod void questionnaireSaveTest() {
        
        system.debug('DDQuestionaireResponseExtensionTest :: questionnaireSaveTest :: start');
        dd_Questions__c q1;
        dd_Questions__c q2;
        dd_Questions__c q3;
        List<Id> questionList = new List<Id>();
        Case cs; 
        dd_Questionnaire_Response__c questinnaire = TestDataHelper.createQuestionnaire();
        insert questinnaire;
        q1 = TestDataHelper.createQuestion();
        q1.dd_Questionnaire_Response__c = questinnaire.Id;
        q1.dd_Question_Number__c = 1;
        q1.dd_Section_Name__c = 'testSectionName1';
        system.debug('q1 :: '+q1);
        insert q1;
        questionList.add(q1.Id);
        q2 = TestDataHelper.createQuestion();
        q2.dd_Questionnaire_Response__c = questinnaire.Id;
        q2.dd_Question_Number__c = 2;
        q2.dd_Section_Name__c = 'testSectionName2';
        system.debug('q2 :: '+q2);
        insert q2;
        questionList.add(q2.Id);
        q3 = TestDataHelper.createQuestion();
        q3.dd_Questionnaire_Response__c = questinnaire.Id;
        q3.dd_Question_Number__c = 3;
        q3.dd_Section_Name__c = 'testSectionName3';
        system.debug('q3 :: '+q3);
        insert q3;
        questionList.add(q3.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(questinnaire);
        DDQuestionaireResponseExtension qre = new DDQuestionaireResponseExtension(sc);
        List<SelectOption> options = qre.getquestionSections();
        system.assertEquals(options.size(), 4);
        qre.saveChanges();
        qre.refreshPage();
        qre.getQuestion();
        qre.getquestionSectionList();
        List<dd_Questions__c> qList = [select Id, dd_Question_Number__c , dd_Answer__c, dd_Section_Name__c  from dd_Questions__c where Id in: questionList];
        for(dd_Questions__c qVal : qList){
            if(qVal.dd_Question_Number__c == 1){
                system.assertEquals(qList.get(0).dd_Section_Name__c, 'testSectionName1');
            }
        }
        system.debug('DDQuestionaireResponseExtensionTest :: questionnaireSaveTest :: end');        
    }
 }