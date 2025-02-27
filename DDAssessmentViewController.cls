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

 Code purpose  :  Redirects counterparty to a recently submitted questionnaire


 Birthday      : 15/05/2014
 Api version   : v30

 ****************************************************************************************************************************/


public with sharing class DDAssessmentViewController{
    
    public String questionnaireURL {get; set;}
    public Id testUserId {get; set;}
    String conId;
    
    // Default Constructor
    public void AssessmentViewController(){}
    
    /**
        This method redirect counterparty to the most recently submitted Questionnaire URL
    */
    public pagereference assessmentURL(){        
        system.debug('DDAssessmentViewController ::  assessmentURL :: Start ');
        User usr;
        Id userId;
        PageReference newPage;
        
         if(Test.isRunningTest()){
            userId = testUserId;
         }
         else{
             userId = UserInfo.getUserId();
         }
         usr = [select Id, ContactId from User where Id =: userId];
         
         Contact con = [select Id, Account.DD_Automated_Questionnaire__c, (Select Id, DD_Questionnaire_URL__c From Cases order By CreatedDate desc ) from Contact where Id =: usr.ContactId];
         
         List<Case> caseList = con.Cases;
         
         if(caseList!=null && caseList.size()>0){
            questionnaireURL  = caseList.get(0).DD_Questionnaire_URL__c;             
            system.debug('questionnaireURL  :: '+questionnaireURL  );
         }
        
         if(con.Account.DD_Automated_Questionnaire__c){
             newPage = new PageReference(questionnaireURL);
         }
         else{
            newPage = new PageReference('/counterparty/apex/DDQuestionnaireNotPresent');
            return newPage;
         }
         newPage.setRedirect(true);
         return newPage;   
    }
}