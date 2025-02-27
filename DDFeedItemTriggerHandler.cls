public class DDFeedItemTriggerHandler {
    
    public void afterInsert(List<FeedItem> newFeedItemList){
        
        system.debug('newFeedItemList :: '+newFeedItemList);
        
        Map<Id, Id> feedItemId_instructionId_Map = new Map<Id, Id>();
        Map<Id, Id> feedItemId_questionnaireResponseId_Map = new Map<Id, Id>();
        Map<Id, Id> feedItemFromCPId_questionnaireResponseId_Map = new Map<Id, Id>();
        Map<Id, Id> feedItemFromSCId_EngagementId_Map = new Map<Id, Id>();
        List<DD_Instruction__c> insList;
        List<dd_Questionnaire_Response__c> qRespList;
        List<dd_Questionnaire_Response__c> qRespCPList;
        List<SubcontractorEngagement__c> engagementSCList;
        Id loggedInUserId = Userinfo.getUserId();        
        List<User> usr = [select Id, UserType, DD_T_C_s_Accepted__c from User where Id =: loggedInUserId];
        
        system.debug('usr :: '+usr);
        
        for (FeedItem fi: newFeedItemList) {
            if (usr.get(0).UserType == 'PowerPartner' && fi.Type != 'TrackedChange'){
                if(fi.ParentID != null && String.valueOf(fi.ParentID).startsWith('a8u')){
                    feedItemId_instructionId_Map.put(fi.Id, fi.ParentID);   
                } 
                else if(fi.ParentID != null && String.valueOf(fi.ParentID).startsWith('a92')){
                    feedItemId_questionnaireResponseId_Map.put(fi.Id, fi.ParentID);
                }
            }
            if (usr.get(0).UserType == 'CspLitePortal' && fi.Type != 'TrackedChange'){                 
                if(fi.ParentID != null && String.valueOf(fi.ParentID).startsWith('a92')){
                    feedItemFromCPId_questionnaireResponseId_Map.put(fi.Id, fi.ParentID);
                }
                if(fi.ParentID != null && String.valueOf(fi.ParentID).startsWith('a5v')){
                    feedItemFromSCId_EngagementId_Map.put(fi.Id, fi.ParentID);
                }
            }
        }                
        
        system.debug('feedItemId_instructionId_Map :: '+feedItemId_instructionId_Map);
        system.debug('feedItemId_questionnaireResponseId_Map :: '+feedItemId_questionnaireResponseId_Map);
        system.debug('feedItemId_questionnaireResponseId_Map :: '+feedItemId_questionnaireResponseId_Map);
        system.debug('feedItemFromSCId_EngagementId_Map :: '+feedItemFromSCId_EngagementId_Map);
                
        if(feedItemId_instructionId_Map.size() > 0){
            insList = [select Id, DD_Status__c, Post_feed_added_by_Client__c from DD_Instruction__c where Id in: feedItemId_instructionId_Map.values() and DD_Status__c != 'New'];
            system.debug('insList :: '+insList);
            for(DD_Instruction__c insVal : insList ){
                insVal.Post_feed_added_by_Client__c = true;
            }
        }
        
		if(feedItemId_questionnaireResponseId_Map.size() > 0){
            qRespList = [select Id, Post_feed_added_by_Client__c from dd_Questionnaire_Response__c where Id in: feedItemId_questionnaireResponseId_Map.values()];
            system.debug('qRespList :: '+qRespList);
            for(dd_Questionnaire_Response__c qRespVal : qRespList ){
                qRespVal.Post_feed_added_by_Client__c = true;
            }
        }
        if(feedItemFromCPId_questionnaireResponseId_Map.size() > 0){
            qRespCPList = [select Id, Post_feed_added_by_Client__c from dd_Questionnaire_Response__c where Id in: feedItemFromCPId_questionnaireResponseId_Map.values()];
            system.debug('qRespCPList :: '+qRespCPList);
            for(dd_Questionnaire_Response__c qRespCPVal : qRespCPList ){
                qRespCPVal.Post_Feed_by_Counterparty__c = true;
            }
        } 
        if(feedItemFromSCId_EngagementId_Map.size() > 0){
            engagementSCList = [select Id, Post_feed_added_by_Subcontractor__c from SubcontractorEngagement__c where Id in: feedItemFromSCId_EngagementId_Map.values()];
            system.debug('engagementSCList :: '+engagementSCList);
            for(SubcontractorEngagement__c engagementSCVal : engagementSCList ){
                engagementSCVal.Post_feed_added_by_Subcontractor__c = true;
            }
        } 
        
        if(insList!=null && !insList.isEmpty()){
            update insList;
        }
        
        if(qRespList != null && !qRespList.isEmpty()){
            update qRespList;
        }
        
        if(qRespCPList != null && !qRespCPList.isEmpty()){
            update qRespCPList;
        }
        if(engagementSCList != null && !engagementSCList.isEmpty()){
            update engagementSCList;
        }
    }
}