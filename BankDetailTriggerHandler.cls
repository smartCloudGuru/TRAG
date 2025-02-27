public class BankDetailTriggerHandler{

    public void afterUpdate(List<c2g__codaBankAccount__c> newBankDetailList, Map<Id, c2g__codaBankAccount__c> oldMap, Map<Id, c2g__codaBankAccount__c> newMap){
        
        List<Id> bankDetailIdList = new List<Id>();
        List<DDSalesInvoiceProxy__c> allSalesInvoiceProxyList = new List<DDSalesInvoiceProxy__c>();
        for(c2g__codaBankAccount__c newBankDetailVal : newBankDetailList){
            bankDetailIdList.add(newBankDetailVal.Id);
        }    
        /*List<c2g__codaBankAccount__c> queriedBankDetailList = [Select  Id, c2g__AccountName__c, c2g__SortCode__c, c2g__AccountNumber__c, 
                                                        c2g__IBANNumber__c, c2g__SWIFTNumber__c,
                                                        c2g__BankName__c, c2g__Street__c, c2g__City__c,
                                                        c2g__ZipPostalCode__c, 
                                                         (Select Bank_Account_Name__c, Bank_Sort_Code__c, Bank_Account_Number__c, Bank_IBAN__c, Bank_Swift_Code__c, Bank_Name__c, 
                                                         Bank_Street__c, Bank_City__c, Bank_Zip_Postal_Code__c From DDSalesInvoiceProxy__r)
                                                        From c2g__codaBankAccount__c where Id in: bankDetailIdList];*/
                                        
        for(c2g__codaBankAccount__c queriedBankDetailVal : [Select  Id, c2g__AccountName__c, c2g__SortCode__c, c2g__AccountNumber__c, 
                                                        c2g__IBANNumber__c, c2g__SWIFTNumber__c,
                                                        c2g__BankName__c, c2g__Street__c, c2g__City__c,
                                                        c2g__ZipPostalCode__c, 
                                                         (Select Bank_Account_Name__c, Bank_Sort_Code__c, Bank_Account_Number__c, Bank_IBAN__c, Bank_Swift_Code__c, Bank_Name__c, 
                                                         Bank_Street__c, Bank_City__c, Bank_Zip_Postal_Code__c From DDSalesInvoiceProxy__r)
                                                        From c2g__codaBankAccount__c where Id in: bankDetailIdList]){
        system.debug('oldMap.get(queriedBankDetailVal.Id).c2g__AccountName__c:: '+oldMap.get(queriedBankDetailVal.Id).c2g__AccountName__c);
        system.debug('newMap.get(queriedBankDetailVal.Id).c2g__AccountName__c:: '+newMap.get(queriedBankDetailVal.Id).c2g__AccountName__c);
            if(oldMap.get(queriedBankDetailVal.Id).c2g__AccountName__c!=newMap.get(queriedBankDetailVal.Id).c2g__AccountName__c
                || oldMap.get(queriedBankDetailVal.Id).c2g__SortCode__c!=newMap.get(queriedBankDetailVal.Id).c2g__SortCode__c
                || oldMap.get(queriedBankDetailVal.Id).c2g__AccountNumber__c!=newMap.get(queriedBankDetailVal.Id).c2g__AccountNumber__c
                || oldMap.get(queriedBankDetailVal.Id).c2g__IBANNumber__c!=newMap.get(queriedBankDetailVal.Id).c2g__IBANNumber__c
                || oldMap.get(queriedBankDetailVal.Id).c2g__SWIFTNumber__c!=newMap.get(queriedBankDetailVal.Id).c2g__SWIFTNumber__c
                || oldMap.get(queriedBankDetailVal.Id).c2g__BankName__c!=newMap.get(queriedBankDetailVal.Id).c2g__BankName__c
                || oldMap.get(queriedBankDetailVal.Id).c2g__Street__c!=newMap.get(queriedBankDetailVal.Id).c2g__Street__c
                || oldMap.get(queriedBankDetailVal.Id).c2g__City__c!=newMap.get(queriedBankDetailVal.Id).c2g__City__c
                || oldMap.get(queriedBankDetailVal.Id).c2g__ZipPostalCode__c!=newMap.get(queriedBankDetailVal.Id).c2g__ZipPostalCode__c){
                //List<DDSalesInvoiceProxy__c> salesInvoiceProxyList = queriedBankDetailVal.DDSalesInvoiceProxy__r;
                //system.debug('salesInvoiceProxyList :: '+salesInvoiceProxyList);
                for(DDSalesInvoiceProxy__c salesInvoiceProxyVal : queriedBankDetailVal.DDSalesInvoiceProxy__r){
                    salesInvoiceProxyVal.Bank_Account_Name__c= newMap.get(queriedBankDetailVal.Id).c2g__AccountName__c;
                    salesInvoiceProxyVal.Bank_Sort_Code__c= newMap.get(queriedBankDetailVal.Id).c2g__SortCode__c;
                    salesInvoiceProxyVal.Bank_Account_Number__c= newMap.get(queriedBankDetailVal.Id).c2g__AccountNumber__c;
                    salesInvoiceProxyVal.Bank_IBAN__c= newMap.get(queriedBankDetailVal.Id).c2g__IBANNumber__c;
                    salesInvoiceProxyVal.Bank_Swift_Code__c= newMap.get(queriedBankDetailVal.Id).c2g__SWIFTNumber__c;
                    salesInvoiceProxyVal.Bank_Name__c= newMap.get(queriedBankDetailVal.Id).c2g__BankName__c;
                    salesInvoiceProxyVal.Bank_Street__c= newMap.get(queriedBankDetailVal.Id).c2g__Street__c;
                    salesInvoiceProxyVal.Bank_City__c= newMap.get(queriedBankDetailVal.Id).c2g__City__c;
                    salesInvoiceProxyVal.Bank_Zip_Postal_Code__c = newMap.get(queriedBankDetailVal.Id).c2g__ZipPostalCode__c;                    
                    allSalesInvoiceProxyList.add(salesInvoiceProxyVal);
                }
                //allSalesInvoiceProxyList.addAll(salesInvoiceProxyList);
            }
        }
        system.debug('allSalesInvoiceProxyList after :: '+allSalesInvoiceProxyList);
        if(allSalesInvoiceProxyList.size()>0){
            update allSalesInvoiceProxyList;
        }                               
    }
}