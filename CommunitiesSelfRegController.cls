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

 Code purpose  : An apex page controller that supports self registration of users in communities that allow self registration


 Birthday      : 2014-03-28
 Api version   : v26

 ****************************************************************************************************************************/


public class CommunitiesSelfRegController {

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String street {get; set;}
    public String city {get; set;}
    public String State {get; set;}
    public String postalCode {get; set;}
    public String country {get; set;}
    public String phone {get; set;}
    public String email {get; set;}
    public String userName {get; set;}
    public String accountId {get; set;}
    public String counterpartyPhoneNumber {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public String counterPartyInviteId;
    public List<CounterParty_Invite__c> cpInviteList;
    public String HtmlVisibility {get; set;}
    public String BodyMargin {get; set;}
    public String BodyTextAlign {get; set;}
    public String BodyBackgroundcolor {get; set;}
    public String TFloat {get; set;}
    public String TMarginTop {get; set;}
    public String TMarginLeft {get; set;}
    public String ThumbnailWidth {get; set;}
    public String ThumbnailHeight {get; set;}
    public String ThumbnailPaddingRight {get; set;}
    public String LogoWrapperMaxHeight {get; set;}
    public String LogoWrapperOverflow {get; set;}
    public String LogoWrapperMarginTop {get; set;}
    public String LogoWrapperHeight {get; set;}
    public String LogoWrapperWidth {get; set;}
    public String LogoWrapperTextAlign {get; set;}
    public String LogoWrapperMaxWidth {get; set;}
    public String LogoWrapperMarginBottom {get; set;}
    public String LoginBgBoxBorderRadius {get; set;}
    public String LoginBgBoxMozBgImage {get; set;}
    public String LoginBgBoxWebBgImage {get; set;}
    public String LoginBgBoxMsBgImage {get; set;}
    public String LoginBgBoxBoxShadow {get; set;}
    public String LoginBgBoxWidth {get; set;}
    public String LoginBgBoxHeight {get; set;}
    public String LoginBoxContainerBgColor {get; set;}
    public String LoginBoxContainerBorderStyle {get; set;}
    public String LoginBoxContainerBorderWidth {get; set;}
    public String LoginBoxContainerBorderColor {get; set;}
    public String LoginBoxContainerBorderRadius {get; set;}
    public String LoginBoxContainerHeight {get; set;}
    public String LoginBoxContainerWidth {get; set;}
    public String LoginBoxContainerMarginTop {get; set;}
    public String InputFontSize {get; set;}
    public String InputFontFamily {get; set;}
    public String InputColor {get; set;}
    public String InputFontLineHeight {get; set;}
    public String InputTextAlign {get; set;}
    public String InputBgColor {get; set;}
    public String TextLabelFontSize {get; set;}
    public String TextLabelFontFamily {get; set;}
    public String TextLabelColor {get; set;}
    public String TextLabelLineHeight {get; set;}
    public String TextLabelWidth {get; set;}
    public String TextLabelMarginLeft {get; set;}
    public String TextLabelMarginRight {get; set;}
    public String TextLabelMarginTop {get; set;}
    public String ContentWidth {get; set;}
    public String ContentMargin {get; set;}
    public String ContentTextAlign {get; set;}
    public String ContentBorder {get; set;}
    public String TitleWidth {get; set;}
    public String TitleCellPadding {get; set;}
    public String TitleCellSpacing {get; set;}
    public String TitleBGColor {get; set;}
    public String TitleColumns {get; set;}
    public String TitleTestAlign {get; set;}
    public String AColor {get; set;}
    public String InputPrimaryBg {get; set;}
    public String ButtonBorderStyle {get; set;}
    public String ButtonBorderWidth {get; set;}
    public String ButtonBorderColor {get; set;}
    public String ButtonBorderRadius {get; set;}
    public String ButtonMozBgImage {get; set;}
    public String ButtonWebBgImage {get; set;}
    public String ButtonMsBgImage {get; set;}
    public String ButtonWidth {get; set;}
    public String ButtonHeight {get; set;}
    public String ButtonFontSize {get; set;}
    public String ButtonFontFamily {get; set;}
    public String ButtonColor {get; set;}
    public String ButtonLineHeight {get; set;}
    public String ButtonTextAlign {get; set;}
    public String ButtonTextShadow {get; set;}
    public String ButtonMarginTop {get; set;}
    public String ButtonHoverBorderStyle {get; set;}
    public String ButtonHoverBorderWidth {get; set;}
    public String ButtonHoverBorderColor {get; set;}
    public String ButtonHoverBorderRadius {get; set;}
    public String ButtonHoverMozBgColor {get; set;}
    public String ButtonHoverWebBgColor {get; set;}
    public String ButtonHoverMsBgColor {get; set;}
    public String ButtonHoverWidth {get; set;}
    public String ButtonHoverHeight {get; set;}
    public String FooterColor {get; set;}
    public String ContentBgColor {get; set;}
    public String LeftSideFLoat {get; set;}
    public String RightSideMarginLeft {get; set;}
    public String MessageTableDisplay {get; set;}
    public String MessageTableWidth {get; set;}
    public String MessageTableHeight {get; set;}
    public String MessageTableTextAlign {get; set;}
    public String MessageTableFontSize {get; set;}
    public String MessageTableFontFamily {get; set;}
    public String MessageTableColor {get; set;}
    public String MessageTableLineHeight {get; set;}
    public String MessageTableBorderRadius {get; set;}
    public String MessageTableBgColor {get; set;}
    public String MessageTableMargin {get; set;}
    public String H4Display {get; set;}
    public String H4WebMarginBefore {get; set;}
    public String H4WebMarginAfter {get; set;}
    public String H4WebMarginStart {get; set;}
    public String H4WebMarginEnd {get; set;}
    public String H4FontWeight {get; set;}
    public String SpanColor {get; set;}
    public String MediaMaxWidth {get; set;}
    public String MediaRightSidePaddingLeft {get; set;}
    public String MediaRightSideDisplay {get; set;}
    public String MediaRightSideMarginLeft {get; set;}
    public String MediaRightSideMarginTop {get; set;}
    public String LeftSideWidth {get; set;}
    public String RightSideMarginTop {get; set;}
    public String HashContentBorder {get; set;}
    public String InputPaddingLeft {get; set;}
    
    // Default constructor
    public CommunitiesSelfRegController(){   
        
        system.debug('CommunitiesSelfRegController  :: CommunitiesSelfRegController :: start');
        List<DDCustomerRegistrationBrandingParameter__c> brandingParamentersList = DDCustomerRegistrationBrandingParameter__c.getall().values();
        
        // populate CustomerRegistration page styling parameters
        for(DDCustomerRegistrationBrandingParameter__c brandingParamentersVal : brandingParamentersList){
                HtmlVisibility  = brandingParamentersVal.HtmlVisibility__c;
                BodyMargin  = brandingParamentersVal.BodyMargin__c;
                BodyTextAlign  = brandingParamentersVal.BodyTextAlign__c;
                BodyBackgroundcolor  = brandingParamentersVal.BodyBackgroundcolor__c;
                TFloat  = brandingParamentersVal.TFloat__c;
                TMarginTop  = brandingParamentersVal.TMarginTop__c;
                TMarginLeft  = brandingParamentersVal.TMarginLeft__c;
                ThumbnailWidth  = brandingParamentersVal.ThumbnailWidth__c;
                ThumbnailHeight  = brandingParamentersVal.ThumbnailHeight__c;
                ThumbnailPaddingRight = brandingParamentersVal.ThumbnailHeight__c;
                LogoWrapperMaxHeight = brandingParamentersVal.LogoWrapperMaxHeight__c;
                LogoWrapperMaxWidth = brandingParamentersVal.LogoWrapperMaxWidth__c;
                LogoWrapperOverflow  = brandingParamentersVal.LogoWrapperOverflow__c;
                LogoWrapperMarginTop  = brandingParamentersVal.LogoWrapperMarginTop__c;
                LogoWrapperHeight  = brandingParamentersVal.LogoWrapperHeight__c;
                LogoWrapperWidth  = brandingParamentersVal.LogoWrapperWidth__c;
                LogoWrapperMarginBottom  = brandingParamentersVal.LogoWrapperMarginBottom__c;
                LoginBgBoxBorderRadius  = brandingParamentersVal.LoginBgBoxBorderRadius__c;
                LoginBgBoxMozBgImage  = brandingParamentersVal.LoginBgBoxMozBgImage__c;
                LoginBgBoxWebBgImage  = brandingParamentersVal.LoginBgBoxWebBgImage__c;
                LoginBgBoxMsBgImage  = brandingParamentersVal.LoginBgBoxMsBgImage__c;
                LoginBgBoxBoxShadow  = brandingParamentersVal.LoginBgBoxBoxShadow__c;
                LoginBgBoxWidth  = brandingParamentersVal.LoginBgBoxWidth__c;
                LoginBgBoxHeight = brandingParamentersVal.LoginBgBoxHeight__c;
                LoginBoxContainerBgColor = brandingParamentersVal.LoginBoxContainerBgColor__c;
                LoginBoxContainerBorderStyle  = brandingParamentersVal.LoginBoxContainerBorderStyle__c;
                LoginBoxContainerBorderWidth  = brandingParamentersVal.LoginBoxContainerBorderWidth__c;
                LoginBoxContainerBorderColor  = brandingParamentersVal.LoginBoxContainerBorderColor__c;
                LoginBoxContainerBorderRadius  = brandingParamentersVal.LoginBoxContainerBorderRadius__c;
                LoginBoxContainerHeight  = brandingParamentersVal.LoginBoxContainerHeight__c;
                LoginBoxContainerWidth = brandingParamentersVal.LoginBoxContainerWidth__c;
                LoginBoxContainerMarginTop  = brandingParamentersVal.LoginBoxContainerMarginTop__c;
                InputFontSize  = brandingParamentersVal.InputFontSize__c;
                InputFontFamily  = brandingParamentersVal.InputFontFamily__c;
                InputColor  = brandingParamentersVal.InputColor__c;
                InputFontLineHeight  = brandingParamentersVal.InputFontLineHeight__c;
                InputTextAlign  = brandingParamentersVal.InputTextAlign__c;
                InputBgColor  = brandingParamentersVal.InputBgColor__c;
                TextLabelFontSize  = brandingParamentersVal.TextLabelFontSize__c;
                TextLabelFontFamily  = brandingParamentersVal.TextLabelFontFamily__c;
                TextLabelColor  = brandingParamentersVal.TextLabelColor__c;
                TextLabelLineHeight  = brandingParamentersVal.TextLabelLineHeight__c;
                TextLabelWidth  = brandingParamentersVal.TextLabelWidth__c;
                TextLabelMarginLeft  = brandingParamentersVal.TextLabelMarginLeft__c;
                TextLabelMarginRight  = brandingParamentersVal.TextLabelMarginRight__c;
                TextLabelMarginTop  = brandingParamentersVal.TextLabelMarginTop__c;
                ContentWidth  = brandingParamentersVal.ContentWidth__c;
                ContentMargin  = brandingParamentersVal.ContentMargin__c;
                ContentTextAlign  = brandingParamentersVal.ContentTextAlign__c;
                ContentBorder  = brandingParamentersVal.ContentBorder__c;
                TitleWidth  = brandingParamentersVal.TitleWidth__c;
                TitleCellPadding  = brandingParamentersVal.TitleCellPadding__c;
                TitleCellSpacing  = brandingParamentersVal.TitleCellSpacing__c;
                TitleBGColor  = brandingParamentersVal.TitleBGColor__c;
                TitleColumns  = brandingParamentersVal.TitleColumns__c;
                TitleTestAlign  = brandingParamentersVal.TitleTestAlign__c;
                AColor  = brandingParamentersVal.AColor__c;
                InputPrimaryBg  = brandingParamentersVal.InputPrimaryBg__c;
                ButtonBorderStyle  = brandingParamentersVal.ButtonBorderStyle__c;
                ButtonBorderWidth  = brandingParamentersVal.ButtonBorderWidth__c;
                ButtonBorderColor  = brandingParamentersVal.ButtonBorderColor__c;
                ButtonBorderRadius  = brandingParamentersVal.ButtonBorderRadius__c;
                ButtonMozBgImage  = brandingParamentersVal.ButtonMozBgImage__c;
                ButtonWebBgImage  = brandingParamentersVal.ButtonWebBgImage__c;
                ButtonMsBgImage  = brandingParamentersVal.ButtonMsBgImage__c;
                ButtonWidth  = brandingParamentersVal.ButtonWidth__c;
                ButtonHeight  = brandingParamentersVal.ButtonHeight__c;
                ButtonFontSize  = brandingParamentersVal.ButtonFontSize__c;
                ButtonFontFamily  = brandingParamentersVal.ButtonFontFamily__c;
                ButtonColor  = brandingParamentersVal.ButtonColor__c;
                ButtonLineHeight  = brandingParamentersVal.ButtonLineHeight__c;
                ButtonTextAlign  = brandingParamentersVal.ButtonTextAlign__c;
                ButtonTextShadow  = brandingParamentersVal.ButtonTextShadow__c;
                ButtonMarginTop  = brandingParamentersVal.ButtonMarginTop__c;
                ButtonHoverBorderStyle  = brandingParamentersVal.ButtonHoverBorderStyle__c;
                ButtonHoverBorderWidth  = brandingParamentersVal.ButtonHoverBorderWidth__c;
                ButtonHoverBorderColor  = brandingParamentersVal.ButtonHoverBorderColor__c;
                ButtonHoverBorderRadius  = brandingParamentersVal.ButtonHoverBorderRadius__c;
                ButtonHoverMozBgColor  = brandingParamentersVal.ButtonHoverMozBgColor__c;
                ButtonHoverWebBgColor  = brandingParamentersVal.ButtonHoverWebBgColor__c;
                ButtonHoverMsBgColor  = brandingParamentersVal.ButtonHoverMsBgColor__c;
                ButtonHoverWidth  = brandingParamentersVal.ButtonHoverWidth__c;
                ButtonHoverHeight  = brandingParamentersVal.ButtonHoverHeight__c;
                FooterColor  = brandingParamentersVal.FooterColor__c;
                ContentBgColor  = brandingParamentersVal.ContentBgColor__c;
                LeftSideFLoat  = brandingParamentersVal.LeftSideFLoat__c;
                RightSideMarginLeft  = brandingParamentersVal.RightSideMarginLeft__c;
                MessageTableDisplay  = brandingParamentersVal.MessageTableDisplay__c;
                MessageTableWidth  = brandingParamentersVal.MessageTableWidth__c;
                MessageTableHeight  = brandingParamentersVal.MessageTableHeight__c;
                MessageTableTextAlign  = brandingParamentersVal.MessageTableTextAlign__c;
                MessageTableFontSize  = brandingParamentersVal.MessageTableFontSize__c;
                MessageTableFontFamily  = brandingParamentersVal.MessageTableFontFamily__c;
                MessageTableColor  = brandingParamentersVal.MessageTableColor__c;
                MessageTableLineHeight  = brandingParamentersVal.MessageTableLineHeight__c;
                MessageTableBorderRadius  = brandingParamentersVal.MessageTableBorderRadius__c;
                MessageTableBgColor  = brandingParamentersVal.MessageTableBgColor__c;
                MessageTableMargin  = brandingParamentersVal.MessageTableMargin__c;
                H4Display  = brandingParamentersVal.H4Display__c;
                H4WebMarginBefore  = brandingParamentersVal.H4WebMarginBefore__c;
                H4WebMarginAfter  = brandingParamentersVal.H4WebMarginAfter__c;
                H4WebMarginStart  = brandingParamentersVal.H4WebMarginStart__c;
                H4WebMarginEnd  = brandingParamentersVal.H4WebMarginEnd__c;
                H4FontWeight  = brandingParamentersVal.H4FontWeight__c;
                SpanColor  = brandingParamentersVal.SpanColor__c;
                MediaMaxWidth  = brandingParamentersVal.MediaMaxWidth__c;
                MediaRightSidePaddingLeft  = brandingParamentersVal.MediaRightSidePaddingLeft__c;
                MediaRightSideDisplay  = brandingParamentersVal.MediaRightSideDisplay__c;
                MediaRightSideMarginLeft  = brandingParamentersVal.MediaRightSideMarginLeft__c;
                MediaRightSideMarginTop  = brandingParamentersVal.MediaRightSideMarginTop__c;
                LeftSideWidth  = brandingParamentersVal.LeftSideWidth__c;
                RightSideMarginTop  = brandingParamentersVal.RightSideMarginTop__c;
                HashContentBorder  = brandingParamentersVal.HashContentBorder__c;
                LoginBgBoxHeight  = brandingParamentersVal.LoginBgBoxHeight__c;
                InputPaddingLeft = brandingParamentersVal.InputPaddingLeft__c;
            }
            system.debug('CommunitiesSelfRegController  :: CommunitiesSelfRegController :: end');
    }
    
    // Validate if password and confirm password are same
    private boolean isValidPassword() {
        system.debug('CommunitiesSelfRegController  :: isValidPassword :: start');
        return password == confirmPassword;
    }

    // populate firstname, lastname and email from counterparty record id
    public void populateFields(){
        
        system.debug('CommunitiesSelfRegController  :: populateFields :: start');
        counterPartyInviteId = ApexPages.currentPage().getParameters().get('cpInviteId');
        
        if(counterPartyInviteId!=null){
            cpInviteList = [Select c.DD_Send_Invite__c, c.DD_Last_Name__c, c.DD_First_Name__c, c.DD_Email__c, c.DD_Account__c, Counterparty_Registered__c,
                            DD_Questionnaire__c , createdbyid, 
                            c.DD_Account__r.DD_Automated_Questionnaire__c, DD_Account__r.Parent.Watchlist_Client__c, Counterparty_Phone__c,  
                            (Select Id From DD_Assessments__r) From CounterParty_Invite__c c where Id =: counterPartyInviteId];
        }
        system.debug('cpInviteList :: '+cpInviteList);
        
        if(cpInviteList!=null && cpInviteList.size()>0){
            firstName = cpInviteList.get(0).DD_First_Name__c;
            lastName = cpInviteList.get(0).DD_Last_Name__c;
            email = cpInviteList.get(0).DD_Email__c;
            accountId = cpInviteList.get(0).DD_Account__c;
            counterpartyPhoneNumber = cpInviteList.get(0).Counterparty_Phone__c;
        }
        system.debug('CommunitiesSelfRegController  :: populateFields :: end');
    }
    
    // call to register user and create contact in the salesforce
    public PageReference registerUser() {
    
        system.debug('CommunitiesSelfRegController  :: registerUser :: start');
        String userId;
        String profileId;
        
        
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.LUMA_Password_Error);
            ApexPages.addMessage(msg);
            return null;
        } 
        
        List<Profile__c> profileIdList = Profile__c.getall().values();
        
        for(Profile__c profileIdVal : profileIdList){
            if(profileIdVal.Name.equals('CounterParty')){
                profileId = profileIdVal.Value__c;
            }
        }   

        String roleEnum = null; // To be filled in by customer.
        String accountId = accountId; // To be filled in by customer.
        system.debug('accountId in registration :: '+accountId);
        //String userName = userName;

        User u = new User();
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.street = street; 
        u.city = city; 
        u.country= country; 
        u.State = State; 
        u.postalCode= postalCode; 
        u.phone= phone; 
        u.Counterparty_Phone_number__c = counterpartyPhoneNumber;
        if(lastName.length()>=4){
            u.CommunityNickname = firstName.subString(0,1)+lastName.subString(0,4)+System.now();
        }
        else{
            u.CommunityNickname = firstName.subString(0,1)+lastName+System.now();
        }
        u.ProfileId = profileId;
        
        // Create Portal User
        try{
            userId = Site.createPortalUser(u, accountId, password);
        }
        catch(Exception ex){            
            system.debug('Exception occurred :: '+ex.getMessage());
        }
        
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                try{
                    createAssessment(userId);
                    Pagereference pgRef = Site.login(u.Username, password, '/counterparty/home/home.jsp');
                    return pgRef;
                }
                catch(Exception ex){
                    system.debug('Exception occurred :: '+ex.getMessage());                    
                }
            }
            else {
                createAssessment(userId);
                PageReference page = System.Page.CommunitiesSelfRegConfirm;                
                page.setRedirect(true);
                return page;
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.DDCounterpartyRegistrationError));
        }
        system.debug('CommunitiesSelfRegController  :: registerUser :: end');
        return null;
    }
    
    /**
        This method create assessment on successful creation of Counterparty User 
    */
    private void createAssessment(Id userId){
        
        system.debug('CommunitiesSelfRegController  :: createAssessment :: start');
        Case cs;
        String assignmentQueueId;
        String clientGroupId;
        List<Case> caseList ;
        String verificationTeamQueueId;
        List<User> userList;
        try{        
            userList = [Select Id, Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c, 
                               Contact.Account.WL_Risk_Model_Questionnaire__c, Contact.Counterparty_Phone__c, 
                                    ContactId, Contact.OwnerId, Contact.name, Contact.Account.ParentId, 
                                    Contact.Account.CreatedById, Contact.Account.DD_Questionaire__c, 
                                    Contact.AccountId From User u where Id =: userId];  
        
        
            // Get verification queue Id        

            List<Queue__c> queueCustomSettingList = Queue__c.getall().values();        
            if(verificationTeamQueueId==null){
                for(Queue__c queueVal : queueCustomSettingList){
                    if(queueVal.Name.equals('Verification Team')){
                        verificationTeamQueueId = queueVal.Id__c;
                        break;
                    }            
                } 
            }
            system.debug('verificationTeamQueueId after queue :: '+verificationTeamQueueId);
            //List<DGL__c> accountGroupList = DGL__c.getall().values();
            
            // Assign newly created assessment to Client Compliance Queue
            List<DGL__c> dglCustomSettingList = DGL__c.getall().values();
            for(DGL__c accountGroupVal : dglCustomSettingList){
                /*if(accountGroupVal.Account__c.equals(String.valueOf(userList.get(0).Contact.Account.ParentId).subString(0,15)+'__CL_COMPLIANCE_TEAM_QUE')){
                    assignmentQueueId = accountGroupVal.Group__c;
                }*/
                if(accountGroupVal.Account__c.equals(String.valueOf(userList.get(0).Contact.Account.ParentId).subString(0,15)+'__CL_PARTNER_USER_ROLE')){
                    clientGroupId = accountGroupVal.Group__c;
                }
            }
        
            // populate fields in the assessment        
            if(cpInviteList!=null && cpInviteList.size()>0){
                for(CounterParty_Invite__c cpInviteVal : cpInviteList){
                    caseList = cpInviteVal.DD_Assessments__r;
                    userList.get(0).contact.Counterparty_Phone__c = cpInviteList.get(0).Counterparty_Phone__c;                    
                    if(caseList==null || caseList.size()==0){
                        cs = new Case();                                                                                   
                        cs.DD_Invitation__c = counterPartyInviteId ;
                        cs.Status = 'Open';
                        cpInviteList.get(0).Counterparty_Registered__c = true;
                        if(userList!=null && userList.size()>0){
                            cs.OwnerId = cpInviteList.get(0).createdbyId;//assignmentQueueId; 
                            cs.DD_Contact__c = userList.get(0).ContactId;
                            cs.Counterparty_User__c = userList.get(0).Id;
                            cs.ContactId = userList.get(0).ContactId;
                            cs.DD_Assessment_Name__c = userList.get(0).Contact.name;                        
                            if(cpInviteVal.DD_Account__r.Parent.Watchlist_Client__c){
                                cs.WL_Risk_Model_Questionnaire__c = userList.get(0).Contact.Account.WL_Risk_Model_Questionnaire__c ;   
                            }                 
                            else{
                                //cs.DD_Questionnaire_URL__c = userList.get(0).Contact.Account.DD_Questionaire__c;
                                cs.DD_Questionnaire_URL__c = cpInviteList.get(0).DD_Questionnaire__c;
                            }
                        }                            
                    }
                    else{ // if there is an assessment already created with a counterparty, update it
                        caseList.get(0).DD_Invitation__c = counterPartyInviteId ;
                        caseList.get(0).Status = 'Open';
                        cpInviteList.get(0).Counterparty_Registered__c = true;
                        if(userList!=null && userList.size()>0){
                            caseList.get(0).DD_Contact__c = userList.get(0).ContactId;
                            caseList.get(0).Counterparty_User__c = userList.get(0).Id;
                            caseList.get(0).DD_Assessment_Name__c = userList.get(0).Contact.name;
                            caseList.get(0).ContactId = userList.get(0).ContactId;                        
                            if(cpInviteVal.DD_Account__r.Parent.Watchlist_Client__c){
                                caseList.get(0).WL_Risk_Model_Questionnaire__c = userList.get(0).Contact.Account.WL_Risk_Model_Questionnaire__c ;
                            }
                            else{
                                //caseList.get(0).DD_Questionnaire_URL__c = userList.get(0).Contact.Account.DD_Questionaire__c;   
                                caseList.get(0).DD_Questionnaire_URL__c = cpInviteList.get(0).DD_Questionnaire__c;
                            }
                        }
                    }
                }
            }         
            if(cs!=null ){
                insert cs;
                //if(cpInviteList.get(0).DD_Account__r.DD_Automated_Questionnaire__c){
                    if(cpInviteList.get(0).DD_Account__r.Parent.Watchlist_Client__c){
                        cs.Send_Questionnaire_WLRM__c = true;                   
                    }
                    else{
                        cs.Send_Questionnaire__c = true; 
                    }
                    update cs;
                    update cpInviteList.get(0);
                    update userList.get(0).contact;
                //shareCaseWithClientGroup(cs, clientGroupId);
                //}
                
            }
            if(caseList!=null){
                //if(cpInviteList.get(0).DD_Account__r.DD_Automated_Questionnaire__c){
                    if(cpInviteList.get(0).DD_Account__r.Parent.Watchlist_Client__c){
                        caseList.get(0).Send_Questionnaire_WLRM__c = true; 
                    }
                    else{
                        caseList.get(0).Send_Questionnaire__c = true;
                    }                          
                    update caseList;
                    update cpInviteList.get(0);
                    update userList.get(0).contact;
               // }                
            }                        
        }
        catch(DMLException ex){
            system.debug('DML Exception Occurred while inserting Assessments (Case) :: '+ex.getMessage());
        }
        catch(Exception ex){
            system.debug('Exception Occurred while inserting Assessments (Case) :: '+ex.getMessage());
        }
        system.debug('CommunitiesSelfRegController  :: createAssessment :: end');
    }
    
   /* public void shareCaseWithClientGroup(Case cs, String clientGroupId){
        List<CaseShare> toShareList = new List<CaseShare>();
        CaseShare shr = new CaseShare(UserOrGroupId = clientGroupId , caseId = cs.Id, caseaccesslevel = 'edit');
        toShareList.add(shr);
        insert toShareList;
   }*/
}