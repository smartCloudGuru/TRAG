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

 Code purpose  : Trigger Handler to populate Questionnaire Response from the related assessment creation of Instruction record


 Birthday      : 2014-04-11
 Api version   : v29

 ****************************************************************************************************************************/
public class InstructionTriggerHandler {
    
    /**
        Before insert on Instruction Object
    */
    public void beforeInsertInstruction(List<DD_Instruction__c> newInstructionList, Map<Id, DD_Instruction__c> newInstructionMap){
        
        List<Id> assessmentIdList = new List<Id>();
        List<Id> controlMeasureIdList = new List<Id>();
        Map<Id, Id> assessmentIdControlMeasureIdMap = new Map<Id, Id>();
        Map<Id, DD_Instruction__c> controlMeasureIdInstructionMap = new Map<Id, DD_Instruction__c>();
        
        system.debug('newInstructionMap :: '+newInstructionMap);
        
        for(DD_Instruction__c newInstructionVal : newInstructionList){
            if(newInstructionVal.DD_Control_Measure__c == null){
                newInstructionVal.DD_Type__c = 'Direct Instruction';
            }
            else{
                newInstructionVal.DD_Type__c = 'Control Measure';
            }
            controlMeasureIdList.add(newInstructionVal.DD_Control_Measure__c);
            controlMeasureIdInstructionMap.put(newInstructionVal.DD_Control_Measure__c, newInstructionVal);
        }
        List<DD_Control_Measure__c> queriedControlMeasureList = [Select Id, DD_Assessment__r.Id
                                                                     from  DD_Control_Measure__c where Id in:  controlMeasureIdList];  
        
        system.debug('queriedControlMeasureList :: '+queriedControlMeasureList);
        
        for(DD_Control_Measure__c queriedControlMeasureVal : queriedControlMeasureList){
            if(queriedControlMeasureVal.DD_Assessment__r!=null){
                assessmentIdList.add(queriedControlMeasureVal.DD_Assessment__r.Id);    
                assessmentIdControlMeasureIdMap.put(queriedControlMeasureVal.DD_Assessment__r.Id, queriedControlMeasureVal.Id);
            }
        }   
        
        List<Case> queriedAssessmentList = [Select Id, (select Id from Questionnaire_Responses__r),
                                                Contact.MailingStreet,
                                                Contact.MailingCity, Contact.MailingState,
                                                Contact.MailingPostalCode, Contact.MailingCountry,
                                                Contact.Phone from Case where Id in: assessmentIdList];     
        
        for(Case queriedAssessmentVal : queriedAssessmentList){
            List<dd_Questionnaire_Response__c> qrList = queriedAssessmentVal.Questionnaire_Responses__r;
            controlMeasureIdInstructionMap.get(assessmentIdControlMeasureIdMap.get(queriedAssessmentVal.Id)).DD_Questionnaire_Response__c = qrList.get(0).Id;
            controlMeasureIdInstructionMap.get(assessmentIdControlMeasureIdMap.get(queriedAssessmentVal.Id)).DD_Address__c = queriedAssessmentVal.Contact.MailingStreet + '\n ' +
                                                                                                                            queriedAssessmentVal.Contact.MailingCity + ' ' +queriedAssessmentVal.Contact.MailingState + '\n ' +
                                                                                                                            queriedAssessmentVal.Contact.MailingPostalCode + '\n ' + queriedAssessmentVal.Contact.MailingCountry;
            controlMeasureIdInstructionMap.get(assessmentIdControlMeasureIdMap.get(queriedAssessmentVal.Id)).DDPhone__c = queriedAssessmentVal.Contact.Phone;
        }                
    }
    
    /**
        After update on Instruction Object
    */
    public void afterUpdateInstruction(List<DD_Instruction__c> newInstructionList, Map<Id, DD_Instruction__c> newInstructionMap, Map<Id, DD_Instruction__c> oldInstructionMap){
        
        List<Id> billingAccountIdRemoveList = new List<Id>();
        Map<Id,Id> instructionId_billingAccountIdAdd_Map = new Map<Id,Id>();
        List<Account> accToUpdateList = new List<Account>();
        List<DD_Instruction__c> insQueriedList = [select Id, DD_Check_Level__c, Billing_Account__c, currencyISOCode, DD_Currency__c,
                                       DD_Client_Commissioner__r.Account.LUMA_Account__c,
                                       DD_Client_Commissioner__r.AccountId from  DD_Instruction__c where Id in: newInstructionList];
        
        for(DD_Instruction__c insQueriedVal : insQueriedList){
            if(newInstructionMap.get(insQueriedVal.Id).Billing_Account__c != null 
               && oldInstructionMap.get(insQueriedVal.Id).Billing_Account__c != newInstructionMap.get(insQueriedVal.Id).Billing_Account__c){
                billingAccountIdRemoveList.add(oldInstructionMap.get(insQueriedVal.Id).Billing_Account__c);
                instructionId_billingAccountIdAdd_Map.put(insQueriedVal.Id, insQueriedVal.Billing_Account__c);
            }
        }
        
        List<Account> billAccountToRemoveList = [select Id, LUMA_Account__c, (Select Id From Instructions__r)from Account where Id in: billingAccountIdRemoveList];        
        for(Account billAccountVal : billAccountToRemoveList){
            if(billAccountVal.Instructions__r.isEmpty()){
                billAccountVal.LUMA_Account__c = null;                        
            	accToUpdateList.add(billAccountVal);
            }
        }
        List<Account> billAccountToAddList = [select Id, LUMA_Account__c from Account where Id in: instructionId_billingAccountIdAdd_Map.values()];        
        for(Account billAccountVal : billAccountToAddList){
            for(DD_Instruction__c insQueriedVal : insQueriedList){
                if(billAccountVal.Id == insQueriedVal.Billing_Account__c 
                   && billAccountVal.LUMA_Account__c == null){
                    billAccountVal.LUMA_Account__c = insQueriedVal.DD_Client_Commissioner__r.AccountId;
                }
                accToUpdateList.add(billAccountVal);
            }
        }
        if(!accToUpdateList.isEmpty()){
            update accToUpdateList;
        }                
    }
    
    /**
        Before insert on Instruction Object
    */
    /*public void beforeUpdateInstruction(List<DD_Instruction__c> newInstructionList, Map<Id, DD_Instruction__c> newInstructionMap,Map<Id, DD_Instruction__c> oldInstructionMap){
                
        for(DD_Instruction__c newInstructionVal : newInstructionList){
            system.debug('oldInstructionMap.get(newInstructionVal.Id).DD_Currency__c :: '+oldInstructionMap.get(newInstructionVal.Id).DD_Currency__c);
            system.debug('newInstructionMap.get(newInstructionVal.Id).DD_Currency__c :: '+newInstructionMap.get(newInstructionVal.Id).DD_Currency__c);
            system.debug('newInstructionMap.get(newInstructionVal.Id).currencyISOCode :: '+newInstructionMap.get(newInstructionVal.Id).currencyISOCode);
            system.debug('newInstructionVal.currencyISOCode :: '+newInstructionVal.currencyISOCode);
            system.debug('oldInstructionMap.get(newInstructionVal.Id).DD_Price_Formula__c :: '+oldInstructionMap.get(newInstructionVal.Id).DD_Price_Formula__c);
            system.debug('newInstructionMap.get(newInstructionVal.Id).DD_Price_Formula__c :: '+newInstructionMap.get(newInstructionVal.Id).DD_Price_Formula__c);
            if(oldInstructionMap.get(newInstructionVal.Id).DD_Currency__c != null 
               && newInstructionMap.get(newInstructionVal.Id).DD_Currency__c != oldInstructionMap.get(newInstructionVal.Id).DD_Currency__c
               && newInstructionMap.get(newInstructionVal.Id).DD_Currency__c != newInstructionMap.get(newInstructionVal.Id).currencyISOCode ) {
                	//newInstructionMap.get(newInstructionVal.Id).currencyISOCode = newInstructionMap.get(newInstructionVal.Id).DD_Currency__c;
                	//newInstructionMap.get(newInstructionVal.Id).DD_Price_Formula__c  = oldInstructionMap.get(newInstructionVal.Id).DD_Price_Formula__c ;
                   /*if(oldInstructionMap.get(newInstructionVal.Id).DD_Price_Formula__c != null){
                   		newInstructionMap.get(newInstructionVal.Id).DD_Price_Formula__c  = oldInstructionMap.get(newInstructionVal.Id).DD_Price_Formula__c ;
                   }*/
            /*}
            system.debug('newInstructionVal.currencyISOCode after  :: '+newInstructionVal.currencyISOCode);
        } 
        system.debug('newInstructionList :: '+newInstructionList);
    }*/
}