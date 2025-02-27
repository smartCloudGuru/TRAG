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

 Code purpose  : Trigger Handler to create Standard Salesforce record on creation on 'Counter Party' record


 Birthday      : 2014-03-27
 Api version   : v26

 ****************************************************************************************************************************/
public class CounterPartyTriggerTriggerHandler {
    
    /**
        Before insert on DD_Counterparty_Company__c Object
    */
    public void beforeInsertCounterParty(List<DD_Counterparty_Company__c> newCounterPartyList){}
    
    /* There is List type Custom setting created which contains the Id of record type for 'CounterParty' record type for Standard Account Object
        While creating Account records from Counter part, we need to to create records of 'counterparty' record type
     */
    public RecordType getRecordCounterPartyRecordTypeId(){
        
        system.debug(' CounterPartyTriggerTriggerHandler :: getRecordCounterPartyRecordTypeId :: start ');
        Id recTypeId;
        RecordType recType;
        
        List<RecordType__c> rcTypeList = RecordType__c.getall().values();
        for(RecordType__c rcTypeVal : rcTypeList){
            if(rcTypeVal.Name.equals('CounterParty')){
                recTypeId = rcTypeVal.Value__c;
            }
        }
        if(recTypeId!=null){
            recType = [Select r.Id, r.Name From RecordType r where id =: recTypeId];
        }
        system.debug(' CounterPartyTriggerTriggerHandler :: getRecordCounterPartyRecordTypeId :: end ');
        return recType;
    }
}