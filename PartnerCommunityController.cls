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

 Code purpose  : Loads post login client specific styling


 Birthday      : 03/10/2014
 Api version   : v31

 ****************************************************************************************************************************/
 
public with sharing class PartnerCommunityController{

    public String AHoverColor {get;set;}
    public String AHoverWeight {get;set;}
    public String BodyBodyDivBFilterViewFontSize {get;set;}
    public String BodyBodyDivBFilterViewHeight {get;set;}
    public String BodyBPageTitleFontSize {get;set;}
    public String BodyBPageTitleFontWeight {get;set;}
    public String BodyBPageTitleLineHeight {get;set;}
    public String BodyBPageTitlePtBodyPageTypeFontFamily {get;set;}
    public String BodyBPageTitlePtBodyPageTypeFontSize {get;set;}
    public String BodyBPageTitlePtBodyPageTypeFontWeight {get;set;}
    public String BodyButtonBorderColor {get;set;}
    public String BodyButtonBorderRadius {get;set;}
    public String BodyButtonBorderStyle {get;set;}
    public String BodyButtonBorderWidth {get;set;}
    public String BodyButtonHeight {get;set;}
    public String BodyButtonMoxBgImage {get;set;}
    public String BodyButtonMsBgImage {get;set;}
    public String BodyButtonWebBgImage {get;set;}
    public String BodyDivBgColor {get;set;}
    public String BodyDivDisplay {get;set;}
    public String BodyDivFloat {get;set;}
    public String BodyDivMargin {get;set;}
    public String BodyDivMarginTop {get;set;}
    public String BodyTablePaddingBottom {get;set;}
    public String BPageHeaderBgImage {get;set;}
    public String BrandPrimaryBgrBgColor {get;set;}
    public String BrandPrimaryBgrFontFamily {get;set;}
    public String BrandPrimaryBgrFontSize {get;set;}
    public String BrandPrimaryBgrHeight {get;set;}
    public String BrandPrimaryBrdBorderTopColor {get;set;}
    public String BrandPrimaryFgrColor {get;set;}
    public String BrandPrimaryFgrFontFamily {get;set;}
    public String BrandPrimaryFgrFontSize {get;set;}
    public String BrandPrimaryFgrFontWeight {get;set;}
    public String BrandQuaternaryBgrMozBg {get;set;}
    public String BrandQuaternaryBgrMsBg {get;set;}
    public String BrandQuaternaryBgrWebBg {get;set;}
    public String BrandSecondaryBrdBorderColor {get;set;}
    public String BRelatedListCaseBlockBTitleMargin {get;set;}
    public String BRelatedListCaseBlockDisplay {get;set;}
    public String BRelatedListCaseBlockPosition {get;set;}
    public String BRelatedListCaseMarginLeft {get;set;}
    public String BRelatedListCaseMarginTop {get;set;}
    public String BRelatedListContactBlockBTitleMargin {get;set;}
    public String BRelatedListContactBlockDisplay {get;set;}
    public String BRelatedListContactBlockMarginLeft {get;set;}
    public String BRelatedListContactBlockMarginTop {get;set;}
    public String BRelatedListContactBlockPosition {get;set;}
    public String BRelatedListCustom20BlockBTitleMargin {get;set;}
    public String BRelatedListCustom20BlockDisplay {get;set;}
    public String BRelatedListCustom20BlockMarginLeft {get;set;}
    public String BRelatedListCustom20BlockMarginTop {get;set;}
    public String BRelatedListCustom20BlockPosition {get;set;}
    public String BRelatedListCustom99BlockBTitleMargin {get;set;}
    public String BRelatedListDisplay {get;set;}
    public String BRelatedListMarginLeft {get;set;}
    public String BRelatedListMarginTop {get;set;}
    public String BRelatedListPosition {get;set;}
    public String CommunitybodyBgColor {get;set;}
    public String CommunitybodyDisplay {get;set;}
    public String CommunitybodyMinHeight {get;set;}
    public String CommunitybodyPosition {get;set;}
    public String CommunitybodyWidth {get;set;}
    public String CommunityFooter {get;set;}
    public String CommunityfooterBgColor {get;set;}
    public String CommunityfooterBgPosition {get;set;}
    public String CommunityfooterBgURL {get;set;}
    public String CommunityfooterFooterBgRepeat {get;set;}
    public String CommunityfooterHeight {get;set;}
    public String CommunityfooterLeft {get;set;}
    public String CommunityfooterMarginLeft {get;set;}
    public String CommunityfooterMarginRight {get;set;}
    public String CommunityfooterWidth {get;set;}
    public String CommunityheaderBgColor {get;set;}
    public String CommunityheaderbotHeight {get;set;}
    public String CommunityheaderbotMarginTop {get;set;}
    public String CommunityheaderbotWidth {get;set;}
    public String CommunityheaderHeight {get;set;}
    public String CommunityheaderMargin {get;set;}
    public String CommunityheadertopHeight {get;set;}
    public String CommunityheadertopWidth {get;set;}
    public String CommunityheaderWidth {get;set;}
    public String CommunityLogo {get;set;}
    public String CommunitylogoBgSize {get;set;}
    public String CommunitylogoBgURL {get;set;}
    public String CommunitylogoFloat {get;set;}
    public String CommunitylogoHeight {get;set;}
    public String CommunitylogoMarginTop {get;set;}
    public String CommunitylogoWidth {get;set;}
    public String CommunityPageTitleIcon {get;set;}
    public String CommunityPrimaryColor {get;set;}
    public String CommunitySearchBox {get;set;}
    public String CommunitysearchFloat {get;set;}
    public String CommunitysearchHeight {get;set;}
    public String CommunitysearchPadding {get;set;}
    public String CommunitysearchSearchButtonDisplay {get;set;}
    public String CommunitysearchSearchFocusOutlineWidth {get;set;}
    public String CommunitysearchSearchTextboxBgColor {get;set;}
    public String CommunitysearchSearchTextboxBorderColor {get;set;}
    public String CommunitysearchSearchTextboxBorderFontSi {get;set;}
    public String CommunitysearchSearchTextboxBorderHeight {get;set;}
    public String CommunitysearchSearchTextboxBorderMargin {get;set;}
    public String CommunitysearchSearchTextboxBorderPLeft {get;set;}
    public String CommunitysearchSearchTextboxBorderPositi {get;set;}
    public String CommunitysearchSearchTextboxBorderRadius {get;set;}
    public String CommunitysearchSearchTextboxBorderStyle {get;set;}
    public String CommunitysearchSearchTextboxBorderWidth {get;set;}
    public String CommunitysearchSearchTextboxColor {get;set;}
    public String CommunitysearchSearchTextboxFontFamily {get;set;}
    public String CommunitysearchSearchTextboxFontSize {get;set;}
    public String CommunitysearchSearchTextboxHeight {get;set;}
    public String CommunitysearchSearchTextboxLineHeight {get;set;}
    public String CommunitysearchSearchTextboxTextAlign {get;set;}
    public String CommunitysearchSearchTextboxTexTShadow {get;set;}
    public String CommunitysearchSearchTextboxWidth {get;set;}
    public String CommunitysearchWidth {get;set;}
    public String CommunitySecondaryColor {get;set;}
    public String CommunityTertiaryColor {get;set;}
    public String CommunityWidth {get;set;}
    public String CommunitywrapperDisplay {get;set;}
    public String CommunitywrapperMargin {get;set;}
    public String CommunitywrapperWidth {get;set;}
    public String ContentWrapperMinWidth {get;set;}
    public String ContentWrapperMozBg {get;set;}
    public String ContentWrapperMsBg {get;set;}
    public String ContentWrapperWebBg {get;set;}
    public String FooterclassMarginLeft {get;set;}
    public String FooterContentColor {get;set;}
    public String FooterContentFontFamily {get;set;}
    public String FooterContentFontSize {get;set;}
    public String FooterContentTextDecoration {get;set;}
    public String HandlebarContainerBg {get;set;}
    public String HandlebarContainerHeight {get;set;}
    public String HandlebarContainerRight {get;set;}
    public String HandlebarContainerWidth {get;set;}
    public String handlebarContainerOnHoverbackground {get;set;}
    public String handlebarContainerOnFocusbackground {get;set;}
    public String HashZenNavMenusMarginRight {get;set;}
    public String HomeTabBorderTopColor {get;set;}
    public String HtmlBgColor {get;set;}
    public String HtmlBgImage {get;set;}
    public String HtmlPosition {get;set;}
    public String IdeaContentIdeaBodyWidth {get;set;}
    public String IdeaPageLayoutWithProfileSidebarDisplay {get;set;}
    public String IdeaPageLayoutWithProfileSidebarOverflow {get;set;}
    public String IdeaPageLayoutWithProfileSidebarWidth {get;set;}
    public String PageSectionMarginTop {get;set;}
    public String PageTitleIconDisplay {get;set;}
    public String PageTitleIconFloat {get;set;}
    public String PageTitleIconMarginRight {get;set;}
    public String PageTitleIconWidth {get;set;}
    public String PageWidgetBoxSizing {get;set;}
    public String PageWidgetFloat {get;set;}
    public String PageWidgetNthChildPaddingRight {get;set;}
    public String PageWidgetPFirstLetterFontSize {get;set;}
    public String pageWidgetPLineHeight {get;set;}
    public String pageWidgetPMargin {get;set;}
    public String PageWidgetPPadding {get;set;}
    public String PageWidgetWidth {get;set;}
    public String PartnerAccountId {get;set;}
    public String RelatedListIconDisplay {get;set;}
    public String SearchButtonDivBgPosition {get;set;}
    public String SearchButtonDivBgRepeat {get;set;}
    public String SearchButtonDivBorderColor {get;set;}
    public String SearchButtonDivBorderHeight {get;set;}
    public String SearchButtonDivBorderRadius {get;set;}
    public String SearchButtonDivBorderStyle {get;set;}
    public String SearchButtonDivBorderWidth {get;set;}
    public String SearchButtonDivHoverBgPosition {get;set;}
    public String SearchButtonDivHoverBgRepeat {get;set;}
    public String SearchButtonDivHoverBorderColor {get;set;}
    public String SearchButtonDivHoverBorderRadius {get;set;}
    public String SearchButtonDivHoverBorderStyle {get;set;}
    public String SearchButtonDivHoverBorderWidth {get;set;}
    public String SearchButtonDivHoverHeight {get;set;}
    public String SearchButtonDivHoverMargin {get;set;}
    public String SearchButtonDivHoverMozBgImage {get;set;}
    public String SearchButtonDivHoverMsBgImage {get;set;}
    public String SearchButtonDivHoverWebBgImage {get;set;}
    public String SearchButtonDivHoverWidth {get;set;}
    public String SearchButtonDivMargin {get;set;}
    public String SearchButtonDivMozBgImage {get;set;}
    public String SearchButtonDivMsBgImage {get;set;}
    public String SearchButtonDivWebBgImage {get;set;}
    public String SearchButtonDivWidth {get;set;}
    public String SideBarBg {get;set;}
    public String SideBarBgColor {get;set;}
    public String SideBarBorderTopLeftRadius {get;set;}
    public String SidebarCollapsedBg {get;set;}
    public String SideBarFontFamily {get;set;}
    public String SideBarFontSize {get;set;}
    public String SideBarFontWeight {get;set;}
    public String SidebarModuleHeaderBg {get;set;}
    public String SidebarModuleHeaderDisplay {get;set;}
    public String SidebarModuleHeaderPadding {get;set;}
    public String SideBarPaddingLeft {get;set;}
    public String SideBarLinkColor {get;set;}
    public String SpeechIconHeight {get;set;}
    public String SpeechIconMarginRight {get;set;}
    public String SpeechIconWidth {get;set;}
    public String TabBarMargin {get;set;}
    public String UserPhotoBorderRadius {get;set;}
    public String UserPhotoFloat {get;set;}
    public String UserPhotoHeight {get;set;}
    public String UserPhotoMarginRight {get;set;}
    public String UserPhotoWidth {get;set;}
    public String WelcomeImageBorderRadius {get;set;}
    public String WelcomeImageWidth {get;set;}
    public String WelcomeMessageBg {get;set;}
    public String WelcomeMessageBorderRadius {get;set;}
    public String WelcomeMessageColor {get;set;}
    public String WelcomeMessageDisplay {get;set;}
    public String WelcomeMessageFontFamily {get;set;}
    public String WelcomeMessageFontSize {get;set;}
    public String WelcomeMessageFontStyle {get;set;}
    public String WelcomeMessageHeight {get;set;}
    public String WelcomeMessageHoverCursor {get;set;}
    public String WelcomeMessageHoverOpacity {get;set;}
    public String WelcomeMessageLineHeight {get;set;}
    public String WelcomeMessageMaxWidth {get;set;}
    public String WelcomeMessageOpacity {get;set;}
    public String WelcomeMessagePadding {get;set;}
    public String WelcomeMessagePDisplay {get;set;}
    public String WelcomeMessagePFloat {get;set;}
    public String WelcomeMessagePMargin {get;set;}
    public String WelcomeMessagePosition {get;set;}
    public String WelcomeMessageTextAlign {get;set;}
    public String WelcomeMessageTop {get;set;}
    public String WidgetContentBg {get;set;}
    public String WidgetContentBorderRadius {get;set;}
    public String WidgetContentMinHeight {get;set;}
    public String WidgetContentPadding {get;set;}
    public String WidgetContentTableWidth {get;set;}
    public String WidgetLabelFontSize {get;set;}
    public String WidgetRowWidth {get;set;}
    public String WidgetTitleBg {get;set;}
    public String WidgetTitleBorderRadius {get;set;}
    public String WidgetTitleColor {get;set;}
    public String WidgetTitleColorTextTransform {get;set;}
    public String WidgetTitleFloat {get;set;}
    public String WidgetTitleFontSize {get;set;}
    public String WidgetTitleHeight {get;set;}
    public String WidgetTitleImgHeight {get;set;}
    public String WidgetTitleImgMarginTop {get;set;}
    public String WidgetTitleImgWidth {get;set;}
    public String WidgetTitleLineHeight {get;set;}
    public String WidgetTitleMarginBottom {get;set;}
    public String WidgetTitleMargingTop {get;set;}
    public String WidgetTitlePadding {get;set;}
    public String ZenActiveBg {get;set;}
    public String ZenActiveBorderColor {get;set;}
    public String ZenActiveBorderStyle {get;set;}
    public String ZenActiveBorderTopLeftRadius {get;set;}
    public String ZenActiveBorderTopRightRadius {get;set;}
    public String ZenActiveBorderWidth {get;set;}
    public String ZenActiveBoxShadow {get;set;}
    public String ZenActiveColor {get;set;}
    public String ZenActiveMarginRight {get;set;}
    public String ZenBodyZenBrdPaletteBorderRadius {get;set;}
    public String ZenBodyZenBrdPaletteBoxShadow {get;set;}
    public String ZenHighlightBtnBorder {get;set;}
    public String ZenHighlightBtnBorderColor {get;set;}
    public String ZenHighlightBtnBorderRadius {get;set;}
    public String ZenHighlightBtnBorderStyle {get;set;}
    public String ZenHighlightBtnBorderWidth {get;set;}
    public String ZenHighlightBtnColor {get;set;}
    public String ZenHighlightBtnFontSize {get;set;}
    public String ZenHighlightBtnFontWeight {get;set;}
    public String ZenHighlightBtnHeight {get;set;}
    public String ZenHighlightBtnMargin {get;set;}
    public String ZenHighlightBtnMozBgImage {get;set;}
    public String ZenHighlightBtnMsBgImage {get;set;}
    public String ZenHighlightBtnWebBgImage {get;set;}
    public String ZenNavMenusMarginRight {get;set;}
    public String ZenTabContainerBg {get;set;}
    public String ZenTabContainerBoxShadow {get;set;}
    public String ZenTabContainerHeight {get;set;}
    public String ZenTabContainerPosition {get;set;}
    public String ZenTabContainerTop {get;set;}
    public String ZenTabMenuAColor {get;set;}
    public String ZenTabMenuADisplay {get;set;}
    public String ZenTabMenuAFontFamily {get;set;}
    public String ZenTabMenuAFontSize {get;set;}
    public String ZenTabMenuAFontWeight {get;set;}
    public String ZenTabMenuAHoverColor {get;set;}
    public String ZenTabMenuAHoverTextDecoration {get;set;}
    public String ZenTabMenuAPadding {get;set;}
    public String ZenTabMenuATextAlign {get;set;}
    public String ZenTabMenuATextTransform {get;set;}
    public String ZenTabMenuBg {get;set;}
    public String ZenTabMenuBorder {get;set;}
    public String ZenTabMenuBorderRadius {get;set;}
    public String ZenTabMenuHeight {get;set;}
    public String ZenTabMenuLineHeight {get;set;}
    public String ZenTabMenuMargin {get;set;}
    public String ZenTabMenuMinWidth {get;set;}
    public String ZenTabMenuPadding {get;set;}
    public String ZenTabMenuTextAlign {get;set;}
    public String ZenZenTabMenuPadding {get;set;}
    public String ZenActiveAHoverColor {get;set;}
    public String ZenActiveAHoverBorderWidth {get;set;}
    public String ZenActiveAHoverBorderStyle {get;set;}
    public String ZenActiveAHoverBorderColor {get;set;} 
    public String BrandPrimaryBrdMarginTop {get;set;}
    public String BodyTableMarginBottom {get;set;}
    public String brandSecondaryBrdMarginRight{get;set;}
    public String brandSecondaryBrdMarginLeft{get;set;}
    public String relatedListTitleFontSize{get;set;}
    public String relatedListTitleFontFamily{get;set;}
    public String relatedListTitleColor{get;set;}
    public String relatedListTitleTextDecoration{get;set;}
    public String relatedListTitleTextAlign{get;set;}
    public String relatedListTitleFontWeight{get;set;}
    public String relatedListTitleMarginLeft{get;set;}
    
    
    /**
        Constructor to load post login client specific styling
    */
    public void initializeBrandingParameters(){
    
        system.debug('PartnerCommunityController :: initializeBrandingParameters :: start');
        system.debug('URL  :: '+URL.getCurrentRequestUrl().getQuery());
        DDBrandingParameters__c brandingParamentersVal;
        User loggedInUser = [select Id, contact.AccountId, Contact.Account.DD_Due_Diligence_Portal_Licence__c from User where Id =:  Userinfo.getUserId()];
        List<DDBrandingParameters__c> brandingParamentersList = DDBrandingParameters__c.getall().values();
        
        if(loggedInUser.Contact.Account.DD_Due_Diligence_Portal_Licence__c.equals('Platform')){
            brandingParamentersVal = DDBrandingParameters__c.getall().get(Label.LUMA_Platform_Branding);
        }
        else {
            for(DDBrandingParameters__c brandingParamentersVal1 : brandingParamentersList){
                if(String.valueOf(loggedInUser.contact.AccountId).substring(0,15).equals(brandingParamentersVal1.PartnerAccountId__c)){
                    system.debug('partner Found');
                    system.debug('brandingParamentersVal.Community_Footer__c :: '+brandingParamentersVal1.Community_Footer__c);
                    brandingParamentersVal = DDBrandingParameters__c.getall().get(brandingParamentersVal1.Name);
                    break;
                }
            }
        }
        
        //for(DDBrandingParameters__c brandingParamentersVal : brandingParamentersList){
            //if(String.valueOf(loggedInUser.contact.AccountId).substring(0,15).equals(brandingParamentersVal.PartnerAccountId__c)){                
                AHoverColor = brandingParamentersVal.AHoverColor__c;
                AHoverWeight = brandingParamentersVal.AHoverWeight__c;
                BodyBodyDivBFilterViewFontSize = brandingParamentersVal.BodyBodyDivBFilterViewFontSize__c;
                BodyBodyDivBFilterViewHeight = brandingParamentersVal.BodyBodyDivBFilterViewHeight__c;
                BodyBPageTitleFontSize = brandingParamentersVal.BodyBPageTitleFontSize__c;
                BodyBPageTitleFontWeight = brandingParamentersVal.BodyBPageTitleFontWeight__c;
                BodyBPageTitleLineHeight = brandingParamentersVal.BodyBPageTitleLineHeight__c;
                BodyBPageTitlePtBodyPageTypeFontFamily = brandingParamentersVal.BodyBPageTitlePtBodyPageTypeFontFamily__c;
                BodyBPageTitlePtBodyPageTypeFontSize = brandingParamentersVal.BodyBPageTitlePtBodyPageTypeFontSize__c;
                BodyBPageTitlePtBodyPageTypeFontWeight = brandingParamentersVal.BodyBPageTitlePtBodyPageTypeFontWeight__c;
                BodyButtonBorderColor = brandingParamentersVal.BodyButtonBorderColor__c;
                BodyButtonBorderRadius = brandingParamentersVal.BodyButtonBorderRadius__c;
                BodyButtonBorderStyle = brandingParamentersVal.BodyButtonBorderStyle__c;
                BodyButtonBorderWidth = brandingParamentersVal.BodyButtonBorderWidth__c;
                BodyButtonHeight = brandingParamentersVal.BodyButtonHeight__c;
                BodyButtonMoxBgImage = brandingParamentersVal.BodyButtonMoxBgImage__c;
                BodyButtonMsBgImage = brandingParamentersVal.BodyButtonMsBgImage__c;
                BodyButtonWebBgImage = brandingParamentersVal.BodyButtonWebBgImage__c;
                BodyDivBgColor = brandingParamentersVal.BodyDivBgColor__c;
                BodyDivDisplay = brandingParamentersVal.BodyDivDisplay__c;
                BodyDivFloat = brandingParamentersVal.BodyDivFloat__c;
                BodyDivMargin = brandingParamentersVal.BodyDivMargin__c;
                BodyDivMarginTop = brandingParamentersVal.BodyDivMarginTop__c;
                BodyTablePaddingBottom = brandingParamentersVal.BodyTablePaddingBottom__c;
                BPageHeaderBgImage = brandingParamentersVal.BPageHeaderBgImage__c;
                BrandPrimaryBgrBgColor = brandingParamentersVal.BrandPrimaryBgrBgColor__c;
                BrandPrimaryBgrFontFamily = brandingParamentersVal.BrandPrimaryBgrFontFamily__c;
                BrandPrimaryBgrFontSize = brandingParamentersVal.BrandPrimaryBgrFontSize__c;
                BrandPrimaryBgrHeight = brandingParamentersVal.BrandPrimaryBgrHeight__c;
                BrandPrimaryBrdBorderTopColor = brandingParamentersVal.BrandPrimaryBrdBorderTopColor__c;
                BrandPrimaryFgrColor = brandingParamentersVal.BrandPrimaryFgrColor__c;
                BrandPrimaryFgrFontFamily = brandingParamentersVal.BrandPrimaryFgrFontFamily__c;
                BrandPrimaryFgrFontSize = brandingParamentersVal.BrandPrimaryFgrFontSize__c;
                BrandPrimaryFgrFontWeight = brandingParamentersVal.BrandPrimaryFgrFontWeight__c;
                BrandQuaternaryBgrMozBg = brandingParamentersVal.BrandQuaternaryBgrMozBg__c;
                BrandQuaternaryBgrMsBg = brandingParamentersVal.BrandQuaternaryBgrMsBg__c;
                BrandQuaternaryBgrWebBg = brandingParamentersVal.BrandQuaternaryBgrWebBg__c;
                BrandSecondaryBrdBorderColor = brandingParamentersVal.BrandSecondaryBrdBorderColor__c;
                BRelatedListCaseBlockBTitleMargin = brandingParamentersVal.BRelatedListCaseBlockBTitleMargin__c;
                BRelatedListCaseBlockDisplay = brandingParamentersVal.BRelatedListCaseBlockDisplay__c;
                BRelatedListCaseBlockPosition = brandingParamentersVal.BRelatedListCaseBlockPosition__c;
                BRelatedListCaseMarginLeft = brandingParamentersVal.BRelatedListCaseMarginLeft__c;
                BRelatedListCaseMarginTop = brandingParamentersVal.BRelatedListCaseMarginTop__c;
                BRelatedListContactBlockBTitleMargin = brandingParamentersVal.BRelatedListContactBlockBTitleMargin__c;
                BRelatedListContactBlockDisplay = brandingParamentersVal.BRelatedListContactBlockDisplay__c;
                BRelatedListContactBlockMarginLeft = brandingParamentersVal.BRelatedListContactBlockMarginLeft__c;
                BRelatedListContactBlockMarginTop = brandingParamentersVal.BRelatedListContactBlockMarginTop__c;
                BRelatedListContactBlockPosition = brandingParamentersVal.BRelatedListContactBlockPosition__c;
                BRelatedListCustom20BlockBTitleMargin = brandingParamentersVal.BRelatedListCustom20BlockBTitleMargin__c;
                BRelatedListCustom20BlockDisplay = brandingParamentersVal.BRelatedListCustom20BlockDisplay__c;
                BRelatedListCustom20BlockMarginLeft = brandingParamentersVal.BRelatedListCustom20BlockMarginLeft__c;
                BRelatedListCustom20BlockMarginTop = brandingParamentersVal.BRelatedListCustom20BlockMarginTop__c;
                BRelatedListCustom20BlockPosition = brandingParamentersVal.BRelatedListCustom20BlockPosition__c;
                BRelatedListCustom99BlockBTitleMargin = brandingParamentersVal.BRelatedListCustom99BlockBTitleMargin__c;
                BRelatedListDisplay = brandingParamentersVal.BRelatedListDisplay__c;
                BRelatedListMarginLeft = brandingParamentersVal.BRelatedListMarginLeft__c;
                BRelatedListMarginTop = brandingParamentersVal.BRelatedListMarginTop__c;
                BRelatedListPosition = brandingParamentersVal.BRelatedListPosition__c;
                CommunitybodyBgColor = brandingParamentersVal.CommunitybodyBgColor__c;
                CommunitybodyDisplay = brandingParamentersVal.CommunitybodyDisplay__c;
                CommunitybodyMinHeight = brandingParamentersVal.CommunitybodyMinHeight__c;
                CommunitybodyPosition = brandingParamentersVal.CommunitybodyPosition__c;
                CommunitybodyWidth = brandingParamentersVal.CommunitybodyWidth__c;
                CommunityFooter = brandingParamentersVal.Community_Footer__c;
                CommunityfooterBgColor = brandingParamentersVal.CommunityfooterBgColor__c;
                CommunityfooterBgPosition = brandingParamentersVal.CommunityfooterBgPosition__c;
                CommunityfooterBgURL = brandingParamentersVal.CommunityfooterBgURL__c;
                CommunityfooterFooterBgRepeat = brandingParamentersVal.CommunityfooterFooterBgRepeat__c;
                CommunityfooterHeight = brandingParamentersVal.CommunityfooterHeight__c;
                CommunityfooterLeft = brandingParamentersVal.CommunityfooterLeft__c;
                CommunityfooterMarginLeft = brandingParamentersVal.CommunityfooterMarginLeft__c;
                CommunityfooterMarginRight = brandingParamentersVal.CommunityfooterMarginRight__c;
                CommunityfooterWidth = brandingParamentersVal.CommunityfooterWidth__c;
                CommunityheaderBgColor = brandingParamentersVal.CommunityheaderBgColor__c;
                CommunityheaderbotHeight = brandingParamentersVal.CommunityheaderbotHeight__c;
                CommunityheaderbotMarginTop = brandingParamentersVal.CommunityheaderbotMarginTop__c;
                CommunityheaderbotWidth = brandingParamentersVal.CommunityheaderbotWidth__c;
                CommunityheaderHeight = brandingParamentersVal.CommunityheaderHeight__c;
                CommunityheaderMargin = brandingParamentersVal.CommunityheaderMargin__c;
                CommunityheadertopHeight = brandingParamentersVal.CommunityheadertopHeight__c;
                CommunityheadertopWidth = brandingParamentersVal.CommunityheadertopWidth__c;
                CommunityheaderWidth = brandingParamentersVal.CommunityheaderWidth__c;
                CommunityLogo = brandingParamentersVal.CommunityLogo__c;
                CommunitylogoBgSize = brandingParamentersVal.CommunitylogoBgSize__c;
                CommunitylogoBgURL = brandingParamentersVal.CommunitylogoBgURL__c;
                CommunitylogoFloat = brandingParamentersVal.CommunitylogoFloat__c;
                CommunitylogoHeight = brandingParamentersVal.CommunitylogoHeight__c;
                CommunitylogoMarginTop = brandingParamentersVal.CommunitylogoMarginTop__c;
                CommunitylogoWidth = brandingParamentersVal.CommunitylogoWidth__c;
                CommunityPageTitleIcon = brandingParamentersVal.CommunityPageTitleIcon__c;
                CommunityPrimaryColor = brandingParamentersVal.Community_Primary_Color__c;
                CommunitySearchBox = brandingParamentersVal.Community_Search_Box__c;
                CommunitysearchFloat = brandingParamentersVal.CommunitysearchFloat__c;
                CommunitysearchHeight = brandingParamentersVal.CommunitysearchHeight__c;
                CommunitysearchPadding = brandingParamentersVal.CommunitysearchPadding__c;
                CommunitysearchSearchButtonDisplay = brandingParamentersVal.CommunitysearchSearchButtonDisplay__c;
                CommunitysearchSearchFocusOutlineWidth = brandingParamentersVal.CommunitysearchSearchFocusOutlineWidth__c;
                CommunitysearchSearchTextboxBgColor = brandingParamentersVal.CommunitysearchSearchTextboxBgColor__c;
                CommunitysearchSearchTextboxBorderColor = brandingParamentersVal.CommunitysearchSearchTextboxBorderColor__c;
                CommunitysearchSearchTextboxBorderFontSi = brandingParamentersVal.CommunitysearchSearchTextboxBorderFontSi__c;
                CommunitysearchSearchTextboxBorderHeight = brandingParamentersVal.CommunitysearchSearchTextboxBorderHeight__c;
                CommunitysearchSearchTextboxBorderMargin = brandingParamentersVal.CommunitysearchSearchTextboxBorderMargin__c;
                CommunitysearchSearchTextboxBorderPLeft = brandingParamentersVal.CommunitysearchSearchTextboxBorderPLeft__c;
                CommunitysearchSearchTextboxBorderPositi = brandingParamentersVal.CommunitysearchSearchTextboxBorderPositi__c;
                CommunitysearchSearchTextboxBorderRadius = brandingParamentersVal.CommunitysearchSearchTextboxBorderRadius__c;
                CommunitysearchSearchTextboxBorderStyle = brandingParamentersVal.CommunitysearchSearchTextboxBorderStyle__c;
                CommunitysearchSearchTextboxBorderWidth = brandingParamentersVal.CommunitysearchSearchTextboxBorderWidth__c;
                CommunitysearchSearchTextboxColor = brandingParamentersVal.CommunitysearchSearchTextboxColor__c;
                CommunitysearchSearchTextboxFontFamily = brandingParamentersVal.CommunitysearchSearchTextboxFontFamily__c;
                CommunitysearchSearchTextboxFontSize = brandingParamentersVal.CommunitysearchSearchTextboxFontSize__c;
                CommunitysearchSearchTextboxHeight = brandingParamentersVal.CommunitysearchSearchTextboxHeight__c;
                CommunitysearchSearchTextboxLineHeight = brandingParamentersVal.CommunitysearchSearchTextboxLineHeight__c;
                CommunitysearchSearchTextboxTextAlign = brandingParamentersVal.CommunitysearchSearchTextboxTextAlign__c;
                CommunitysearchSearchTextboxTexTShadow = brandingParamentersVal.CommunitysearchSearchTextboxTexTShadow__c;
                CommunitysearchSearchTextboxWidth = brandingParamentersVal.CommunitysearchSearchTextboxWidth__c;
                CommunitysearchWidth = brandingParamentersVal.CommunitysearchWidth__c;
                CommunitySecondaryColor = brandingParamentersVal.Community_Secondary_Color__c;
                CommunityTertiaryColor = brandingParamentersVal.Community_Tertiary_Color__c;
                CommunityWidth = brandingParamentersVal.Community_Width__c;
                CommunitywrapperDisplay = brandingParamentersVal.CommunitywrapperDisplay__c;
                CommunitywrapperMargin = brandingParamentersVal.CommunitywrapperMargin__c;
                CommunitywrapperWidth = brandingParamentersVal.CommunitywrapperWidth__c;
                ContentWrapperMinWidth = brandingParamentersVal.ContentWrapperMinWidth__c;
                ContentWrapperMozBg = brandingParamentersVal.ContentWrapperMozBg__c;
                ContentWrapperMsBg = brandingParamentersVal.ContentWrapperMsBg__c;
                ContentWrapperWebBg = brandingParamentersVal.ContentWrapperWebBg__c;
                FooterclassMarginLeft = brandingParamentersVal.FooterclassMarginLeft__c;
                FooterContentColor = brandingParamentersVal.FooterContentColor__c;
                FooterContentFontFamily = brandingParamentersVal.FooterContentFontFamily__c;
                FooterContentFontSize = brandingParamentersVal.FooterContentFontSize__c;
                FooterContentTextDecoration = brandingParamentersVal.FooterContentTextDecoration__c;
                HandlebarContainerBg = brandingParamentersVal.HandlebarContainerBg__c;
                HandlebarContainerHeight = brandingParamentersVal.HandlebarContainerHeight__c;
                HandlebarContainerRight = brandingParamentersVal.HandlebarContainerRight__c;
                HandlebarContainerWidth = brandingParamentersVal.HandlebarContainerWidth__c;
                handlebarContainerOnHoverbackground = brandingParamentersVal.handlebarContainerOnHoverbackground__c;
                handlebarContainerOnFocusbackground = brandingParamentersVal.handlebarContainerOnFocusbackground__c;
                HashZenNavMenusMarginRight = brandingParamentersVal.HashZenNavMenusMarginRight__c;
                HomeTabBorderTopColor = brandingParamentersVal.HomeTabBorderTopColor__c;
                HtmlBgColor = brandingParamentersVal.HtmlBgColor__c;
                HtmlBgImage = brandingParamentersVal.HtmlBgImage__c; 
                HtmlPosition = brandingParamentersVal.HtmlPosition__c;
                IdeaContentIdeaBodyWidth = brandingParamentersVal.IdeaContentIdeaBodyWidth__c;
                IdeaPageLayoutWithProfileSidebarDisplay = brandingParamentersVal.IdeaPageLayoutWithProfileSidebarDisplay__c;
                IdeaPageLayoutWithProfileSidebarOverflow = brandingParamentersVal.IdeaPageLayoutWithProfileSidebarOverflow__c;
                IdeaPageLayoutWithProfileSidebarWidth = brandingParamentersVal.IdeaPageLayoutWithProfileSidebarWidth__c;
                PageSectionMarginTop = brandingParamentersVal.PageSectionMarginTop__c;
                PageTitleIconDisplay = brandingParamentersVal.PageTitleIconDisplay__c;
                PageTitleIconFloat = brandingParamentersVal.PageTitleIconFloat__c;
                PageTitleIconMarginRight = brandingParamentersVal.PageTitleIconMarginRight__c;
                PageTitleIconWidth = brandingParamentersVal.PageTitleIconWidth__c;
                PageWidgetBoxSizing = brandingParamentersVal.PageWidgetBoxSizing__c;
                PageWidgetFloat = brandingParamentersVal.PageWidgetFloat__c;
                PageWidgetNthChildPaddingRight = brandingParamentersVal.PageWidgetNthChildPaddingRight__c;
                PageWidgetPFirstLetterFontSize = brandingParamentersVal.PageWidgetPFirstLetterFontSize__c;
                pageWidgetPLineHeight = brandingParamentersVal.pageWidgetPLineHeight__c;
                pageWidgetPMargin = brandingParamentersVal.pageWidgetPMargin__c;
                PageWidgetPPadding = brandingParamentersVal.PageWidgetPPadding__c;
                PageWidgetWidth = brandingParamentersVal.PageWidgetWidth__c;
                PartnerAccountId = brandingParamentersVal.PartnerAccountId__c;
                RelatedListIconDisplay = brandingParamentersVal.RelatedListIconDisplay__c;
                SearchButtonDivBgPosition = brandingParamentersVal.SearchButtonDivBgPosition__c;
                SearchButtonDivBgRepeat = brandingParamentersVal.SearchButtonDivBgRepeat__c;
                SearchButtonDivBorderColor = brandingParamentersVal.SearchButtonDivBorderColor__c;
                SearchButtonDivBorderHeight = brandingParamentersVal.SearchButtonDivBorderHeight__c;
                SearchButtonDivBorderRadius = brandingParamentersVal.SearchButtonDivBorderRadius__c;
                SearchButtonDivBorderStyle = brandingParamentersVal.SearchButtonDivBorderStyle__c;
                SearchButtonDivBorderWidth = brandingParamentersVal.SearchButtonDivBorderWidth__c;
                SearchButtonDivHoverBgPosition = brandingParamentersVal.SearchButtonDivHoverBgPosition__c;
                SearchButtonDivHoverBgRepeat = brandingParamentersVal.SearchButtonDivHoverBgRepeat__c;
                SearchButtonDivHoverBorderColor = brandingParamentersVal.SearchButtonDivHoverBorderColor__c;
                SearchButtonDivHoverBorderRadius = brandingParamentersVal.SearchButtonDivHoverBorderRadius__c;
                SearchButtonDivHoverBorderStyle = brandingParamentersVal.SearchButtonDivHoverBorderStyle__c;
                SearchButtonDivHoverBorderWidth = brandingParamentersVal.SearchButtonDivHoverBorderWidth__c;
                SearchButtonDivHoverHeight = brandingParamentersVal.SearchButtonDivHoverHeight__c;
                SearchButtonDivHoverMargin = brandingParamentersVal.SearchButtonDivHoverMargin__c;
                SearchButtonDivHoverMozBgImage = brandingParamentersVal.SearchButtonDivHoverMozBgImage__c;
                SearchButtonDivHoverMsBgImage = brandingParamentersVal.SearchButtonDivHoverMsBgImage__c;
                SearchButtonDivHoverWebBgImage = brandingParamentersVal.SearchButtonDivHoverWebBgImage__c;
                SearchButtonDivHoverWidth = brandingParamentersVal.SearchButtonDivHoverWidth__c;
                SearchButtonDivMargin = brandingParamentersVal.SearchButtonDivMargin__c;
                SearchButtonDivMozBgImage = brandingParamentersVal.SearchButtonDivMozBgImage__c;
                SearchButtonDivMsBgImage = brandingParamentersVal.SearchButtonDivMsBgImage__c;
                SearchButtonDivWebBgImage = brandingParamentersVal.SearchButtonDivWebBgImage__c;
                SearchButtonDivWidth = brandingParamentersVal.SearchButtonDivWidth__c;
                SideBarBg = brandingParamentersVal.SideBarBg__c;
                SideBarBgColor = brandingParamentersVal.SideBarBgColor__c;
                SideBarBorderTopLeftRadius = brandingParamentersVal.SideBarBorderTopLeftRadius__c;
                SidebarCollapsedBg = brandingParamentersVal.SidebarCollapsedBg__c;
                SideBarFontFamily = brandingParamentersVal.SideBarFontFamily__c;
                SideBarFontSize = brandingParamentersVal.SideBarFontSize__c;
                SideBarFontWeight = brandingParamentersVal.SideBarFontWeight__c;
                SidebarModuleHeaderBg = brandingParamentersVal.SidebarModuleHeaderBg__c;
                SidebarModuleHeaderDisplay = brandingParamentersVal.SidebarModuleHeaderDisplay__c;
                SidebarModuleHeaderPadding = brandingParamentersVal.SidebarModuleHeaderPadding__c;
                SideBarPaddingLeft = brandingParamentersVal.SideBarPaddingLeft__c;
                SideBarLinkColor = brandingParamentersVal.SideBarLinkColor__c;
                SpeechIconHeight = brandingParamentersVal.SpeechIconHeight__c;
                SpeechIconMarginRight = brandingParamentersVal.SpeechIconMarginRight__c;
                SpeechIconWidth = brandingParamentersVal.SpeechIconWidth__c;
                TabBarMargin = brandingParamentersVal.TabBarMargin__c;
                UserPhotoBorderRadius = brandingParamentersVal.UserPhotoBorderRadius__c;
                UserPhotoFloat = brandingParamentersVal.UserPhotoFloat__c;
                UserPhotoHeight = brandingParamentersVal.UserPhotoHeight__c;
                UserPhotoMarginRight = brandingParamentersVal.UserPhotoMarginRight__c;
                UserPhotoWidth = brandingParamentersVal.UserPhotoWidth__c;
                WelcomeImageBorderRadius = brandingParamentersVal.WelcomeImageBorderRadius__c;
                WelcomeImageWidth = brandingParamentersVal.WelcomeImageWidth__c;
                WelcomeMessageBg = brandingParamentersVal.WelcomeMessageBg__c;
                WelcomeMessageBorderRadius = brandingParamentersVal.WelcomeMessageBorderRadius__c;
                WelcomeMessageColor = brandingParamentersVal.WelcomeMessageColor__c;
                WelcomeMessageDisplay = brandingParamentersVal.WelcomeMessageDisplay__c;
                WelcomeMessageFontFamily = brandingParamentersVal.WelcomeMessageFontFamily__c;
                WelcomeMessageFontSize = brandingParamentersVal.WelcomeMessageFontSize__c;
                WelcomeMessageFontStyle = brandingParamentersVal.WelcomeMessageFontStyle__c;
                WelcomeMessageHeight = brandingParamentersVal.WelcomeMessageHeight__c;
                WelcomeMessageHoverCursor = brandingParamentersVal.WelcomeMessageHoverCursor__c;
                WelcomeMessageHoverOpacity = brandingParamentersVal.WelcomeMessageHoverOpacity__c;
                WelcomeMessageLineHeight = brandingParamentersVal.WelcomeMessageLineHeight__c;
                WelcomeMessageMaxWidth = brandingParamentersVal.WelcomeMessageMaxWidth__c;
                WelcomeMessageOpacity = brandingParamentersVal.WelcomeMessageOpacity__c;
                WelcomeMessagePadding = brandingParamentersVal.WelcomeMessagePadding__c;
                WelcomeMessagePDisplay = brandingParamentersVal.WelcomeMessagePDisplay__c;
                WelcomeMessagePFloat = brandingParamentersVal.WelcomeMessagePFloat__c;
                WelcomeMessagePMargin = brandingParamentersVal.WelcomeMessagePMargin__c;
                WelcomeMessagePosition = brandingParamentersVal.WelcomeMessagePosition__c;
                WelcomeMessageTextAlign = brandingParamentersVal.WelcomeMessageTextAlign__c;
                WelcomeMessageTop = brandingParamentersVal.WelcomeMessageTop__c;
                WidgetContentBg = brandingParamentersVal.WidgetContentBg__c;
                WidgetContentBorderRadius = brandingParamentersVal.WidgetContentBorderRadius__c;
                WidgetContentMinHeight = brandingParamentersVal.WidgetContentMinHeight__c;
                WidgetContentPadding = brandingParamentersVal.WidgetContentPadding__c;
                WidgetContentTableWidth = brandingParamentersVal.WidgetContentTableWidth__c;
                WidgetLabelFontSize = brandingParamentersVal.WidgetLabelFontSize__c;
                WidgetRowWidth = brandingParamentersVal.WidgetRowWidth__c;
                WidgetTitleBg = brandingParamentersVal.WidgetTitleBg__c;
                WidgetTitleBorderRadius = brandingParamentersVal.WidgetTitleBorderRadius__c;
                WidgetTitleColor = brandingParamentersVal.WidgetTitleColor__c;
                WidgetTitleColorTextTransform = brandingParamentersVal.WidgetTitleColorTextTransform__c;
                WidgetTitleFloat = brandingParamentersVal.WidgetTitleFloat__c;
                WidgetTitleFontSize = brandingParamentersVal.WidgetTitleFontSize__c;
                WidgetTitleHeight = brandingParamentersVal.WidgetTitleHeight__c;
                WidgetTitleImgHeight = brandingParamentersVal.WidgetTitleImgHeight__c;
                WidgetTitleImgMarginTop = brandingParamentersVal.WidgetTitleImgMarginTop__c;
                WidgetTitleImgWidth = brandingParamentersVal.WidgetTitleImgWidth__c;
                WidgetTitleLineHeight = brandingParamentersVal.WidgetTitleLineHeight__c;
                WidgetTitleMarginBottom = brandingParamentersVal.WidgetTitleMarginBottom__c;
                WidgetTitleMargingTop = brandingParamentersVal.WidgetTitleMargingTop__c;
                WidgetTitlePadding = brandingParamentersVal.WidgetTitlePadding__c;
                ZenActiveBg = brandingParamentersVal.ZenActiveBg__c;
                ZenActiveBorderColor = brandingParamentersVal.ZenActiveBorderColor__c;
                ZenActiveBorderStyle = brandingParamentersVal.ZenActiveBorderStyle__c;
                ZenActiveBorderTopLeftRadius = brandingParamentersVal.ZenActiveBorderTopLeftRadius__c;
                ZenActiveBorderTopRightRadius = brandingParamentersVal.ZenActiveBorderTopRightRadius__c;
                ZenActiveBorderWidth = brandingParamentersVal.ZenActiveBorderWidth__c;
                ZenActiveBoxShadow = brandingParamentersVal.ZenActiveBoxShadow__c;
                ZenActiveColor = brandingParamentersVal.ZenActiveColor__c;
                ZenActiveMarginRight = brandingParamentersVal.ZenActiveMarginRight__c;
                ZenBodyZenBrdPaletteBorderRadius = brandingParamentersVal.ZenBodyZenBrdPaletteBorderRadius__c;
                ZenBodyZenBrdPaletteBoxShadow = brandingParamentersVal.ZenBodyZenBrdPaletteBoxShadow__c;
                ZenHighlightBtnBorder = brandingParamentersVal.ZenHighlightBtnBorder__c;
                ZenHighlightBtnBorderColor = brandingParamentersVal.ZenHighlightBtnBorderColor__c;
                ZenHighlightBtnBorderRadius = brandingParamentersVal.ZenHighlightBtnBorderRadius__c;
                ZenHighlightBtnBorderStyle = brandingParamentersVal.ZenHighlightBtnBorderStyle__c;
                ZenHighlightBtnBorderWidth = brandingParamentersVal.ZenHighlightBtnBorderWidth__c;
                ZenHighlightBtnColor = brandingParamentersVal.ZenHighlightBtnColor__c;
                ZenHighlightBtnFontSize = brandingParamentersVal.ZenHighlightBtnFontSize__c;
                ZenHighlightBtnFontWeight = brandingParamentersVal.ZenHighlightBtnFontWeight__c;
                ZenHighlightBtnHeight = brandingParamentersVal.ZenHighlightBtnHeight__c;
                ZenHighlightBtnMargin = brandingParamentersVal.ZenHighlightBtnMargin__c;
                ZenHighlightBtnMozBgImage = brandingParamentersVal.ZenHighlightBtnMozBgImage__c;
                ZenHighlightBtnMsBgImage = brandingParamentersVal.ZenHighlightBtnMsBgImage__c;
                ZenHighlightBtnWebBgImage = brandingParamentersVal.ZenHighlightBtnWebBgImage__c;
                ZenNavMenusMarginRight = brandingParamentersVal.ZenNavMenusMarginRight__c;
                ZenTabContainerBg = brandingParamentersVal.ZenTabContainerBg__c;
                ZenTabContainerBoxShadow = brandingParamentersVal.ZenTabContainerBoxShadow__c;
                ZenTabContainerHeight = brandingParamentersVal.ZenTabContainerHeight__c;
                ZenTabContainerPosition = brandingParamentersVal.ZenTabContainerPosition__c;
                ZenTabContainerTop = brandingParamentersVal.ZenTabContainerTop__c;
                ZenTabMenuAColor = brandingParamentersVal.ZenTabMenuAColor__c;
                ZenTabMenuADisplay = brandingParamentersVal.ZenTabMenuADisplay__c;
                ZenTabMenuAFontFamily = brandingParamentersVal.ZenTabMenuAFontFamily__c;
                ZenTabMenuAFontSize = brandingParamentersVal.ZenTabMenuAFontSize__c;
                ZenTabMenuAFontWeight = brandingParamentersVal.ZenTabMenuAFontWeight__c;
                ZenTabMenuAHoverColor = brandingParamentersVal.ZenTabMenuAHoverColor__c;
                ZenTabMenuAHoverTextDecoration = brandingParamentersVal.ZenTabMenuAHoverTextDecoration__c;
                ZenTabMenuAPadding = brandingParamentersVal.ZenTabMenuAPadding__c;
                ZenTabMenuATextAlign = brandingParamentersVal.ZenTabMenuATextAlign__c;
                ZenTabMenuATextTransform = brandingParamentersVal.ZenTabMenuATextTransform__c;
                ZenTabMenuBg = brandingParamentersVal.ZenTabMenuBg__c;
                ZenTabMenuBorder = brandingParamentersVal.ZenTabMenuBorder__c;
                ZenTabMenuBorderRadius = brandingParamentersVal.ZenTabMenuBorderRadius__c;
                ZenTabMenuHeight = brandingParamentersVal.ZenTabMenuHeight__c;
                ZenTabMenuLineHeight = brandingParamentersVal.ZenTabMenuLineHeight__c;
                ZenTabMenuMargin = brandingParamentersVal.ZenTabMenuMargin__c;
                ZenTabMenuMinWidth = brandingParamentersVal.ZenTabMenuMinWidth__c;
                ZenTabMenuPadding = brandingParamentersVal.ZenTabMenuPadding__c;
                ZenTabMenuTextAlign = brandingParamentersVal.ZenTabMenuTextAlign__c;
                ZenZenTabMenuPadding = brandingParamentersVal.ZenZenTabMenuPadding__c;
                communityFooter  = brandingParamentersVal.Community_Footer__c;
                communityLogo = brandingParamentersVal.CommunityLogo__c;
                communityPrimaryColor =  brandingParamentersVal.Community_Primary_Color__c;
                communitySearchBox = brandingParamentersVal.Community_Search_Box__c;
                communitySecondaryColor  = brandingParamentersVal.Community_Secondary_Color__c;
                communityTertiaryColor = brandingParamentersVal.Community_Tertiary_Color__c;
                communityWidth = brandingParamentersVal.Community_Width__c;
                communityPageTitleIcon = brandingParamentersVal.CommunityPageTitleIcon__c;
                ZenActiveAHoverBorderWidth = brandingParamentersVal.ZenActi_veAHoverBorderWidth__c;
                ZenActiveAHoverBorderColor = brandingParamentersVal.ZenActiveAHoverBorderColor__c;
                ZenActiveAHoverBorderStyle = brandingParamentersVal.ZenActiveAHoverBorderStyle__c;
                ZenActiveAHoverColor = brandingParamentersVal.ZenActiveAHoverColor__c; 
                BrandPrimaryBrdMarginTop = brandingParamentersVal.BrandPrimaryBrdMarginTop__c; 
                BodyTableMarginBottom = brandingParamentersVal.BodyTableMarginBottom__c;
                brandSecondaryBrdMarginRight = brandingParamentersVal.BrandSecondaryBrd_MarginRight__c;
                brandSecondaryBrdMarginLeft = brandingParamentersVal.BrandSecondaryBrd_MarginLeft__c;
                relatedListTitleFontSize = brandingParamentersVal.RelatedListTitle_FontSize__c;
                relatedListTitleFontFamily = brandingParamentersVal.RelatedListTitle_FontFamily__c;
                relatedListTitleColor = brandingParamentersVal.RelatedListTitle_Color__c;
                relatedListTitleTextDecoration = brandingParamentersVal.RelatedListTitle_TextDecoration__c;
                relatedListTitleTextAlign = brandingParamentersVal.RelatedListTitle_TextAlign__c;
                relatedListTitleFontWeight = brandingParamentersVal.RelatedListTitle_FontWeight__c;
                relatedListTitleMarginLeft = brandingParamentersVal.RelatedListTitle_MarginLeft__c;                
            //}
        //}
        system.debug('PartnerCommunityController :: initializeBrandingParameters :: end');
    }
}