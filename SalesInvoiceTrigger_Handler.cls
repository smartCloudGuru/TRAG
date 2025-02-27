public with sharing class SalesInvoiceTrigger_Handler {

    private static SalesInvoiceTrigger_Handler instance;
    public static SalesInvoiceTrigger_Handler getInstance()
    {
        if (instance == null) instance = new SalesInvoiceTrigger_Handler();
        return instance;
    }
    public void onAfterInsert(List<c2g__codaInvoice__c> newObject){
        this.updateInvoicingDescription(newObject);
    } 
    private void updateInvoicingDescription(List<c2g__codaInvoice__c> newObject){
        List<Id> liOfIds = new List<Id>();
        List<Id> liOfIds2 = new List<Id>();
        List<c2g__codaInvoice__c> updateListAcc = new List<c2g__codaInvoice__c>();
        Map<Id,Id>mapOfIdAcc = new Map<Id,Id>();
        Map<Id,Id>mapOfIdUltimatAcc = new Map<Id,Id>();
        Map<Id,String>mapOfAccInstructions = new Map<Id,String>();
        for(c2g__codaInvoice__c iterator:newObject){
            liOfIds.add(iterator.c2g__Account__c);
            mapOfIdAcc.put(iterator.Id,iterator.c2g__Account__c);
        }
        List<Account> liOfAcc = [select Id,Ultimate_Parent_Account__c from Account where Id IN:liOfIds];
        for(Account iterator:liOfAcc){
            liOfIds2.add(iterator.Ultimate_Parent_Account__c);
            mapOfIdUltimatAcc.put(iterator.Id,iterator.Ultimate_Parent_Account__c);
        }
        //List<Account> liOfUltimateAcc = [select Invoicing_Instructions__c from Account where Id IN:liOfIds2];
        List<Account> liOfUltimateAcc = [select Invoicing_Instructions__c from Account where Id IN:liOfIds2];
        for(Account iterator:liOfUltimateAcc){
            //mapOfAccInstructions.put(iterator.id,iterator.Invoicing_Instructions__c);
            mapOfAccInstructions.put(iterator.id,iterator.Invoicing_Instructions__c);
        }
        for(c2g__codaInvoice__c iterator:newObject){
            //iterator.c2g__InvoiceDescription__c = mapOfAccInstructions.get(mapOfIdUltimatAcc.get(mapOfIdAcc.get(iterator.id)));
            iterator.Quirks_From_Account__c = mapOfAccInstructions.get(mapOfIdUltimatAcc.get(mapOfIdAcc.get(iterator.id)));
            updateListAcc.add(iterator);
        }
        //database.update(updateListAcc);
    }
}