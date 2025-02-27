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

 Code purpose  : This is a controller working 'DD_Approvals' page to fetch information about pending approvals for the logged in user
 


 Birthday      : 15/05/2014 
 Api version   : v29

 ****************************************************************************************************************************/

public with sharing class DDApprovalController {

    public List<ProcessInstance> prosIns{get;set;}
    public boolean rendPgeBlock  {get;set;}
    public String pgMsg{get;set;}
    public string comments{get;set;}
    public List<ProcessInstance> selProsInss{get;set;}
    private List<Id> prosInsIds = new List<Id>();    
    private List<ProcessInstanceWorkitem>  prosInsWrkItms = new List<ProcessInstanceWorkitem>();    
    private List<PendingAppRecs>  selVals = new List<PendingAppRecs>();   
    public List<PendingAppRecs> proInstsLst{get; set;}     
    
    // Constructor to instantiate Pending Processes and process work items
    public DDApprovalController(){
        system.debug('DDApprovalController :: DDApprovalController :: start');        
        
        prosIns = new List<ProcessInstance>();
        selProsInss = new List<ProcessInstance>();
        prosIns = [SELECT Id, Status, TargetObject.Id, TargetObject.Name, TargetObject.Type, CreatedDate FROM ProcessInstance where Status='Pending'];
        for(ProcessInstance prIns: prosIns){
            prosInsIds.add(prIns.Id);
        }
        prosInsWrkItms =  [SELECT Id, ProcessInstance.Id, ProcessInstance.TargetObject.Name,ProcessInstance.Status, Actor.Id, Actor.Name, Actor.Type FROM ProcessInstanceWorkitem where ProcessInstance.Id in : prosInsIds];
        system.debug('DDApprovalController :: DDApprovalController :: End');
    }
    
     
    // Method to check if there are pending approval process and if not specific section on a page is not displayed
    public pagereference appPendingRecs(){
        system.debug('DDApprovalController :: appPendingRecs :: start');
        if(!(prosIns.size()>0)){
            pgMsg = 'There are no records submitted for approval.';
            rendPgeBlock  = false;
        }
        else
            rendPgeBlock  = true;
        system.debug('DDApprovalController :: appPendingRecs :: end');    
        return null;
    }
    
    /* Method to get all the pending processes and realted work items and instantiate inner class with process instance workitem which is fetched back on 
        on the page to display pending approvals */
    public List<PendingAppRecs> getProsInsts() {
        
        system.debug('DDApprovalController :: getProsInsts :: start');    
        Map<Id, List<ProcessInstanceWorkitem>> queueIdProcessInstanceWorkitemMap = new Map<Id, List<ProcessInstanceWorkitem>>();
        List<Id> toList = new List<Id>();
        List<Id> csList = new List<Id>();
        List<Id> prosInsIds = new List<Id>(); 
        if(proInstsLst== null) {
            proInstsLst = new List<PendingAppRecs>();
            for(ProcessInstance p : [SELECT Id, Status, TargetObject.Id, TargetObject.Name, TargetObject.Type, 
                                        CreatedDate FROM ProcessInstance where Status='Pending']) {
                prosInsIds.add(p.Id);
            }
            system.debug('prosInsIds :: '+prosInsIds);
            prosInsWrkItms =  [SELECT Id, ProcessInstance.Id, ProcessInstance.TargetObjectId,
                                    ProcessInstance.TargetObject.Type,  CreatedDate, OriginalActorId, 
                                    OriginalActor.Name, OriginalActor.Type, ProcessInstance.TargetObject.Name,ProcessInstance.Status, Actor.Id, Actor.Name, 
                                    Actor.Type FROM ProcessInstanceWorkitem 
                                    where ProcessInstance.Id in : prosInsIds];
            system.debug('prosInsWrkItms :: '+prosInsWrkItms);
            for(ProcessInstanceWorkitem prosInsWrkItm : prosInsWrkItms){
                system.debug('prosInsWrkItm actor type :: '+prosInsWrkItm.Actor.Type);            
                system.debug('prosInsWrkItm OriginalActor Type :: '+prosInsWrkItm.OriginalActor.Type);            
                system.debug('prosInsWrkItm OriginalActor Name :: '+prosInsWrkItm.OriginalActor.Name);            
                system.debug('prosInsWrkItm.ProcessInstance.TargetObject.Type :: '+prosInsWrkItm.ProcessInstance.TargetObject.Type);
                if(prosInsWrkItm.ProcessInstance.TargetObject.Type == 'Task_Order__c'){
                    toList.add(prosInsWrkItm.ProcessInstance.TargetObject.Id);
                }
                else if(prosInsWrkItm.ProcessInstance.TargetObject.Type == 'Case'){
                    csList.add(prosInsWrkItm.ProcessInstance.TargetObject.Id);
                }
            }
            
            system.debug('toList :: '+toList);
            
            Map<Id, Task_Order__c> toMap_DB = new Map<Id, Task_Order__c>([select Id, name, Instruction_Id__c , Instruction_name__c from Task_Order__c 
                                            where Id in: toList]);
            Map<Id, Case> csMap_DB = new Map<Id, Case>([select Id, DD_Assessment_Name__c, Sanofi_LE__c from Case 
                                            where Id in: csList]);
            
            system.debug('toMap_DB :: '+toMap_DB);
            system.debug('csMap_DB :: '+csMap_DB);
            
            for(ProcessInstanceWorkitem prIns: prosInsWrkItms){
				system.debug('prIns.ProcessInstance.TargetObject.Type 1 :: '+prIns.ProcessInstance.TargetObject.Type);                
                system.debug('prIns.Actor.Type 1 :: '+prIns.Actor.Type);                
                if(prIns.Actor.Type == 'User' || String.valueOf(prIns.ActorId).startsWith('005')){
                    system.debug('prIns.ActorId 1 :: '+prIns.ActorId);                
                    if(prIns.ActorId == UserInfo.getUserId()){
                        system.debug('prIns.ProcessInstance.TargetObject.Type 2 :: '+prIns.ProcessInstance.TargetObject.Type); 
                        system.debug('toMap_DB.get(prIns.ProcessInstance.TargetObjectId) 2 :: '+toMap_DB.get(prIns.ProcessInstance.TargetObjectId));
                        if(prIns.ProcessInstance.TargetObject.Type == 'Task_Order__c'){                            
                            proInstsLst.add(new PendingAppRecs(prIns, toMap_DB.get(prIns.ProcessInstance.TargetObjectId), null));
                        }
                        else if(prIns.ProcessInstance.TargetObject.Type == 'Case'){                            
                            proInstsLst.add(new PendingAppRecs(prIns, null, csMap_DB.get(prIns.ProcessInstance.TargetObjectId)));
                            system.debug('proInstsLst inside 1 :: '+proInstsLst);
                        }
                        else{
                            proInstsLst.add(new PendingAppRecs(prIns, null, null));
                        }
                    }
                }
                else if(prIns.Actor.Type == 'Queue'){
                    if(queueIdProcessInstanceWorkitemMap.get(prIns.ActorId) == null){
                        queueIdProcessInstanceWorkitemMap.put(prIns.ActorId, new List<ProcessInstanceWorkitem>{prIns});     
                    }
                    else{
                        List<ProcessInstanceWorkitem> psrTemp = queueIdProcessInstanceWorkitemMap.get(prIns.ActorId);
                        psrTemp.add(prIns);
                        queueIdProcessInstanceWorkitemMap.put(prIns.ActorId, psrTemp); 
                    }
                }  
                system.debug('proInstsLst step  :: '+proInstsLst);
            }
                        
            system.debug('queueIdProcessInstanceWorkitemMap :: '+queueIdProcessInstanceWorkitemMap);
            List<ProcessInstanceWorkitem> processInstanceWorkitemList = userPresentInQueue(queueIdProcessInstanceWorkitemMap);
            if(processInstanceWorkitemList!=null && processInstanceWorkitemList.size()>0){
                for(ProcessInstanceWorkitem prIns1 : processInstanceWorkitemList){
                    if(prIns1.ProcessInstance.TargetObject.Type == 'Task_Order__c'){
                        proInstsLst.add(new PendingAppRecs(prIns1, toMap_DB.get(prIns1.ProcessInstance.TargetObjectId), null));
                    }
                    else if(prIns1.ProcessInstance.TargetObject.Type == 'Case'){
                        proInstsLst.add(new PendingAppRecs(prIns1, null, csMap_DB.get(prIns1.ProcessInstance.TargetObjectId)));
                        system.debug('proInstsLst inside 2 :: '+proInstsLst);
                    }
                    else{
                        proInstsLst.add(new PendingAppRecs(prIns1, null, null));
                    }
                }
            }
            
            system.debug('proInstsLst final  :: '+proInstsLst);
        }                
        
        system.debug('DDApprovalController :: getProsInsts :: end');    
        return proInstsLst;
    }
    
    // If a record is assigned to a queue. This method checks if user is present in  the queue. If yes, the record is displayed pending approval list
    private List<ProcessInstanceWorkitem> userPresentInQueue(Map<Id, List<ProcessInstanceWorkitem>> queueIdProcessInstanceWorkitemMap){
       
       system.debug('DDApprovalController :: userPresentInQueue :: start');    
       List<ProcessInstanceWorkitem> processInstanceWorkitemList = new List<ProcessInstanceWorkitem>();
       List<GroupMember> gmList = [Select GroupId, UserOrGroupId From GroupMember where GroupId in: queueIdProcessInstanceWorkitemMap.keySet()];
       for(GroupMember gmVal : gmList){
           if(gmVal.UserOrGroupId == UserInfo.getUserId()){
               processInstanceWorkitemList.addAll(queueIdProcessInstanceWorkitemMap.get(gmVal.GroupId));
           }
       }
       system.debug('DDApprovalController :: userPresentInQueue :: end');    
       return processInstanceWorkitemList;
    }
    
    // Wrapper class
    public class PendingAppRecs{
        public ProcessInstanceWorkitem  proInstce{get; set;}
        public Task_Order__c taskOrder {get; set;}
        public Case caseVal {get; set;}
        public PendingAppRecs(ProcessInstanceWorkitem  p, Task_Order__c taskOrder, Case caseVal) {
            this.proInstce = p;
            this.taskOrder = taskOrder;
            this.caseVal = caseVal;
        }
    }
}