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

 Code purpose  : Updates the related task order on update of some field change on Opportunity


 Birthday      : 13/05/2014
 Api version   : v30

 ****************************************************************************************************************************/

public class DDOpportunityTriggerHandler{

    
    /**
        On after update of Opportunity Trigger
        This method updates the related task order on update of some field change on Opportunity
    */
    public void onAfterUpdate(final List<Opportunity > oldObjects, final Map<Id, Opportunity > oldObjectsMap,
                          final List<Opportunity > newObjects, final Map<Id, Opportunity > newObjectsMap) {
        
        system.debug('DDOpportunityTriggerHandler :: onAfterUpdate :: start');
        List<Id> taskOrderIdList = new List<Id>();
        List<Id> opportunityIdList = new List<Id>();
        List<Task_Order__c> taskOrderList = new List<Task_Order__c>();
        for(Opportunity newObjectVal : newObjects){
            if(newObjectVal.Originating_Office__c != oldObjectsMap.get(newObjectVal.Id).Originating_Office__c 
               || newObjectVal.Practice_area__c != oldObjectsMap.get(newObjectVal.Id).Practice_area__c
              || newObjectVal.practiceText__c != oldObjectsMap.get(newObjectVal.Id).practiceText__c)
            opportunityIdList.add(newObjectVal.Id);
        }                          
        List<Opportunity> oppQList = [select Id, Originating_Office__c, Practice_area__c, practiceText__c, Owner.name,
                                         (Select DD_Opp_Originating_Office__c, DD_Opp_Practice_area__c, 
                                         DD_Opp_practiceText__c, 
                                         DD_Parent_Opportunity_Owner__c From Task_Orders__r) 
                                         from Opportunity where Id in: opportunityIdList];
        for(Opportunity oppQVal : oppQList){
            List<Task_Order__c> taskOrderToUpdateList = oppQVal.Task_Orders__r;
            for(Task_Order__c taskOrderToUpdateVal : taskOrderToUpdateList){
                taskOrderToUpdateVal.DD_Opp_Originating_Office__c = oppQVal.Originating_Office__c;
                taskOrderToUpdateVal.DD_Opp_Practice_area__c = oppQVal.Practice_area__c;
                taskOrderToUpdateVal.DD_Opp_practiceText__c = oppQVal.practiceText__c;
                taskOrderToUpdateVal.DD_Parent_Opportunity_Owner__c = oppQVal.Owner.name;
                taskOrderList.add(taskOrderToUpdateVal);
            }
        }
        if(taskOrderList!=null && taskOrderList.size()>0){
            update taskOrderList;
        }
        system.debug('DDOpportunityTriggerHandler :: onAfterUpdate :: end');
    }
    
}