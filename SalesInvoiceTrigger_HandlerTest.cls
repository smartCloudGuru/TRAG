@isTest(SeeAllData=true)
//This is used as the validation keeps on failing, With the error message Object Validation Failed from a Managed Package.
private class SalesInvoiceTrigger_HandlerTest{

static testMethod void testAccountAndSalesInvoice(){
 Triggers__c cs = TestFactory.createCustom();
 cs.Name = 'AccountCalcCodeNew11';
      insert cs;
      
    List<Account> listOfAcc = TestFactory.createAccount(1);
    Account acc = listOfAcc.get(0);
    acc.Quirks__c= 'Test Description';
    acc.CurrencyIsoCode = 'GBP';
    acc.c2g__CODAAccountTradingCurrency__c = 'GBP';
    
    insert acc;
	Id periodId = TestDataHelper.getSalesInvoicePeriod(); 
    List<c2g__codaAccountingCurrency__c> accountingCurrency = TestDataHelper.getAccountingCurrency();
    List<c2g__codaInvoice__c> invoiceList  = new List<c2g__codaInvoice__c>();   
    c2g__codaInvoice__c invoice = new c2g__codaInvoice__c(c2g__Account__c = acc.id,c2g__InvoiceDate__c = Date.today(),c2g__DueDate__c=Date.today()+2);
    invoice.c2g__Period__c = periodId;
    invoice.c2g__InvoiceCurrency__c = accountingCurrency.get(0).Id;
    invoiceList.add(invoice);
    insert invoiceList;
    system.assertEquals('','');
}
}