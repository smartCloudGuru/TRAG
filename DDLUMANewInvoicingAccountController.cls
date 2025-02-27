public class DDLUMANewInvoicingAccountController {
        
    public Account acc;
    public pagereference prevPage;
    
    // Standard controller constructor     
    public DDLUMANewInvoicingAccountController(ApexPages.StandardController controller) {
        system.debug('DDLUMANewInvoicingAccountController :: constructor :: start ');
        acc = (Account)controller.getSubject();
        system.debug('acc in constructor :: '+acc);
        system.debug('DDLUMANewInvoicingAccountController :: constructor :: end ');
    }
    
    public void createAccount(){  
        try{            
            String insId = ApexPages.currentPage().getParameters().get('insId'); 
            system.debug('insId :: '+insId);
            system.debug('acc.LUMA_Billing_Country__c :: '+acc.LUMA_Billing_Country__c);
            String recordSharingRoleId;
            List<DGL__c> accountGroupList = DGL__c.getall().values();
            RecordType__c recType1 = RecordType__c.getValues('ClientBillingAccount');  
            List<DD_Instruction__c> ins = [select Id, DD_Check_Level__c, Billing_Account__c, currencyISOCode, DD_Currency__c,
                                       DD_Client_Commissioner__r.Account.LUMA_Account__c,
                                           DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c,
                                       DD_Client_Commissioner__r.AccountId from  DD_Instruction__c where Id =: insId];
            system.debug('ins :: '+ins);
            system.debug('ins.get(0).DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c before :: '+ins.get(0).DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c);                       
            acc.recordTypeId = recType1.Value__c;
            acc.shippingcountry = acc.Shipping_Country_mapped__c;
            acc.shippingstate = acc.Shipping_state_mapped__c;
            acc.Billing_Account_By_Client__c = true; 
            //acc.ShippingCountry = acc.LUMA_Billing_Country__c; 
            acc.c2g__CODAAccountTradingCurrency__c = acc.CurrencyIsoCode;
            upsert acc;
            for(DGL__c accountGroupVal : accountGroupList){
                if(accountGroupVal.Account__c.equals(String.valueOf(ins.get(0).DD_Client_Commissioner__r.AccountId).subString(0,15)+'__CL_PARTNER_USER_ROLE')){
                        recordSharingRoleId = accountGroupVal.Group__c;         
                }
            }
            AccountShare shr = new AccountShare(UserOrGroupId=recordSharingRoleId, accountid = acc.id, accountaccesslevel = 'read',  OpportunityAccessLevel='read');                          
            insert shr;
            
            ins.get(0).Billing_Account__c = acc.Id;      
            update ins.get(0); 
            Contact con = new Contact();
            RecordType__c recType2 = RecordType__c.getValues('ClientBillingContact');  
            con.firstName = acc.name;
            con.lastName = acc.name;
            con.AccountId = acc.Id;
            con.AR_AP_Contact__c = true;
            con.Email = acc.c2g__CODAInvoiceEmail__c;
            con.recordTypeId = recType2.Value__c;
            upsert con;
            if(ins.get(0).DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c != null){
                acc.ParentId = ins.get(0).DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c;
            } 
            else{
                ins.get(0).DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c = acc.Id;
                acc.parentId = null;
            }  
            update ins.get(0).DD_Client_Commissioner__r.Account;
            update acc;
            system.debug('ins.get(0).DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c after :: '+ins.get(0).DD_Client_Commissioner__r.Account.Parent_LUMA_Billing_Account__c);
            system.debug('acc.ParentId :: '+acc.ParentId);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Success. Close window.'));            
        }            
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to create/update Invoice Account'+ex.getMessage()));
        }
    }         
}