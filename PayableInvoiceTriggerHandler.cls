public class PayableInvoiceTriggerHandler {
    
    public void beforeInsert(List<c2g__codaPurchaseInvoice__c> newPayableInvoiceList, Map<Id, c2g__codaPurchaseInvoice__c> newMap) {
        
        Map<Id, User> dim3Id_ProjectManager_Map = new Map<Id, User>();
        List<Id> dim3IdList = new List<Id>();        
        
        system.debug('newPayableInvoiceList :: '+newPayableInvoiceList);
        for(c2g__codaPurchaseInvoice__c newPayableInvoiceVal : newPayableInvoiceList){
            dim3IdList.add(newPayableInvoiceVal.c2g__Dimension3__c);            
        }
        system.debug('dim3IdList :: '+dim3IdList);
        List<c2g__codaDimension3__c> dim3QueriedList = [select id, ffps_0387__Project__r.Project_Manager_new__c 
                                                                       from c2g__codaDimension3__c where Id in: dim3IdList];        
        system.debug('dim3QueriedList :: '+dim3QueriedList);
        
        for(c2g__codaPurchaseInvoice__c newPayableInvoiceVal : newPayableInvoiceList){
            for(c2g__codaDimension3__c dim3QueriedVal : dim3QueriedList){
                if(dim3QueriedVal.ffps_0387__Project__r != null 
                   && dim3QueriedVal.ffps_0387__Project__r.Project_Manager_new__c != null
                   && newPayableInvoiceVal.c2g__Dimension3__c ==  dim3QueriedVal.Id){
                    newPayableInvoiceVal.Project_Manager__c = dim3QueriedVal.ffps_0387__Project__r.Project_Manager_new__c;
                    break;
                   }
            }
        }
        
    }
    
    /*public void afterInsertOrUpdate(List<c2g__codaPurchaseInvoice__c> newPurInvoiceList, Map<Id, c2g__codaPurchaseInvoice__c> newPurInvoiceMap) {    	        
        validateReferenceNumber(newPurInvoiceList, newPurInvoiceMap);            
    }*/
    
    public void validateReferenceNumber(List<c2g__codaPurchaseInvoice__c> newPurInvoiceList, Map<Id, c2g__codaPurchaseInvoice__c> newPurchaseInvoiceMap){
        
        system.debug('newPurInvoiceList :: '+newPurInvoiceList);
        Map<Id, Bank_details__c> acctId_RecentBankDetails_Map = new Map<Id, Bank_details__c>();        
        Map<Id, Id> purInvoiceId_accId_Map = new Map<Id, Id>();  
        Map<Id, c2g__codaPurchaseInvoice__c> purInvoiceId_PurInvoice_Map = new Map<Id, c2g__codaPurchaseInvoice__c>();  
        
        for(c2g__codaPurchaseInvoice__c newPurInvoiceVal : newPurInvoiceList){
            if(!newPurInvoiceVal.Created_by_scheduled_job__c && newPurInvoiceVal.c2g__InvoiceTotal__c != null && newPurInvoiceVal.c2g__Reference2__c != null
               && newPurInvoiceVal.c2g__InvoiceTotal__c > Integer.valueOf(Label.Bank_Detail)){
                  purInvoiceId_accId_Map.put(newPurInvoiceVal.Id, newPurInvoiceVal.c2g__Account__c);
                  purInvoiceId_PurInvoice_Map.put(newPurInvoiceVal.Id, newPurInvoiceVal);
            }
        }
                
        system.debug('purInvoiceId_accId_Map :: '+purInvoiceId_accId_Map);
        system.debug('purInvoiceId_PurInvoice_Map :: '+purInvoiceId_PurInvoice_Map);
        
        if(purInvoiceId_accId_Map.size() > 0){
            List<Account> accountList_DB = [Select Id,  (Select Id, OwnerId, Name, CurrencyIsoCode, CreatedDate, LastModifiedDate, 
                                                         Account_name__c, Approval_status__c, Bank_City__c, Bank_Country__c, Bank_Fax__c, Bank_Phone__c, 
                                                         Bank_State_Province__c, Bank_Street__c, Bank_Zip_Postal_Code__c, Bank_account_number__c, Bank_name__c, 
                                                         Date_effective_from__c, IBAN_number__c, Routing_number__c, Sort_code__c, Swift_code__c, Verified_by_phone__c 
                                                         From Bank_details__r order by CreatedDate desc) From Account a where Id in: purInvoiceId_accId_Map.values()];
            
            system.debug('accountList_DB :: '+accountList_DB);
            
            for(Account accountVal_DB : accountList_DB){
                if(accountVal_DB.Bank_details__r != null && accountVal_DB.Bank_details__r.size() > 0){
                    if(accountVal_DB.Bank_details__r.get(0).Approval_status__c == 'Approved'){                
                       acctId_RecentBankDetails_Map.put(accountVal_DB.Id, accountVal_DB.Bank_details__r.get(0));   
                    }
                    else{
                        newPurInvoiceList.get(0).addError('Recent Bank Account is not approved');
                    }
                }
                else{
                        newPurInvoiceList.get(0).addError('No associated Bank Account');
                    }
            }
            
            system.debug('acctId_RecentBankDetails_Map :: '+acctId_RecentBankDetails_Map);
            
            if(acctId_RecentBankDetails_Map.size() > 0){
                String accountNumber;    
                String ref2;            
                
                for(Id purInvoiceId_PurInvoice_Id : purInvoiceId_PurInvoice_Map.keySet()){
                    ref2 = purInvoiceId_PurInvoice_Map.get(purInvoiceId_PurInvoice_Id).c2g__Reference2__c;
                    if(acctId_RecentBankDetails_Map.get(purInvoiceId_accId_Map.get(purInvoiceId_PurInvoice_Id)) != null){
                        accountNumber = acctId_RecentBankDetails_Map.get(purInvoiceId_accId_Map.get(purInvoiceId_PurInvoice_Id)).Bank_account_number__c ;
                    }
                    system.debug('ref2 :: '+ref2);
                    system.debug('accountNumber :: '+accountNumber);
                    if(ref2 == null || ref2.length() < 8 || accountNumber == null || accountNumber.length() < 8
                       || ref2.subString(ref2.length()-8, ref2.length()) != accountNumber.subString(accountNumber.length()-8, accountNumber.length())){
                           newPurInvoiceList.get(0).addError('Reference 2 on Payable Invoice does not match Bank Account Number on Bank Details');
                       }
                    else{
                        newPurchaseInvoiceMap.get(purInvoiceId_PurInvoice_Id).Bank_details__c = acctId_RecentBankDetails_Map.get(purInvoiceId_accId_Map.get(purInvoiceId_PurInvoice_Id)).Id;
                    }
                }            
            }
            system.debug('purInvoiceId_PurInvoice_Map :: '+purInvoiceId_PurInvoice_Map);            
        }
    }
        
    public void beforeUpdate(List<c2g__codaPurchaseInvoice__c> newPayableInvoiceList, Map<Id, c2g__codaPurchaseInvoice__c> newMap, Map<Id, c2g__codaPurchaseInvoice__c> oldMap) {        
        
        List<Id> dim3IdList = new List<Id>();        
        for(c2g__codaPurchaseInvoice__c newPayableInvoiceVal : newPayableInvoiceList){
            dim3IdList.add(newPayableInvoiceVal.c2g__Dimension3__c);
        }
        
        system.debug('dim3IdList :: '+dim3IdList);
        
        List<c2g__codaDimension3__c> dim3QueriedList = [select id, ffps_0387__Project__r.Project_Manager_new__c 
                                                                       from c2g__codaDimension3__c where Id in: dim3IdList];        
        system.debug('dim3QueriedList :: '+dim3QueriedList);
        
        validateReferenceNumber(newPayableInvoiceList, newMap);  
        
        for(c2g__codaPurchaseInvoice__c newPayableInvoiceVal : newPayableInvoiceList){
            if(newMap.get(newPayableInvoiceVal.Id).c2g__Dimension3__c == null){
               system.debug('Inside if 3 :: '+newMap.get(newPayableInvoiceVal.Id).c2g__Dimension3__c);
               newPayableInvoiceVal.Project_Manager__c = null;
               continue;
           }
            for(c2g__codaDimension3__c dim3QueriedVal : dim3QueriedList){
                if(dim3QueriedVal.ffps_0387__Project__r != null 
                   && dim3QueriedVal.ffps_0387__Project__r.Project_Manager_new__c != null
                   && newPayableInvoiceVal.c2g__Dimension3__c ==  dim3QueriedVal.Id){
                       if(oldMap.get(newPayableInvoiceVal.Id).c2g__Dimension3__c != newMap.get(newPayableInvoiceVal.Id).c2g__Dimension3__c){
                               newPayableInvoiceVal.Project_Manager__c = dim3QueriedVal.ffps_0387__Project__r.Project_Manager_new__c; 
                                break;
                       }
                   }
            }
        }
        
        system.debug('newMap after :: '+newMap);
    }        
}