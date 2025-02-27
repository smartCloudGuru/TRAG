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

 Code purpose  : This is a home tab component visualforce page component to display client specific useful data


 Birthday      : 14/10/2014
 Api version   : v31

 ****************************************************************************************************************************/
public with sharing class DDClientHomePageController{

     public String recordTypeId {get;set;}
     public String instructionObjectId {get;set;}
     public String contactPageId {get;set;}
     public String contactName {get;set;}
     public String taskOrderRequiredPageId {get;set;}
     public Integer taskOrderRequired {get;set;}
     public String InstructionEnvironmentValue {get;set;}
     //variable used for page styling//
     public String AssessmentRleativeURL {get;set;}
     public String bodyBackgroundColor {get;set;}
     public String bottomRightImage {get;set;}
     public String brandQuaternaryBgrBackgroudColor {get;set;}
     public String brandSecondaryBrdBackgroundColor {get;set;}
     public String brandSecondaryBrdBorderColor {get;set;}
     public String brandSecondaryBrdBorderTopColor {get;set;}
     public String brandSecondaryBrdMarginTop {get;set;}
     public String dataColColor {get;set;}
     public String dataColFontFamily {get;set;}
	 public String dataColFontSize {get;set;}	
	 public String dataRowColor {get;set;}
	 public String dataRowFontSize {get;set;}	
     public String dataRowFontWeight {get;set;}
	 public String dataRowFontFamily {get;set;}	
	 public String dataRowHeight {get;set;}
	 public String headerRowColor {get;set;}
	 public String headerRowFontFamily {get;set;}	
	 public String headerRowFontSize {get;set;}
    public String headerRowFontWeight {get;set;}
	 public String headerRowHeight {get;set;}
	 public String instructionRleativeURL {get;set;}
	 public String listHeight {get;set;}
	 public String onHoverColor {get;set;}
	 public String pageBackgroundColor {get;set;}
	 public String topLeftImage {get;set;}
	 public String topRightVideo {get;set;}
	 public String customizeTextFontSize {get;set;}
	 public String customizeTextFontFamily {get;set;}
	 public String customizeTextColor {get;set;}
	 public String customizeLinksFontSize {get;set;}
	 public String customizeLinksFontFamily {get;set;}
	 public String customizeLinksColor {get;set;}
	 public String customizeLinksTextDecoration {get;set;}
	 public String customizeLinksTextAlign {get;set;}
	 public String listMarginTop {get;set;}
     public String listBorderColor {get;set;}
     public String listBorderWidth {get;set;}
     public String listBorderBottomColor {get;set;}
	 public String headerRowVeriticalAlignment {get;set;}
	 public String headerRowPaddingBottom {get;set;}
	 public String brandSecondaryBrdWidth{get;set;}
	 public String quickLinksBackground {get;set;}
	 public String quickLinksMarginTop{get;set;}
	 public String quickLinksBorder{get;set;}
	 public String quickLinksBorderColor{get;set;}
	 public String quickLinksHeight{get;set;}
	 public String imageVideoStylingMarginTop {get;set;}
	 public String imageVideoStylingBorder{get;set;}
	 public String imageVideoStylingBorderColor{get;set;} 
     public String createInstructionImageURL{get;set;} 
	 public String reviewInstructionImageURL{get;set;} 
    
    
	public String h2Color {get;set;}
	public String h2FontFamily  {get;set;}
	public String h2FontSize  {get;set;}	
	public String h2FontWeight  {get;set;} 
	public String headerTextColor  {get;set;}
	public String headerTextFontFamily  {get;set;}
	public String headerTextFontSize  {get;set;}
	public String headerTextPadding  {get;set;}	 
	public String headerTextBackground  {get;set;}	  
	public String headerTextDisplay  {get;set;}	  
	public String headerTextFontWeight  {get;set;} 
	public String onHoverColorQA  {get;set;}	
    public String onHoverFontWeightQA  {get;set;}
	public String quickLinksBackgroundQA  {get;set;}	  
	public String quickLinksBackgroundColorQA  {get;set;}
	public String quickLinksColor  {get;set;}  
	public String quickLinksFontFamily  {get;set;} 
	public String quickLinksFontSize  {get;set;}	  
    public String quickLinksFontWeight  {get;set;}	 
	public String quickLinksImagesTableBackgroundColor  {get;set;}	  
	public String quickLinksImagesTableWidth  {get;set;}	 
	public String quickLinksPaddingLeft  {get;set;}	   	 	
	public String quickLinksTableBackgroundColor  {get;set;}
	public String quickLinksTableHeight  {get;set;}
	public String quickLinksTableWidth  {get;set;}
	public String quickLinksTextDecoration  {get;set;}	
	public String subsectionBackground  {get;set;} 	 	
	public String subsectionBackgroundColor  {get;set;}	   	 	
	public String subsectionFontFamily  {get;set;}
	public String subsectionFontSize  {get;set;}  	 	
	public String subsectionHeight  {get;set;}
	public String quickLinksTablePaddingTop{get;set;}
	public String quickLinksImagesTableHeight{get;set;}
     // ----------------------------//
     public List<ProcessInstance> prosIns{get;set;}
     public boolean rendPgeBlock  {get;set;}
     public String pgMsg{get;set;}
     public string comments{get;set;}
     public List<ProcessInstance> selProsInss{get;set;}
     private List<Id> prosInsIds = new List<Id>();    
     private List<ProcessInstanceWorkitem>  prosInsWrkItms = new List<ProcessInstanceWorkitem>();    
     private List<PendingAppRecs>  selVals = new List<PendingAppRecs>();   
     public List<PendingAppRecs> proInstsLst{get; set;}     
     
     /**
         Constructor to load existing pending approvals
     */
     public DDClientHomePageController(){
        system.debug('DDClientHomePageController :: DDClientHomePageController :: start');
        prosIns = new List<ProcessInstance>();
        selProsInss = new List<ProcessInstance>();
        prosIns = [SELECT Id, Status, TargetObject.Id, TargetObject.Name, TargetObject.Type, CreatedDate FROM ProcessInstance where Status='Pending' order by CreatedDate desc limit 5];
        for(ProcessInstance prIns: prosIns){
            prosInsIds.add(prIns.Id);
        }
        prosInsWrkItms =  [SELECT Id, ProcessInstance.Id, ProcessInstance.TargetObject.Name, ProcessInstance.Status, Actor.Id, Actor.Name, Actor.Type FROM ProcessInstanceWorkitem where ProcessInstance.Id in : prosInsIds];
        system.debug('DDClientHomePageController :: DDClientHomePageController :: end');
    }
    
    /**
         Method to check if there are pending approval process and if not specific section on a page is not displayed
    */
    public pagereference appPendingRecs(){
        system.debug('DDClientHomePageController :: appPendingRecs :: start');
        if(!(prosIns.size()>0)){
            pgMsg = 'There are no records submitted for approval.';
            rendPgeBlock  = false;
        }
        else
            rendPgeBlock  = true;
        system.debug('DDClientHomePageController :: appPendingRecs :: end');
        return null;
    }
    
    /**
        Method to fetch oldest 5 Instructions
    */
    public List<DD_Instruction__c > getInstructions() {
        
        system.debug('DDClientHomePageController :: getInstructions :: start');
        List<String> statusTypeList = new List<String>();
        statusTypeList.add('New');
        statusTypeList.add('Submitted');
        statusTypeList.add('Cancelled');
        statusTypeList.add('Cancelled');
        List<DD_Instruction__c> instList = [SELECT Id, Name, CreatedDate, DD_Status__c FROM DD_Instruction__c 
                                            where DD_Status__c not in : statusTypeList and DD_Status__c != '' 
                                            order by CreatedDate desc limit 5];
        
        system.debug('DDClientHomePageController :: getInstructions :: end');
        return instList;
    }
    
    /**
        Method to fetch oldest 5 Assessments
    */
    public List<Case> getAssessments() {
        
        system.debug('DDClientHomePageController :: getAssessments :: start');
        List<Case> assList = [SELECT Id, DD_Assessment_Name__c, CreatedDate, AccountId, Account.Name, DD_Control_Process_Status__c, DD_Desired_Delivery_Date__c FROM Case
                                            where Status = 'Open' 
                                            order by CreatedDate desc limit 5];
                                            
        List<Case> assSortedList = [SELECT Id, DD_Assessment_Name__c, CreatedDate, AccountId, Account.Name, DD_Control_Process_Status__c, DD_Desired_Delivery_Date__c FROM Case
                                            where Id in: assList 
                                            order by DD_Desired_Delivery_Date__c  desc];
        system.debug('DDClientHomePageController :: getAssessments :: end');
        return assSortedList ;
    }
    
    /**
        Method to fetch pending approval assigned to logged in user or logged in user member of a queue
    */
    public List<PendingAppRecs> getProsInsts(){
        
        system.debug('DDClientHomePageController :: getProsInsts :: start');
        List<Id> prosInsIds = new List<Id>(); 
        if(proInstsLst == null) {
            proInstsLst = new List<PendingAppRecs>();
            for(ProcessInstance p : [SELECT Id, Status,  TargetObject.Id, TargetObject.Name, TargetObject.Type, 
                                        CreatedDate FROM ProcessInstance where Status='Pending' order by CreatedDate desc limit 5]){
                prosInsIds.add(p.Id);
            }
            
            prosInsWrkItms =  [SELECT Id, ProcessInstance.Id, ProcessInstance.TargetObjectId,
                                    ProcessInstance.TargetObject.Type, ProcessInstance.TargetObject.Name, CreatedDate, OriginalActorId, 
                                    OriginalActor.Name, ProcessInstance.Status, Actor.Id, Actor.Name, 
                                    Actor.Type FROM ProcessInstanceWorkitem 
                                    where ProcessInstance.Id in : prosInsIds];
                                    
            for(ProcessInstanceWorkitem prIns: prosInsWrkItms){
                if(prIns.Actor.Type == 'User'){
                    if(prIns.ActorId == UserInfo.getUserId()){
                        if(prIns.ProcessInstance.TargetObject.Type == 'Case'){
                            proInstsLst.add(new PendingAppRecs(prIns, 'Assessment'));
                        }
                        else if(prIns.ProcessInstance.TargetObject.Type == 'Task_Order__c'){
                            proInstsLst.add(new PendingAppRecs(prIns, 'Task Order'));
                        }
                    }
                }
                else if(prIns.Actor.Type == 'Queue'){
                    if(userPresentInQueue(prIns.ActorId)){
                        if(prIns.ProcessInstance.TargetObject.Type == 'Case'){
                            proInstsLst.add(new PendingAppRecs(prIns, 'Assessment'));
                        }
                        else if(prIns.ProcessInstance.TargetObject.Type == 'Task_Order__c'){
                            proInstsLst.add(new PendingAppRecs(prIns, 'Task Order'));
                        }
                    }
                }                
            }                        
            }
        system.debug('DDClientHomePageController :: getProsInsts :: end');
        return proInstsLst;
    }
    
    /** 
        If a record is assigned to a queue. This method checks if user is present in  the queue. If yes, the record is displayed pending approval list
    */
    private boolean userPresentInQueue(Id queueId){
    
       system.debug('DDClientHomePageController :: userPresentInQueue :: start');
       List<GroupMember> gmList = [Select UserOrGroupId From GroupMember where GroupId =:queueId];
       for(GroupMember gmVal : gmList){
           if(gmVal.UserOrGroupId == UserInfo.getUserId()){
               return true;
           }
       }
       system.debug('DDClientHomePageController :: userPresentInQueue :: end');
       return false;
    }
    
    // Wrapper class
    public class PendingAppRecs{
        public ProcessInstanceWorkitem  proInstce{get; set;}
        //public String targetObjectName {get; set;}
        public String targetObjectLabel{get; set;}
        
        public PendingAppRecs(ProcessInstanceWorkitem  p, String targetObjLabel) {
            proInstce = p;
            //targetObjectName = targetObjectName;
            targetObjectLabel = targetObjLabel;
        }
    }
     
     /**
         Load styling parameters for the approval page
     */
     public void initializeBrandingParameters(){
        
        system.debug('DDClientHomePageController :: initializeBrandingParameters :: start');                        
        
        List<Contact> contactList;
        Pagereference pg;
        DDClientHomePageComponents__c clientHomePageParamentersVal;
        DDQuickActionPageComponents__c quickActionPageParamentersVal; 
        User loggedInUser = [select Id, contact.Account.ParentId, contact.Account.DD_Due_Diligence_Portal_Licence__c, contact.AccountId from User where Id =:  Userinfo.getUserId()];
        List<New_Button_Override__c> newButtonOverrideList = New_Button_Override__c.getall().values();
        
        List<User> userList = [select Id, ContactId, Contact.Account.DD_Due_Diligence_Portal_Licence__c from User where Id=: loggedInUser.Id];
        
        // Get related contact of logged in user 
        if(userList!=null && userList.size()>0){
           contactList = [select Id, Name, Account.DD_Task_Order_Required__c from Contact where Id=: userList.get(0).ContactId];
        }  
        if(contactList!=null && contactList.size()>0){
            contactName = contactList.get(0).Name;
            if(contactList.get(0).Account.DD_Task_Order_Required__c){
                taskOrderRequired = 1;
            }
            else{
                taskOrderRequired = 0;
            }
            if(contactName==null){
                contactName = '';
            }
        }    
                
        for(New_Button_Override__c newButtonOverrideVal : newButtonOverrideList){
            if(newButtonOverrideVal.Name.equals('New Button Over Ride')){
                instructionObjectId = newButtonOverrideVal.Instruction_Object_Page_Id__c;
                recordTypeId = newButtonOverrideVal.Record_Type_Page_Id__c;
                contactPageId = newButtonOverrideVal.Logged_In_User_Contact_Page_Id__c;
                taskOrderRequiredPageId = newButtonOverrideVal.Task_Order_Required__c;
                InstructionEnvironmentValue = newButtonOverrideVal.InstructionEnvironmentValue__c; 
            }            
        }
        
        //pg = new Pagereference('/client/{!InstructionEnvironmentValue}/e?retURL=/{!InstructionEnvironmentValue}&RecordType='+recordTypeId+'&ent='+instructionObjectId+'&'+contactPageId+'='+contactName+'&nooverride=1'+'&'+taskOrderRequiredPageId+'='+taskOrderRequired);             
        List<DDClientHomePageComponents__c> clientHomePageParamentersList = DDClientHomePageComponents__c.getall().values();
         
        if(loggedInUser.Contact.Account.DD_Due_Diligence_Portal_Licence__c.equals('Platform')){
            clientHomePageParamentersVal = DDClientHomePageComponents__c.getall().get(Label.LUMA_Platform_Branding);
        }
        else {
            for(DDClientHomePageComponents__c clientHomePageParamentersVal1 : clientHomePageParamentersList){
                if(String.valueOf(loggedInUser.contact.AccountId).substring(0,15).equals(clientHomePageParamentersVal1.PartnerAccountId__c)){
                    system.debug('partner Found');
                    system.debug('clientHomePageParamentersVal1.name :: '+clientHomePageParamentersVal1.name);
                    clientHomePageParamentersVal = DDClientHomePageComponents__c.getall().get(clientHomePageParamentersVal1.Name);
                    break;
                }
            }
        }        
        
        //for(DDClientHomePageComponents__c clientHomePageParamentersVal : clientHomePageParamentersList){
            //if(loggedInUser.contact!=null && String.valueOf(loggedInUser.contact.AccountId).substring(0,15).equals(clientHomePageParamentersVal.PartnerAccountId__c)){
                assessmentRleativeURL = clientHomePageParamentersVal.AssessmentRleativeURL__c;
                bodyBackgroundColor = clientHomePageParamentersVal.Body_BackgroundColor__c;
                bottomRightImage = clientHomePageParamentersVal.BottomRightImage__c;
                brandQuaternaryBgrBackgroudColor = clientHomePageParamentersVal.BrandQuaternaryBgr_BackgroudColor__c;
                brandSecondaryBrdBackgroundColor = clientHomePageParamentersVal.BrandSecondaryBrd_BackgroundColor__c;
                brandSecondaryBrdBorderColor = clientHomePageParamentersVal.BrandSecondaryBrd_BorderColor__c;
                brandSecondaryBrdBorderTopColor = clientHomePageParamentersVal.BrandSecondaryBrd_BorderTopColor__c;
                dataColColor = clientHomePageParamentersVal.DataCol_Color__c;
                dataColFontFamily = clientHomePageParamentersVal.DataCol_FontFamily__c;
				dataColFontSize = clientHomePageParamentersVal.DataCol_FontSize__c;
				dataRowColor = clientHomePageParamentersVal.DataRow_Color__c;
				dataRowFontSize	= clientHomePageParamentersVal.DataRow_FontSize__c;
                dataRowFontWeight	= clientHomePageParamentersVal.DataRow_FontWeight__c;
				dataRowFontFamily = clientHomePageParamentersVal.DataRow_FontFamily__c;
				dataRowHeight = clientHomePageParamentersVal.DataRow_Height__c;
				headerRowColor = clientHomePageParamentersVal.headerRow_Color__c;
				headerRowFontFamily = clientHomePageParamentersVal.HeaderRow_FontFamily__c;
				headerRowFontSize = clientHomePageParamentersVal.HeaderRow_FontSize__c;
				headerRowHeight = clientHomePageParamentersVal.HeaderRow_Height__c;
                headerRowFontWeight = clientHomePageParamentersVal.HeaderRow_FontWeight__c;
				instructionRleativeURL = clientHomePageParamentersVal.InstructionRleativeURL__c;
				listHeight = clientHomePageParamentersVal.ListHeight__c;
                listBorderColor = clientHomePageParamentersVal.ListBorderColor__c;
                listBorderWidth = clientHomePageParamentersVal.ListBorderWidth__c;
                listBorderBottomColor = clientHomePageParamentersVal.listBorderBottomColor__c;
				onHoverColor = clientHomePageParamentersVal.OnHover_Color__c;
				pageBackgroundColor = clientHomePageParamentersVal.Page_BackgroundColor__c;
				topLeftImage = clientHomePageParamentersVal.TopLeftImage__c;
                topRightVideo = clientHomePageParamentersVal.TopRightVideo__c;
                customizeTextFontSize = clientHomePageParamentersVal.CustomizeText_FontSize__c;
				customizeTextFontFamily = clientHomePageParamentersVal.CustomizeText_FontFamily__c;
				customizeTextColor = clientHomePageParamentersVal.CustomizeText_Color__c;
				customizeLinksFontSize = clientHomePageParamentersVal.CustomizeLinks_FontSize__c;
				customizeLinksFontFamily = clientHomePageParamentersVal.CustomizeLinks_FontFamily__c;
				customizeLinksColor = clientHomePageParamentersVal.CustomizeLinks_Color__c;
				customizeLinksTextDecoration = clientHomePageParamentersVal.CustomizeLinks_TextDecoration__c;
				customizeLinksTextAlign = clientHomePageParamentersVal.CustomizeLinks_TextAlign__c;
				brandSecondaryBrdMarginTop = clientHomePageParamentersVal.BrandSecondaryBrd_MarginTop__c;
				listMarginTop = clientHomePageParamentersVal.List_MarginTop__c;
				headerRowVeriticalAlignment = clientHomePageParamentersVal.HeaderRow_VeriticalAlignment__c;
				headerRowPaddingBottom = clientHomePageParamentersVal.HeaderRow_PaddingBottom__c;
				brandSecondaryBrdWidth = clientHomePageParamentersVal.BrandSecondaryBrd_Width__c;
				quickLinksBackground = clientHomePageParamentersVal.quickLinks_Background__c;
				quickLinksMarginTop = clientHomePageParamentersVal.quickLinks_MarginTop__c;
	 			quickLinksBorder = clientHomePageParamentersVal.quickLinks_Border__c;
				quickLinksBorderColor = clientHomePageParamentersVal.quickLinks_BorderColor__c;
	 			quickLinksHeight = clientHomePageParamentersVal.quickLinks_Height__c;
	 			imageVideoStylingMarginTop = clientHomePageParamentersVal.ImageVideoStyling_MarginTop__c;
	 			imageVideoStylingBorder = clientHomePageParamentersVal.ImageVideoStyling_Border__c;
	 			imageVideoStylingBorderColor = clientHomePageParamentersVal.ImageVideoStyling_BorderColor__c;
                createInstructionImageURL = clientHomePageParamentersVal.CreateInstructionImageURL__c;
                reviewInstructionImageURL = clientHomePageParamentersVal.ReviewInstructionImageURL__c;
            //}
        //}
        
        List<DDQuickActionPageComponents__c> quickActionPageParamentersList = DDQuickActionPageComponents__c.getall().values();
        
         if(loggedInUser.Contact.Account.DD_Due_Diligence_Portal_Licence__c.equals('Platform')){
            quickActionPageParamentersVal = DDQuickActionPageComponents__c.getall().get(Label.LUMA_Platform_Branding);
        }
        else {
            for(DDQuickActionPageComponents__c quickActionPageParamentersVal1 : quickActionPageParamentersList){
                if(String.valueOf(loggedInUser.contact.AccountId).substring(0,15).equals(quickActionPageParamentersVal1.DDPartnerAccountId__c)){
                    system.debug('partner Found');
                    system.debug('quickActionPageParamentersVal1.name :: '+quickActionPageParamentersVal1.name);
                    quickActionPageParamentersVal = DDQuickActionPageComponents__c.getall().get(quickActionPageParamentersVal1.Name);
                    break;
                }
            }
        }  
         
         //for(DDQuickActionPageComponents__c quickActionPageParamentersVal : quickActionPageParamentersList){
            //if(loggedInUser.contact!=null && String.valueOf(loggedInUser.contact.AccountId).substring(0,15).equals(quickActionPageParamentersVal.DDPartnerAccountId__c)){
           		h2Color = quickActionPageParamentersVal.h2_Color__c;	
				h2FontFamily = quickActionPageParamentersVal.h2_FontFamily__c;
				h2FontSize = quickActionPageParamentersVal.h2_FontSize__c;
				h2FontWeight = quickActionPageParamentersVal.h2_FontWeight__c;	 
				headerTextColor = quickActionPageParamentersVal.HeaderText_Color__c;	  
				headerTextFontFamily = quickActionPageParamentersVal.HeaderText_FontFamily__c;
				headerTextFontSize = quickActionPageParamentersVal.HeaderText_FontSize__c;	   	 	
				headerTextPadding = quickActionPageParamentersVal.HeaderText_Padding__c;	   	 
				headerTextBackground = quickActionPageParamentersVal.HeaderText_Background__c;	  
				headerTextDisplay = quickActionPageParamentersVal.HeaderText_Display__c;	  
				headerTextFontWeight = quickActionPageParamentersVal.HeaderText_FontWeight__c;	  
				onHoverColorQA = quickActionPageParamentersVal.OnHover_Color__c;	  
                onHoverFontWeightQA = quickActionPageParamentersVal.onHoverFontWeightQA__c;	
				quickLinksBackgroundQA = quickActionPageParamentersVal.QuickLinks_Background__c;	  
				quickLinksBackgroundColorQA = quickActionPageParamentersVal.QuickLinks_BackgroundColor__c;	  
				quickLinksColor = quickActionPageParamentersVal.QuickLinks_Color__c;	  
				quickLinksFontFamily = quickActionPageParamentersVal.QuickLinks_FontFamily__c;	 
				quickLinksFontSize = quickActionPageParamentersVal.QuickLinks_FontSize__c;	  
                quickLinksFontWeight = quickActionPageParamentersVal.QuickLinks_FontWeight__c;	
				quickLinksImagesTableBackgroundColor = quickActionPageParamentersVal.QuickLinksImagesTable_BackgroundColor__c;	  
				quickLinksImagesTableWidth = quickActionPageParamentersVal.QuickLinksImagesTable_Width__c;	 
				quickLinksPaddingLeft = quickActionPageParamentersVal.QuickLinks_PaddingLeft__c	;   	 	
				quickLinksTableBackgroundColor = quickActionPageParamentersVal.QuickLinksTable_BackgroundColor__c;	  	 	
				quickLinksTableHeight = quickActionPageParamentersVal.QuickLinksTable_Height__c;	   	 	
				quickLinksTableWidth = quickActionPageParamentersVal.QuickLinksTable_Width__c	;  	 	
				quickLinksTextDecoration = quickActionPageParamentersVal.QuickLinks_TextDecoration__c;	   	 	
				subsectionBackground = quickActionPageParamentersVal.Subsection_Background__c	;  	 	
				subsectionBackgroundColor = quickActionPageParamentersVal.Subsection_BackgroundColor__c	  ; 	 	
				subsectionFontFamily = quickActionPageParamentersVal.Subsection_FontFamily__c	;  	 	
				subsectionFontSize = quickActionPageParamentersVal.Subsection_FontSize__c	;  	 	
				subsectionHeight = quickActionPageParamentersVal.Subsection_Height__c;
				quickLinksTablePaddingTop = quickActionPageParamentersVal.QuickLinksTable_PaddingTop__c;
				quickLinksImagesTableHeight = quickActionPageParamentersVal.QuickLinksImagesTable_Height__c;
            //}
        //}   
         system.debug('DDClientHomePageController :: initializeBrandingParameters :: end');
     }
}