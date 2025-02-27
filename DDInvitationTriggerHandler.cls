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

 Code purpose  : 

 Birthday      : 04/07/2014
 Api version   : v30

 ****************************************************************************************************************************/
public class DDInvitationTriggerHandler {
    
    /**
        after insert on CounterParty_Invite__c Object
        This method assosciates assessment with the counterparty invitation when 
        counterparty invitation is created from the assessment
    */
    public void afterInsertInvitation(List<CounterParty_Invite__c> newInvitationList){
    
        List<Id> assessmentIdList = new List<Id>();
        Map<Id, Id> assessmentIdCounterpartyMap = new Map<Id, Id>();
        
        for(CounterParty_Invite__c newInvitationVal: newInvitationList){
            if(newInvitationVal.DD_TempAssessmentId__c!=null && newInvitationVal.DD_TempAssessmentId__c!=''){
                assessmentIdList.add(newInvitationVal.DD_TempAssessmentId__c);
                assessmentIdCounterpartyMap.put(newInvitationVal.DD_TempAssessmentId__c, newInvitationVal.Id);
            }
        }
        List<Case> csList = [select Id, DD_Counterparty__c from Case where Id in: assessmentIdList];    
         
        for(Case csVal : csList){
           csVal.DD_Invitation__c = assessmentIdCounterpartyMap.get(csVal.Id);
        }
        if(csList!=null && csList.size()>0){
           update csList;
        }
    }
}