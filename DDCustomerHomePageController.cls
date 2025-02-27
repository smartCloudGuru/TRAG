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

 Code purpose  : This controller is used to display home page customer specific useful data


 Birthday      : 11/12/2014
 Api version   : v32

 ****************************************************************************************************************************/
public with sharing class DDCustomerHomePageController{

     public String CustomerInformation {get;set;}
    public String  CustomerInformation2 {get;set;}
     public String TopRightVideo {get;set;}
     public String pageBackgroundColor {get;set;}
     public String bodyBackgroundColor {get;set;}
     public String brandQuaternaryBgrBackgroud {get;set;}
     public String quickLinksTableHeight {get;set;}
     public String quickLinksTableWidth {get;set;}
     public String bodyTDWidth {get;set;}
     public String bodyTDVerticalAlign {get;set;}
     public String customizeTextFontSize {get;set;}
     public String customizeTextFontFamily {get;set;}
     public String customizeTextColor {get;set;}
     public String brandQuaternaryBgrWidth {get;set;}
     public String quickLinksTableMarginTop {get;set;}
     /**
         Constructor to load customer home page info
     */
     public DDCustomerHomePageController(){  
        User loggedInUser = [select Id, contact.Account.ParentId, contact.AccountId from User where Id =:  Userinfo.getUserId()]; 
        List<DDCustomerHomePageComponent__c> customerHomePageParamentersList = DDCustomerHomePageComponent__c.getall().values();
        for(DDCustomerHomePageComponent__c customerHomePageParamentersVal : customerHomePageParamentersList){
            if(loggedInUser.contact!=null && loggedInUser.contact.Account.ParentId!=null && String.valueOf(loggedInUser.contact.Account.ParentId).substring(0,15).equals(customerHomePageParamentersVal.DDPartnerAccountId__c)){
                CustomerInformation = customerHomePageParamentersVal.DDCustomerInformation__c;
                CustomerInformation2 = customerHomePageParamentersVal.DDCustomerInformation2__c;
                TopRightVideo = customerHomePageParamentersVal.DDTopRightVideo__c;    
                pageBackgroundColor = customerHomePageParamentersVal.Page_BackgroundColor__c;
     			bodyBackgroundColor = customerHomePageParamentersVal.Body_BackgroundColor__c;
     			brandQuaternaryBgrBackgroud = customerHomePageParamentersVal.BrandQuaternaryBgr_Backgroud__c;
     			quickLinksTableHeight = customerHomePageParamentersVal.QuickLinksTable_Height__c;
     			quickLinksTableWidth = customerHomePageParamentersVal.QuickLinksTable_Width__c;
     			bodyTDWidth = customerHomePageParamentersVal.BodyTD_Width__c;
     			bodyTDVerticalAlign = customerHomePageParamentersVal.BodyTD_VerticalAlign__c;
     			customizeTextFontSize = customerHomePageParamentersVal.CustomizeText_FontSize__c;
    			customizeTextFontFamily = customerHomePageParamentersVal.CustomizeText_FontFamily__c;
     			customizeTextColor = customerHomePageParamentersVal.CustomizeText_Color__c;   
     			brandQuaternaryBgrWidth = customerHomePageParamentersVal.BrandQuaternaryBgr_Width__c;
     			quickLinksTableMarginTop = customerHomePageParamentersVal.QuickLinksTable_MarginTop__c; 
            }
        }
                 
     }    
}