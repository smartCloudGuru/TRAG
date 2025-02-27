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
 


 Birthday      : 2014-12-17
 Api version   : v32

 ****************************************************************************************************************************/

public with sharing class DD_ReInviteSentController {

    // Default constructor
    public void DD_ReInviteSentController(){}
    
    // Action method on a page to send email notification to counter party
    public Pagereference sendEmail(){
        
        system.debug('DD_ReInviteSentController :: sendEmail :: start');
        List<CounterParty_Invite__c> cpiList;
        List<Account> accList;
        String counterPartyInviteId = ApexPages.currentPage().getParameters().get('counterPartyInviteId');
        system.debug('counterPartyInviteId :: '+counterPartyInviteId);
        
        if(counterPartyInviteId!=null){
            cpiList = [select Id, (select Id, Resend_Questionnaire__c from DD_Assessments__r order by createddate desc), DD_Send_Invite__c, DD_First_Name__c, DD_Last_Name__c, DD_Email__c, DD_Account__c from CounterParty_Invite__c where Id =: counterPartyInviteId];
        }
        system.debug('cpiList :: '+cpiList);
        
        if(cpiList!=null && cpiList.size() == 1){
            if(cpiList.get(0).DD_Assessments__r != null && cpiList.get(0).DD_Assessments__r.size() > 0){
                cpiList.get(0).DD_Assessments__r.get(0).Resend_Questionnaire__c = false;
                update cpiList.get(0).DD_Assessments__r.get(0);
                cpiList.get(0).DD_Assessments__r.get(0).Resend_Questionnaire__c = true;
                update cpiList.get(0).DD_Assessments__r.get(0);
            }
            else{
                cpiList.get(0).DD_Send_Invite__c = false; // This checkbox is ticked to trigger workflow rule to send email
                update cpiList.get(0);
                cpiList.get(0).DD_Send_Invite__c = true; // This checkbox is ticked to trigger workflow rule to send email
                update cpiList.get(0);   
            }
            
        }                
        Pagereference pg = new Pagereference('/client/'+cpiList.get(0).Id);
        pg.setRedirect(true);  
        system.debug('DD_ReInviteSentController :: sendEmail :: start'); 
        return pg;        
    }
}