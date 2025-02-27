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

 Code purpose  : a. redirects client to the terms and conditions page if logging in the first time
                 elsedirectly to home page of the portal
                 b. Once client ticks the terms and conditions check box, user profile is updated to bypass 
                 terms and conditions for the next time.

 Birthday      : 15/05/2014
 Api version   : v30

 ****************************************************************************************************************************/

public with sharing class DDTermsAndConditionsController{
 
   public Boolean checkbox01 {get; set;}
   public Boolean termsAndConditionsNotAccepted{get; set;}
   public String accountName{get; set;}
   public User usr{get; set;}
   
   /**
       This method update the user profile with terms and conditions accepted
   */
   public PageReference saveTermsAndConditionsPref() {
    if(confirmAgreement()) {      
        usr.DD_T_C_s_Accepted__c = true;
        update usr;
        termsAndConditionsNotAccepted = false;
        PageReference retURL = new PageReference('/client/home/home.jsp');
        return retURL;
    } else {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check Terms and Conditions checkbox before submitting.'));
        termsAndConditionsNotAccepted = true;
        return null;
    }
    }
    
    /**
        This method fetches user detail and checks if terms and condition page is to be displayed or not
    */
    public void userDetails(){
        Id loggedInUserId = Userinfo.getUserId();
        usr = [select Id, Contact.Account.Name, DD_T_C_s_Accepted__c from User where Id =: loggedInUserId];
        system.debug('usr  :: '+usr);
        accountName = usr.Contact.Account.Name;
        system.debug('accountName :: '+accountName);
        //return usr;
    }
    
    /**
        This method validates if terms and conditions are accepted or not
    */
    public boolean confirmAgreement() {
        if(!checkbox01) {
            return false;
        } else {
            return true;
        }
    }
}