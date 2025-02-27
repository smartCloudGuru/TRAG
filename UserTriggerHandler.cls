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

 Code purpose  : a. This class identifies the role of a Partner User on its creation and assign it a specific queue.
                 b. If the Partner user role is updated, user is added/removed to a specific queue.
                 c. Depending on the Partner user's functional account license, relevant permission sets are assigned
                 d. Assign Users to Client specific report groups.


 Birthday      : 01/09/2014
 Api version   : v30

 ****************************************************************************************************************************/


public class UserTriggerHandler {

     public boolean checkLicense(List<User> newUserList){
         Map<Id, List<User>> accountId_RelatedActiveUsers_Map = new Map<Id, List<User>>();
         //Map<Id, List<User>> accountId_RelatedInActiveUsers_Map = new Map<Id, List<User>>();
         Set<Id> accIdSet = new Set<Id>();
         Integer tempActiveUser = 0;
         //Integer tempInActiveUser = 0;
         Map<Id, Integer> accountId_RemainingLicense_Map = new Map<Id, Integer>();
         List<User> userQueriedList1;
         List<User> userQueriedList = [select Id, contactId, contact.AccountId, isActive,
                                       contact.Account.DD_User_Licenses__c from User where Id in: newUserList
                                      and UserType = 'PowerPartner'];
                           
         system.debug('userQueriedList :: '+userQueriedList);
         if(userQueriedList != null && userQueriedList.size() > 0){
             for(User userQueriedVal : userQueriedList){
                 system.debug('userQueriedVal :: '+userQueriedVal);
                 if(!accIdSet.contains(userQueriedVal.contact.AccountId)){
                     accIdSet.add(userQueriedVal.contact.AccountId);
                 }
                 
             }         
             
             userQueriedList1 = [select Id, isActive, contactId, contact.AccountId, contact.Account.DD_User_Licenses__c from User where contact.AccountId in: accIdSet];
                                          
             for(User userQueriedVal : userQueriedList1){
                 if(userQueriedVal.isActive){
                     if(!accountId_RelatedActiveUsers_Map.containsKey(userQueriedVal.contact.AccountId)){                         
                         accountId_RelatedActiveUsers_Map.put(userQueriedVal.contact.AccountId, new List<User>{userQueriedVal});
                     }
                     else{
                         accountId_RelatedActiveUsers_Map.get(userQueriedVal.contact.AccountId).add(userQueriedVal);                 
                     }
                 }
                 /*else{
                     if(!accountId_RelatedInActiveUsers_Map.containsKey(userQueriedVal.contact.AccountId)){                         
                         accountId_RelatedInActiveUsers_Map.put(userQueriedVal.contact.AccountId, new List<User>{userQueriedVal});
                     }
                     else{
                         accountId_RelatedInActiveUsers_Map.get(userQueriedVal.contact.AccountId).add(userQueriedVal);                 
                     }
                 }*/
                 
             }
             //system.debug('accountId_RelatedInActiveUsers_Map :: '+accountId_RelatedInActiveUsers_Map);
             system.debug('accountId_RelatedActiveUsers_Map :: '+accountId_RelatedActiveUsers_Map);
             
             for(User userVal : userQueriedList){
                 if(accountId_RelatedActiveUsers_Map.size() == 0){
                     tempActiveUser = 0;
                 }
                 else{
                     tempActiveUser = accountId_RelatedActiveUsers_Map.get(userVal.Contact.AccountId).size();
                 }
                 /*if(accountId_RelatedInActiveUsers_Map.size() == 0){
                     tempInActiveUser = 0;
                 }
                 else{
                     tempInActiveUser = accountId_RelatedInActiveUsers_Map.get(userVal.Contact.AccountId).size();
                 }*/
                 if(tempActiveUser > userVal.contact.Account.DD_User_Licenses__c){
                     system.debug('Licenses Exceeded'); 
                     return false;                                                          
                 }
                 else{
                     accountId_RemainingLicense_Map.put(userVal.contact.AccountId, tempActiveUser);
                     //userVal.contact.Account.DD_User_Licenses_Used__c = accountId_RelatedActiveUsers_Map.get(userVal.Contact.AccountId).size();
                     //accountsLicenseToUpdate.add(userVal.contact.Account);
                 }
             }             
         }      
         if(accountId_RemainingLicense_Map.size() > 0){
             UserTriggerHandler.updateAccountsLicense(accountId_RemainingLicense_Map);
         }
         return true;         
     }
    
    @future
    public static void updateAccountsLicense(Map<Id, Integer> accountId_RemainingLicense_Map){
        system.debug('accountId_RemainingLicense_Map :: '+accountId_RemainingLicense_Map);
        List<Account> accountToUpdateList = new List<Account>();
        for(Account acc : [select Id, DD_User_Licenses_Used__c from Account where Id in: accountId_RemainingLicense_Map.keySet()]){
            acc.DD_User_Licenses_Used__c = accountId_RemainingLicense_Map.get(acc.Id);
            accountToUpdateList.add(acc);
        }   
        system.debug('accountToUpdateList :: '+accountToUpdateList);
        update accountToUpdateList;
    }
    
    /**
        On after insert of User
        This method identifies the role of a Partner User on its creation, identifies the Client specific group
        and depending on the Partner user's functional account license, relevant permission sets are assigned
    */
    public void afterInsert(List<User> newUserList){
        
        system.debug('UserTriggerHandler :: afterInsert :: start');
        List<Id> userIdList = new List<Id>();
        List<Id> userRoleIdList = new List<Id>();
        List<Id> userIdToComplianceQueueList = new List<Id>();
        List<Id> userIdToGeneralCounselQueueList = new List<Id>();
        List<Id> userIdToHeadOfComplainceQueueList = new List<Id>();
        List<Id> userIdToWatchListAccQueueList = new List<Id>();
        Map<Id, User> contactIdUserMap = new Map<Id, User>();
        List<Contact> contactListToUpdate = new List<Contact>();
        Id questionnaire;
        Id counterpartyApplication;
        Id verification;
        Map<Id, Id> userIdProfileIdMap = new Map<Id, Id>();
        Map<Id, String> userIdProfileNameMap = new Map<Id, String>();
        Map<Id, Id> userIdUserRoleMap = new Map<Id, Id>();
        Map<Id, String> userRoleIdUserRoleNameMap = new Map<Id, String>();
        Map<Id, String> userIdReportGroupIdNameMap = new Map<Id, String>();
        Id complianceTeamQueueId;
        Id watchListAccQueueId;
        Id generalCounselQueueId;
        Id headOfComplianceQueueId;
        Id sharedGroupId;
        List<String> psNameList = new String[]{'DD_Questionnaire','DD_Counterparty_Application','DD_Verification_Application'};         
        list <PermissionSetAssignment> psAssignments = new list <PermissionSetAssignment>();
        Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
        for(User newUserVal : newUserList){
            userIdList.add(newUserVal.Id);
            userIdProfileIdMap.put(newUserVal.ProfileId, newUserVal.Id);
            userRoleIdList.add(newUserVal.UserRoleId);
            userIdUserRoleMap.put(newUserVal.Id, newUserVal.UserRoleId);
            if(newUserVal.userType.equals('CspLitePortal')){
                contactIdUserMap.put(newUserVal.ContactId, newUserVal);
            }
        }
        
        if(!checkLicense(newUserList)){
            Trigger.new[0].addError(' License Limit Exceeded. All of your user licenses are currently in use by active users. Please contact the LUMA account team to increase your license limit via email at luma@riskadvisory.net. Click cancel to return to the previous page.');
        }
        
        List<Contact> queriedContactList = [select Id, MailingStreet , MailingCity , MailingState , MailingPostalCode , MailingCountry , Phone from Contact where Id in: contactIdUserMap.keySet()];
        
        for(Contact queriedContactVal : queriedContactList){
            queriedContactVal.MailingStreet = contactIdUserMap.get(queriedContactVal.Id).Street;
            queriedContactVal.MailingCity = contactIdUserMap.get(queriedContactVal.Id).City;
            queriedContactVal.MailingState = contactIdUserMap.get(queriedContactVal.Id).State;
            queriedContactVal.MailingPostalCode = contactIdUserMap.get(queriedContactVal.Id).PostalCode;
            queriedContactVal.MailingCountry = contactIdUserMap.get(queriedContactVal.Id).Country;
            queriedContactVal.Phone = contactIdUserMap.get(queriedContactVal.Id).Phone;
            contactListToUpdate.add(queriedContactVal);
        }
        
        if(contactListToUpdate.size()>0){
            update contactListToUpdate;
        }
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Id in: userIdProfileIdMap.KeySet()];
        for(Profile profileVal : profileList){
            userIdProfileNameMap.put(userIdProfileIdMap.get(profileVal.Id), profileVal.Name);  
        }  
            
        List<User> queriedUserList = [select Id, UserType, Contact.AccountId, Contact.Account.name, Contact.Account.DD_Due_Diligence_Portal_Licence__c, 
                                      Contact.Account.Watchlist_Client__c from User where Id in: userIdList];
        
        List<Queue__c> queueCustomSettingList = Queue__c.getall().values();
        
        List<DGL__c> dglCustomSettingList = DGL__c.getall().values();
        
        List<DD_Folder_Permission__c> folderPermissionSettingList = DD_Folder_Permission__c.getall().values();
        
        
        
        for(Queue__c queueVal : queueCustomSettingList){
            if(queueVal.Name.equals('CL GENERAL COUNSEL')){
                generalCounselQueueId = queueVal.Id__c;
            }
            else if(queueVal.Name.equals('CL HEAD OF COMPLIANCE')){
                headOfComplianceQueueId = queueVal.Id__c;
            }
        }   
        List<UserRole> userRoleList = [Select Id, Name From UserRole where Id in: userRoleIdList];
        
        for(UserRole userRoleVal : userRoleList){
            userRoleIdUserRoleNameMap.put(userRoleVal.Id, userRoleVal.Name);
        }                
        
        for(User queriedUserVal : queriedUserList){   
            for(DGL__c dglCustomSettingVal : dglCustomSettingList){
                String val;
                if(queriedUserVal.Contact != null && queriedUserVal.Contact.AccountId != null){
                    val = String.valueOf(queriedUserVal.Contact.AccountId).subString(0,15);                
                    if(dglCustomSettingVal.Account__c.equals(val+'__CL_WL_TEAM_QUE')){
                        watchListAccQueueId = dglCustomSettingVal.Group__c;
                    }   
                }
            }
           if(queriedUserVal!=null && queriedUserVal.UserType!=null && queriedUserVal.UserType.equals('PowerPartner')){  
               if(queriedUserVal.Contact!=null && queriedUserVal.Contact.Account!=null 
                  && queriedUserVal.Contact.Account.name !=null
                  && queriedUserVal.Contact.Account.Watchlist_Client__c){
                      psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('Enable Watchlist').PermissionSetId__c));
                      userIdToWatchListAccQueueList.add(queriedUserVal.Id);
                  } 
               if(queriedUserVal.Contact!=null && queriedUserVal.Contact.Account!=null  
                  && queriedUserVal.Contact.Account.name !=null
                  && queriedUserVal.Contact.Account.name.contains(Label.DDCastoramaAccountName)){
                      psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('Castorama').PermissionSetId__c));
                  } 
               if(queriedUserVal.Contact!=null && queriedUserVal.Contact.Account!=null 
                       && queriedUserVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c!=null
                       && queriedUserVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c.equals('Platform')){
                           psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('Enable Billing Account').PermissionSetId__c));
                           /*if(userIdProfileNameMap.get(queriedUserVal.Id)!=null && 
                              userIdProfileNameMap.get(queriedUserVal.Id).equals('Client Admin User')){
                                  psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Platform').PermissionSetId__c));
                              }    */               
                       }
               else if(queriedUserVal.Contact!=null && queriedUserVal.Contact.Account!=null 
                       && queriedUserVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c!=null
                       && queriedUserVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c.equals('Counterparty Application')){
                           psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('Enable Accounts Tab').PermissionSetId__c));                           
                           if(userIdProfileNameMap.get(queriedUserVal.Id)!=null && 
                              userIdProfileNameMap.get(queriedUserVal.Id).equals('Client Admin User')){
                                  psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Counterparty').PermissionSetId__c));
                              }
                           else{ 
                               //psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Platform').PermissionSetId__c));
                               psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('USER Counterparty').PermissionSetId__c));
                           }
                       }
               else if(queriedUserVal.Contact!=null && queriedUserVal.Contact.Account!=null 
                       && queriedUserVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c!=null
                       && queriedUserVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c.equals('Counterparty Application with Questionnaire')){
                           psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('Enable Accounts Tab').PermissionSetId__c));
                           if(userIdProfileNameMap.get(queriedUserVal.Id)!=null && 
                              userIdProfileNameMap.get(queriedUserVal.Id).equals('Client Admin User')){
                                  psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Counterparty').PermissionSetId__c));
                                  psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Questionnaire').PermissionSetId__c));
                              }
                           else{
                               //psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Platform').PermissionSetId__c));
                               psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('USER Counterparty').PermissionSetId__c));
                               psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('USER Questionnaire').PermissionSetId__c));
                           }
                   
               } 
               else if(queriedUserVal.Contact!=null && queriedUserVal.Contact.Account!=null 
                       && queriedUserVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c!=null
                       && queriedUserVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c.equals('Verification')){
                           psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('Enable Accounts Tab').PermissionSetId__c));
                           if(userIdProfileNameMap.get(queriedUserVal.Id)!=null && 
                              userIdProfileNameMap.get(queriedUserVal.Id).equals('Client Admin User')){
                                  psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Counterparty').PermissionSetId__c));
                                  psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Questionnaire').PermissionSetId__c));
                                  psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Verification').PermissionSetId__c));
                              }
                           else{
                               //psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('ADMIN Platform').PermissionSetId__c));
                               psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('USER Counterparty').PermissionSetId__c));
                               psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('USER Questionnaire').PermissionSetId__c));
                               psAssignments.add(new PermissionSetAssignment(AssigneeId = queriedUserVal.id, PermissionSetId = modulePermissionMap.get('USER Verification').PermissionSetId__c));
                           }                   
                       }
               
               for(DD_Folder_Permission__c folderPermissionSettingVal : folderPermissionSettingList){
                   String val = String.valueOf(queriedUserVal.Contact.AccountId).subString(0,15);
                   if(folderPermissionSettingVal.Client_Account__c.equals('SharedGroup')){
                       sharedGroupId = folderPermissionSettingVal.Report_Group_Id__c;
                   }
                   if(folderPermissionSettingVal.Client_Account__c.equals(val+'__CL_REPORT_GROUP_ID')){
                       userIdReportGroupIdNameMap.put(queriedUserVal.Id, folderPermissionSettingVal.Report_Group_Id__c);
                   }
               }
               
               for(DGL__c dglCustomSettingVal : dglCustomSettingList){
                   String val = String.valueOf(queriedUserVal.Contact.AccountId).subString(0,15);
                   if(dglCustomSettingVal.Account__c.equals(val+'__CL_COMPLIANCE_TEAM_QUE')){
                       complianceTeamQueueId = dglCustomSettingVal.Group__c;
                   }           
               }
           } 
            
            if(userRoleIdUserRoleNameMap!=null && userRoleIdUserRoleNameMap.size()>0 
                && userRoleIdUserRoleNameMap.get(userIdUserRoleMap.get(queriedUserVal.Id)) != null
                && userRoleIdUserRoleNameMap.get(userIdUserRoleMap.get(queriedUserVal.Id)).contains('Partner User')){
                    userIdToComplianceQueueList.add(queriedUserVal.Id);
            }
            else if(userRoleIdUserRoleNameMap!=null && userRoleIdUserRoleNameMap.size()>0 
                && userRoleIdUserRoleNameMap.get(userIdUserRoleMap.get(queriedUserVal.Id)) != null
                && userRoleIdUserRoleNameMap.get(userIdUserRoleMap.get(queriedUserVal.Id)).contains('Partner Executive')){
                    userIdToGeneralCounselQueueList.add(queriedUserVal.Id);
            }
            else if(userRoleIdUserRoleNameMap!=null && userRoleIdUserRoleNameMap.size()>0 
                && userRoleIdUserRoleNameMap.get(userIdUserRoleMap.get(queriedUserVal.Id)) != null
                && userRoleIdUserRoleNameMap.get(userIdUserRoleMap.get(queriedUserVal.Id)).contains('Partner Manager')){
                    userIdToHeadOfComplainceQueueList.add(queriedUserVal.Id);
            }
        }
        if(psAssignments.size()>0){
            insert psAssignments;
        }
        
        
        if(userIdToComplianceQueueList.size()>0 && complianceTeamQueueId !=null ){
            addUserToQueue(userIdToComplianceQueueList, complianceTeamQueueId);
        }
        if(userIdToGeneralCounselQueueList.size()>0){
            addUserToQueue(userIdToGeneralCounselQueueList, generalCounselQueueId);
        }
        
        if(userIdToHeadOfComplainceQueueList.size()>0){
            addUserToQueue(userIdToHeadOfComplainceQueueList, headOfComplianceQueueId);
        }
        
        if(userIdToWatchListAccQueueList.size()>0){
            addUserToQueue(userIdToWatchListAccQueueList, watchListAccQueueId);
        }
        
        addUserToGroup(userIdReportGroupIdNameMap, queriedUserList, sharedGroupId);
        addUserToDahsboarFolder(queriedUserList);
        
        system.debug('UserTriggerHandler :: afterInsert :: end');
    }
    
    private void addUserToDahsboarFolder(List<User> userList){
        
        Map<Id, String> userIdAcconutLicenseTypeMap = new Map<Id, String>();
        
        //List<User> userList = [select Id, UserType, Contact.AccountId, Contact.Account.DD_Due_Diligence_Portal_Licence__c from User where Id in: userIdList];        
        
        for(User userVal : userList){
            if(!String.isEmpty(userVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c)
                              && userVal.UserType != 'CspLitePortal'){
                userIdAcconutLicenseTypeMap.put(userVal.Id, userVal.Contact.Account.DD_Due_Diligence_Portal_Licence__c); 
            }
        }
        
        system.debug('userIdAcconutLicenseTypeMap :: '+userIdAcconutLicenseTypeMap);
        
        //List<Account> accountList = [select Id, DD_Due_Diligence_Portal_Licence__c from Account where Id =: accountId];
        //List<DD_Folder_Permission__c> fpList; 
        Id groupId;
        for(Id userId : userIdAcconutLicenseTypeMap.keySet()){
            if(userIdAcconutLicenseTypeMap.get(userId) == 'Platform'){                    
                groupId = DD_Folder_Permission__c.getAll().get('PlatformUserGroup').Report_Group_Id__c;                    
            }
            else if(!Test.isRunningTest() && (userIdAcconutLicenseTypeMap.get(userId) == 'Counterparty Application' 
                   || userIdAcconutLicenseTypeMap.get(userId) == 'Counterparty Application with Questionnaire'
                   || userIdAcconutLicenseTypeMap.get(userId) == 'Verification')){
                groupId = DD_Folder_Permission__c.getAll().get('NonPlatformUserGroup').Report_Group_Id__c;  
            }
            if(groupId!=null){
            	GroupMember gm = new GroupMember(GroupId = groupId, UserOrGroupId = userId);
                insert gm;
            } 
        }
        
        /*if(!accountList.isEmpty() && accountList.size() == 1){
            if(accountList.get(0).DD_Due_Diligence_Portal_Licence__c == 'Platform'){                    
                groupId = DD_Folder_Permission__c.getAll().get('PlatformUserGroup').Report_Group_Id__c;                    
            }
            else{
                groupId = DD_Folder_Permission__c.getAll().get('NonPlatformUserGroup').Report_Group_Id__c;  
            }
            if(groupId!=null){
            	GroupMember gm = new GroupMember(GroupId = groupId, UserOrGroupId = userId);
                insert gm;
            }            
        }  */                      
    }
    
    /**
        This method adds user to their identified groups
    */
    public void addUserToGroup(Map<Id, String> userIdReportGroupIdNameMap, List<User> queriedUserList, Id sharedGroupId){            
            List<GroupMember> gmList = new List<GroupMember>();            
        system.debug('userIdReportGroupIdNameMap :: '+userIdReportGroupIdNameMap);     
        system.debug('queriedUserList :: '+queriedUserList);     
        system.debug('sharedGroupId :: '+sharedGroupId);     
        for(Id userIdVal : userIdReportGroupIdNameMap.keySet()){
                    if(userIdReportGroupIdNameMap.get(userIdVal)!=null && userIdReportGroupIdNameMap.get(userIdVal)!=''){
                        GroupMember gm = new GroupMember();
                        gm.GroupId = userIdReportGroupIdNameMap.get(userIdVal);
                        gm.UserOrGroupId = userIdVal;
                        gmList.add(gm);
                    }
                }
        system.debug('gmList before :: '+gmList);
            if(sharedGroupId!=null && sharedGroupId!=''){
                for(User queriedUserVal : queriedUserList){
                    GroupMember gm = new GroupMember();
                    gm.GroupId = sharedGroupId;
                    gm.UserOrGroupId = queriedUserVal.Id;
                    gmList.add(gm);
                }
            }
        system.debug('gmList :: '+gmList);
            try{
                  if(gmList.size()>0){
                      insert gmList;
                  }
            }
            catch(exception e){
                  system.debug('Oops... QueueMemberHelper - AddUserToQueue - Error: ' + e);
            }
    }
    
    /**
        If the partner User role is updated, user is added/removed to a specific queue.
    */
    public void afterUpdate(List<User> newUserList, Map<Id, User> newUserMap, Map<Id, User> oldUserMap){
        
        List<Id> userIdList = new List<Id>();
        List<Id> userRoleIdList = new List<Id>();
        Id complianceTeamQueueId;
        Id generalCounselQueueId;
        Id headOfComplianceQueueId;
        List<Id> userIdToComplianceQueueList = new List<Id>();
        List<Id> userIdToGeneralCounselQueueList = new List<Id>();
        List<Id> userIdToHeadOfComplainceQueueList = new List<Id>();
        List<Id> userIdToBeRemovedFromExistingQueueList = new List<Id>();
        Map<Id, String> userRoleIdUserRoleNameMap = new Map<Id, String>();
        Map<Id, String> userId_PermissionSet_Map = new Map<Id, String> ();        
        /*List<User> standardSFUserList;*/
        
        List<User> queriedUserList = [select Id, UserType, Permission_Set__c, Contact.AccountId, Contact.Account.DD_Due_Diligence_Portal_Licence__c from User where Id in: newUserList];
        
        system.debug('queriedUserList :: '+queriedUserList);
        List<Queue__c> queueCustomSettingList = Queue__c.getall().values();
        
        List<DGL__c> dglCustomSettingList = DGL__c.getall().values();
        
        /*List<PermissionSetAssignment> permAssignmentList = [SELECT Id, PermissionSetId, AssigneeId from PermissionSetAssignment 
                                                            where AssigneeId in: queriedUserList and Assignee.UserType = 'Standard'];
        
        system.debug('permAssignmentList :: '+permAssignmentList);
        for(PermissionSetAssignment permAssignmentVal : permAssignmentList){
            if(userId_permissionSet_Map.get(permAssignmentVal.AssigneeId) != null){
                Set<Id> permissionSet = userId_permissionSet_Map.get(permAssignmentVal.AssigneeId);
                permissionSet.add(permAssignmentVal.PermissionSetId);
                userId_permissionSet_Map.put(permAssignmentVal.AssigneeId, permissionSet);
            }
            else{
                userId_permissionSet_Map.put(permAssignmentVal.AssigneeId, new Set<Id>{permAssignmentVal.PermissionSetId});
            }
        }
        
        system.debug('userId_permissionSet_Map :: '+userId_permissionSet_Map);*/
        
        if(!checkLicense(newUserList)){
        system.debug('Add Trigger Error');
            Trigger.new[0].addError(' You do not have enough licenses');
        }
        
        
        for(Queue__c queueVal : queueCustomSettingList){
            if(queueVal.Name!=null && queueVal.Name.equals('CL GENERAL COUNSEL')){
                generalCounselQueueId = queueVal.Id__c;
            }
            else if(queueVal.Name!=null && queueVal.Name.equals('CL HEAD OF COMPLIANCE')){
                headOfComplianceQueueId = queueVal.Id__c;
            }
        }
        for(User newUserVal : newUserList){
                userRoleIdList.add(newUserVal.UserRoleId);
        }
        
        List<UserRole> userRoleList = [Select Id, Name From UserRole where Id in: userRoleIdList];
        
        for(UserRole userRoleVal : userRoleList){
            userRoleIdUserRoleNameMap.put(userRoleVal.Id, userRoleVal.Name);
        }      
        
        for(User newUserVal : queriedUserList){            
            if(newUserVal.UserType!=null && newUserVal.UserType.equals('PowerPartner') 
                && userRoleIdUserRoleNameMap.get(newUserMap.get(newUserVal.Id).UserRoleId)!=null
                && newUserMap.get(newUserVal.Id).UserRoleId != oldUserMap.get(newUserVal.Id).UserRoleId){
                 if(userRoleIdUserRoleNameMap.get(newUserMap.get(newUserVal.Id).UserRoleId).contains('Partner Executive')){
                         userIdToBeRemovedFromExistingQueueList.add(newUserVal.Id);
                         userIdToGeneralCounselQueueList.add(newUserVal.Id);
                 }
                 else if(userRoleIdUserRoleNameMap.get(newUserMap.get(newUserVal.Id).UserRoleId).contains('Manager')){
                         userIdToBeRemovedFromExistingQueueList.add(newUserVal.Id);
                         userIdToHeadOfComplainceQueueList.add(newUserVal.Id);
                 }
                 else if(userRoleIdUserRoleNameMap.get(newUserMap.get(newUserVal.Id).UserRoleId).contains('Partner User')){
                         userIdToBeRemovedFromExistingQueueList.add(newUserVal.Id);   
                         userIdToComplianceQueueList.add(newUserVal.Id);                      
                 }
                 
                 for(DGL__c dglCustomSettingVal : dglCustomSettingList){
                   String val = String.valueOf(newUserVal.Contact.AccountId).subString(0,15);
                   if(dglCustomSettingVal.Account__c.equals(val+'__CL_COMPLIANCE_TEAM_QUE')){
                       complianceTeamQueueId = dglCustomSettingVal.Group__c;
                   }           
                }
            }
            
            if(oldUserMap.get(newUserVal.Id).Permission_Set__c != newUserMap.get(newUserVal.Id).Permission_Set__c
              && newUserMap.get(newUserVal.Id).isactive){                  
                   userId_PermissionSet_Map.put(newUserVal.Id, newUserVal.Permission_Set__c);
              }
        }
        
        if(userId_PermissionSet_Map.size() > 0){
            updatePermissionSetforCandidateUser(userId_PermissionSet_Map);
        }
        
        if(userIdToBeRemovedFromExistingQueueList.size()>0){
            List<GroupMember> grpMemberList = [Select UserOrGroupId, Id, GroupId From GroupMember where UserOrGroupId in: userIdToBeRemovedFromExistingQueueList];
            if(grpMemberList.size()>0){
                delete grpMemberList;
            }
        } 
        
        if(userIdToComplianceQueueList.size()>0 && complianceTeamQueueId != null){
            addUserToQueue(userIdToComplianceQueueList, complianceTeamQueueId);
        }
        
        if(userIdToGeneralCounselQueueList.size()>0){
            addUserToQueue(userIdToGeneralCounselQueueList, generalCounselQueueId);
        }
        
        if(userIdToHeadOfComplainceQueueList.size()>0){
            addUserToQueue(userIdToHeadOfComplainceQueueList, headOfComplianceQueueId);
        }    
                
        /*try{
            standardSFUserList = getUserWithSalesforceLicense(newUserList);        
            updateUsersPermissionSetAssignment(standardSFUserList);
        }
        catch(Exception ex){
            newUserList.get(0).addError('Unable to update permission set assignment for client Account Team');
        }*/
        
        
    }
    
    private void updatePermissionSetforCandidateUser(Map<Id, String> userId_PermissionSet_Map){
        Map<String, Id> permissionsetname_PermissionSetId_Map = new Map<String, Id>();
        list <PermissionSetAssignment> psAssignments = new list <PermissionSetAssignment>();
        List<Id> userList = new List<Id>();
        List<Id> usersToAddToGroup = new List<Id>();
        List<Id> usersToRemoveFromGroup = new List<Id>();
        userList.addAll(userId_PermissionSet_Map.keySet());
        List<String> permSetList;
        list <PermissionSetAssignment> existingAssignments = [Select PermissionSetId, Id, AssigneeId 
                                                              From PermissionSetAssignment where AssigneeId In: userId_PermissionSet_Map.keySet()
                                                             and (PermissionSetId =: Label.Candidate_Line_Manager or PermissionSetId =: Label.Candidate_Candidate_Reviewer
                                                                 or PermissionSetId =: Label.Candidate_Employee)];
        
        system.debug('existingAssignments :: '+existingAssignments);
        if(existingAssignments.size() > 0){
            try{
                delete existingAssignments;
            }
            catch(exception ex){
                system.debug('Error while adding permission set :: '+ex.getMessage());
            }
        }
        List<PermissionSet> candidatePermSetList = [select Id, label,  name from PermissionSet where Id =: Label.Candidate_Line_Manager or Id =: Label.Candidate_Candidate_Reviewer
                                                   or Id =: Label.Candidate_Employee];
        for(PermissionSet candidatePermSetVal : candidatePermSetList){
            permissionsetname_PermissionSetId_Map.put(candidatePermSetVal.label, candidatePermSetVal.Id);
        }
        system.debug('permissionsetname_PermissionSetId_Map :: '+permissionsetname_PermissionSetId_Map);        
        for(Id userId : userId_PermissionSet_Map.keySet()){
            if(userId_PermissionSet_Map.get(userId) != null){
                permSetList = userId_PermissionSet_Map.get(userId).split(';');
                system.debug('permSetList :: '+permSetList);
                for(String permsetVal : permSetList){
                    if(permissionsetname_PermissionSetId_Map.get(permsetVal) != null){
                        psAssignments.add(new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = permissionsetname_PermissionSetId_Map.get(permsetVal)));
                    }
                }
            }
        }
        system.debug('psAssignments :: '+psAssignments);
        if(psAssignments.size() > 0){
            try{
                upsert psAssignments;   
                for(PermissionSetAssignment psAssignment : psAssignments){
                    if(psAssignment.PermissionSetId != Label.Candidate_Employee){
                        usersToAddToGroup.add(psAssignment.AssigneeId);
                    }
                    else{
                        usersToRemoveFromGroup.add(psAssignment.AssigneeId);
                    }
                }                
            }
            catch(Exception ex){
                system.debug('Error while adding permission set :: '+ex.getMessage());
            }
        }
        if(usersToAddToGroup.size() > 0){
            addUserToQueue(usersToAddToGroup, Label.Candidate_reviewer_group);
        }
		
        if(usersToRemoveFromGroup.size() > 0){
            removeUserFromQueue(usersToRemoveFromGroup, Label.Candidate_reviewer_group);   
        }
    }
    
    /*private List<User> getUserWithSalesforceLicense(List<User> newUserList){
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);
        system.debug('profileIds :: '+profileIds);
        List<User> standardProfileUsers = [select id from user where profileId in:profileIds.Keyset() and id In: newUserList];
        system.debug('standardProfileUsers :: '+standardProfileUsers);
        
        return standardProfileUsers;
    }*/
    
    
    
    /**
        This method assigns user to idenfied queues
    */
    public void addUserToQueue(List<Id> userIdList, Id queueId){
            
            List<GroupMember> gmList = new List<GroupMember>();
            for(Id userIdVal : userIdList){
                GroupMember gm = new GroupMember();
                gm.GroupId = queueId;
                gm.UserOrGroupId = userIdVal;
                gmList.add(gm);
            }
            try{
                  if(gmList.size()>0){
                      insert gmList;
                  }
            }
            catch(exception e){
                  system.debug('Oops... QueueMemberHelper - AddUserToQueue - Error: ' + e);
            }
      }
    
    public void removeUserFromQueue(List<Id> userIdList, Id queueId){
        List<GroupMember> gmList = [Select UserOrGroupId, Id, GroupId From GroupMember g where UserOrGroupId in: userIdList and GroupId =: Label.Candidate_reviewer_group];
        system.debug('gmList :: '+gmList);
        if(gmList.size() > 0){
            delete gmList;
        }
    }
      
}