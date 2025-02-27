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

 Code purpose  : Loads Customer portal styling for forgot password confirm page


 Birthday      : 03/10/2014
 Api version   : v31

 ****************************************************************************************************************************/

global  class DDCustomerForgotPasswordConfirm{
    
    public String ABorderRadius {get; set;}
    public String ABorderColor {get; set;}
    public String ABorderStyle {get; set;}
    public String ABorderWidth {get; set;}
    public String AMozBgImage {get; set;}
    public String AWebBgImage {get; set;}
    public String AMsBgImage {get; set;}
    public String AWidth {get; set;}
    public String AHeight {get; set;}
    public String AFontSize {get; set;}
    public String AFontFamily {get; set;}
    public String AColor {get; set;}
    public String ALineHeight {get; set;}
    public String ATextAlign {get; set;}
    public String ATextShadow {get; set;}
    public String AMarginTop {get; set;}    
    public String AHoverBgPosition {get; set;}
    public String AHoverBorderColor {get; set;}
    public String AHoverBorderRadius {get; set;}
    public String AHoverBorderStyle {get; set;}
    public String AHoverBorderWidth {get; set;}
    public String AHoverColor {get; set;}
    public String AHoverFontFamily {get; set;}
    public String AHoverFontSize {get; set;}
    public String AHoverHeight {get; set;}
    public String AHoverMozBgImage {get; set;}
    public String AHoverMsBgImage {get; set;}
    public String AHoverWebBgImage {get; set;}
    public String AHoverWidth {get; set;}
    public String BodyBackgroundcolor {get; set;}
    public String BodyMargin {get; set;}
    public String BodyTextAlign {get; set;}
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
    public String FormLineHeight {get; set;}
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
    public String H1Display {get; set;}
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

    
     /**
         This is a constructor to load styling related to forgot password confirm for customer portal
     */
     public DDCustomerForgotPasswordConfirm(){   
        
        system.debug('DDCustomerForgotPasswordConfirm :: DDCustomerForgotPasswordConfirm :: start');
        List<DDCustomeForgotPwdConfBrandingParameters__c> brandingParamentersList = DDCustomeForgotPwdConfBrandingParameters__c.getall().values();
        for(DDCustomeForgotPwdConfBrandingParameters__c brandingParamentersVal : brandingParamentersList){
            ABorderRadius = brandingParamentersVal.ABorderRadius__c;
            ABorderColor = brandingParamentersVal.ABorderColor__c;
            ABorderStyle = brandingParamentersVal.ABorderStyle__c;
            ABorderWidth = brandingParamentersVal.ABorderWidth__c;
            AMozBgImage = brandingParamentersVal.AMozBgImage__c;
            AWebBgImage = brandingParamentersVal.AWebBgImage__c;
            AMsBgImage = brandingParamentersVal.AMsBgImage__c;
            AWidth = brandingParamentersVal.AWidth__c;
            AHeight = brandingParamentersVal.AHeight__c;
            AFontSize = brandingParamentersVal.AFontSize__c;
            AFontFamily = brandingParamentersVal.AFontFamily__c;
            AColor = brandingParamentersVal.AColor__c;
            ALineHeight = brandingParamentersVal.ALineHeight__c;
            ATextAlign = brandingParamentersVal.ATextAlign__c;
            ATextShadow = brandingParamentersVal.ATextShadow__c;
            AMarginTop = brandingParamentersVal.AMarginTop__c;            
            AHoverBgPosition = brandingParamentersVal.AHoverBgPosition__c;
            AHoverBorderColor = brandingParamentersVal.AHoverBorderColor__c;
            AHoverBorderRadius = brandingParamentersVal.AHoverBorderRadius__c;
            AHoverBorderStyle = brandingParamentersVal.AHoverBorderStyle__c;
            AHoverBorderWidth = brandingParamentersVal.AHoverBorderWidth__c;
            AHoverColor = brandingParamentersVal.AHoverColor__c;
            AHoverFontFamily = brandingParamentersVal.AHoverFontFamily__c;
            AHoverFontSize = brandingParamentersVal.AHoverFontSize__c;
            AHoverHeight = brandingParamentersVal.AHoverHeight__c;
            AHoverMozBgImage = brandingParamentersVal.AHoverMozBgImage__c;
            AHoverMsBgImage = brandingParamentersVal.AHoverMsBgImage__c;
            AHoverWebBgImage = brandingParamentersVal.AHoverWebBgImage__c;
            AHoverWidth = brandingParamentersVal.AHoverWidth__c;
            BodyBackgroundcolor = brandingParamentersVal.BodyBackgroundcolor__c;
            BodyMargin = brandingParamentersVal.BodyMargin__c;
            BodyTextAlign = brandingParamentersVal.BodyTextAlign__c;
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
            FormLineHeight = brandingParamentersVal.FormLineHeight__c;
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
            H1Display = brandingParamentersVal.H1Display__c;
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
    system.debug('DDCustomerForgotPasswordConfirm :: DDCustomerForgotPasswordConfirm :: end');
    }
}