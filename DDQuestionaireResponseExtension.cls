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

 Code purpose  : This is a standard controller extension responsible for saving changes of the Question and Answer records related to Questionnaire Response
 


 Birthday      : 2014-08-19
 Api version   : v31

 ****************************************************************************************************************************/

public  class DDQuestionaireResponseExtension{

    /* class variables */
    dd_Questionnaire_Response__c qResp;
    String[] questionSectionList;
    Set<SelectOption> questionSectionNameSet = new Set<SelectOption>();
    Set<SelectOption> questionStatusNameSet = new Set<SelectOption>();    
    List<dd_Questions__c> qList; 
    public boolean isNotCounterparty {get; set;}
    public boolean ifNotClient {get; set;}
    public boolean refreshButtonVisibility {get; set;}
    public boolean assignToMeButtonVisibility {get; set;}
    public boolean submitToClientButtonVisibility {get; set;}
    public boolean completeButtonVisibility {get; set;}
    public boolean counterpartyReviewButtonVisibility {get; set;}
    public boolean counterpartySubmissionButtonVisibility {get; set;}
    public boolean recallButtonVisibility {get; set;}
    public boolean saveButtonVisibility {get; set;}
    public String verificationStatus {get; set;}
    public String selectedVerificationStatus {get; set;}
    public String selectedSection {get; set;}
    public boolean isCounterPartyWithQuestionnaire {get; set;}
    public boolean isVerificationByClientOnly {get; set;}
    List<User> loggedInUser;
    //List<Attachment> att{get;set;} 	        
    
    /* getter */
     public List<dd_Questions__c> getQuestion() { 
      return qList; 
     } 
     
     public String[] getquestionSectionList() {
        return questionSectionList;
    }
        
    public void setquestionSectionList(String[] questionSectionList) {
        this.questionSectionList= questionSectionList;
    }
    
    public List<SelectOption> getquestionSections() {
        List<SelectOption> options = new List<SelectOption>();
        List<SelectOption> options1 = new List<SelectOption>();
        options.addAll(questionSectionNameSet);
        options1.addAll(questionStatusNameSet);
        options.sort();
        options1.sort();
        return options;
    }
    
    public List<SelectOption> getquestionStatus() {
        List<SelectOption> options1 = new List<SelectOption>();
        options1.addAll(questionStatusNameSet);
        options1.sort();
        return options1;
    }
    
    public List<SelectOption> getSelectAllOptions() {
        List<SelectOption> options1 = new List<SelectOption>();
        options1.add(new SelectOption('--None--','--None--'));
        options1.add(new SelectOption('Not Started','Not Started'));
        options1.add(new SelectOption('In Progress','In Progress'));
        options1.add(new SelectOption('Flagged','Flagged'));
        options1.add(new SelectOption('Verified','Verified')); 
        options1.sort();
        return options1;
    }
    
    /* One Argument Constructor 
       In this constructor, class variable qs has been assigned
    */
    public DDQuestionaireResponseExtension(ApexPages.StandardController controller) {
        
        isCounterPartyWithQuestionnaire = false;
        isNotCounterparty = false;
        ifNotClient  = false;
        refreshButtonVisibility = false;
        assignToMeButtonVisibility = false;
        submitToClientButtonVisibility = false;
        completeButtonVisibility = false;
        saveButtonVisibility = false;
        isVerificationByClientOnly = false;
        qResp = (dd_Questionnaire_Response__c)controller.getSubject();                  
        qList = [SELECT dd_Question__c, dd_Answer__c, dd_Questionnaire_Response__c, dd_Questionnaire_Response__r.dd_Assessment__r.Status, Answers_tracking__c,
                 dd_Questionnaire_Response__r.dd_Assessment__r.Account.Parent.Verification_by_Client_Only__c,
                   dd_Questionnaire_Response__r.dd_Status__c, dd_Questionnaire_Response__r.OwnerId, Counterparty_comment__c,
                              dd_Researcher_Comment__c, dd_Verification_Comment__c, dd_Verification_Status__c, Multiple_answers__c,
                            dd_Question_Number__c, dd_Section_Name__c, dd_Section_Number__c, RAG_Client__c, Client_comments__c 
                            from dd_Questions__c where dd_Questionnaire_Response__c =: qResp.Id order by dd_Question_Number__c asc];                        
        questionSectionNameSet.add(new SelectOption('01','All'));
        questionStatusNameSet.add(new SelectOption('01','All'));
        questionStatusNameSet.add(new SelectOption('Not Started','Not Started'));
        questionStatusNameSet.add(new SelectOption('In Progress','In Progress'));
        questionStatusNameSet.add(new SelectOption('Flagged','Flagged'));
        questionStatusNameSet.add(new SelectOption('Verified','Verified'));
        if(qList != null && qList.size() > 0 
           && qList.get(0).dd_Questionnaire_Response__r != null){
               if(qList.get(0).dd_Questionnaire_Response__r.dd_Assessment__r != null
                  && qList.get(0).dd_Questionnaire_Response__r.dd_Assessment__r.Account.Parent.Verification_by_Client_Only__c ){
                   isVerificationByClientOnly = true;
               }
           }
        for(dd_Questions__c qVal : qList){
            SelectOption selOpt = new SelectOption(qVal.dd_Section_Name__c, qVal.dd_Section_Name__c);
            //SelectOption selOpt1 = new SelectOption(qVal.dd_Verification_Status__c, qVal.dd_Verification_Status__c);
            questionSectionNameSet.add(selOpt);
            //questionStatusNameSet.add(selOpt1);
        }   
       loggedInUser = [select Id, UserType, Contact.Account.DD_Due_Diligence_Portal_Licence__c, 
                       Contact.Account.Verification_by_Client_Only__c 
                       from User where Id =: Userinfo.getUserId()];
        if(loggedInUser != null && loggedInUser.size() == 1){
           if(loggedInUser.get(0).Contact.Account.DD_Due_Diligence_Portal_Licence__c != null 
               && loggedInUser.get(0).Contact.Account.DD_Due_Diligence_Portal_Licence__c.equals('Counterparty Application with Questionnaire')){
                   isCounterPartyWithQuestionnaire = true;
               }            
        }
        system.debug('isCounterPartyWithQuestionnaire :: '+isCounterPartyWithQuestionnaire);
       if(loggedInUser!=null && loggedInUser.size()>0){
           if(!loggedInUser.get(0).userType.equals('CspLitePortal')){
               isNotCounterparty = true;
           }
           if(!loggedInUser.get(0).userType.equals('PowerPartner')){
               ifNotClient = true;
           }
       }
        buttonsVisibility();
    }
    
    public void getQuestionsList(){
        if(selectedSection != '01' && selectedVerificationStatus == '01'){
            qList = [SELECT dd_Question__c, dd_Answer__c, dd_Questionnaire_Response__c, dd_Questionnaire_Response__r.dd_Assessment__r.Status, Answers_tracking__c,
                     dd_Questionnaire_Response__r.dd_Status__c, Counterparty_comment__c,
                              dd_Researcher_Comment__c, dd_Verification_Comment__c, dd_Verification_Status__c, Multiple_answers__c,
                            dd_Question_Number__c, dd_Section_Name__c, dd_Section_Number__c, RAG_Client__c, Client_comments__c 
                            from dd_Questions__c where dd_Questionnaire_Response__c =: qResp.Id and dd_Section_Name__c =: selectedSection
                     order by dd_Section_Number__c,dd_Question_Number__c asc]; 
        }
        else if(selectedVerificationStatus != '01' && selectedSection == '01'){
            qList = [SELECT dd_Question__c, dd_Answer__c, dd_Questionnaire_Response__c, dd_Questionnaire_Response__r.dd_Assessment__r.Status, Answers_tracking__c,
                     dd_Questionnaire_Response__r.dd_Status__c, Counterparty_comment__c,
                              dd_Researcher_Comment__c, dd_Verification_Comment__c, dd_Verification_Status__c,Multiple_answers__c,
                            dd_Question_Number__c, dd_Section_Name__c, dd_Section_Number__c, RAG_Client__c, Client_comments__c
                            from dd_Questions__c where dd_Questionnaire_Response__c =: qResp.Id and dd_Verification_Status__c =: selectedVerificationStatus
                     order by dd_Section_Number__c,dd_Question_Number__c asc]; 
        }
        else if(selectedSection != '01' && selectedVerificationStatus != '01'){
            qList = [SELECT dd_Question__c, dd_Answer__c, dd_Questionnaire_Response__c, dd_Questionnaire_Response__r.dd_Assessment__r.Status, Answers_tracking__c,
                     dd_Questionnaire_Response__r.dd_Status__c, Counterparty_comment__c,
                              dd_Researcher_Comment__c, dd_Verification_Comment__c, dd_Verification_Status__c, Multiple_answers__c,
                            dd_Question_Number__c, dd_Section_Name__c, dd_Section_Number__c, RAG_Client__c, Client_comments__c  
                            from dd_Questions__c where dd_Questionnaire_Response__c =: qResp.Id and dd_Section_Name__c =: selectedSection 
                     and dd_Verification_Status__c =: selectedVerificationStatus
                     order by dd_Section_Number__c,dd_Question_Number__c asc]; 
        }  
        else{
            qList = [SELECT dd_Question__c, dd_Answer__c, dd_Questionnaire_Response__c, dd_Questionnaire_Response__r.dd_Assessment__r.Status, Answers_tracking__c,
                              dd_Researcher_Comment__c, dd_Verification_Comment__c, dd_Verification_Status__c, Multiple_answers__c, Counterparty_comment__c,
                            dd_Question_Number__c, dd_Section_Name__c, dd_Section_Number__c, RAG_Client__c, Client_comments__c  
                            from dd_Questions__c where dd_Questionnaire_Response__c =: qResp.Id order by dd_Section_Number__c,dd_Question_Number__c asc];     
        }
    }
    
    public void updateVerificationstatus(){
        system.debug('verificationStatus :: '+verificationStatus);
        system.debug('selectedSection :: '+selectedSection);
        //selectedSection = '01';
        for(dd_Questions__c qVal : qList){
            if(isNotCounterparty && ifNotClient && qVal.RAG_Client__c == 'RAG'){
                if(selectedSection == '01'){
                    qVal.dd_Verification_Status__c = verificationStatus;
                }
                else{
                    if(qVal.dd_Section_Name__c == selectedSection){
                        qVal.dd_Verification_Status__c = verificationStatus;
                    }
                }
            }
            else{
                if(!ifNotClient && qVal.RAG_Client__c == 'Client'){
                    if(selectedSection == '01'){
                        qVal.dd_Verification_Status__c = verificationStatus;
                    }
                    else{
                        if(qVal.dd_Section_Name__c == selectedSection){
                            qVal.dd_Verification_Status__c = verificationStatus;
                        }
                    }
                }
            }
            //selectedSection = '01';
        } 
    }
    
    /*public void resetStatus(){
        qList = [SELECT dd_Question__c, dd_Answer__c, dd_Questionnaire_Response__c, dd_Questionnaire_Response__r.dd_Assessment__r.Status,
                              dd_Researcher_Comment__c, dd_Verification_Comment__c, dd_Verification_Status__c,
                            dd_Question_Number__c, dd_Section_Name__c, dd_Section_Number__c, RAG_Client__c 
                            from dd_Questions__c where dd_Questionnaire_Response__c =: qResp.Id order by dd_Section_Number__c,dd_Question_Number__c asc];
    }*/
    
    public void buttonsVisibility(){
        List<dd_Questionnaire_Response__c> qRespList = [select Id , dd_Status__c, Questionnaire_remaining_by_RAG__c, Assigned_to_User__c, OwnerId,
                                                         dd_Assessment__r.Account.ParentId, dd_Assessment__r.Status
                                                         from dd_Questionnaire_Response__c where Id =: qResp.Id];
        system.debug('qRespList :: '+qRespList);
        if(/*!isNotCounterparty || */qRespList.get(0).dd_Status__c == 'Sent'){
            refreshButtonVisibility = false;
            assignToMeButtonVisibility = false;
            submitToClientButtonVisibility = false;
            completeButtonVisibility = false;
            saveButtonVisibility = false;
            counterpartyReviewButtonVisibility = false;
            counterpartySubmissionButtonVisibility = false;
            recallButtonVisibility = false;
        }
        else if(qRespList.get(0).dd_Status__c == 'Submitted' && !qRespList.get(0).Assigned_to_User__c){
            if(ifNotClient && isNotCounterparty){
            	refreshButtonVisibility = false;
                assignToMeButtonVisibility = true;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
            else if(!ifNotClient){
                refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
            else{
                refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }            
        }
        else if(qRespList.get(0).dd_Status__c == 'Submitted' && qRespList.get(0).Assigned_to_User__c){
            if(!ifNotClient || !isNotCounterparty){
                refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
            else{
                refreshButtonVisibility = true;
                assignToMeButtonVisibility = true;
                submitToClientButtonVisibility = true;
                completeButtonVisibility = false;
                saveButtonVisibility = true;
                counterpartyReviewButtonVisibility = true;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
        }
        else if(qRespList.get(0).dd_Status__c == 'Counterparty Review' && qRespList.get(0).Assigned_to_User__c){
            if(ifNotClient && isNotCounterparty){
                refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                if(loggedInUser.get(0).Id == qRespList.get(0).OwnerId){
                    recallButtonVisibility = true;
                }
            }
            if(!ifNotClient){
                refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                if(loggedInUser.get(0).Id == qRespList.get(0).OwnerId){
                    recallButtonVisibility = true;
                }
            }
            else if(!isNotCounterparty){
                refreshButtonVisibility = true;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = true;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = true;
                recallButtonVisibility = false;
            }
        }
        else if(qRespList.get(0).dd_Status__c == 'Completed by RAG' && !qRespList.get(0).Assigned_to_User__c){
            if(ifNotClient && isNotCounterparty){
            	refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
            else if(!ifNotClient){
                refreshButtonVisibility = false;
                assignToMeButtonVisibility = true;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
            else{
                refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
        } 
        else if(qRespList.get(0).dd_Status__c == 'Completed by RAG' && qRespList.get(0).Assigned_to_User__c){
            if(ifNotClient && isNotCounterparty){
            	refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
            else if(!ifNotClient){
                refreshButtonVisibility = true;
                assignToMeButtonVisibility = true;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = true;
                saveButtonVisibility = true;
                counterpartyReviewButtonVisibility = true;
                counterpartySubmissionButtonVisibility = false;
                counterpartyReviewButtonVisibility = true;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
            else{
                refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
               counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
                counterpartySubmissionButtonVisibility = false;
                recallButtonVisibility = false;
            }
        } 
        else if(qRespList.get(0).dd_Status__c == 'Complete' && qRespList.get(0).Assigned_to_User__c){
            //if(!ifNotClient){
            refreshButtonVisibility = false;
            assignToMeButtonVisibility = false;
            submitToClientButtonVisibility = false;
            completeButtonVisibility = false;
            saveButtonVisibility = false;
            counterpartyReviewButtonVisibility = false;
            counterpartyReviewButtonVisibility = false;
            counterpartySubmissionButtonVisibility = false;
            recallButtonVisibility = false;
            /*}
            else{
                refreshButtonVisibility = false;
                assignToMeButtonVisibility = false;
                submitToClientButtonVisibility = false;
                completeButtonVisibility = false;
                saveButtonVisibility = false;
                counterpartyReviewButtonVisibility = false;
            }*/
        } 
    }            
     
     /**
         This method refreshes the page
     */
     public Pagereference refreshPage() { 
         Pagereference pg = new Pagereference('/'+this.qResp.Id);
         pg.setRedirect(true);
         return pg;
     }
     
     /**
         This method redirects to a page where owner can be changed
     */
     public Pagereference changeOwner() { 
         Pagereference pg = new Pagereference('/'+this.qResp.Id+'/a?retURL=/'+this.qResp.Id);
         pg.setRedirect(true);
         return pg;
     }
    
     public Pagereference counterpartyReview() { 
        Pagereference pg;
        List<dd_Questionnaire_Response__c> qRespList = [select Id , dd_Status__c, Questionnaire_remaining_by_Client__c, dd_Assessment__r.Status, 
                                                        Questions_For_Counterparty_review__c, Questionnaire_remaining_by_RAG__c, dd_Assessment__r.Account.ParentId 
                                                        from dd_Questionnaire_Response__c where Id =: qResp.Id];
        system.debug('qRespList :: '+qRespList);
        
         if(!qRespList.isEmpty() && qRespList.size() == 1 &&  qRespList.get(0).Questions_For_Counterparty_review__c > 0){          
             qRespList.get(0).dd_Status__c = 'Counterparty Review';
             update qRespList.get(0);
             pg = new Pagereference('/'+this.qResp.Id);
             pg.setRedirect(true);
             return pg;
         }
         else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Question is selected for Counterparty Review'));
             return null;
         }
	      return null;  
     }
    
    public Pagereference counterpartySubmission() { 
        Pagereference pg;
        List<dd_Questionnaire_Response__c> qRespList = [select Id , dd_Status__c, Questionnaire_remaining_by_Client__c, dd_Assessment__r.Status, OwnerId, 
                                                        Questions_For_Counterparty_review__c, Questionnaire_remaining_by_RAG__c, dd_Assessment__r.Account.ParentId 
                                                        from dd_Questionnaire_Response__c where Id =: qResp.Id];
        system.debug('qRespList :: '+qRespList);               
         if(!qRespList.isEmpty() && qRespList.size() == 1){
             List<User> qRespOwner = [select Id, UserType from User where Id =: qRespList.get(0).OwnerId];
             if(qRespOwner!=null && qRespOwner.size() > 0){
                 if(qRespOwner.get(0).userType.equals('PowerPartner')){
                     qRespList.get(0).dd_Status__c = 'Completed by RAG';
                 }
                 else{
                     qRespList.get(0).dd_Status__c = 'Submitted';
                 }                 
             }
             
             update qRespList.get(0);
             pg = new Pagereference('/'+this.qResp.Id);
             pg.setRedirect(true);
             return pg;
         }         
	      return null;  
     }        
    
    public Pagereference markCompleted() { 
        
        List<dd_Questionnaire_Response__c> qRespList = [select Id , dd_Status__c, Questionnaire_remaining_by_Client__c, dd_Assessment__r.Status,
                                                        Questionnaire_remaining_by_RAG__c, dd_Assessment__r.Account.ParentId 
                                                        from dd_Questionnaire_Response__c where Id =: qResp.Id];
        system.debug('qRespList :: '+qRespList);
        Pagereference pg;
        if(!qRespList.isEmpty() && qRespList.size() == 1 &&  qRespList.get(0).Questionnaire_remaining_by_Client__c == 0
          && qRespList.get(0).Questionnaire_remaining_by_Client__c == 0){ 
              qRespList.get(0).dd_Status__c = 'Complete';
              update qRespList.get(0);
              qRespList.get(0).dd_Assessment__r.Status  = 'Ready For Submission';              
              update qRespList.get(0).dd_Assessment__r;              
              pg = new Pagereference('/'+this.qResp.Id);
              pg.setRedirect(true);
              return pg;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'All questions are not completed'));
            return null;
        }
	      return null;  
     }
    
    private void initiateCaseApprovalProcess(Id caseId){
        System.debug('initiateCaseApprovalProcess :: ');        
        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
        approvalRequest.setComments('Case Submitted for approval');
        approvalRequest.setObjectId(caseId);
        Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
        System.debug('offer submitted for approval successfully: '+approvalResult .isSuccess());
    }
    
    /**
         This method validated if all RAG questionnaires are completed  and then assigns ownership to client
     */
     public Pagereference submitToClient() { 
         String partnerQueueToShareWith;
         Pagereference pg ;
         //String ;
         //dd_Questionnaire_Response__Share shr;
         //String verificationTeamQueueId;         
         List<dd_Questionnaire_Response__c> qRespList = [select Id , dd_Status__c, Questionnaire_remaining_by_RAG__c, Assigned_to_User__c,
                                                         dd_Assessment__r.Account.ParentId, dd_Assessment__r.Status
                                                         from dd_Questionnaire_Response__c where Id =: qResp.Id];
         system.debug('qRespList :: '+qRespList);
         List<DGL__c> accountGroupList = DGL__c.getall().values(); 
         if(!qRespList.isEmpty() && qRespList.size() == 1 &&  qRespList.get(0).Questionnaire_remaining_by_RAG__c == 0){      
             //qRespList.get(0).OwnerId = partnerQueueToShareWith;
             qRespList.get(0).dd_Status__c = 'Completed by RAG';
             //qRespList.get(0).Assigned_to_User__c = false;
             update qRespList.get(0);
             if(qRespList.get(0).dd_Assessment__r.Account.ParentId == Label.WLSanofiaccountId){
                 initiateCaseApprovalProcess(qRespList.get(0).dd_Assessment__r.Id);
             }
             pg = new Pagereference('/'+qRespList.get(0).Id);
             pg.setRedirect(true);
             return pg;
             /*for(DGL__c accountGroupVal : accountGroupList){
                 if(accountGroupVal.Account__c.equals(String.valueOf(qRespList.get(0).dd_Assessment__r.Account.ParentId).subString(0,15)+'__CL_COMPLIANCE_TEAM_QUE')){
                        partnerQueueToShareWith = accountGroupVal.Group__c;
                        break;
                 }                
             }*/
             //ystem.debug('partnerQueueToShareWith :: '+partnerQueueToShareWith);
             //system.debug('verificationTeamQueueId :: '+verificationTeamQueueId);
         } 
         else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'All questions are not completed'));
             return null;
         }
         /*if(partnerQueueToShareWith != null){
             qRespList.get(0).OwnerId = partnerQueueToShareWith;
             qRespList.get(0).dd_Status__c = 'Completed by RAG';
             update qRespList.get(0);
             pg = new Pagereference('/'+qRespList.get(0).Id);
             pg.setRedirect(true);
             return pg;*/
             //qRespList.get(0).dd_Assessment__r.Status = 'Completed by RAG';
             
             //update qRespList.get(0).dd_Assessment__r;
             /*if(!qRespList.isEmpty() && qRespList.size() == 1){
                 for(DGL__c dglVal : accountGroupList){
                     if(dglVal.Account__c.equals(String.valueOf(qRespList.get(0).dd_Assessment__r.Account.ParentId).subString(0,15)+'__RA_VERIFICATION_TEAM_QUE')){
                         verificationTeamQueueId = dglVal.Group__c;
                         break;
                     }            
                 } 
             }             
             system.debug('verificationTeamQueueId :: '+verificationTeamQueueId);*/
             /*if(verificationTeamQueueId != null){
                 shr = new dd_Questionnaire_Response__Share(UserOrGroupId=verificationTeamQueueId, ParentId = qRespList.get(0).id, AccessLevel = 'read');
                 try{
                     system.debug('shr :: '+shr);
                     insert shr;                                          
                 }
                 catch(Exception ex){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Exception while trying to share Questionnaire response with Partner/Verification team'));
                     system.debug('Exception while trying to share Questionnaire response with Partner/Verification team ');                
                 }
             }*/            
         /*}
         else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to find client compliance queue'));
         }*/
         return null;
     }
    
    /**
         This method changes the ownership to logged in user and share back with verification team in read only format
     */
     public Pagereference changeOwnerToMe() { 
         String verificationTeamQueueId;
         String partnerUserGroupId;
         List<dd_Questionnaire_Response__Share> shrList = new List<dd_Questionnaire_Response__Share>();
         List<dd_Questionnaire_Response__c> qRespList = [select Id, OwnerId, dd_Status__c, Assigned_to_User__c, dd_Assessment__r.Account.ParentId from dd_Questionnaire_Response__c where Id =: qResp.Id];
         system.debug('qRespList :: '+qRespList);
         List<DGL__c> accountGroupList = DGL__c.getall().values();              
         system.debug('accountGroupList :: '+accountGroupList);
         if(!qRespList.isEmpty() && qRespList.size() == 1){
             for(DGL__c dglVal : accountGroupList){
                 if(dglVal.Account__c.equals(String.valueOf(qRespList.get(0).dd_Assessment__r.Account.ParentId).subString(0,15)+'__RA_VERIFICATION_TEAM_QUE')){
                     verificationTeamQueueId = dglVal.Group__c;
                     //break;
                 } 
                 if(dglVal.Account__c.equals(String.valueOf(qRespList.get(0).dd_Assessment__r.Account.ParentId).subString(0,15)+'__CL_PARTNER_USER_ROLE')){
                     partnerUserGroupId = dglVal.Group__c;
                }
             } 
         }
         system.debug('verificationTeamQueueId :: '+verificationTeamQueueId);
         system.debug('partnerUserGroupId :: '+partnerUserGroupId);
         if(verificationTeamQueueId != null && partnerUserGroupId != null){
         	Id userId = UserInfo.getUserId();
            qRespList.get(0).Assigned_to_User__c = true;
         	qRespList.get(0).OwnerId = userId;
            //qRespList.get(0).dd_Status__c = 'In Progress';
         	update qRespList.get(0);
             dd_Questionnaire_Response__Share shr = new dd_Questionnaire_Response__Share(UserOrGroupId=verificationTeamQueueId, ParentId = qRespList.get(0).id, AccessLevel = 'edit');
             dd_Questionnaire_Response__Share shr1 = new dd_Questionnaire_Response__Share(UserOrGroupId=partnerUserGroupId, ParentId = qRespList.get(0).id, AccessLevel = 'read');
             shrList.add(shr);
             shrList.add(shr1);
         }
         else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to find verification or partner user queue'));
         }
         if(!shrList.isEmpty()){
             try{
                 insert shrList;
             }
             catch(Exception ex){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Exception while trying to share Questionnaire response with Partner/Verification team'));
                 system.debug('Exception while trying to share Questionnaire response with Partner/Verification team ');                
             }
         }
         Pagereference pg = new Pagereference('/'+qRespList.get(0).Id);
         pg.setRedirect(true);
         return pg;
     }
 
     /*  This is an action method responsible for saving changes for Question records. 
         After records are saves, user is redirected to the same page.
     */
     public void saveChanges() { 
         List<Id> failedQuestionsId = new List<Id>(); 
         system.debug('qList :: '+qList);
         String errorMessage = '';
         try{             
             Database.SaveResult[] srList = Database.update(qList, false);
             for (Database.SaveResult sr : srList) { 
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else { 
                    failedQuestionsId.add(sr.getId());
                    system.debug('sr.getId() :: '+sr.getId());
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        errorMessage += err.getMessage()+'. ';
                        System.debug('Questions fields that affected this error: ' + err.getFields());                        
                    }
                }
            }
            if(failedQuestionsId.size()>0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);//Same old drama 
                ApexPages.addMessage(myMsg);
                List<dd_Questions__c> failedQuestionsList = [select Id, Name from dd_Questions__c  where Id in: failedQuestionsId];  
                system.debug('failedQuestionsList :: '+failedQuestionsList);            
                for(dd_Questions__c failedQuestionsVal: failedQuestionsList){
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,' : '+failedQuestionsVal.Name);//Same old drama 
                    ApexPages.addMessage(myMsg1);
                }
                
            }
         }
         catch(DMLException dmlex){
             system.debug('Exception occurred while upserting Question :: '+dmlex.getMessage());
             //qList.get(0).dd_Verification_Status__c.addError('You do not have necessary permissions');
             
             
             //refreshPage();
         }
      
     }
}