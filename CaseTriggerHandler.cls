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

 Code purpose  : a. Create Questionnaire Response on Case creation which is created on Counterparty registration
                 b. Share Questionnaire response with Correct Partner with relevant read/write access
                 b. Update related contact with assessment closed date


 Birthday      : 06/06/2014
 Api version   : v30

 ****************************************************************************************************************************/

public class CaseTriggerHandler {

    /** 
        Before update Case Trigger
        This method create Questionnaire Response on Case creation 
        (in case of Counterparty registration or counterparty reassessment)
         
    */
    public void beforeUpdate(list<Case> caseList, Map<Id, Case> newMap,Map<Id, Case> oldMap){        
        
        system.debug('CaseTriggerHandler :: beforeUpdate :: start');
        List<dd_Questionnaire_Response__c> qRespList = new List<dd_Questionnaire_Response__c>();
        List<Risk_Model_2_Questionnaire_Response__c> qRespWLRMList = new List<Risk_Model_2_Questionnaire_Response__c>();
        List<Account> accountToUpdateList = new List<Account>();
        List<Id> contIdList = new List<Id>();
        Map<Id,Id> caseIdUserIdMap = new Map<Id,Id>();
        Map<Id,Id> caseId_AccountId_Map = new Map<Id,Id>();
        Map<Id,User> contactIdUserMap = new Map<Id, User>();
        String verificationTeamQueueId;
        String partnerQueueToShareWith;
        List<Account> accList = new List<Account>();
        Map<Id, Boolean> accId_watchlistapprovalstatus_map = new Map<Id, Boolean>();
        Map<Id, String> cpAccId_cpTypeName_Map = new Map<Id, String>();
        Map<Id, Account> cpAccId_cpAccount_Map = new Map<Id, Account>();
        Map<String, DD_Counterparty_Type__c> cpTypeName_cpType_Map = new Map<String, DD_Counterparty_Type__c>();
        List<DD_Counterparty_Type__c> cpTypeList;
        
        // Query the related Questionnaire response and contacts of the cases
        List<Case> queriedCaseList = [select Id, Status, Account.Recordtype.name, Account.Validity__c, Account.Counterparty_progress_status__c, Account.IsCounterpartyValid__c, 
                                      Account.DD_Validity_in_months__c, ContactId, OwnerId, DD_Counterparty_Type__c, AccountId,
                                      Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c, Contact.Account.Parent.Verification_by_Client_Only__c , 
                                      Send_Questionnaire__c, contact.Account.DD_Automated_Questionnaire__c,
                                            (Select Id From Questionnaire_Responses__r), Account.ParentId,
                                            DD_Questionnaire_Sent_Date__c , Contact.OwnerId from Case where Id in: caseList];        
        
        system.debug('queriedCaseList  :: '+queriedCaseList);
        
        if(!queriedCaseList.isEmpty()){ 
            for(Case cs : queriedCaseList){
                system.debug('cs  :: '+cs);
                system.debug('cs.Account  :: '+cs.Account);
                system.debug('cs.Account.Recordtype  :: '+cs.Account.Recordtype);
                system.debug('cs.Account.Recordtype.name  :: '+cs.Account.Recordtype.name);
                if(cs.AccountId != null){
                    if(cs.Account.Recordtype.name.contains('watchlist')){
                        caseId_AccountId_Map.put(cs.Id, cs.AccountId);
                    }
                }
                contIdList.add(cs.ContactId);                
            }
        }
        
        system.debug('caseId_AccountId_Map :: '+caseId_AccountId_Map);
        
        if(!caseId_AccountId_Map.values().isEmpty()){
            accList = [select id, (Select Id, Status__c, disabled__c From Watchlist_Search_Subject__r) from Account where Id in: caseId_AccountId_Map.values()];
        }
        system.debug('accList :: '+accList);
        
        if(accList != null){
            for(Account accVal : accList){
                boolean isApproved = true;
                for(Watchlist_Search_Subject__c wlVal : accVal.Watchlist_Search_Subject__r){
                    if(!wlVal.disabled__c && (wlVal.status__c == null || !wlVal.status__c.equalsIgnorecase('Approved'))){
                        isApproved = false;
                        break;
                    }
                }
                system.debug('isApproved :: '+isApproved);
                if(!isApproved){
                    accId_watchlistapprovalstatus_map.put(accVal.Id, false);
                }                        
            }
        }
        system.debug('accId_watchlistapprovalstatus_map :: '+accId_watchlistapprovalstatus_map);
        
        
        // Query the related Users from the contacts
        List<User> usrList = [select Id, ContactId from User where ContactId in: contIdList];        
        
        // Query to fetch the license type on the functional account
        List<Case> case1List = [select Id, ContactId, Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c 
                                        from Case where ContactId in: contIdList];
                                        
        for(User userVal : usrList){
            contactIdUserMap.put(userVal.ContactId, userVal);
        }
        
        for(Case caseVal : case1List){
            if(contactIdUserMap.get(caseVal.ContactId) != null){
                caseIdUserIdMap.put(caseVal.Id, contactIdUserMap.get(caseVal.ContactId).Id);
            }
        }
        
        List<DGL__c> accountGroupList = DGL__c.getall().values();  
        system.debug('accountGroupList :: '+accountGroupList);    
        system.debug('queriedCaseList.get(0) :: '+queriedCaseList.get(0));
        system.debug('queriedCaseList.get(0).Contact :: '+queriedCaseList.get(0).Contact);
        system.debug('queriedCaseList.get(0).Contact.Account :: '+queriedCaseList.get(0).Contact.Account);
        system.debug('queriedCaseList.get(0).Contact.Account.Parent :: '+queriedCaseList.get(0).Contact.Account.Parent);
        system.debug('queriedCaseList.get(0).Contact.Account.ParentId :: '+queriedCaseList.get(0).Contact.Account.ParentId);
        for(DGL__c dglVal : accountGroupList){
            if(!Test.isRunningTest() 
            && queriedCaseList.get(0).Contact.Account.ParentId != null 
               && dglVal.Account__c.equals(String.valueOf(queriedCaseList.get(0).Contact.Account.ParentId).subString(0,15)+'__RA_VERIFICATION_TEAM_QUE')){
                verificationTeamQueueId = dglVal.Group__c;
                break;
            }            
        } 
        
        system.debug('verificationTeamQueueId after dgl :: '+verificationTeamQueueId);        
        
        List<Queue__c> queueCustomSettingList = Queue__c.getall().values();
        if(verificationTeamQueueId == null){
            for(Queue__c queueVal : queueCustomSettingList){
                if(queueVal.Name.equals('Verification Team')){
                    verificationTeamQueueId = queueVal.Id__c; 
                }            
            }
        }
        
        User usr = [select Id, contactId, contact.AccountId from User where Id =: Userinfo.getUserId()];
        system.debug('usr :: '+usr);
        system.debug('usr.contactId :: '+usr.contactId);
        system.debug('usr.contact.AccountId :: '+usr.contact.AccountId);
        //List<DGL__c> accountGroupList = DGL__c.getall().values();         
        
        /* This is a critical functionity. If the functional account has a verification license then Client will only have
           read access and verification team has RW access on the questionnaire response. If functional account has not got verification license then Client
           will have RW access and verification team will not have any access on the questionnaire response.  
        */
        for(Case cs : queriedCaseList){
            /*if(newMap.get(cs.Id).Status!=null && newMap.get(cs.Id).Status.equals('Submitted') 
               && usr.Id != cs.OwnerId && !newMap.get(cs.Id).Assigned_to_User__c){
                   system.debug('1 :: ');
                newMap.get(cs.Id).addError(Label.Case_Submission_Error);
            }
            else *//*if(newMap.get(cs.Id).Status!=null && newMap.get(cs.Id).Status.contains('Submitted') 
               && accId_watchlistapprovalstatus_map.size() > 0
                    && !accId_watchlistapprovalstatus_map.get(cs.AccountId)){
                        system.debug('1.1 :: ');
                newMap.get(cs.Id).addError('Unapproved watchlist subjects');
            }
            else*/ if(newMap.get(cs.Id).Status != null && newMap.get(cs.Id).Status.equals('Submitted')){
                system.debug('1.2 :: ');
                cpAccId_cpTypeName_Map.put(newMap.get(cs.Id).AccountId, newMap.get(cs.Id).DD_Counterparty_Type__c);                
            }                
            else if(newMap.get(cs.Id).Status!=null 
                    && !oldMap.get(cs.Id).Status.equals('Approved')
                    && newMap.get(cs.Id).Status.equals('Approved')){
                system.debug('2 :: ');
                /*if(cs.Account.IsCounterpartyValid__c 
                   && cs.Account.Validity__c != null
                   && cs.Account.Validity__c != System.today().addMonths(Integer.valueOf(cs.Account.DD_Validity_in_months__c))){
                    system.debug('3 :: ');
                    cs.Account.Validity__c = cs.Account.Validity__c.addMonths(Integer.valueOf(cs.Account.DD_Validity_in_months__c));
                    cs.Account.Counterparty_progress_status__c = 'Approved';
                    accountToUpdateList.add(cs.Account);                                        
                }
                else{*/
                    if(cs.Account.DD_Validity_in_months__c!=null){
                        system.debug('4 :: ');
                        cs.Account.Validity__c = System.today().addMonths(Integer.valueOf(cs.Account.DD_Validity_in_months__c));
                        cs.Account.Counterparty_progress_status__c = 'Approved';
                        cs.Account.IsCounterpartyValid__c = true;
                        accountToUpdateList.add(cs.Account);
                    }
                //}
            }
            else if(newMap.get(cs.Id).Status!=null 
                    && !oldMap.get(cs.Id).Status.equals('Rejected')
                    && newMap.get(cs.Id).Status.equals('Rejected')){
                if(cs.Account.Validity__c != null){
                    cs.Account.Validity__c = cs.Account.Validity__c.addDays(-1);
                }
                cs.Account.Counterparty_progress_status__c = 'Rejected';
                cs.Account.IsCounterpartyValid__c = false;
                accountToUpdateList.add(cs.Account);                                        
            }
            system.debug('cs :: '+cs);  
            system.debug('cpAccId_cpTypeName_Map :: '+cpAccId_cpTypeName_Map);  
            
            if(!cpAccId_cpTypeName_Map.isEmpty()){
                for(Account acc  : [select Id, parentId, DD_Validity_in_months__c from Account 
                                    where Id in: cpAccId_cpTypeName_Map.keyset()]){
                   cpAccId_cpAccount_Map.put(acc.Id, acc);
                }
                
            }
            String lumaAccId;
            if(!Test.isRunningTest() 
               && queriedCaseList.get(0).ContactId != null && queriedCaseList.get(0).Contact.AccountId != null
               && queriedCaseList.get(0).Contact.Account.ParentId != null
               && String.valueOf(queriedCaseList.get(0).Contact.Account.ParentId).subString(0,15) == Label.WLSanofiaccountId){
                lumaAccId =  Label.WLSanofiaccountId;
            }
            else{
                lumaAccId = usr.contact.AccountId;
            }
            if(!cpAccId_cpTypeName_Map.isEmpty()){
                cpTypeList = [select Id, Name, Questionnaire_Name__c, Questionnaire_URL__c, DD_validity_in_months__c 
                                                from  DD_Counterparty_Type__c 
                                                where Name in: cpAccId_cpTypeName_Map.values() and Account__c =: lumaAccId]; 
            }            
            system.debug('cpTypeList :: '+cpTypeList);
            
            if(cpTypeList!= null && !cpTypeList.isEmpty()){
                for(DD_Counterparty_Type__c cpTypeVal : cpTypeList){
                    cpTypeName_cpType_Map.put(cpTypeVal.name, cpTypeVal);
                }
            }
            system.debug('cpTypeName_cpType_Map :: '+cpTypeName_cpType_Map);
            system.debug('cpAccId_cpAccount_Map :: '+cpAccId_cpAccount_Map);
            system.debug('cpAccId_cpTypeName_Map :: '+cpAccId_cpTypeName_Map);
            
            for(Id cpAccId : cpAccId_cpTypeName_Map.keyset()){
                system.debug('cpAccId_cpTypeName_Map.get(cpAccId) :: '+cpAccId_cpTypeName_Map.get(cpAccId));
                system.debug('cpAccId_cpAccount_Map.get(cpAccId) :: '+cpAccId_cpAccount_Map.get(cpAccId));
                system.debug('cpTypeName_cpType_Map.get(cpAccId_cpTypeName_Map.get(cpAccId)) :: '+cpTypeName_cpType_Map.get(cpAccId_cpTypeName_Map.get(cpAccId)));
                cpAccId_cpAccount_Map.get(cpAccId).DD_Validity_in_months__c = cpTypeName_cpType_Map.get(cpAccId_cpTypeName_Map.get(cpAccId)).DD_validity_in_months__c;
                accountToUpdateList.add(cpAccId_cpAccount_Map.get(cpAccId));
            }
            
            for(DGL__c accountGroupVal : accountGroupList){
                if(cs.Account!=null && cs.Account.ParentId != null && accountGroupVal.Account__c.equals(String.valueOf(cs.Account.ParentId).subString(0,15)+'__CL_COMPLIANCE_TEAM_QUE')){
                     partnerQueueToShareWith = accountGroupVal.Group__c;
                }
            }
            
            system.debug('partnerQueueToShareWith :: '+partnerQueueToShareWith);
            
            if(newMap.get(cs.Id).Send_Questionnaire__c 
               && newMap.get(cs.Id).DD_Questionnaire_Sent_Date__c == null 
               && newMap.get(cs.Id).Questionnaire_Responses__r.size()==0){
                dd_Questionnaire_Response__c qResp = new dd_Questionnaire_Response__c();
                qResp.dd_Assessment__c = cs.Id;
                if(!cs.Contact.Account.Parent.Verification_by_Client_Only__c && (cs.Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c.equals('Verification')
                  || cs.Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c.equals('Counterparty Application with Questionnaire'))){
                    qResp.ownerId = verificationTeamQueueId;
                }
                else{
                    qResp.ownerId = partnerQueueToShareWith;
                }
                qRespList.add(qResp);
            }
            
            if(newMap.get(cs.Id).Send_Questionnaire_WLRM__c 
               && newMap.get(cs.Id).Questionnaire_Sent_Date_WLRM__c == null 
               && newMap.get(cs.Id).Risk_Model_2_Questionnaire_Responses__r.size()==0){
                Risk_Model_2_Questionnaire_Response__c qRespWLRM = new Risk_Model_2_Questionnaire_Response__c();
                qRespWLRM.Case__c = cs.Id;               
                qRespWLRM.ownerId = partnerQueueToShareWith;
                qRespWLRMList.add(qRespWLRM);
            }
        }
        if(qRespList.size()>0){
            try{
                insert qRespList;
            }
            catch(Exception ex){
                system.debug('Exception while trying to insert Questionnaire Response ');                
            }
        }
        
        if(qRespWLRMList.size()>0){
            try{
                insert qRespWLRMList;
            }
            catch(Exception ex){
                system.debug('Exception while trying to insert Watchlist Risk Model 2 Questionnaire Response ');                
            }
        }
        system.debug('accountToUpdateList :: '+accountToUpdateList);
        if(accountToUpdateList.size()>0){
            try{
                update accountToUpdateList;
            }
            catch(Exception ex){
                system.debug('Exception while trying to update Account ');                
            }
        }
        
        for(dd_Questionnaire_Response__c qRespVal : qRespList){
            if(newMap.get(qRespVal.dd_Assessment__c).DD_Questionnaire_URL__c!=null && !newMap.get(qRespVal.dd_Assessment__c).DD_Questionnaire_URL__c.contains('responseid')){
                newMap.get(qRespVal.dd_Assessment__c).DD_Questionnaire_URL__c += '?responseid='+String.valueOf(qRespVal.Id).subString(0,15)+'&tfa_1='+String.valueOf(qRespVal.Id).subString(0,15);
                newMap.get(qRespVal.dd_Assessment__c).Status = 'Open';
            }
         }
        
        for(Risk_Model_2_Questionnaire_Response__c qRespWLRMVal : qRespWLRMList){
            if(newMap.get(qRespWLRMVal.Case__c).WL_Risk_Model_Questionnaire__c !=null && !newMap.get(qRespWLRMVal.Case__c).WL_Risk_Model_Questionnaire__c.contains('responseid')){
                newMap.get(qRespWLRMVal.Case__c).WL_Risk_Model_Questionnaire__c += '?responseid='+String.valueOf(qRespWLRMVal.Id).subString(0,15)+'&tfa_1='+String.valueOf(qRespWLRMVal.Id).subString(0,15);
                newMap.get(qRespWLRMVal.Case__c).Status = 'Open';
            }
         }
        
        List<dd_Questionnaire_Response__c> queriedQuestionnaireRespList = [select Id, dd_Assessment__r.Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c, 
                                    dd_Assessment__r.Contact.OwnerId, dd_Assessment__r.Contact.Account.CreatedById, dd_Assessment__r.Account.ParentId,
                                    dd_Assessment__r.Contact.Account.ParentId from dd_Questionnaire_Response__c 
                                    where Id in: qRespList];
        
        shareWithPartnerOrVerificationTeam(queriedQuestionnaireRespList, caseIdUserIdMap);
        system.debug('CaseTriggerHandler :: beforeUpdate :: end');
    }
    
    /**
        This method shares the questionnaire response with correct counterparty 
        and assigns ownerId of contact to the person who created counterparty account
    */
    public void shareWithPartnerOrVerificationTeam(List<dd_Questionnaire_Response__c> queriedQuestionnaireRespList, Map<Id,Id> caseIdUserMap){
        
        system.debug('CaseTriggerHandler :: shareWithPartnerOrVerificationTeam :: start');
        String recordSharingRoleId;
        List<dd_Questionnaire_Response__Share> shrList = new List<dd_Questionnaire_Response__Share>();
        Map<Id, String> questionnaireRespIdRecordShareId = new Map<Id, String>();
        List<DGL__c> accountGroupList = DGL__c.getall().values();
        
        //Share Questionnaire response with Partner User role
        for(dd_Questionnaire_Response__c queriedQuestionnaireRespVal : queriedQuestionnaireRespList){
            for(DGL__c accountGroupVal : accountGroupList){
                if(accountGroupVal.Account__c.equals(String.valueOf(queriedQuestionnaireRespVal.dd_Assessment__r.Account.ParentId).subString(0,15)+'__CL_PARTNER_USER_ROLE')){
                    questionnaireRespIdRecordShareId.put(queriedQuestionnaireRespVal.Id, accountGroupVal.Group__c);
                }
            }
        }
        
        system.debug('questionnaireRespIdRecordShareId :: '+questionnaireRespIdRecordShareId);
        
        try{
            if(queriedQuestionnaireRespList!=null && queriedQuestionnaireRespList.size()>0){
                queriedQuestionnaireRespList.get(0).dd_Assessment__r.Contact.OwnerId = queriedQuestionnaireRespList.get(0).dd_Assessment__r.Contact.Account.createdById;
                update queriedQuestionnaireRespList.get(0).dd_Assessment__r.Contact;
            }
            
            for(dd_Questionnaire_Response__c queriedQuestionnaireRespVal : queriedQuestionnaireRespList){
                dd_Questionnaire_Response__Share shr;
                if(queriedQuestionnaireRespVal.dd_Assessment__r.Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c.equals('Verification')
                  || queriedQuestionnaireRespVal.dd_Assessment__r.Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c.equals('Counterparty Application with Questionnaire')){                
                   shr = new dd_Questionnaire_Response__Share(UserOrGroupId=questionnaireRespIdRecordShareId.get(queriedQuestionnaireRespVal.Id), ParentId = queriedQuestionnaireRespVal.id, AccessLevel = 'edit');  
                }
                else{
                   shr = new dd_Questionnaire_Response__Share(UserOrGroupId=questionnaireRespIdRecordShareId.get(queriedQuestionnaireRespVal.Id), ParentId = queriedQuestionnaireRespVal.id, AccessLevel = 'read');  
                }
                system.debug('shr :: '+shr);
                shrList.add(shr);
            }                        
        }
        catch(Exception ex){
            system.debug('Exception while trying to update Questionnaire Response ');                
        }
        system.debug('shrList :: '+shrList);
        if(shrList.size()>0){
            try{
                insert shrList;
            }
            catch(Exception ex){
                system.debug('Exception while trying to share Questionnaire response with Partner/Verification team ');                
            }
        }
        system.debug('CaseTriggerHandler :: shareWithPartnerOrVerificationTeam :: End');
    }
    
    /**
        After update on Case
        This method update the last assessment date on the related contact
    */
    public void afterUpdate(list<Case> caseList){
        
        system.debug('CaseTriggerHandler :: afterUpdate :: start');
        List<Id> caseIdList = new List<Id>();
        List<Id> caseIdHOCSubmissionList = new List<Id>();
        List<Id> caseIdGCSubmissionList = new List<Id>();
        List<Contact> contactToBeUpdatedList = new List<Contact>();
        List<dd_Questionnaire_Response__c> qRespList = new List<dd_Questionnaire_Response__c>();
        
        for(Case cs : caseList){
            if(cs.Status.equals('Submitted to HOC')){
                caseIdHOCSubmissionList.add(cs.Id);
            }
            if(cs.Status.equals('Submitted to GC')){
                caseIdGCSubmissionList.add(cs.Id);
            }
            caseIdList.add(cs.Id);            
        }
        
        system.debug('caseIdHOCSubmissionList :: '+caseIdHOCSubmissionList);
        system.debug('caseIdGCSubmissionList :: '+caseIdGCSubmissionList);
        
        List<dd_Questionnaire_Response__c> queriedafterUPdateQuestionnaireRespList = [select Id, dd_Assessment__r.Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c, 
                                    dd_Assessment__r.Contact.OwnerId, dd_Assessment__r.Contact.Account.CreatedById, 
                                    dd_Assessment__r.Contact.Account.ParentId from dd_Questionnaire_Response__c 
                                    where dd_Assessment__r.Id in: caseIdList];
        
        system.debug('queriedafterUPdateQuestionnaireRespList :: '+queriedafterUPdateQuestionnaireRespList);
        
        // Query the related contact to get the last assessment date
        List<Case> queriedCaseList = [select Id, DD_Closed_Date__c, Contact.DD_Date_of_Last_Assessment__c 
                                                from Case where DD_Closed_Date__c!= null and Id in: caseIdList];
        
        for(Case queriedCaseVal : queriedCaseList){
            if(queriedCaseVal.Contact.DD_Date_of_Last_Assessment__c == null 
                    || queriedCaseVal.Contact.DD_Date_of_Last_Assessment__c < queriedCaseVal.DD_Closed_Date__c){
                    queriedCaseVal.Contact.DD_Date_of_Last_Assessment__c = queriedCaseVal.DD_Closed_Date__c;
                    contactToBeUpdatedList.add(queriedCaseVal.Contact); 
            }
        }
        
        if(contactToBeUpdatedList.size()>0){
            try{
                update contactToBeUpdatedList;
            }
            catch(Exception ex){
                system.debug('Exception while trying to update related contact ');
            }
        }
        if(caseIdHOCSubmissionList != null && caseIdHOCSubmissionList.size() > 0){
            DDUtility.getUsersWithAccess(caseIdHOCSubmissionList, 'CL_HEAD_OF_COMPLIANCE', 'Assessment_Approval');
        }
        if(caseIdGCSubmissionList != null && caseIdGCSubmissionList.size() > 0){
            DDUtility.getUsersWithAccess(caseIdGCSubmissionList, 'CL_GENERAL_COUNSEL', 'Assessment_Approval');
        }
        
        system.debug('CaseTriggerHandler :: afterUpdate :: End');        
    }
    
    
}