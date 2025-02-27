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

 Code purpose  : Updates the SalesInvoice Line Item and Sales Invoice Installment Line Item
                 related to the ProxySalesInvoice on its update


 Birthday      : 06/06/2014
 Api version   : v30

 ****************************************************************************************************************************/
public class DDSalesInvoiceProxyTriggerHanlder{

    
    /**
        On after insert of Sales Invoice Proxy
        This method Updates the SalesInvoice Line Item and Sales Invoice Installment Line Item
        related to the ProxySalesInvoice on its update
    */
    public void afterInsert(List<DDSalesInvoiceProxy__c> newSalesInvoiceProxyList){
        
        // - Commented out by KC Thiruchelvam @ Tquila in response to the Recurring Invoices error caused by the salesInvoiceCreateProxy.trigger
        // - this is a TEMPORARY measure
        // - Date : 11/03/2015  
		String recordSharingRoleId;
        List<DDSalesInvoiceProxy__Share> invoiceShare = new List<DDSalesInvoiceProxy__Share>();
        List<Id> salesInvoiceIdList = new List<Id>();
        List<Id> salesInvoiceProxyIdList = new List<Id>();
        List<DDSalesInvoiceProxy__c> salesInvoiceProxyList = new List<DDSalesInvoiceProxy__c>();
        List<DDSalesInvoiceLineItemProxy__c> salesInvoiceLineItemProxyList = new List<DDSalesInvoiceLineItemProxy__c>();
        List<DDSalesInvoiceInstallmentLineItemProxy__c> salesInvoiceInstallmentProxyList = new List<DDSalesInvoiceInstallmentLineItemProxy__c>();
        Decimal admCharge = 0.00;
        Decimal dbCharge = 0.00;
        Decimal profFeeCharge = 0.00;
        Decimal OOPCharge = 0.00;
        Decimal miscCharge = 0.00;
       
        List<DGL__c> accountGroupList = DGL__c.getall().values();
        
        for (DDSalesInvoiceProxy__c newSalesInvoiceProxyVal : newSalesInvoiceProxyList){
            salesInvoiceProxyIdList.add(newSalesInvoiceProxyVal.Id);
            salesInvoiceIdList.add(newSalesInvoiceProxyVal.Sales_Invoice__c);
        }
        
       
        List<c2g__codaInvoice__c> salesInvoiceQueriedList = [Select Id, Tax_Rate_Total__c, c2g__InvoiceCurrency__c, c2g__InvoiceCurrency__r.Name, ffps_0387__CatTitleAdminChrg__c, ffps_0387__CatTitleDbChrg__c, 
                                                                ffps_0387__CatTitleOOPE__c, ffps_0387__CatTitleMiscAdj__c, ffps_0387__CatTitleProfFee__c, 
                                                                c2g__NetTotal__c, c2g__InvoiceTotal__c, c2g__TaxTotal__c, 
                                                                 (Select Id, c2g__Product__c, c2g__Product__r.Name, c2g__TaxRateTotal__c, c2g__NetValue__c, c2g__UnitPrice__c From c2g__InvoiceLineItems__r),
                                                                  (Select Id, c2g__Amount__c, c2g__DueDate__c, c2g__LineNumber__c From c2g__InvoiceInstallmentLineItems__r), 
                                                                  (Select Id, Account__c, Account__r.LUMA_Account__c From DDSalesInvoiceProxy__r) 
                                                                   from c2g__codaInvoice__c 
                                                                where Id in: salesInvoiceIdList];
                                                                
        System.debug('DEBUG:::After SOQL salesInvoiceQueriedList ::' + salesInvoiceQueriedList); 
        for (c2g__codaInvoice__c newSalesInvoiceVal : salesInvoiceQueriedList){          
            if(!newSalesInvoiceVal.DDSalesInvoiceProxy__r.isEmpty()){
                for(DDSalesInvoiceProxy__c psiVal : newSalesInvoiceVal.DDSalesInvoiceProxy__r){
                    if(psiVal.Account__c != null && psiVal.Account__r.LUMA_Account__c != null){
                        for(DGL__c accountGroupVal : accountGroupList){
                            if(accountGroupVal.Account__c.equals(String.valueOf(psiVal.Account__r.LUMA_Account__c).subString(0,15)+'__CL_PARTNER_USER_ROLE')){
                                recordSharingRoleId = accountGroupVal.Group__c;		
                                break;
                            }                            
                        }
                        DDSalesInvoiceProxy__Share shr = new DDSalesInvoiceProxy__Share(UserOrGroupId=recordSharingRoleId, ParentId = psiVal.id, AccessLevel = 'read');                          
                        invoiceShare.add(shr);
                    }
                }
            }
            
            if(newSalesInvoiceVal.c2g__InvoiceLineItems__r.size()>0){
                List<c2g__codaInvoiceLineItem__c> iliList = newSalesInvoiceVal.c2g__InvoiceLineItems__r;
                for(c2g__codaInvoiceLineItem__c iliVal : iliList){
                    DDSalesInvoiceLineItemProxy__c salesInvoiceLineItemProxy = new DDSalesInvoiceLineItemProxy__c();
                    salesInvoiceLineItemProxy.DDSalesInvoiceProxy__c = newSalesInvoiceVal.DDSalesInvoiceProxy__r.get(0).Id; 
                    salesInvoiceLineItemProxy.Product_Name__c = iliVal.c2g__Product__r.Name;
                    salesInvoiceLineItemProxy.Professional_Fee__c = iliVal.c2g__NetValue__c;
                    salesInvoiceLineItemProxy.Tax_Rate__c = iliVal.c2g__TaxRateTotal__c;
                    salesInvoiceLineItemProxyList.add(salesInvoiceLineItemProxy);
                    if(iliVal.c2g__Product__r!=null && iliVal.c2g__Product__r.Name!=null){                  
                        if(iliVal.c2g__Product__r.Name.contains('Admin')){
                            admCharge += iliVal.c2g__NetValue__c ;
                        }
                        else if(iliVal.c2g__Product__r.Name.contains('Database')){
                            dbCharge += iliVal.c2g__NetValue__c ;
                        }
                        else if(iliVal.c2g__Product__r.Name.contains('Professional') || iliVal.c2g__Product__r.Name.contains('Retainer')){
                            profFeeCharge += iliVal.c2g__NetValue__c ;
                        }
                        else if(iliVal.c2g__Product__r.Name.contains('Out of pocket') || iliVal.c2g__Product__r.Name.contains('Pass Through')){
                            OOPCharge += iliVal.c2g__NetValue__c ;
                        }
                        else {
                            miscCharge += iliVal.c2g__NetValue__c ;
                        }
                    }
                    
                }
                if(miscCharge!=0.00){
                    newSalesInvoiceVal.DDSalesInvoiceProxy__r.get(0).Miscellaneous_Charge_Value__c = miscCharge;
                }
                if(OOPCharge!=0.00){
                    newSalesInvoiceVal.DDSalesInvoiceProxy__r.get(0).Out_of_pocket_expense_Value__c= OOPCharge;
                }
                if(profFeeCharge!=0.00){
                    newSalesInvoiceVal.DDSalesInvoiceProxy__r.get(0).Professional_Fee_Value__c=profFeeCharge;
                }
                if(admCharge!=0.00){
                    newSalesInvoiceVal.DDSalesInvoiceProxy__r.get(0).Admin_Charge_Value__c= admCharge;
                }
                if(dbCharge!=0.00){
                    newSalesInvoiceVal.DDSalesInvoiceProxy__r.get(0).Database_Charge_Value__c= dbCharge;
                }
                salesInvoiceProxyList.add(newSalesInvoiceVal.DDSalesInvoiceProxy__r.get(0));
                
                if(newSalesInvoiceVal.c2g__InvoiceInstallmentLineItems__r.size()>0){
                    List<c2g__codaInvoiceInstallmentLineItem__c> iiliList = newSalesInvoiceVal.c2g__InvoiceInstallmentLineItems__r;
                    for(c2g__codaInvoiceInstallmentLineItem__c iiliVal : iiliList){
                        DDSalesInvoiceInstallmentLineItemProxy__c salesInvoiceInstallmentLineItemProxy = new DDSalesInvoiceInstallmentLineItemProxy__c();
                        salesInvoiceInstallmentLineItemProxy.DDSalesInvoiceProxy__c = newSalesInvoiceVal.DDSalesInvoiceProxy__r.get(0).Id; 
                        salesInvoiceInstallmentLineItemProxy.Amount__c = iiliVal.c2g__Amount__c;
                        salesInvoiceInstallmentLineItemProxy.Due_Date__c= iiliVal.c2g__DueDate__c;
                        salesInvoiceInstallmentLineItemProxy.Line_Number__c= iiliVal.c2g__LineNumber__c ;
                        salesInvoiceInstallmentProxyList.add(salesInvoiceInstallmentLineItemProxy);
                    }
                    
                }
            }
            admCharge = 0.00;
            dbCharge = 0.00;
            profFeeCharge = 0.00;
            OOPCharge = 0.00;
            miscCharge = 0.00;
            
        }
      /* new Code : Case 8152 : Code fix for Recurring invoice issue */
        if(salesInvoiceLineItemProxyList.size()>0){
            insert salesInvoiceLineItemProxyList;
        }
        if(salesInvoiceInstallmentProxyList.size()>0){
            insert salesInvoiceInstallmentProxyList;
        }
        
        if(salesInvoiceProxyList.size()>0){
            update salesInvoiceProxyList;
        }
        system.debug('invoiceShare :: '+invoiceShare);
        if(invoiceShare.size() >0 ){
            insert invoiceShare;
        }
        
    /*  End of new code*/      
   system.debug('DDSalesInvoiceProxyTriggerHanlder :: afterInsert :: end');
   
   }

}