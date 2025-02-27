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

 Code purpose  : This is a controller working on a 'Send Invite' button on Counterparty 
                 to send invitation to fill in questionnaire and registration details
 


 Birthday      : 2014-03-28
 Api version   : v26

 ****************************************************************************************************************************/

public with sharing class DD_InviteSentController {

    // Default constructor
    public void DD_InviteSentController(){}
    
    // Action method on a page to send email notification to counter party
    public Pagereference sendEmail(){
        
        system.debug('DD_InviteSentController :: sendEmail :: start');
        List<CounterParty_Invite__c> cpiList;
        List<Account> accList;
        Pagereference pg;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String counterPartyInviteId = ApexPages.currentPage().getParameters().get('counterPartyInviteId');
        system.debug('counterPartyInviteId :: '+counterPartyInviteId);
        
        if(counterPartyInviteId!=null){
            cpiList = [select Id, DD_Send_Invite__c, DD_Counterparty_Type__c, DD_First_Name__c, DD_Last_Name__c, DD_Email__c, 
                       WL_Risk_Model_Counterparty_Type__c, DD_Account__c from CounterParty_Invite__c where Id =: counterPartyInviteId];
        }
        system.debug('cpiList :: '+cpiList);
        
        if(cpiList!=null && cpiList.size()>0){
            if((cpiList.get(0).DD_Counterparty_Type__c != null && cpiList.get(0).DD_Counterparty_Type__c != '')
              || (cpiList.get(0).WL_Risk_Model_Counterparty_Type__c != null && cpiList.get(0).WL_Risk_Model_Counterparty_Type__c != '')){
                cpiList.get(0).DD_Send_Invite__c = true; // This checkbox is ticked to trigger workflow rule to send email
                update cpiList;   
                pg = new Pagereference('/client/'+cpiList.get(0).Id);
                pg.setRedirect(true); 
                   
            }
            else{
                system.debug('Add error message'); 
                cpiList.get(0).addError('You have not selected Counterparty Type');                 
            }
        }         
        system.debug('DD_InviteSentController :: sendEmail :: end'); 
        return pg;     
        
    }
}