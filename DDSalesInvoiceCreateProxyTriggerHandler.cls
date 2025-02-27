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

 Code purpose  : Creates Proxy Sales Invoice on creation of Sales Invoice 
                 or Updates Proxy SalesInvoice if relevant field changes on Sales Invoice


 Birthday      : 15/05/2014
 Api version   : v30

 ****************************************************************************************************************************/

public class DDSalesInvoiceCreateProxyTriggerHandler{

    
    /**
        On after update on SalesInvoice
        This method creates Proxy Sales Invoice on creation of Sales Invoice 
        or Updates Proxy SalesInvoice if relevant field changes on Sales Invoice
    */
    
    public Map<Id, List<c2g__codaBankAccount__c>> getMappedBankAccounts(List<Id> ownerCompanyIdList){
        
        Map<Id, List<c2g__codaBankAccount__c>> ownerCompanyId_RelatedBankAccounts_Map = new Map<Id, List<c2g__codaBankAccount__c>>();
        
       List<c2g__codaCompany__c> ownerCompanyList_Queried = [Select c.Id, (Select Id, Name, CurrencyIsoCode, c2g__AccountName__c, 
                       c2g__AccountNumber__c, c2g__BankAccountCurrency__c, c2g__BankAccountCurrency__r.name, c2g__BankChargesDimension1__c, c2g__BankChargesDimension2__c, 
                       c2g__BankChargesDimension3__c, c2g__BankChargesDimension4__c, c2g__BankChargesGLA__c, c2g__BankName__c, c2g__City__c, 
                       c2g__Country__c, c2g__Dimension1__c, c2g__Dimension2__c, c2g__Dimension3__c, c2g__Dimension4__c, 
                       c2g__DirectDebitOriginatorReference__c, c2g__Email__c, c2g__ExternalId__c, c2g__Fax__c, c2g__GeneralLedgerAccount__c, 
                       c2g__IBANNumber__c, c2g__InterestPaidDimension1__c, c2g__InterestPaidDimension2__c, c2g__InterestPaidDimension3__c, 
                       c2g__InterestPaidDimension4__c, c2g__InterestPaidGLA__c, c2g__InterestReceivedDimension1__c, c2g__InterestReceivedDimension2__c, 
                       c2g__InterestReceivedDimension3__c, c2g__InterestReceivedDimension4__c, c2g__InterestReceivedGLA__c, c2g__OwnerCompany__c, 
                       c2g__Phone__c, c2g__ReportingCode__c, c2g__SWIFTNumber__c, c2g__SortCode__c, c2g__StateProvince__c, c2g__Street__c, 
                       c2g__UnitOfWork__c, c2g__ZipPostalCode__c, Routing_Number__c From c2g__BankAccounts__r) From c2g__codaCompany__c c where Id in: ownerCompanyIdList];
        
        system.debug('ownerCompanyList_Queried :: '+ownerCompanyList_Queried);
        for(c2g__codaCompany__c ownerCompanyVal_Queried : ownerCompanyList_Queried){
            system.debug('ownerCompanyVal_Queried.c2g__BankAccounts__r :: '+ownerCompanyVal_Queried.c2g__BankAccounts__r);
            if(!ownerCompanyVal_Queried.c2g__BankAccounts__r.isEmpty()){
                ownerCompanyId_RelatedBankAccounts_Map.put(ownerCompanyVal_Queried.Id, ownerCompanyVal_Queried.c2g__BankAccounts__r);
            }            
        }
        system.debug('ownerCompanyId_RelatedBankAccounts_Map :: '+ownerCompanyId_RelatedBankAccounts_Map);
        return ownerCompanyId_RelatedBankAccounts_Map;
        
    }
    public void afterUpdate(List<c2g__codaInvoice__c> newSalesInvoiceList, Map<Id, c2g__codaInvoice__c> newMap, Map<Id, c2g__codaInvoice__c> oldMap){
        
        //- Commented out by KC Thiruchelvam @ Tquila in response to the Recurring Invoices error caused by the salesInvoiceCreateProxy.trigger
        // - this is a TEMPORARY measure
        // - Date : 11/03/2015  
        system.debug('newSalesInvoiceList :: '+newSalesInvoiceList);
        system.debug('oldMap :: '+oldMap);
        system.debug('newMap :: '+newMap);
        List<Id> salesInvoiceIdList = new List<Id>();
        List<DDSalesInvoiceProxy__c> allSalesInvoiceProxyListToUpdate = new List<DDSalesInvoiceProxy__c>();
        List<DDSalesInvoiceProxy__c> allSalesInvoiceProxyListToCreate = new List<DDSalesInvoiceProxy__c>();
        Set<String> officesToExcludeForProxyCreationSet = new Set<String>();
        List<Id> ownerCompanyIdList = new List<Id>();
        Map<Id, List<c2g__codaBankAccount__c>> ownerCompanyId_RelatedBankAccounts_Map;
        
        List<c2g__codaInvoice__c> newSalesInvoiceQueriedList = [select Id, c2g__InvoiceStatus__c, c2g__Dimension3__r.ffps_0387__Project__r.pse__Group__c,
                                             c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__r.DD_Instruction__c
                                                                from c2g__codaInvoice__c where Id in: newSalesInvoiceList];
        
        system.debug('newSalesInvoiceQueriedList :: '+newSalesInvoiceQueriedList);
            for(c2g__codaInvoice__c newSalesInvoiceVal : newSalesInvoiceQueriedList){
            
                salesInvoiceIdList.add(newSalesInvoiceVal.Id);
        }  
        system.debug('salesInvoiceIdList :: '+salesInvoiceIdList);
        List<c2g__codaInvoice__c> queriedSalesInvoiceList = [Select Id, c2g__CustomerReference__c, Tax_Overall__c, IsUSACompany__c, Routing_Number__c, Routing_Number1__c,
                                                             c2g__InvoiceDate__c, c2g__InvoiceDescription__c, c2g__TaxTotal__c, Name,
                                                                ffps_0387__CatTitleAdminChrg__c, ffps_0387__CatTitleDbChrg__c, ffps_0387__CatTitleMiscAdj__c, ffps_0387__CatTitleOOPE__c, 
                                                                ffps_0387__CatTitleProfFee__c, Tax_Rate_Total__c, c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Subject_s__c,
                                                                c2g__Transaction__r.c2g__DocumentOutstandingTotal__c,
                                                                Invoice_Description_Line_2__c, Invoice_Description_Line_3__c, c2g__InvoiceStatus__c, c2g__InvoiceTotal__c, 
                                                                c2g__NetTotal__c, c2g__OutstandingValue__c, c2g__PaymentSchedule__c, c2g__PaymentStatus__c, c2g__DueDate__c, c2g__PrintStatus__c, 
                                                                c2g__OwnerCompany__c, c2g__OwnerCompany__r.c2g__BankAccount__r.Name, c2g__OwnerCompany__r.c2g__City__c, c2g__OwnerCompany__r.c2g__ContactEmail__c, 
                                                                c2g__OwnerCompany__r.RecordType.Name, c2g__OwnerCompany__r.c2g__ECCountryCode__c,  
                                                                c2g__OwnerCompany__r.c2g__Country__c, c2g__OwnerCompany__r.c2g__Fax__c, c2g__OwnerCompany__r.Name, 
                                                             c2g__OwnerCompany__r.c2g__Phone__c, c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__BankName__c, c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__AccountName__c,
                                                             c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__SortCode__c, c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__Street__c,
                                                             c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__AccountNumber__c, c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__IBANNumber__c, 
                                                             c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__City__c, c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__SWIFTNumber__c, c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__ZipPostalCode__c,                                                                                                                           
                                                                c2g__OwnerCompany__r.RecordTypeId, c2g__OwnerCompany__r.c2g__StateProvince__c, c2g__OwnerCompany__r.c2g__Street__c, c2g__OwnerCompany__r.c2g__Website__c,
                                                                c2g__OwnerCompany__r.c2g__ZipPostCode__c, c2g__OwnerCompany__r.c2g__LogoURL__c, c2g__OwnerCompany__r.c2g__VATRegistrationNumber__c,
                                                                c2g__OwnerCompany__r.Subsidiary__c, c2g__OwnerCompany__r.c2g__TaxIdentificationNumber__c, 
                                                                c2g__Account__c, c2g__Account__r.Name, c2g__Account__r.c2g__CODAECCountryCode__c, c2g__Account__r.c2g__CODAVATRegistrationNumber__c, 
                                                                c2g__Account__r.ShippingStreet, c2g__Account__r.ShippingState, c2g__Account__r.ShippingPostalCode, c2g__Account__r.ShippingCountry, c2g__Account__r.ShippingCity, 
                                                                ffpsai__BillingEvent__c, ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Client_Contact__r.Name, ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Project_Code__c, 
                                                                ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Country_ies__c, 
                                                                c2g__Dimension3__c,c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Client_Contact__r.Name, c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Project_Code__c, 
                                                                c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Country_ies__c, c2g__Dimension3__r.ffps_0387__Project__r.pse__Group__r.Name, 
                                                             c2g__Dimension3__r.ffps_0387__Project__r.Invoicing_Contact__r.Name,   
                                                             Bankaccounttest2__c, Bankaccounttest2__r.Name, Bankaccounttest2__r.c2g__AccountNumber__c, Bankaccounttest2__r.c2g__City__c,
                                                                Bankaccounttest2__r.c2g__IBANNumber__c, Bankaccounttest2__r.c2g__BankName__c, Bankaccounttest2__r.c2g__SortCode__c,
                                                                Bankaccounttest2__r.c2g__Street__c, Bankaccounttest2__r.c2g__SWIFTNumber__c, Bankaccounttest2__r.c2g__ZipPostalCode__c,
                                                                c2g__InvoiceCurrency__c, c2g__InvoiceCurrency__r.Name,
                                                                c2g__IncomeScheduleGroup__c, c2g__IncomeScheduleGroup__r.Name, 
                                                                (select Id from DDSalesInvoiceProxy__r)
                                                                From c2g__codaInvoice__c where Id in: salesInvoiceIdList];
        system.debug('queriedSalesInvoiceList :: '+queriedSalesInvoiceList);
        List<String> officesToExcludeForProxyInvoiceCreation = Label.LUMA_Offices_to_exclude_proxy_invoice.split(';');
        if(!officesToExcludeForProxyInvoiceCreation.isEmpty()){
            officesToExcludeForProxyCreationSet.addAll(officesToExcludeForProxyInvoiceCreation);
        }
        system.debug('officesToExcludeForProxyCreationSet :: '+officesToExcludeForProxyCreationSet);
        
        for(c2g__codaInvoice__c queriedSalesInvoiceVal : queriedSalesInvoiceList){
            system.debug('queriedSalesInvoiceVal.c2g__OwnerCompany__c :: '+queriedSalesInvoiceVal.c2g__OwnerCompany__c);
            if(!officesToExcludeForProxyCreationSet.contains(queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.pse__Group__r.Name)
              && queriedSalesInvoiceVal.Bankaccounttest2__c == null){
            	ownerCompanyIdList.add(queriedSalesInvoiceVal.c2g__OwnerCompany__c);
            }            
        }       
        system.debug('ownerCompanyIdList :: '+ownerCompanyIdList);
        
        if(!ownerCompanyIdList.isEmpty()){
            ownerCompanyId_RelatedBankAccounts_Map = getMappedBankAccounts(ownerCompanyIdList);
        }
        system.debug('ownerCompanyId_RelatedBankAccounts_Map :: '+ownerCompanyId_RelatedBankAccounts_Map);
        
        for(c2g__codaInvoice__c queriedSalesInvoiceVal : queriedSalesInvoiceList){
            system.debug('officesToExcludeForProxyCreationSet :: '+queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.pse__Group__r.Name);
            if(!officesToExcludeForProxyCreationSet.contains(queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.pse__Group__r.Name)){
                List<DDSalesInvoiceProxy__c> salesInvoiceProxyList = queriedSalesInvoiceVal.DDSalesInvoiceProxy__r;
                system.debug('queriedSalesInvoiceVal.c2g__Transaction__r.c2g__DocumentOutstandingTotal__c :: '+queriedSalesInvoiceVal.c2g__Transaction__r.c2g__DocumentOutstandingTotal__c);    
                system.debug('salesInvoiceProxyList :: '+salesInvoiceProxyList);
                if(salesInvoiceProxyList!=null && salesInvoiceProxyList.size()>0){
                    DDSalesInvoiceProxy__c sip = queriedSalesInvoiceVal.DDSalesInvoiceProxy__r.get(0);
                    sip.Account__c = queriedSalesInvoiceVal.c2g__Account__c;
                    sip.IsUSACompany__c = queriedSalesInvoiceVal.IsUSACompany__c;
                    if(!String.isEmpty(queriedSalesInvoiceVal.Routing_Number1__c)){
                        sip.Routing_Number__c = Decimal.valueOf(queriedSalesInvoiceVal.Routing_Number1__c);   
                    }                    
                    sip.Account_Name__c = queriedSalesInvoiceVal.c2g__Account__r.Name;
                    if(queriedSalesInvoiceVal.Bankaccounttest2__c != null /*&& queriedSalesInvoiceVal.Bankaccounttest2__c != ''*/){
                        sip.Bank_Account__c = queriedSalesInvoiceVal.Bankaccounttest2__c;
                        sip.Bank_Account_Name__c = queriedSalesInvoiceVal.Bankaccounttest2__r.Name;
                        sip.Bank_Account_Number__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__AccountNumber__c;
                        sip.Bank_City__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__City__c;
                        sip.Bank_IBAN__c =queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__IBANNumber__c;
                        sip.Bank_Name__c  = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__BankName__c;
                        sip.Bank_Sort_Code__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__SortCode__c;
                        sip.Bank_Street__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__Street__c;
                        sip.Bank_Swift_Code__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__SWIFTNumber__c;
                        sip.Bank_Zip_Postal_Code__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__ZipPostalCode__c; 
                    }
                    else{
                        c2g__codaBankAccount__c bankAcc = getMappedBankAccount(queriedSalesInvoiceVal, ownerCompanyId_RelatedBankAccounts_Map);                                                       
                        sip.Bank_Account__c = bankAcc.Id;
                        sip.Bank_Account_Name__c = bankAcc.c2g__AccountName__c;
                        sip.Bank_Account_Number__c = bankAcc.c2g__AccountNumber__c;
                        sip.Bank_City__c = bankAcc.c2g__City__c;
                        sip.Bank_IBAN__c =bankAcc.c2g__IBANNumber__c;
                        sip.Bank_Name__c  = bankAcc.c2g__BankName__c;
                        sip.Bank_Sort_Code__c = bankAcc.c2g__SortCode__c;
                        sip.Bank_Street__c = bankAcc.c2g__Street__c;
                        sip.Bank_Swift_Code__c = bankAcc.c2g__SWIFTNumber__c;
                        sip.Bank_Zip_Postal_Code__c = bankAcc.c2g__ZipPostalCode__c;
                    }
                    //sip.Billing_Event__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__c;
                    sip.DDDimension_3__c = queriedSalesInvoiceVal.c2g__Dimension3__c;
                    //sip.Client_Contact__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Client_Contact__r.Name;
                    sip.Client_Contact__c = queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.Invoicing_Contact__r.Name;
                    sip.Company__c = queriedSalesInvoiceVal.c2g__OwnerCompany__c;
                    sip.Company_Bank_Name__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__BankAccount__r.Name;
                    sip.Company_City__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__City__c;
                    sip.Company_Contact_Email__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__ContactEmail__c;
                    sip.Company_Country__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Country__c;
                    sip.Company_Fax__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Fax__c;
                    sip.Company_Name__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.Name;
                    sip.Company_Phone__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Phone__c;
                    sip.Company_Record_Type__c= queriedSalesInvoiceVal.c2g__OwnerCompany__r.RecordTypeId;
                    sip.Company_State__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__StateProvince__c;
                    sip.Company_Street__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Street__c;
                    sip.Company_Website__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Website__c;
                    sip.Company_Zip_PostCode__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__ZipPostCode__c;
                    sip.Country_ies__c = queriedSalesInvoiceVal.c2g__InvoiceDescription__c;
                    sip.Country_Code__c = queriedSalesInvoiceVal.c2g__Account__r.c2g__CODAECCountryCode__c;
                    sip.Country_Code__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__ECCountryCode__c;
                    sip.Customer_Reference__c = queriedSalesInvoiceVal.c2g__CustomerReference__c;
                    sip.Customer_Vat_Number__c = queriedSalesInvoiceVal.c2g__Account__r.c2g__CODAVATRegistrationNumber__c;
                    //sip.Customer_Vat_Number__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__VATRegistrationNumber__c;
                    sip.Invoice_Company_Name__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.Name;
                    sip.Invoice_Currency__c= queriedSalesInvoiceVal.c2g__InvoiceCurrency__r.Name;
                    sip.Invoice_Date__c = queriedSalesInvoiceVal.c2g__InvoiceDate__c;
                    sip.Invoice_Description__c = queriedSalesInvoiceVal.c2g__InvoiceDescription__c;
                    sip.Invoice_Description_2__c = queriedSalesInvoiceVal.Invoice_Description_Line_2__c;
                    sip.Invoice_Description_3__c = queriedSalesInvoiceVal.Invoice_Description_Line_3__c;
                    sip.Invoice_Group_Name__c = queriedSalesInvoiceVal.c2g__IncomeScheduleGroup__r.Name;
                    sip.Invoice_Number__c = queriedSalesInvoiceVal.Name;
                    sip.Invoice_Status__c = queriedSalesInvoiceVal.c2g__InvoiceStatus__c;
                    sip.Invoice_Total__c = queriedSalesInvoiceVal.c2g__InvoiceTotal__c;
                    sip.Logo_URL__c  = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__LogoURL__c;
                    sip.Net_Total__c = queriedSalesInvoiceVal.c2g__NetTotal__c;                    
                    sip.Payment_Schedule__c = queriedSalesInvoiceVal.c2g__PaymentSchedule__c;
                    if(oldMap.get(queriedSalesInvoiceVal.Id).c2g__PaymentStatus__c == 'Not Applicable'){
                        sip.Payment_Status__c = 'Unpaid';
                        sip.Outstanding_Value__c = queriedSalesInvoiceVal.c2g__InvoiceTotal__c;
                    } 
                    else{
                        sip.Payment_Status__c = queriedSalesInvoiceVal.c2g__PaymentStatus__c;  
                        sip.Outstanding_Value__c = queriedSalesInvoiceVal.c2g__OutstandingValue__c;
                    }                    
                    sip.Payment_Terms__c = queriedSalesInvoiceVal.c2g__DueDate__c;
                    sip.Print_Status__c = queriedSalesInvoiceVal.c2g__PrintStatus__c;
                    //sip.Project_Code__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Project_Code__c;
                    sip.Project_Code__c = queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Project_Code__c;
                    //sip.Reference__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Project_Code__c;
                    sip.Reference__c = queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Project_Code__c;
                    sip.Registration_Number__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__VATRegistrationNumber__c;
                    sip.Sales_Invoice__c = queriedSalesInvoiceVal.Id;
                    sip.Shipping_City__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingCity ;
                    sip.Shipping_Country__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingCountry;
                    sip.Shipping_State__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingState;
                    sip.Shipping_Street__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingStreet;
                    sip.Shipping_Zip_Postal_Code__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingPostalCode;
                    //sip.Subject__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Country_ies__c;
                    sip.Subject__c = queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Subject_s__c;
                    sip.Subsidiary__c= queriedSalesInvoiceVal.c2g__OwnerCompany__r.Subsidiary__c;
                    sip.Tax_Identification_Number__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__TaxIdentificationNumber__c;
                    sip.Tax_Total__c = queriedSalesInvoiceVal.c2g__TaxTotal__c;
                    sip.Admin_Charge__c = queriedSalesInvoiceVal.ffps_0387__CatTitleAdminChrg__c;
                    sip.Database_Charge__c = queriedSalesInvoiceVal.ffps_0387__CatTitleDbChrg__c;
                    sip.Miscellaneous_Charge__c = queriedSalesInvoiceVal.ffps_0387__CatTitleMiscAdj__c;
                    sip.Out_of_pocket_expense__c = queriedSalesInvoiceVal.ffps_0387__CatTitleOOPE__c;
                    sip.Professional_Fee__c = queriedSalesInvoiceVal.ffps_0387__CatTitleProfFee__c;
                    //sip.Tax_Rate_Total__c = queriedSalesInvoiceVal.Tax_Rate_Total__c;
                    sip.Tax_Rate_Total__c = queriedSalesInvoiceVal.Tax_Overall__c;
                    sip.Tax_Type__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.RecordType.Name;
                    allSalesInvoiceProxyListToUpdate.add(sip);
                }
                else{
                    DDSalesInvoiceProxy__c sip = new DDSalesInvoiceProxy__c();
                    sip.Account__c = queriedSalesInvoiceVal.c2g__Account__c;
                    sip.Account_Name__c = queriedSalesInvoiceVal.c2g__Account__r.Name;
                    sip.IsUSACompany__c = queriedSalesInvoiceVal.IsUSACompany__c;
                    if(!String.isEmpty(queriedSalesInvoiceVal.Routing_Number1__c)){
                        sip.Routing_Number__c = Decimal.valueOf(queriedSalesInvoiceVal.Routing_Number1__c);  
                    }                
                    if(queriedSalesInvoiceVal.Bankaccounttest2__c != null /*&& queriedSalesInvoiceVal.Bankaccounttest2__c != ''*/){
                        sip.Bank_Account__c = queriedSalesInvoiceVal.Bankaccounttest2__c;
                        sip.Bank_Account_Name__c = queriedSalesInvoiceVal.Bankaccounttest2__r.Name;
                        sip.Bank_Account_Number__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__AccountNumber__c;
                        sip.Bank_City__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__City__c;
                        sip.Bank_IBAN__c =queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__IBANNumber__c;
                        sip.Bank_Name__c  = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__BankName__c;
                        sip.Bank_Sort_Code__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__SortCode__c;
                        sip.Bank_Street__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__Street__c;
                        sip.Bank_Swift_Code__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__SWIFTNumber__c;
                        sip.Bank_Zip_Postal_Code__c = queriedSalesInvoiceVal.Bankaccounttest2__r.c2g__ZipPostalCode__c;
                    }
                    else{
                        c2g__codaBankAccount__c bankAcc = getMappedBankAccount(queriedSalesInvoiceVal, ownerCompanyId_RelatedBankAccounts_Map);     
                        sip.Bank_Account__c = bankAcc.Id;
                        sip.Bank_Account_Name__c = bankAcc.c2g__AccountName__c;
                        sip.Bank_Account_Number__c =bankAcc.c2g__AccountNumber__c;
                        sip.Bank_City__c = bankAcc.c2g__City__c;
                        sip.Bank_IBAN__c =bankAcc.c2g__IBANNumber__c;
                        sip.Bank_Name__c  = bankAcc.c2g__BankName__c;
                        sip.Bank_Sort_Code__c =bankAcc.c2g__Street__c;
                        sip.Bank_Street__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__BankAccount__r.c2g__Street__c;
                        sip.Bank_Swift_Code__c = bankAcc.c2g__SWIFTNumber__c;
                        sip.Bank_Zip_Postal_Code__c = bankAcc.c2g__ZipPostalCode__c;
                    }
                    //sip.Billing_Event__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__c;
                    sip.DDDimension_3__c = queriedSalesInvoiceVal.c2g__Dimension3__c;
                    //sip.Client_Contact__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Client_Contact__r.Name;
                    sip.Client_Contact__c = queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.Invoicing_Contact__r.Name;
                    sip.Company__c = queriedSalesInvoiceVal.c2g__OwnerCompany__c;
                    sip.Company_Bank_Name__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__BankAccount__r.Name;
                    sip.Company_City__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__City__c;
                    sip.Company_Contact_Email__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__ContactEmail__c;
                    sip.Company_Country__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Country__c;
                    sip.Company_Fax__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Fax__c;
                    sip.Company_Name__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.Name;
                    sip.Company_Phone__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Phone__c;
                    sip.Company_Record_Type__c= queriedSalesInvoiceVal.c2g__OwnerCompany__r.RecordTypeId;
                    sip.Company_State__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__StateProvince__c;
                    sip.Company_Street__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Street__c;
                    sip.Company_Website__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__Website__c;
                    sip.Company_Zip_PostCode__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__ZipPostCode__c;
                    sip.Country_ies__c = queriedSalesInvoiceVal.c2g__InvoiceDescription__c;
                    //sip.Country_Code__c = queriedSalesInvoiceVal.c2g__Account__r.c2g__CODAECCountryCode__c;
                    sip.Country_Code__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__ECCountryCode__c;
                    sip.Customer_Reference__c = queriedSalesInvoiceVal.c2g__CustomerReference__c;
                    sip.Customer_Vat_Number__c = queriedSalesInvoiceVal.c2g__Account__r.c2g__CODAVATRegistrationNumber__c;
                    //sip.Customer_Vat_Number__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__VATRegistrationNumber__c;
                    sip.Invoice_Company_Name__c= queriedSalesInvoiceVal.c2g__OwnerCompany__r.Name;
                    sip.Invoice_Currency__c= queriedSalesInvoiceVal.c2g__InvoiceCurrency__r.Name;
                    sip.Invoice_Date__c = queriedSalesInvoiceVal.c2g__InvoiceDate__c;
                    sip.Invoice_Description__c = queriedSalesInvoiceVal.c2g__InvoiceDescription__c;
                    sip.Invoice_Description_2__c = queriedSalesInvoiceVal.Invoice_Description_Line_2__c;
                    sip.Invoice_Description_3__c = queriedSalesInvoiceVal.Invoice_Description_Line_3__c;
                    sip.Invoice_Group_Name__c = queriedSalesInvoiceVal.c2g__IncomeScheduleGroup__r.Name;
                    sip.Invoice_Number__c = queriedSalesInvoiceVal.Name;
                    sip.Invoice_Status__c = queriedSalesInvoiceVal.c2g__InvoiceStatus__c;
                    sip.Invoice_Total__c = queriedSalesInvoiceVal.c2g__InvoiceTotal__c;
                    sip.Logo_URL__c  = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__LogoURL__c;
                    sip.Net_Total__c = queriedSalesInvoiceVal.c2g__NetTotal__c;
                    sip.Payment_Schedule__c = queriedSalesInvoiceVal.c2g__PaymentSchedule__c;
                    if(oldMap.get(queriedSalesInvoiceVal.Id).c2g__PaymentStatus__c == 'Not Applicable'){
                        sip.Payment_Status__c = 'Unpaid';
                        sip.Outstanding_Value__c = queriedSalesInvoiceVal.c2g__InvoiceTotal__c;
                    } 
                    else{
                        sip.Payment_Status__c = queriedSalesInvoiceVal.c2g__PaymentStatus__c;  
                        sip.Outstanding_Value__c = queriedSalesInvoiceVal.c2g__OutstandingValue__c;
                    } 
                    sip.Payment_Terms__c = queriedSalesInvoiceVal.c2g__DueDate__c;
                    sip.Print_Status__c = queriedSalesInvoiceVal.c2g__PrintStatus__c;
                    //sip.Project_Code__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Project_Code__c;
                    sip.Project_Code__c = queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Project_Code__c;
                    //sip.Reference__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Project_Code__c;
                    sip.Reference__c = queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Project_Code__c;
                    sip.Registration_Number__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__VATRegistrationNumber__c;
                    sip.Sales_Invoice__c = queriedSalesInvoiceVal.Id;
                    sip.Shipping_City__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingCity ;
                    sip.Shipping_Country__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingCountry;
                    sip.Shipping_State__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingState;
                    sip.Shipping_Street__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingStreet;
                    sip.Shipping_Zip_Postal_Code__c = queriedSalesInvoiceVal.c2g__Account__r.ShippingPostalCode;
                    //sip.Subject__c = queriedSalesInvoiceVal.ffpsai__BillingEvent__r.pse__Project__r.ffps_0387__Country_ies__c;
                    sip.Subject__c = queriedSalesInvoiceVal.c2g__Dimension3__r.ffps_0387__Project__r.ffps_0387__Subject_s__c;
                    sip.Subsidiary__c= queriedSalesInvoiceVal.c2g__OwnerCompany__r.Subsidiary__c;
                    sip.Tax_Identification_Number__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.c2g__TaxIdentificationNumber__c;
                    sip.Tax_Total__c = queriedSalesInvoiceVal.c2g__TaxTotal__c;
                    sip.Admin_Charge__c = queriedSalesInvoiceVal.ffps_0387__CatTitleAdminChrg__c;
                    sip.Database_Charge__c = queriedSalesInvoiceVal.ffps_0387__CatTitleDbChrg__c;
                    sip.Miscellaneous_Charge__c = queriedSalesInvoiceVal.ffps_0387__CatTitleMiscAdj__c;
                    sip.Out_of_pocket_expense__c = queriedSalesInvoiceVal.ffps_0387__CatTitleOOPE__c;
                    sip.Professional_Fee__c = queriedSalesInvoiceVal.ffps_0387__CatTitleProfFee__c;
                    //sip.Tax_Rate_Total__c = queriedSalesInvoiceVal.Tax_Rate_Total__c;
                    sip.Tax_Rate_Total__c = queriedSalesInvoiceVal.Tax_Overall__c;
                    sip.Tax_Type__c = queriedSalesInvoiceVal.c2g__OwnerCompany__r.RecordType.Name;
                    allSalesInvoiceProxyListToCreate.add(sip);
                }
            }
        }
                
        if(allSalesInvoiceProxyListToCreate.size()>0){
            insert allSalesInvoiceProxyListToCreate;
        }  

        if(allSalesInvoiceProxyListToUpdate.size()>0){
            update allSalesInvoiceProxyListToUpdate;
        }  
                             
    system.debug('DDSalesInvoiceCreateProxyTriggerHandler :: afterUpdate :: end');
    
    }
    
    public c2g__codaBankAccount__c getMappedBankAccount(c2g__codaInvoice__c queriedSalesInvoiceVal, Map<Id, List<c2g__codaBankAccount__c>> ownerCompanyId_RelatedBankAccounts_Map){
        
        system.debug('queriedSalesInvoiceVal :: '+queriedSalesInvoiceVal);
        system.debug('ownerCompanyId_RelatedBankAccounts_Map :: '+ownerCompanyId_RelatedBankAccounts_Map);
        
        List<c2g__codaBankAccount__c> bankAccList = new List<c2g__codaBankAccount__c>();
        c2g__codaBankAccount__c bankAcc = new c2g__codaBankAccount__c();
        
        if(ownerCompanyId_RelatedBankAccounts_Map != null && ownerCompanyId_RelatedBankAccounts_Map.size() > 0){
            List<c2g__codaBankAccount__c> bankAccountList = ownerCompanyId_RelatedBankAccounts_Map.get(queriedSalesInvoiceVal.c2g__OwnerCompany__c);
            system.debug('bankAccountList :: '+bankAccountList);
            for(c2g__codaBankAccount__c bankAccountVal : bankAccountList){
                system.debug('bankAccountVal.name :: '+bankAccountVal.name);
                system.debug('queriedSalesInvoiceVal.c2g__InvoiceCurrency__r.Name :: '+queriedSalesInvoiceVal.c2g__InvoiceCurrency__r.Name);
                system.debug('bankAccountVal.c2g__BankAccountCurrency__r.name :: '+bankAccountVal.c2g__BankAccountCurrency__r.name);
                system.debug('queriedSalesInvoiceVal.c2g__OwnerCompany__r.name :: '+queriedSalesInvoiceVal.c2g__OwnerCompany__r.name);
                if(bankAccountVal.name.contains(queriedSalesInvoiceVal.c2g__InvoiceCurrency__r.Name)
                   && queriedSalesInvoiceVal.c2g__InvoiceCurrency__r.Name.equals(bankAccountVal.c2g__BankAccountCurrency__r.name)){
                       if(queriedSalesInvoiceVal.c2g__OwnerCompany__r.name.equals('The Risk Advisory Group Ltd')){
                           if(queriedSalesInvoiceVal.c2g__InvoiceCurrency__r.Name.equals('GBP') 
                              && bankAccountVal.name.contains('LON GBP Main')){
                               bankAccList.add(bankAccountVal);
                               break;
                           }
                           else if(queriedSalesInvoiceVal.c2g__InvoiceCurrency__r.Name.equals('USD') 
                              && bankAccountVal.name.contains('Barclays LON USD')){
                               bankAccList.add(bankAccountVal);
                               break;
                           }
                           else if(queriedSalesInvoiceVal.c2g__InvoiceCurrency__r.Name.equals('EUR') 
                              && bankAccountVal.name.contains('Barclays LON EUR')){
                               bankAccList.add(bankAccountVal);
                               break;
                           }
                       }
                       else{
                           bankAccList.add(bankAccountVal);
                           break;
                       }
                   }
            }
            system.debug('bankAccList :: '+bankAccList);
            if(bankAccList.size() == 1){
                bankAcc = bankAccList.get(0);
            }    
        }
        system.debug('bankAcc :: '+bankAcc);
        return bankAcc;
    }    
}