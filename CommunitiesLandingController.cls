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
  
 
  
Crafted by     : Mayank Sharma
               : msharma@tquila.com 
               : www.tquila.com

 Code purpose  : An apex page controller that takes the user to the right start page based on 
                 credentials or lack thereof


 Birthday      : 15/05/2014
 Api version   : v29

 ****************************************************************************************************************************/

public with sharing class CommunitiesLandingController {
    
     public CommunitiesLandingController() {}
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        
        system.debug('CommunitiesLandingController :: forwardToStartPage :: start');
        // get logged in User Id
        Id loggedInUserId = Userinfo.getUserId();
        system.debug('ApexPages.currentPage().getParameters() :: '+ApexPages.currentPage().getParameters());
        String returnURL = ApexPages.currentPage().getParameters().get('retURL');
        system.debug('returnURL :: '+returnURL);
        //returnURL = startURL; 
        // Get Partner User
        List<User> usr = [select Id, UserType, DD_T_C_s_Accepted__c from User 
                                where Id =: loggedInUserId and UserType = 'PowerPartner'];
        
        /* Redirect Partner User to terms and conditions page on first time log in else redirect to Client
           or counterparty portal
        */
        if(usr!=null && usr.size()>0 && !usr.get(0).DD_T_C_s_Accepted__c){ 
            return new Pagereference('/DDTermsandCondition');           
        }
        else if(!String.isEmpty(returnURL) && (returnURL.contains('DDProxySalesInvoicePDF') 
                                               || returnURL.contains('KnowledgeHome') 
                                               || returnURL.contains('DD_Approvals')
                                              || returnURL.contains('a920'))){   
            return new Pagereference(returnURL);
        }
        
        /*else{
            if(usr!=null && usr.size()>0 && usr.get(0).UserType.equals('PowerPartner')){
                return new Pagereference('/client/home/home.jsp');
            }
            else{
                return new Pagereference('/counterparty/home/home.jsp');
            }
        }    */ 
        system.debug('CommunitiesLandingController :: forwardToStartPage :: end');
        return Network.communitiesLanding();
    }
}