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

 Code purpose  : Allows Client Admin (Partner Portal user with Admin Access) to create or manage other
                 Partner User


 Birthday      : 11/07/2014
 Api version   : v30

 ****************************************************************************************************************************/
 
public with sharing class  DDCreateAndManagePartnerUser{

    ApexPages.StandardController controller;
    
    // Constructor
    public DDCreateAndManagePartnerUser(ApexPages.StandardController controller) {
        
        system.debug('DDCreateAndManagePartnerUser :: DDCreateAndManagePartnerUser :: start');
        this.controller = controller;
        system.debug('DDCreateAndManagePartnerUser :: DDCreateAndManagePartnerUser :: end');
    }

    /**
        This method redirects Client Admin from a Partner contact to a new partner user creation 
        page or an existing user page to manage
    */
    public Pagereference redirectClientAdmintoCreateOrManagePartnerUser(){
        
        system.debug('DDCreateAndManagePartnerUser :: redirectClientAdmintoCreateOrManagePartnerUser :: start');
        Contact cont = (Contact)controller.getRecord();
        Pagereference pg;
            
        List<User> usrList = [select Id, Contact.Email, contact.name, ContactId from User where contactId =: cont.Id];
        if(usrList==null || usrList.size()==0){
            String firstName;
            String lastName;
            String commNickName;
            List<Contact> contList = [select Id, Email, name, firstName, lastName from Contact where Id =: cont.Id];
            if((contList.get(0).FirstName!=null && contList.get(0).FirstName!='') && contList.get(0).FirstName.length()>0){
                firstName = contList.get(0).FirstName.subString(0,1);
            }
            if((contList.get(0).lastName!=null || contList.get(0).lastName!='')){
                if(contList.get(0).lastName.length()>0 && contList.get(0).lastName.length()<4){
                    lastName = contList.get(0).lastName.subString(0,contList.get(0).lastName.length());
                }
                else{
                    lastName = contList.get(0).lastName.subString(0,4);
                }
                if(contList.get(0).Email!=null || contList.get(0).Email!=''){
                    commNickName = contList.get(0).Email.split('@')[0];
                }
                pg = new Pagereference('https://'+URL.getSalesforceBaseURL().getHost()+'/client/_ui/core/portal/PortalUserManagePage/e?ut=P&retURL=/client/'+contList.get(0).Id+
                                                        '&retURL=/client/'+contList.get(0).Id+'&cntc='+contList.get(0).Id+
                                                        '&Email='+contList.get(0).Email+'&Username='+contList.get(0).Email+'&name_firstName='+contList.get(0).firstName+
                                                        '&name_lastName='+contList.get(0).LastName+'&Alias='+firstName+lastName+'&CommunityNickname='+commNickName);
            
            }
        }
        else{
            pg = new Pagereference('https://'+URL.getSalesforceBaseURL().getHost()+'/client/_ui/core/portal/PortalUserManagePage/d?ut=P&retURL=/client/'+
                                    usrList.get(0).ContactId+'&retURL=/client/'+usrList.get(0).ContactId+'&id='+usrList.get(0).Id+
                                        '&id='+usrList.get(0).Id+'&cntc='+usrList.get(0).ContactId);
        }
        if(pg!=null){
            system.debug('pg inside  :: '+pg );
            return pg;
        }
        system.debug('DDCreateAndManagePartnerUser :: redirectClientAdmintoCreateOrManagePartnerUser :: end');
        return null;
    }
}