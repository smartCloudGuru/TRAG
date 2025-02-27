/**
This controller allows members to be added to client specific account team and then continue to create branding parameter
*/

public with sharing class DDOBCreateQueueMemberController {	
	
    public String accId{get;set;}
    public String accName{get;set;}
    public String queueId{get;set;}
    public pagereference pr;
    public pagereference pg;
    public boolean isUserAddedInQueue{get;set;}
    public String queueURL {get;set;}
    //public String queue {get;set;}
    public boolean isNonPlatform{get;set;}
    public String accTeamId {get;set;}
    public String verTeamId {get;set;}
    public String clientwlTeamId {get;set;}
    public String ragwlTeamId {get;set;}
    
    /**
    * Controller constructor
    * 1. Fetches URL parameters           
    * 2. Determines the next page URL         
    */ 
    public DDOBCreateQueueMemberController(){     
        system.debug('DDOBCreateQueueMemberController :: constructor :: start ');
        isNonPlatform = false;
        isUserAddedInQueue = false;
        accId = ApexPages.currentPage().getParameters().get('accId');  
        accName = ApexPages.currentPage().getParameters().get('accName');   
        accTeamId = ApexPages.currentPage().getParameters().get('accTeamQId');
        system.debug('accTeamId :: '+accTeamId);
        verTeamId = ApexPages.currentPage().getParameters().get('verTeamQId');
        system.debug('verTeamId :: '+verTeamId);
        clientwlTeamId = ApexPages.currentPage().getParameters().get('clientwlQId');
        system.debug('verTeamId :: '+verTeamId);
        ragwlTeamId = ApexPages.currentPage().getParameters().get('ragwlQId');
        system.debug('verTeamId :: '+verTeamId);
        if(ApexPages.currentPage().getParameters().get('verTeamQId') != null){
            isNonPlatform = true;
        }
        else{
        	isNonPlatform = false;
        }
        if(isNonPlatform){
            pg = new PageReference('/apex/DDOBBackgroundParameterSuccess');
        }
        else{
            pg = new Pagereference('/apex/DDOBThankyou?accId='+accId+'&accName='+accName);
        }
        /*queueURL = '/p/own/Queue/e?id='+queueId+'&retURL=/p/own/Queue/d?id='+queueId;*/
        
        system.debug('DDOBCreateQueueMemberController :: constructor :: end ');
    }
    
    /**
     * Action method to redirect user to add member to client specific account team queue     
    */
    public pagereference addUserToQueue(){
        system.debug('DDOBCreateQueueMemberController :: addUserToQueue :: start ');    
        system.debug('apexpages.currentpage().getParameters() :: '+apexpages.currentpage().getParameters());
        String queueType = apexpages.currentpage().getParameters().get('queue');
        system.debug('queueType :: '+queueType);        
        String retURL;
        if(queueType!=null && queueType.equals('accountTeamQueue')){
            queueId = accTeamId;
        }
        else if(queueType!=null && queueType.equals('verificationTeamQueue')){
            queueId = verTeamId;
        }
        else if(queueType!=null && queueType.equals('clientwlTeamQueue')){
            queueId = clientwlTeamId;
        }
        else if(queueType!=null && queueType.equals('ragwlTeamQueue')){
            queueId = ragwlTeamId;
        }
        if(verTeamId!=null){
            retURL='/apex/DDOBCreateQueueMember?accId='+accId+'&accName='+accName+'&accTeamQId='+accTeamId+'&verTeamQId='+verTeamId+'&clientwlQId='+clientwlTeamId+'&ragwlQId='+ragwlTeamId;
        }
        else{
            retURL='/apex/DDOBCreateQueueMember?accId='+accId+'&accName='+accName+'&accTeamQId='+accTeamId+'&clientwlQId='+clientwlTeamId+'&ragwlQId='+ragwlTeamId;
        }
        
        pr = new pagereference('/p/own/Queue/e?id='+queueId);
        pr.getParameters().put('retURL',retURL);
        pr.setRedirect(true);
        //queueURL = '/p/own/Queue/e?id='+queueId+'&retURL=/apex/DDOBCreateQueueMember?accId='+accId+'&accName='+accName+'&accTeamQId='+accTeamId+'&verTeamQId='+verTeamId;
        system.debug('DDOBCreateQueueMemberController :: addUserToQueue :: end ');
        return pr;
    }
    
    public pagereference moveForward(){
        if(checkMembers(accTeamId, 'accTeam') && checkMembers(verTeamId, 'verTeam')
          /*&& checkMembers(clientwlTeamId, 'verTeam') && checkMembers(ragwlTeamId, 'verTeam')*/){
            pg.getParameters().put('accId',accId);
            pg.getParameters().put('accName',accName);
            pg.setRedirect(true);
            return pg;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No user assigned to the queue'));
        }
        return null;
    }
    
    /**
     * Redirects user to success page. Displays an error page if there is no member in the account team queue 
    */
    public boolean checkMembers(String queueId, String team){
        system.debug('DDOBCreateQueueMemberController :: continueToSuccessPage :: start ');
        isUserAddedInQueue = false;
        List<GroupMember> grpMember;
        List<Group> grpList;
        List<Account> accList = [Select Id, DD_Due_Diligence_Portal_Licence__c from Account a where Id =: accId];
        grpList = [Select g.Name, g.Id, g.DeveloperName, (Select Id, UserOrGroupId, GroupId From GroupMembers) From Group g where Id =: queueId];
        if(grpList != null && grpList.size()>0){
            grpMember = grpList.get(0).GroupMembers;
            if(grpMember != null && grpMember.size()>0){
                isUserAddedInQueue = true;
                addPermissionSetAssignmentForTeamMember(accList, grpMember, team);  
                return true;
            }
            else{
                return false;
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No user assigned to the queue'));
            }
        }
        else if(queueId == null){
            return true;
        }
        else{
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No user assigned to the queue'));
            return false;
            }
        system.debug('DDOBCreateQueueMemberController :: continueToSuccessPage :: end ');
        return null;
    }
    
    private void addPermissionSetAssignmentForTeamMember(List<Account> accList, List<GroupMember> grpMembers, String team){
        List<PermissionSetAssignment> permAssignmentToAddList = new List<PermissionSetAssignment>();
        Set<Id> permissionSetToAddUserIdSet = new Set<Id>();
        List<Id> permissionSetToAddUserIdList = new List<Id>();
        Set<Id> permissionSetToRemoveUserIdSet = new Set<Id>();
        Id permissionSetId;
        system.debug('grpMembers :: '+grpMembers);
        
        for(GroupMember grpMember : grpMembers){
            permissionSetToAddUserIdSet.add(grpMember.UserOrGroupId);
        }
        
        system.debug('permissionSetToAddUserIdSet :: '+permissionSetToAddUserIdSet);
        
		Map<String, DD_Module_Permission_Sets_List__c> modulePermissionMap = DD_Module_Permission_Sets_List__c.getall();
        system.debug('modulePermissionMap :: '+modulePermissionMap);
        if(team.equals('verTeam') && (accList.get(0).DD_Due_Diligence_Portal_Licence__c.equals('Counterparty Application with Questionnaire')
          || accList.get(0).DD_Due_Diligence_Portal_Licence__c.equals('Verification'))){
            permissionSetId = modulePermissionMap.get('Verification Team Member').PermissionSetId__c;
        }
        else{
        	permissionSetId = modulePermissionMap.get('Client Account Team Member Instruction').PermissionSetId__c;
        }
        system.debug('permissionSetId :: '+permissionSetId);
        
        
        List<PermissionSetAssignment> permAssignmentToAddQ = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN : permissionSetToAddUserIdSet 
                                        /*AND PermissionSetId !=: catInstructionPermissionSetId*/];
        system.debug('permAssignmentToAddQ :: '+permAssignmentToAddQ);
        
        for(PermissionSetAssignment permAssignmentToAddVal : permAssignmentToAddQ){
            if(permAssignmentToAddVal.PermissionSetId == permissionSetId){
                permissionSetToRemoveUserIdSet.add(permAssignmentToAddVal.AssigneeId);
            }            
        }
        system.debug('permissionSetToRemoveUserIdSet :: '+permissionSetToRemoveUserIdSet);
        permissionSetToAddUserIdSet.removeAll(permissionSetToRemoveUserIdSet);
        permissionSetToAddUserIdList.addAll(permissionSetToAddUserIdSet);
        system.debug('permissionSetToAddUserIdList after  :: '+permissionSetToAddUserIdList);
        for(Id permissionSetToAddUserIdVal : permissionSetToAddUserIdList){
            	permAssignmentToAddList.add(new PermissionSetAssignment(AssigneeId = permissionSetToAddUserIdVal, PermissionSetId = permissionSetId));
        }
        system.debug('permAssignmentToAddList after  :: '+permAssignmentToAddList);
        
        if(permAssignmentToAddList.size() >0){
            insert permAssignmentToAddList; 
        }        
    }
    
}