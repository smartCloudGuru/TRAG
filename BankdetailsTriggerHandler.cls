public class BankdetailsTriggerHandler {
    
     public static Boolean isUpdate = true;
    
    public void afterUpdate(List<Bank_details__c> newList, Map<Id, Bank_details__c> newMap, List<Bank_details__c> oldList, Map<Id, Bank_details__c> oldMap){
        
       
        Map<Id, Id> bankDetailsId_AccountId_Map = new Map<Id, Id>();
        Map<Id, List<Bank_details__c>> accountId_BankDetailsList_Map = new Map<Id, List<Bank_details__c>>();
        List<Bank_details__c> bdList ;
        for(Bank_details__c newVal : newList){
            if(newVal.Approval_status__c == 'Submitted'){
                bankDetailsId_AccountId_Map.put(newVal.Id, newVal.Account_name__c);
            }            
        }
        
        List<Account> assoaciatedAccounts_DB = [select Id, (select Id, Approval_status__c from Bank_details__r) from Account where Id in: bankDetailsId_AccountId_Map.values()];
        
        for(Account assoaciatedAccount_DB : assoaciatedAccounts_DB){
            if(!assoaciatedAccount_DB.Bank_details__r.isEmpty()){
                accountId_BankDetailsList_Map.put(assoaciatedAccount_DB.Id, assoaciatedAccount_DB.Bank_details__r);
            }
        }
        
        for(Id bankDetailsId_AccountId_Val : bankDetailsId_AccountId_Map.keyset()){
            bdList = accountId_BankDetailsList_Map.get(bankDetailsId_AccountId_Map.get(bankDetailsId_AccountId_Val));
            for(Bank_details__c bdVal : bdList){
                if(bdVal.Id != bankDetailsId_AccountId_Val){
                    bdVal.Approval_status__c = 'Superseded';
                }
            }
        }
        if(bdList != null && !bdList.isEmpty() && BankdetailsTriggerHandler.isUpdate){
            BankdetailsTriggerHandler.isUpdate = false;
         	update bdList;   
            
        }        
    }

}