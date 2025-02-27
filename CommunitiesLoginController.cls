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

 Code purpose  : An apex page controller that exposes the site login functionality


 Birthday      : 15/05/2014
 Api version   : v29

 ****************************************************************************************************************************/

global with sharing class CommunitiesLoginController {

    // Constructor
    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
        system.debug('CommunitiesLoginController :: forwardToAuthPage :: start ');
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');
        String retURL = System.currentPageReference().getParameters().get('retURL');
        PageReference pg;
        system.debug('retURL :: '+retURL);
        system.debug('displayType :: '+displayType);
        system.debug('startUrl :: '+startUrl);
        //redirect to custom login page
        if(Site.getPrefix().contains('client')){
            pg = new PageReference(Site.getPrefix()+'/DDPartnerCustomLoginPage?retURL='+startUrl);
        }
        else if(Site.getPrefix().contains('subcontractor')){
            pg = new PageReference(Site.getPrefix()+'/login?retURL='+retURL);
        }        
        pg.setRedirect(true);
        system.debug('CommunitiesLoginController :: forwardToAuthPage :: end ');
        return pg;
    }
}