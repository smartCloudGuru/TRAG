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

 Code purpose  : This is a controller working on 'DD_ApprovalDetails' page to take appropriate action of Approval/Rejection and Cancel
 


 Birthday      : 2014-03-28
 Api version   : v29

 ****************************************************************************************************************************/

public  class DD_ApproveDetailsController {

    public string comments{get;set;}
    public String pid {get;set;}
    public Id id {get;set;}
    public String assessmentNumber {get;set;}
    public List<ProcessInstanceHistory> approvalProcess{get;set;}
    public String assessmentOwnerId {get;set;}
    public String assessmentOwnerName {get;set;}
    public String assessmentOpenDate {get;set;}
    public String assessmentName {get;set;}
    public String assessmentAccountName {get;set;}
    public String assessmentAccountId {get;set;}
    public String assessmentControlProcessStatus {get;set;}
    public String assessmentSubject {get;set;}
    public String assessmentDescription {get;set;}
    public Boolean isTargetObjectAssessment {get;set;}
    public String taskOrderAccountName {get;set;}
    public String taskOrderAccountId {get;set;}
    public String taskOrderInstructionName {get;set;}
    public String taskOrderInstructionId {get;set;}
    public String taskOrderControlMeasureName {get;set;}
    public String taskOrderControlMeasureId {get;set;} 
    public String taskOrderAssessmentName {get;set;}
    public String taskOrderAssessmentId {get;set;}
    public String taskOrderDelideryDate {get;set;}
    public String taskOtherAgreeTerms {get;set;}
    public Boolean isTargetObjectTaskOrder {get;set;}
    public String taskVal {get;set;}
    public String taskMethod {get;set;}
    public String taskStartDate {get;set;}
    public Decimal taskTimeScale {get;set;}
    public String taskCurrency {get;set;}
    public Decimal taskFee {get;set;}
    public Boolean taskExpense {get;set;}
    public Decimal taskExpenseCap {get;set;}
    
    public List<ProcessInstance> prosIns{get;set;}
    private List<ProcessInstanceWorkitem>  prosInsWrkItms = new List<ProcessInstanceWorkitem>();  
    private List<Id> prosInsIds = new List<Id>(); 
    public List<PendingAppRecs> proInstsLst{get; set;} 

     // Default constructor
     public void DD_ApproveDetailsController() {}
     
     // Constructor for initialization of Process Instance and Proces work Item and assessmentNumber, assessmentOwnerId, assessmentOwnerName and assessmentOpenDate
     public void initialize() {
            system.debug('DD_ApproveDetailsController :: initialize :: start ');
            String targetObjectType = getObjectType();
            Id objId = ApexPages.currentPage().getParameters().get('id');
            if(targetObjectType == 'Case'){
                List<Case> csList = [select Id, DD_Assessment_Name__c, Account.Name, AccountId, DD_Control_Process_Status__c, Subject, Description from Case where Id =: objId];
                if(csList!=null && csList.size()>0){
                    assessmentName = csList.get(0).DD_Assessment_Name__c;
                    assessmentAccountId = csList.get(0).AccountId;
                    assessmentAccountName = csList.get(0).Account.Name;
                    assessmentControlProcessStatus = csList.get(0).DD_Control_Process_Status__c;
                    assessmentSubject = csList.get(0).Subject;
                    assessmentDescription = csList.get(0).Description;
                    isTargetObjectAssessment  = true;
                }
            }
            else if(targetObjectType == 'Task_Order__c'){
                List<Task_Order__c> toList = [select Id, CurrencyIsoCode, DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.DD_Assessment__r.Account.Name, Delivery_Date__c,
                                                DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.DD_Assessment__r.AccountId,
                                                DD_Opportunity__r.DD_Instruction__r.Name, DD_Opportunity__r.DD_Instruction__r.Id,
                                                DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.Name, 
                                                DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.Id, 
                                                DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.DD_Assessment__r.DD_Assessment_Name__c, DD_Other_Agreed_Terms__c,
                                                DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.DD_Assessment__r.Id,
                                                DD_Task__c, DD_Method__c, DD_Start_Date__c, DD_Timescale_working_days__c, DD_Fee__c,
                                                DD_Expenses__c, DD_Expenses_Cap__c
                                                from Task_Order__c where Id =: objId];
                if(toList!=null && toList.size()>0){
                    taskOrderAccountName = toList.get(0).DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.DD_Assessment__r.Account.Name;
                    taskOrderAccountId = toList.get(0).DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.DD_Assessment__r.AccountId;
                    taskOrderInstructionName = toList.get(0).DD_Opportunity__r.DD_Instruction__r.Name;
                    taskOrderInstructionId  = toList.get(0).DD_Opportunity__r.DD_Instruction__r.Id;
                    taskOrderControlMeasureName = toList.get(0).DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.Name;
                    taskOrderControlMeasureId = toList.get(0).DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.Id;
                    taskOrderAssessmentName  = toList.get(0).DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.DD_Assessment__r.DD_Assessment_Name__c;
                    taskOrderAssessmentId  = toList.get(0).DD_Opportunity__r.DD_Instruction__r.DD_Control_Measure__r.DD_Assessment__r.Id;                    
                    taskVal = toList.get(0).DD_Task__c;
                    taskMethod = toList.get(0).DD_Method__c;
                    if(toList.get(0).DD_Start_Date__c != null){
                        taskStartDate = DDutility.formatDate(toList.get(0).DD_Start_Date__c);
                    }
                    taskTimeScale = toList.get(0).DD_Timescale_working_days__c;
                    taskFee = toList.get(0).DD_Fee__c;
                    taskCurrency = toList.get(0).CurrencyIsoCode;
                    taskExpense = toList.get(0).DD_Expenses__c;
                    taskExpenseCap = toList.get(0).DD_Expenses_Cap__c;
                    taskOtherAgreeTerms = toList.get(0).DD_Other_Agreed_Terms__c;
                    if(toList.get(0).Delivery_Date__c != null){
                        taskOrderDelideryDate  = DDutility.formatDate(toList.get(0).Delivery_Date__c);
                    }
                    isTargetObjectTaskOrder  = true;                    
                }
            }
            pid = ApexPages.currentPage().getParameters().get('pid');
            prosIns = [SELECT Id, Status, TargetObject.Id, TargetObject.Name, TargetObject.Type, CreatedDate FROM ProcessInstance where Status='Pending' and id=: pid];
            for(ProcessInstance prIns: prosIns){
                prosInsIds.add(prIns.Id);            
            }
            prosInsWrkItms =  [SELECT Id, CreatedDate, ProcessInstance.Id, ProcessInstance.TargetObject.Id, ProcessInstance.TargetObject.Name, ProcessInstance.Status, Actor.Id, Actor.Name, Actor.Type FROM ProcessInstanceWorkitem where ProcessInstance.Id in : prosInsIds];
            for(ProcessInstanceWorkitem prosInsWrkItmsVal : prosInsWrkItms){
                assessmentNumber = prosInsWrkItmsVal.ProcessInstance.TargetObject.Name;
                assessmentOwnerId = prosInsWrkItmsVal.Actor.Id;
                assessmentOwnerName = prosInsWrkItmsVal.Actor.Name;
                assessmentOpenDate = prosInsWrkItmsVal.CreatedDate.format('dd/MM/yyyy HH:mm');               
            }
            system.debug('DD_ApproveDetailsController :: initialize :: end ');
     }
     
     /**
         This method fetches the approval history of specific SObject type record
     */
     public List<ProcessInstanceHistory> getApprovalHistory(){
        system.debug('DD_ApproveDetailsController :: getApprovalHistory :: start ');
        List<ProcessInstanceHistory> psList;
        String objectType = getObjectType();
        String queryString = 'Select Id, (Select Id, CreatedDate, StepStatus, OriginalActor.Name, OriginalActorId, Actor.name, ActorId, Comments, SystemModstamp From ProcessSteps order by CreatedDate Desc)  FROM ' + objectType  + ' WHERE Id= \'' + id+'\'';
        system.debug('queryString  :: '+queryString);
        sObject[] objDBList = Database.query(queryString);
        for(sObject lsVal : objDBList){
            if (lsVal.getSObjectType() == Account.sObjectType){
                lsVal = (Opportunity)lsVal;            
            }
            else if (lsVal.getSObjectType() == DD_Control_Measure__c.sObjectType){
                lsVal = (DD_Control_Measure__c)lsVal;
            }
            else if (lsVal.getSObjectType() == DD_Instruction__c.sObjectType){
                lsVal = (DD_Instruction__c)lsVal;
            }
            else if (lsVal.getSObjectType() == Case.sObjectType){
                lsVal = (Case)lsVal;
            }
            psList = (LIST<ProcessInstanceHistory>)lsVal.getSObjects('ProcessSteps');            
        }
        system.debug('DD_ApproveDetailsController :: getApprovalHistory :: end ');
          return psList;
      } 
      
      /**
          This method identifies the SObject Type
      */
      private String getObjectType(){
          system.debug('DD_ApproveDetailsController :: getObjectType :: start ');
          id = ApexPages.currentPage().getParameters().get('id');
          Schema.SObjectType token = id.getSObjectType();
          Schema.DescribeSObjectResult dr = token.getDescribe();
          String name = dr.getName();
          system.debug('DD_ApproveDetailsController :: getObjectType :: end ');
          return name ;
          
      } 
      
    /** 
        Action for approval on click Approve button and redirect to DD_Approval page
    */
    public pagereference approveAll(){
            system.debug('DD_ApproveDetailsController :: approveAll :: start ');
            appRej('Approve');
            Pagereference pg = new pagereference('/apex/DD_Approvals');
            pg.setredirect(true);
            system.debug('DD_ApproveDetailsController :: approveAll :: end ');
            return pg;
        }
    
    /** 
        Action for approval on click Reject button and redirect to DD_Approval page
    */
        public pagereference rejectAll(){
            system.debug('DD_ApproveDetailsController :: rejectAll :: start ');
            appRej('Reject');
            Pagereference pg = new pagereference('/apex/DD_Approvals');
            pg.setredirect(true);
            system.debug('DD_ApproveDetailsController :: rejectAll :: end ');
            return pg;
        }
    
    // No Action on click Reject button and redirect to DD_Approval page
        public pagereference cancel()
        {
            Pagereference pg = new pagereference('/apex/DD_Approvals');
            pg.setredirect(true);
            return pg;
        }
        
        // Core method to actually Approve/Reject the record
        public void appRej(String appRej)
        {     
            system.debug('appRej :: '+appRej);
            for(ProcessInstance pi : prosIns)
            {
                for(ProcessInstanceWorkitem  pwi  : prosInsWrkItms)
                {
                    if(pi.Id == pwi.ProcessInstance.Id)
                    {
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setComments(Comments);
                        req.setAction(appRej);
                        if(appRej == 'Approve')
                            req.setNextApproverIds(new Id[] {pwi.Actor.id});        
                            List<ProcessInstanceWorkitem> procWrkItms = new List<ProcessInstanceWorkitem>();
                            procWrkItms  = [Select Id from ProcessInstanceWorkitem where ProcessInstance.Id =: pi.Id];                    
                system.debug('procWrkItms :: '+procWrkItms);
                        if((!(procWrkItms.isEmpty()) && procWrkItms[0].Id!=null))
                        {
                            req.setWorkitemId(procWrkItms[0].Id);        
                                                
                            // Submit the request for approval    
                            Approval.ProcessResult result2 =  Approval.process(req);
                            system.debug('result2 :: '+result2);
                        }
                    }
                }
            }
        }
        
        // Method to get pending process instances
        public List<PendingAppRecs> getProsInsts() 
        {
            if(proInstsLst== null) 
            {
                proInstsLst = new List<PendingAppRecs>();
                for(ProcessInstance p : [SELECT Id, Status, TargetObject.Id, TargetObject.Name, TargetObject.Type, CreatedDate FROM ProcessInstance where Status='Pending']) 
                {
                    proInstsLst.add(new PendingAppRecs(p));
                }
            }
            return proInstsLst;
        }
        
        // Wrapper Class
        public class PendingAppRecs
        {
            public ProcessInstance  proInstce{get; set;}
            //public Boolean selected {get; set;}
            public PendingAppRecs(ProcessInstance  p) 
            {
            proInstce = p;
            //selected = false;
            }
        }
}