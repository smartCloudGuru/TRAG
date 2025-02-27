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

 Code purpose  : Loads styling parameter specific to customer portal forgot password page


 Birthday      : 03/10/2014
 Api version   : v31

 ****************************************************************************************************************************/

global  class DDCustomerForgotPassword {

public String BodyBackgroundcolor {get; set;}
    public String BodyMargin {get; set;}
    public String BodyTextAlign {get; set;}
    public String ButtonBorderColor {get; set;}
    public String ButtonBorderRadius {get; set;}
    public String ButtonBorderStyle {get; set;}
    public String ButtonBorderWidth {get; set;}
    public String ButtonColor {get; set;}
    public String ButtonFontFamily {get; set;}
    public String ButtonFontSize {get; set;}
    public String ButtonHeight {get; set;}
    public String ButtonHoverBgPosition {get; set;}
    public String ButtonHoverBorderColor {get; set;}
    public String ButtonHoverBorderStyle {get; set;}
    public String ButtonHoverBorderWidth {get; set;}
    public String ButtonHoverBorderRadius {get; set;}
    public String ButtonHoverColor {get; set;}
    public String ButtonHoverFontFamily {get; set;}
    public String ButtonHoverFontSize {get; set;}
    public String ButtonHoverHeight {get; set;}
    public String ButtonHoverMozBgImage {get; set;}
    public String ButtonHoverMsBgImage {get; set;}
    public String ButtonHoverWebBgImage {get; set;}
    public String ButtonHoverWidth {get; set;}
    public String ButtonLineHeight {get; set;}
    public String ButtonMarginTop {get; set;}
    public String ButtonMozBgimage {get; set;}
    public String ButtonMsBgimage {get; set;}
    public String ButtonTextAlign {get; set;}
    public String ButtonTextShadow {get; set;}
    public String ButtonWebBgimage {get; set;}
    public String ButtonWidth {get; set;}
    public String CsFormKeyDisplay {get; set;}
    public String CsFormKeyFloat {get; set;}
    public String CsFormKeyTextAlign {get; set;}
    public String FormBorderRadius {get; set;}
    public String FormBoxShadow {get; set;}
    public String FormColor {get; set;}
    public String FormCsLabelWidth {get; set;}
    public String FormFloat {get; set;}
    public String FormFontFamily {get; set;}
    public String FormFontSize {get; set;}
    public String FormHeight {get; set;}
    public String FormLineWeight {get; set;}
    public String FormMarginLeft {get; set;}
    public String FormMarginRight {get; set;}
    public String FormMarginTop {get; set;}
    public String FormMozBgImage {get; set;}
    public String FormMsBgImage {get; set;}
    public String FormPosition {get; set;}
    public String FormRowDisplay {get; set;}
    public String FormRowMarginBottom {get; set;}
    public String FormRowMarginLeft {get; set;}
    public String FormRowMarginTop {get; set;}
    public String FormWebBgImage {get; set;}
    public String FormWidth {get; set;}
    public String H1Color {get; set;}
    public String H1FontFamily {get; set;}
    public String H1FontSize {get; set;}
    public String H1LineHeight {get; set;}
    public String H1MarginTop {get; set;}
    public String H1TextAlign {get; set;}
    public String LogoWrapperHeight {get; set;}
    public String LogoWrapperMarginBottom {get; set;}
    public String LogoWrapperMarginTop {get; set;}
    public String LogoWrapperMaxHeight {get; set;}
    public String LogoWrapperMaxWidth {get; set;}
    public String LogoWrapperTextAlign {get; set;}
    public String LogoWrapperWidth {get; set;}
    public String NoticeBgColor {get; set;}
    public String NoticeBgImage {get; set;}
    public String NoticeBorder {get; set;}
    public String NoticeBorderRadius {get; set;}
    public String NoticeColor {get; set;}
    public String NoticeDisplay {get; set;}
    public String NoticeFontFamily {get; set;}
    public String NoticeFontSize {get; set;}
    public String NoticeHeight {get; set;}
    public String NoticeLineHeight {get; set;}
    public String NoticeMargin {get; set;}
    public String NoticeTextAlign {get; set;}
    public String NoticeWidth {get; set;}
    public String PColor {get; set;}
    public String PFontFamily {get; set;}
    public String PFontSize {get; set;}
    public String PLineHeight {get; set;}
    public String PMarginTop {get; set;}
    public String PTextAlign {get; set;}
    public String TextColor {get; set;}
    public String TextFontFamily {get; set;}
    public String TextFontSize {get; set;}
    public String TextLineHeight {get; set;}
    public String TextMarginLeft {get; set;}
    public String TextMarginTop {get; set;}
    public String TextOutline {get; set;}
    public String TextTextAlign {get; set;}
    public String TextWidth {get; set;}

     
     // Constructor to fetch styling parameters on Customer forgot password page upload
     public DDCustomerForgotPassword (){   
        
        system.debug('DDCustomerForgotPassword :: DDCustomerForgotPassword :: start');
        List<DDCustomerForgotPwdBrandingParameters__c> brandingParamentersList = DDCustomerForgotPwdBrandingParameters__c.getall().values();
        for(DDCustomerForgotPwdBrandingParameters__c brandingParamentersVal : brandingParamentersList){
            BodyBackgroundcolor = brandingParamentersVal.BodyBackgroundcolor__c;
            BodyMargin = brandingParamentersVal.BodyMargin__c;
            BodyTextAlign = brandingParamentersVal.BodyTextAlign__c;
            ButtonBorderColor = brandingParamentersVal.ButtonBorderColor__c;
            ButtonBorderRadius = brandingParamentersVal.ButtonBorderRadius__c;
            ButtonBorderStyle = brandingParamentersVal.ButtonBorderStyle__c;
            ButtonBorderWidth = brandingParamentersVal.ButtonBorderWidth__c;
            ButtonColor = brandingParamentersVal.ButtonColor__c;
            ButtonFontFamily = brandingParamentersVal.ButtonFontFamily__c;
            ButtonFontSize = brandingParamentersVal.ButtonFontSize__c;
            ButtonHeight = brandingParamentersVal.ButtonHeight__c;
            ButtonHoverBgPosition = brandingParamentersVal.ButtonHoverBgPosition__c;
            ButtonHoverBorderColor = brandingParamentersVal.ButtonHoverBorderColor__c;
            ButtonHoverBorderStyle = brandingParamentersVal.ButtonHoverBorderStyle__c;
            ButtonHoverBorderWidth = brandingParamentersVal.ButtonHoverBorderWidth__c;
            ButtonHoverColor = brandingParamentersVal.ButtonHoverColor__c;
            ButtonHoverFontFamily = brandingParamentersVal.ButtonHoverFontFamily__c;
            ButtonHoverFontSize = brandingParamentersVal.ButtonHoverFontSize__c;
            ButtonHoverHeight = brandingParamentersVal.ButtonHoverHeight__c;
            ButtonHoverMozBgImage = brandingParamentersVal.ButtonHoverMozBgImage__c;
            ButtonHoverMsBgImage = brandingParamentersVal.ButtonHoverMsBgImage__c;
            ButtonHoverWebBgImage = brandingParamentersVal.ButtonHoverWebBgImage__c;
            ButtonHoverBorderRadius = brandingParamentersVal.ButtonHoverBorderRadius__c;
            ButtonHoverWidth = brandingParamentersVal.ButtonHoverWidth__c;
            ButtonLineHeight = brandingParamentersVal.ButtonLineHeight__c;
            ButtonMarginTop = brandingParamentersVal.ButtonMarginTop__c;
            ButtonMozBgimage = brandingParamentersVal.ButtonMozBgimage__c;
            ButtonMsBgimage = brandingParamentersVal.ButtonMsBgimage__c;
            ButtonTextAlign = brandingParamentersVal.ButtonTextAlign__c;
            ButtonTextShadow = brandingParamentersVal.ButtonTextShadow__c;
            ButtonWebBgimage = brandingParamentersVal.ButtonWebBgimage__c;
            ButtonWidth = brandingParamentersVal.ButtonWidth__c;
            CsFormKeyDisplay = brandingParamentersVal.CsFormKeyDisplay__c;
            CsFormKeyFloat = brandingParamentersVal.CsFormKeyFloat__c;
            CsFormKeyTextAlign = brandingParamentersVal.CsFormKeyTextAlign__c;
            FormBorderRadius = brandingParamentersVal.FormBorderRadius__c;
            FormBoxShadow = brandingParamentersVal.FormBoxShadow__c;
            FormColor = brandingParamentersVal.FormColor__c;
            FormCsLabelWidth = brandingParamentersVal.FormCsLabelWidth__c;
            FormFloat = brandingParamentersVal.FormFloat__c;
            FormFontFamily = brandingParamentersVal.FormFontFamily__c;
            FormFontSize = brandingParamentersVal.FormFontSize__c;
            FormHeight = brandingParamentersVal.FormHeight__c;
            FormLineWeight = brandingParamentersVal.FormLineWeight__c;
            FormMarginLeft = brandingParamentersVal.FormMarginLeft__c;
            FormMarginRight = brandingParamentersVal.FormMarginRight__c;
            FormMarginTop = brandingParamentersVal.FormMarginTop__c;
            FormMozBgImage = brandingParamentersVal.FormMozBgImage__c;
            FormMsBgImage = brandingParamentersVal.FormMsBgImage__c;
            FormPosition = brandingParamentersVal.FormPosition__c;
            FormRowDisplay = brandingParamentersVal.FormRowDisplay__c;
            FormRowMarginBottom = brandingParamentersVal.FormRowMarginBottom__c;
            FormRowMarginLeft = brandingParamentersVal.FormRowMarginLeft__c;
            FormRowMarginTop = brandingParamentersVal.FormRowMarginTop__c;
            FormWebBgImage = brandingParamentersVal.FormWebBgImage__c;
            FormWidth = brandingParamentersVal.FormWidth__c;
            H1Color = brandingParamentersVal.H1Color__c;
            H1FontFamily = brandingParamentersVal.H1FontFamily__c;
            H1FontSize = brandingParamentersVal.H1FontSize__c;
            H1LineHeight = brandingParamentersVal.H1LineHeight__c;
            H1MarginTop = brandingParamentersVal.H1MarginTop__c;
            H1TextAlign = brandingParamentersVal.H1TextAlign__c;
            LogoWrapperHeight = brandingParamentersVal.LogoWrapperHeight__c;
            LogoWrapperMarginBottom = brandingParamentersVal.LogoWrapperMarginBottom__c;
            LogoWrapperMarginTop = brandingParamentersVal.LogoWrapperMarginTop__c;
            LogoWrapperMaxHeight = brandingParamentersVal.LogoWrapperMaxHeight__c;
            LogoWrapperMaxWidth = brandingParamentersVal.LogoWrapperMaxWidth__c;
            LogoWrapperTextAlign = brandingParamentersVal.LogoWrapperTextAlign__c;
            LogoWrapperWidth = brandingParamentersVal.LogoWrapperWidth__c;
            NoticeBgColor = brandingParamentersVal.NoticeBgColor__c;
            NoticeBgImage = brandingParamentersVal.NoticeBgImage__c;
            NoticeBorder = brandingParamentersVal.NoticeBorder__c;
            NoticeBorderRadius = brandingParamentersVal.NoticeBorderRadius__c;
            NoticeColor = brandingParamentersVal.NoticeColor__c;
            NoticeDisplay = brandingParamentersVal.NoticeDisplay__c;
            NoticeFontFamily = brandingParamentersVal.NoticeFontFamily__c;
            NoticeFontSize = brandingParamentersVal.NoticeFontSize__c;
            NoticeHeight = brandingParamentersVal.NoticeHeight__c;
            NoticeLineHeight = brandingParamentersVal.NoticeLineHeight__c;
            NoticeMargin = brandingParamentersVal.NoticeMargin__c;
            NoticeTextAlign = brandingParamentersVal.NoticeTextAlign__c;
            NoticeWidth = brandingParamentersVal.NoticeWidth__c;
            PColor = brandingParamentersVal.PColor__c;
            PFontFamily = brandingParamentersVal.PFontFamily__c;
            PFontSize = brandingParamentersVal.PFontSize__c;
            PLineHeight = brandingParamentersVal.PLineHeight__c;
            PMarginTop = brandingParamentersVal.PMarginTop__c;
            PTextAlign = brandingParamentersVal.PTextAlign__c;
            TextColor = brandingParamentersVal.TextColor__c;
            TextFontFamily = brandingParamentersVal.TextFontFamily__c;
            TextFontSize = brandingParamentersVal.TextFontSize__c;
            TextLineHeight = brandingParamentersVal.TextLineHeight__c;
            TextMarginLeft = brandingParamentersVal.TextMarginLeft__c;
            TextMarginTop = brandingParamentersVal.TextMarginTop__c;
            TextOutline = brandingParamentersVal.TextOutline__c;
            TextTextAlign = brandingParamentersVal.TextTextAlign__c;
            TextWidth = brandingParamentersVal.TextWidth__c;
        }
    system.debug('DDCustomerForgotPassword :: DDCustomerForgotPassword :: end');
    }
}