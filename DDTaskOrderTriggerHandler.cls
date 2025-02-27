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

 Code purpose  : a. Create TaskOrder by pre populating fields from Opportunity
                 b. Update the Instruction related to the task order on the status chage of Task Order


 Birthday      : 15/05/2014
 Api version   : v29

 ****************************************************************************************************************************/

public class DDTaskOrderTriggerHandler{

    
    /**
        Before insert on Task Order trigger
        This method fetches the relevant values from the related Opportunity and pre-populates on the task order
    */
    public void beforeInsertQuote(List<Task_Order__c> taskOrderListTrigger, Map<Id, Task_Order__c> newTaskOrderMap){
        system.debug('DDTaskOrderTriggerHandler :: beforeInsertQuote :: start');
        List<DD_Instruction__c> instList = new List<DD_Instruction__c>();
        List<Id> taskOrderIdList = new List<Id>();
        List<Id> oppIdList = new List<Id>();
        Map<Id, Task_Order__c> oppIdTaskOrderMap = new Map<Id, Task_Order__c>();
        
        for(Task_Order__c taskOrderVal : taskOrderListTrigger){
            if(taskOrderVal.DD_Opportunity__c!=null){
            	oppIdList.add(taskOrderVal.DD_Opportunity__c);
            	oppIdTaskOrderMap.put(taskOrderVal.DD_Opportunity__c, taskOrderVal);
            }
        }    
        List<Opportunity> oppQList = [Select Id, Originating_Office__c,
                                                 Practice_area__c,
                                                 practiceText__c, DD_Instruction__r.CreatedById,
                                                 Owner.Name From Opportunity 
                                                 where Id in: oppIdList];
            
            for(Task_Order__c taskOrderVal : taskOrderListTrigger){
                for(Opportunity oppQVal : oppQList){
                    if(oppIdTaskOrderMap.get(oppQVal.Id) == taskOrderVal){
                        if(taskOrderVal.DD_Opp_Originating_Office__c!=null && taskOrderVal.DD_Opp_Originating_Office__c!=''){
                            taskOrderVal.DD_Opp_Originating_Office__c = oppQVal.Originating_Office__c;
                        }
                        if(taskOrderVal.DD_Opp_Practice_area__c!=null && taskOrderVal.DD_Opp_Practice_area__c!=''){
                            taskOrderVal.DD_Opp_Practice_area__c = oppQVal.Practice_area__c;
                        }
                        if(taskOrderVal.DD_Opp_practiceText__c!=null && taskOrderVal.DD_Opp_practiceText__c!=''){
                            taskOrderVal.DD_Opp_practiceText__c = oppQVal.practiceText__c;
                        }
                        if(taskOrderVal.DD_Parent_Opportunity_Owner__c!=null && taskOrderVal.DD_Parent_Opportunity_Owner__c!=''){
                            taskOrderVal.DD_Parent_Opportunity_Owner__c = oppQVal.Owner.Name;
                        }                        
                        taskOrderVal.Instruction_Created_By__c = oppQVal.DD_Instruction__r.CreatedById;
                        
                     }
                }
            }
        system.debug('DDTaskOrderTriggerHandler :: beforeInsertQuote :: end');
        }
    
    /**
        After update or insert on task order trigger
        This method updates the related instruction on status change on the Task Order
    */
    public void afterUpdateOrInsertQuote(List<Task_Order__c> taskOrderListTrigger, Map<Id, Task_Order__c> newTaskOrderMap, Map<Id, Task_Order__c> oldTaskOrderMap){
        
        system.debug('DDTaskOrderTriggerHandler :: afterUpdateOrInsertQuote :: start');
        List<DD_Instruction__c> instList = new List<DD_Instruction__c>();
        List<Id> taskOrderIdList = new List<Id>();
        String recordSharingRoleId;
        List<Task_Order__Share> toShareList = new List<Task_Order__Share>();
        List<Id> taskOrderIdHOCSubmissionList = new List<Id>();
        List<Id> taskOrderIdGCSubmissionList = new List<Id>();
        
        List<DGL__c> accountGroupList = DGL__c.getall().values();
                
        for(Task_Order__c taskOrderVal : taskOrderListTrigger){
            if(taskOrderVal.DD_Status__c.equals('Submitted to HOC')){
                taskOrderIdHOCSubmissionList.add(taskOrderVal.Id);
            }
            if(taskOrderVal.DD_Status__c.equals('Submitted to GC')){
                taskOrderIdGCSubmissionList.add(taskOrderVal.Id);
            }
            taskOrderIdList.add(taskOrderVal.id);
        }
        
        system.debug('taskOrderIdHOCSubmissionList :: '+taskOrderIdHOCSubmissionList);
        system.debug('taskOrderIdGCSubmissionList :: '+taskOrderIdGCSubmissionList);
        
        if(taskOrderIdList!=null && taskOrderIdList.size()>0){
            List<Task_Order__c> taskOrderList = [Select t.DD_Status__c, t.Id, t.DD_Opportunity__r.DD_Instruction__c, t.DD_Opportunity__r.AccountId, Delivery_Date__c,
                                                        t.DD_Timescale_working_days__c, t.DD_Fee__c, t.DD_Method__c, t.DD_Expenses__c,t.DD_Expenses_Cap__c,
                                                        t.DD_Other_Agreed_Terms__c,
                                                        t.DD_Opp_Originating_Office__c,
                                                        t.DD_Opp_Practice_area__c,
                                                        t.DD_Opp_practiceText__c,
                                                        t.DD_Parent_Opportunity_Owner__c,
                                                        t.DD_Opportunity__r.Originating_Office__c,
                                                        t.DD_Opportunity__r.Practice_area__c,
                                                        t.DD_Opportunity__r.practiceText__c,
                                                        t.DD_Opportunity__r.Owner.Name,
                                                 		t.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r.Account.Id,
                                                        t.DD_Opportunity__r.DD_Instruction__r.DD_Timescale_working_days__c, 
                                                        t.DD_Opportunity__r.DD_Instruction__r.DD_Fee__c, 
                                                 		t.DD_Opportunity__r.DD_Instruction__r.Method__c,
                                                        t.DD_Opportunity__r.DD_Instruction__r.DD_Expenses__c, 
                                                 		t.DD_Opportunity__r.DD_Instruction__r.DD_Desired_Delivery_Date__c, 
                                                        t.DD_Opportunity__r.DD_Instruction__r.DD_Expenses_Cap__c, 
                                                        t.DD_Opportunity__r.DD_Instruction__r.DD_Other_Agreed_Terms__c, 
                                                        t.DD_Opportunity__r.DD_Instruction__r.dd_Status__c From Task_Order__c t                                                         
                                                        where Id in: taskOrderIdList];
            if(taskOrderList !=null && taskOrderList.size()>0){
               for(Task_Order__c taskOrderVal: taskOrderList){
                	if(taskOrderVal.DD_Opportunity__r!=null){
		                taskOrderVal.DD_Opp_Originating_Office__c = taskOrderVal.DD_Opportunity__r.Originating_Office__c;
		                taskOrderVal.DD_Opp_Practice_area__c = taskOrderVal.DD_Opportunity__r.Practice_area__c;
		                taskOrderVal.DD_Opp_practiceText__c = taskOrderVal.DD_Opportunity__r.practiceText__c;
		                taskOrderVal.DD_Parent_Opportunity_Owner__c = taskOrderVal.DD_Opportunity__r.Owner.Name;                	
		                if(taskOrderVal.DD_Status__c.equals('Submitted')
                                && taskOrderVal.DD_Opportunity__r !=null 
                                && taskOrderVal.DD_Opportunity__r.DD_Instruction__r != null 
                                && taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r != null
                                && taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r.AccountId != null)
                        {
                            taskOrderVal.DD_Opportunity__r.DD_Instruction__r.dd_status__c = 'Quoted';
                            instList.add(taskOrderVal.DD_Opportunity__r.DD_Instruction__r);
		                    for(DGL__c accountGroupVal : accountGroupList){
                                system.debug('accountGroupVal :: '+accountGroupVal);
                                system.debug('taskOrderVal.DD_Opportunity__r :: '+taskOrderVal.DD_Opportunity__r);
                                system.debug('taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r.Account.Id :: '+taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r.Account.Id);
                                system.debug('accountGroupVal.Account__c :: '+accountGroupVal.Account__c);                                
		                        if(accountGroupVal.Account__c!=null && 
                                   accountGroupVal.Account__c.equals(String.valueOf(taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r.AccountId).subString(0,15)+'__CL_PARTNER_USER_ROLE')){
		                            recordSharingRoleId = accountGroupVal.Group__c;
		                            Task_Order__Share shr = new Task_Order__Share(UserOrGroupId = recordSharingRoleId , ParentId = taskOrderVal.id, AccessLevel = 'edit');
		                            toShareList.add(shr);
		                        }
		                    }
		                }
		                else if(taskOrderVal.DD_Status__c.equals('Submitted to HOC') 
                                && taskOrderVal.DD_Opportunity__r !=null 
                                && taskOrderVal.DD_Opportunity__r.DD_Instruction__r != null 
                                && taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r != null
                                && taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r.AccountId != null)
                        {
                            taskOrderVal.DD_Opportunity__r.DD_Instruction__r.dd_status__c = 'Quoted';
		                    instList.add(taskOrderVal.DD_Opportunity__r.DD_Instruction__r);
		                    for(DGL__c accountGroupVal : accountGroupList){
                                system.debug('accountGroupVal :: '+accountGroupVal);
                                system.debug('taskOrderVal.DD_Opportunity__r :: '+taskOrderVal.DD_Opportunity__r);
                                system.debug('taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r.AccountId :: '+taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r.AccountId);
                                system.debug('accountGroupVal.Account__c :: '+accountGroupVal.Account__c);
		                        if(accountGroupVal.Account__c!=null && 
                                   accountGroupVal.Account__c.equals(String.valueOf(taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Client_Commissioner__r.AccountId).subString(0,15)+'__CL_PARTNER_MANAGER_ROLE')){
		                            recordSharingRoleId = accountGroupVal.Group__c;
		                            Task_Order__Share shr = new Task_Order__Share(UserOrGroupId = recordSharingRoleId , ParentId = taskOrderVal.id, AccessLevel = 'edit');
		                            toShareList.add(shr);
		                        }
		                    }
		                }                        
		                else if(taskOrderVal.DD_Status__c.equals('Approved')){
		                    taskOrderVal.DD_Opportunity__r.DD_Instruction__r.dd_status__c = 'Quote Approved';
		                    taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Timescale_working_days__c= taskOrderVal.DD_Timescale_working_days__c;
		                    taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Fee__c= taskOrderVal.DD_Fee__c;
                            taskOrderVal.DD_Opportunity__r.DD_Instruction__r.Method__c = taskOrderVal.DD_Method__c;
		                    taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Expenses__c= taskOrderVal.DD_Expenses__c;
		                    taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Expenses_Cap__c = taskOrderVal.DD_Expenses_Cap__c;
		                    taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Other_Agreed_Terms__c= taskOrderVal.DD_Other_Agreed_Terms__c;
                            if(taskOrderVal.Delivery_Date__c != taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Desired_Delivery_Date__c){
                                taskOrderVal.DD_Opportunity__r.DD_Instruction__r.DD_Desired_Delivery_Date__c = taskOrderVal.Delivery_Date__c;
                            }                            
                            instList.add(taskOrderVal.DD_Opportunity__r.DD_Instruction__r);
		                }
		                else if(taskOrderVal.DD_Status__c.equals('Rejected')){
		                    taskOrderVal.DD_Opportunity__r.DD_Instruction__r.dd_status__c = 'Quote Rejected';
		                    instList.add(taskOrderVal.DD_Opportunity__r.DD_Instruction__r);
		                }  
            		}
              }
            }
          }  
        try{
        
            if(toShareList.size()>0){
                insert toShareList;
            }
                        
            if(instList.size()>0){
                update instList;
            }
            
            if(taskOrderIdHOCSubmissionList != null && taskOrderIdHOCSubmissionList.size() > 0){
                DDUtility.getUsersWithAccess(taskOrderIdHOCSubmissionList, 'CL_HEAD_OF_COMPLIANCE', 'DD_Task_Order_Approval');
            }
            if(taskOrderIdGCSubmissionList != null && taskOrderIdGCSubmissionList.size() > 0){
                DDUtility.getUsersWithAccess(taskOrderIdGCSubmissionList, 'CL_GENERAL_COUNSEL', 'DD_Task_Order_Approval');
            }
            
        }
        catch(Exception ex){
            system.debug('Exception occurred while updating Instruction related to Task Order\'s Opportunity '+ex.getMessage());
        }
    system.debug('DDTaskOrderTriggerHandler :: afterUpdateOrInsertQuote :: end');
    }

}