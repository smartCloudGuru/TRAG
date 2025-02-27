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

 Code purpose  : Updates the Proxysalesinvoice on update of relevant fields on the COmapny object


 Birthday      : 15/05/2014
 Api version   : v30

 ****************************************************************************************************************************/

public class DDCompanyTriggerHandler{

    /**
        Afterupdate on Company Trigger
        This method updates the ProxySalesInvoice Object related to Company on update of relevant fields
    */
    public void afterUpdate(List<c2g__codaCompany__c > newCompanyList, Map<Id, c2g__codaCompany__c > oldMap, Map<Id, c2g__codaCompany__c > newMap){
        
        system.debug('DDCompanyTriggerHandler :: afterUpdate :: start');
        List<Id> companyIdList = new List<Id>();
        List<DDSalesInvoiceProxy__c> allSalesInvoiceProxyList = new List<DDSalesInvoiceProxy__c>();
        for(c2g__codaCompany__c newCompanyVal : newCompanyList ){
            companyIdList.add(newCompanyVal.Id); 
        }    
        /*List<c2g__codaCompany__c> queriedCompanyList = [Select c.Id, c.c2g__ZipPostCode__c, c.c2g__Website__c, c.c2g__Street__c, c.c2g__Phone__c, c.c2g__LogoURL__c, c.c2g__LogoImage__c, 
                                                        c.c2g__Fax__c, c.c2g__TaxIdentificationNumber__c, RecordType.Name, Invoice_Company_Name__c, c2g__StateProvince__c,
                                                        c2g__ECCountryCode__c, c2g__BankAccount__r.Name, c2g__Country__c,
                                                        c.c2g__ContactEmail__c, c.c2g__City__c, c.Subsidiary__c, c.Name, (Select Id, Logo_URL__c, LogoImage__c, Company_Name__c, 
                                                        Company_Street__c, 
                                                        Company_City__c, Company_Zip_PostCode__c, Company_Phone__c, Company_Fax__c, Company_Contact_Email__c, 
                                                        Tax_Identification_Number__c, Company_Website__c, Subsidiary__c, Company_Record_Type__c, Invoice_Company_Name__c, Company_State__c,
                                                        Country_Code__c, Company_Bank_Name__c, Company_Country__c 
                                                        From DDSalesInvoiceProxy__r) From c2g__codaCompany__c c where Id in: companyIdList];*/
                                        
        for(c2g__codaCompany__c queriedCompanyVal : [Select c.Id, c.c2g__ZipPostCode__c, c.c2g__Website__c, c.c2g__Street__c, c.c2g__Phone__c, c.c2g__LogoURL__c, c.c2g__LogoImage__c, 
                                                        c.c2g__Fax__c, c.c2g__TaxIdentificationNumber__c, RecordType.Name, Invoice_Company_Name__c, c2g__StateProvince__c,
                                                        c2g__ECCountryCode__c, c2g__BankAccount__r.Name, c2g__Country__c,
                                                        c.c2g__ContactEmail__c, c.c2g__City__c, c.Subsidiary__c, c.Name, (Select Id, Logo_URL__c, LogoImage__c, Company_Name__c, 
                                                        Company_Street__c, 
                                                        Company_City__c, Company_Zip_PostCode__c, Company_Phone__c, Company_Fax__c, Company_Contact_Email__c, 
                                                        Tax_Identification_Number__c, Company_Website__c, Subsidiary__c, Company_Record_Type__c, Invoice_Company_Name__c, Company_State__c,
                                                        Country_Code__c, Company_Bank_Name__c, Company_Country__c 
                                                        From DDSalesInvoiceProxy__r) From c2g__codaCompany__c c where Id in: companyIdList]){
            if(oldMap.get(queriedCompanyVal.Id).c2g__ZipPostCode__c!=newMap.get(queriedCompanyVal.Id).c2g__ZipPostCode__c
                || oldMap.get(queriedCompanyVal.Id).c2g__Website__c!=newMap.get(queriedCompanyVal.Id).c2g__Website__c
                || oldMap.get(queriedCompanyVal.Id).c2g__Street__c!=newMap.get(queriedCompanyVal.Id).c2g__Street__c
                || oldMap.get(queriedCompanyVal.Id).c2g__Phone__c!=newMap.get(queriedCompanyVal.Id).c2g__Phone__c
                || oldMap.get(queriedCompanyVal.Id).c2g__LogoURL__c!=newMap.get(queriedCompanyVal.Id).c2g__LogoURL__c
                || oldMap.get(queriedCompanyVal.Id).c2g__Fax__c!=newMap.get(queriedCompanyVal.Id).c2g__Fax__c
                || oldMap.get(queriedCompanyVal.Id).c2g__City__c!=newMap.get(queriedCompanyVal.Id).c2g__City__c  
                || oldMap.get(queriedCompanyVal.Id).Subsidiary__c!=newMap.get(queriedCompanyVal.Id).Subsidiary__c
                || oldMap.get(queriedCompanyVal.Id).Name!=newMap.get(queriedCompanyVal.Id).Name
                || oldMap.get(queriedCompanyVal.Id).c2g__ContactEmail__c!=newMap.get(queriedCompanyVal.Id).c2g__ContactEmail__c
                || oldMap.get(queriedCompanyVal.Id).c2g__TaxIdentificationNumber__c!=newMap.get(queriedCompanyVal.Id).c2g__TaxIdentificationNumber__c
                || oldMap.get(queriedCompanyVal.Id).RecordType.Name!=newMap.get(queriedCompanyVal.Id).RecordType.Name
                || oldMap.get(queriedCompanyVal.Id).Invoice_Company_Name__c!=newMap.get(queriedCompanyVal.Id).Invoice_Company_Name__c
                || oldMap.get(queriedCompanyVal.Id).c2g__StateProvince__c!=newMap.get(queriedCompanyVal.Id).c2g__StateProvince__c
                || oldMap.get(queriedCompanyVal.Id).c2g__ECCountryCode__c!=newMap.get(queriedCompanyVal.Id).c2g__ECCountryCode__c
                || oldMap.get(queriedCompanyVal.Id).c2g__BankAccount__r.Name!=newMap.get(queriedCompanyVal.Id).c2g__BankAccount__r.Name
                || oldMap.get(queriedCompanyVal.Id).c2g__Country__c!=newMap.get(queriedCompanyVal.Id).c2g__Country__c){
                //List<DDSalesInvoiceProxy__c> salesInvoiceProxyList = queriedCompanyVal.DDSalesInvoiceProxy__r;
                for(DDSalesInvoiceProxy__c salesInvoiceProxyVal : queriedCompanyVal.DDSalesInvoiceProxy__r){
                    salesInvoiceProxyVal.Company_Zip_PostCode__c= newMap.get(queriedCompanyVal.Id).c2g__ZipPostCode__c;
                    salesInvoiceProxyVal.Company_Website__c= newMap.get(queriedCompanyVal.Id).c2g__Website__c;
                    salesInvoiceProxyVal.Company_Street__c= newMap.get(queriedCompanyVal.Id).c2g__Street__c;
                    salesInvoiceProxyVal.Company_Phone__c= newMap.get(queriedCompanyVal.Id).c2g__Phone__c;
                    salesInvoiceProxyVal.Logo_URL__c= newMap.get(queriedCompanyVal.Id).c2g__LogoURL__c;
                    salesInvoiceProxyVal.Company_Fax__c= newMap.get(queriedCompanyVal.Id).c2g__Fax__c;
                    salesInvoiceProxyVal.Company_City__c= newMap.get(queriedCompanyVal.Id).c2g__City__c;
                    salesInvoiceProxyVal.Subsidiary__c = newMap.get(queriedCompanyVal.Id).Subsidiary__c;
                    salesInvoiceProxyVal.Company_Name__c= newMap.get(queriedCompanyVal.Id).Name;
                    salesInvoiceProxyVal.Company_Contact_Email__c= newMap.get(queriedCompanyVal.Id).c2g__ContactEmail__c;
                    salesInvoiceProxyVal.Tax_Identification_Number__c = newMap.get(queriedCompanyVal.Id).c2g__TaxIdentificationNumber__c;
                    salesInvoiceProxyVal.Company_Record_Type__c = newMap.get(queriedCompanyVal.Id).RecordType.Name;
                    salesInvoiceProxyVal.Invoice_Company_Name__c= newMap.get(queriedCompanyVal.Id).Invoice_Company_Name__c;
                    salesInvoiceProxyVal.Company_State__c= newMap.get(queriedCompanyVal.Id).c2g__StateProvince__c;
                    salesInvoiceProxyVal.Country_Code__c= newMap.get(queriedCompanyVal.Id).c2g__ECCountryCode__c;
                    salesInvoiceProxyVal.Company_Bank_Name__c= newMap.get(queriedCompanyVal.Id).c2g__BankAccount__r.Name;
                    salesInvoiceProxyVal.Company_Country__c = newMap.get(queriedCompanyVal.Id).c2g__Country__c;
                    allSalesInvoiceProxyList.add(salesInvoiceProxyVal);
                }
                //allSalesInvoiceProxyList.addAll(salesInvoiceProxyList);
            }
        }
        if(allSalesInvoiceProxyList.size()>0){
            update allSalesInvoiceProxyList;
        }                               
    system.debug('DDCompanyTriggerHandler :: afterUpdate :: end');
    }
}