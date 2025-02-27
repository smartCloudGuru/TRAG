global class DDProxyInvoiceUpdateSchedule implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        
        Set<String> officesToExcludeForProxyCreationSet = new Set<String>();
        List<String> officesToExcludeForProxyInvoiceCreation = Label.LUMA_Offices_to_exclude_proxy_invoice.split(';');
        if(!officesToExcludeForProxyInvoiceCreation.isEmpty()){
            officesToExcludeForProxyCreationSet.addAll(officesToExcludeForProxyInvoiceCreation);
        }
        List<DDSalesInvoiceProxy__c> proxyInvoiceList = [select Id, Payment_Status__c, Sales_Invoice__r.Payment_Status_Update__c, 
                                                         Sales_Invoice__r.c2g__Dimension3__c,
                                                         Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__c,
                                                         Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__c,
                                                         Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__r.DD_Instruction__c,
                                                         Sales_Invoice__r.c2g__PaymentStatus__c from DDSalesInvoiceProxy__c
                                                         where Payment_Status__c != 'Paid' 
                                                         and Sales_Invoice__r.c2g__PaymentStatus__c != 'Unpaid'
                                                         and Sales_Invoice__r.c2g__PaymentStatus__c != 'Not Applicable'
                                                         and Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Group__r.Name not in: officesToExcludeForProxyCreationSet
                                                        and Sales_Invoice__r.c2g__Dimension3__c != null
                                                        and Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__c != null
                                                        and Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__c != null
                                                        and Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__r.DD_Instruction__c != null
                                                        limit 1];
        system.debug('proxyInvoiceList :: '+proxyInvoiceList);
        List<c2g__codaInvoice__c> invoiceList = new List<c2g__codaInvoice__c>();                
        for(DDSalesInvoiceProxy__c proxyInvoiceVal : proxyInvoiceList){
            if(proxyInvoiceVal.Payment_Status__c != proxyInvoiceVal.Sales_Invoice__r.c2g__PaymentStatus__c
              && proxyInvoiceVal.Sales_Invoice__r.c2g__Dimension3__c != null
                && proxyInvoiceVal.Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__c != null
                && proxyInvoiceVal.Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__c != null
                && proxyInvoiceVal.Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__r.DD_Instruction__c != null){
                system.debug('proxyInvoiceVal :: '+proxyInvoiceVal);
                proxyInvoiceVal.Sales_Invoice__r.Payment_Status_Update__c = proxyInvoiceVal.Sales_Invoice__r.c2g__PaymentStatus__c;
                invoiceList.add(proxyInvoiceVal.Sales_Invoice__r);
            }
        }
        system.debug('invoiceList :: '+invoiceList);
        if(!invoiceList.isEmpty()){
     	   update invoiceList;
    	}
    }    
}