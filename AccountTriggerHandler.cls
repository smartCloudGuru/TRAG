/**
* In order to overcome the limitations of the standard SFDC Global Search,
* when an Account record is created the selected picklist values 
* in Countries, Industires and Services
* are copied into two searchable text fields
* 
**/

public class AccountTriggerHandler {
    
    public static void TriggerBeforeInsert(list<Account> triggerNew, Map<Id, Account> newAccountMap, Map<Id, Account> oldAccountMap)
    {
        updateSearchSubcontractors(triggerNew, newAccountMap, oldAccountMap, true); 
        
    }
    
    public static void TriggerBeforeUpdate(list<Account> triggerNew, Map<Id, Account> newAccountMap, Map<Id, Account> oldAccountMap)
    {
        updateSearchSubcontractors(triggerNew, newAccountMap, oldAccountMap, false);
        
    }
    
    /*public static void TriggerAfterInsert(list<Account> triggerNew){
        List<AccountShare> toShareList = new List<AccountShare>();
        String recordSharingRoleId;
        List<DGL__c> accountGroupList = DGL__c.getall().values();
        system.debug('accountGroupList :: '+accountGroupList);
        
        for(Account acc : triggerNew){
            system.debug('acc.IsPartner :: '+acc.IsPartner);
            if(acc.IsPartner){
                system.debug('Inside If Condition');
              for(DGL__c accountGroupVal : accountGroupList){
                  system.debug('acc.IsPartner :: '+acc.IsPartner);
                if(accountGroupVal.Account__c.equals(String.valueOf(acc.Id).subString(0,String.valueOf(acc.Id).length()-3)+'__CL_PARTNER_USER_ROLE')){
                    system.debug('ROle found :: '+accountGroupVal.Group__c);
                    recordSharingRoleId = accountGroupVal.Group__c;
                    system.debug('recordSharingRoleId :: '+recordSharingRoleId);
                    AccountShare shr = new AccountShare(UserOrGroupId = recordSharingRoleId , accountId = acc.Id, contactaccesslevel = 'read', caseaccesslevel = 'read', accountaccesslevel = 'read',  OpportunityAccessLevel='read');
                    toShareList.add(shr);
                }
            }
          }     
        }
    }*/
    
    private static void updateSearchSubcontractors(list<Account> listAcc, Map<Id, Account> newAccountMap, Map<Id, Account> oldAccountMap, Boolean isInsert)
    {
        Id loggedInUserId = UserInfo.getUserId();
        Map<Id, Id> cpaccountId_lumaaccountId_Map = new Map<Id,Id>();
        User usr = [select Id, contact.AccountId from User where Id =: loggedInUserId];
        for(Account acc : listAcc)
        {
            if(acc.calculate_risk_model__c && !isInsert){
                cpaccountId_lumaaccountId_Map.put(acc.Id, acc.ParentId);
            }
            if(acc.RecordType__c.equals('DD_Counterparty') && isInsert){
                acc.ParentId = usr.contact.AccountId;
            }
            if(newAccountMap!=null && newAccountMap.get(acc.Id)!=null 
               && oldAccountMap!=null && oldAccountMap.get(acc.Id)!=null
               && newAccountMap.get(acc.Id).c2g__CODAAccountTradingCurrency__c != oldAccountMap.get(acc.Id).c2g__CODAAccountTradingCurrency__c){
                newAccountMap.get(acc.Id).CurrencyIsoCode = newAccountMap.get(acc.Id).c2g__CODAAccountTradingCurrency__c;
            }
            
            if(newAccountMap!=null && newAccountMap.get(acc.Id)!=null 
               && oldAccountMap!=null && oldAccountMap.get(acc.Id)!=null
               && newAccountMap.get(acc.Id).CurrencyIsoCode != oldAccountMap.get(acc.Id).CurrencyIsoCode){
                newAccountMap.get(acc.Id).c2g__CODAAccountTradingCurrency__c = newAccountMap.get(acc.Id).CurrencyIsoCode;
            }
            acc.Search_Services_Industries__c = (acc.SubcontractorServices__c != null) ? acc.SubcontractorServices__c + '; ' : '';
            
            acc.Search_Countries__c = '';           
                        
            if (acc.SubcontractorCountriesAmericas__c != null)
            {           
                if(acc.SubcontractorCountriesAmericas__c.contains('ALL'))
                {
                    acc.Search_Countries__c += selectAll('SubcontractorCountriesAmericas__c');
                    
                } else {
                    
                    acc.Search_Countries__c += acc.SubcontractorCountriesAmericas__c + '; ';
                }
            }
            
            if (acc.SubcontractorCountriesWesternEurope__c != null)
            {
                if(acc.SubcontractorCountriesWesternEurope__c.contains('ALL'))
                {
                    acc.Search_Countries__c += selectAll('SubcontractorCountriesWesternEurope__c');
                
                } else {
                
                    acc.Search_Countries__c += acc.SubcontractorCountriesWesternEurope__c + '; ';
                }
            }
            
            if (acc.SubcontractorCountriesSubSaharanAfrica__c != null)
            {           
                if(acc.SubcontractorCountriesSubSaharanAfrica__c.contains('ALL'))
                {   
                    acc.Search_Countries__c += selectAll('SubcontractorCountriesSubSaharanAfrica__c');
                
                } else {    
                
                    acc.Search_Countries__c += acc.SubcontractorCountriesSubSaharanAfrica__c + '; ';
                }
            }           
            
            if (acc.SubcontractorCountriesMENA__c != null)
            {
                if(acc.SubcontractorCountriesMENA__c.contains('ALL'))
                {
                    acc.Search_Countries__c += selectAll('SubcontractorCountriesMENA__c');
                
                } else {
            
                    acc.Search_Countries__c += acc.SubcontractorCountriesMENA__c + '; ';
                }
            }
            
            if (acc.SubcontractorCountriesCentralEasternEU__c != null)
            {           
                if(acc.SubcontractorCountriesCentralEasternEU__c.contains('ALL'))
                {
                    acc.Search_Countries__c += selectAll('SubcontractorCountriesCentralEasternEU__c');
                
                } else {
            
                    acc.Search_Countries__c += acc.SubcontractorCountriesCentralEasternEU__c + '; ';
                }
            }
            
            if (acc.SubcontractorCountriesRussia__c != null)
            {
                if(acc.SubcontractorCountriesRussia__c.contains('ALL'))
                {
                    acc.Search_Countries__c += selectAll('SubcontractorCountriesRussia__c');
                
                } else {
                
                    acc.Search_Countries__c += acc.SubcontractorCountriesRussia__c + '; ';
                }
            }
            
            if (acc.SubcontractorCountriesCaucCentAsia__c != null)
            {
                if(acc.SubcontractorCountriesCaucCentAsia__c.contains('ALL'))
                {
                    acc.Search_Countries__c += selectAll('SubcontractorCountriesCaucCentAsia__c');
                
                } else {
                
                    acc.Search_Countries__c += acc.SubcontractorCountriesCaucCentAsia__c + '; ';
                }
            }
            
            if (acc.SubcontractorCountriesSouthEastAsia__c != null)
            {
                if(acc.SubcontractorCountriesSouthEastAsia__c.contains('ALL'))
                {
                    acc.Search_Countries__c += selectAll('SubcontractorCountriesSouthEastAsia__c');
                
                } else {
            
                    acc.Search_Countries__c += acc.SubcontractorCountriesSouthEastAsia__c + '; ';
                }
            }
            
            if (acc.SubcontractorCountriesChina__c != null)
            {
                if(acc.SubcontractorCountriesChina__c.contains('ALL'))
                {
                    acc.Search_Countries__c += selectAll('SubcontractorCountriesChina__c');
                
                } else {
            
                    acc.Search_Countries__c += acc.SubcontractorCountriesChina__c + '; ';
                }
            }
            
            if (acc.SubcontractorIndustries__c != null)
            {
                if(acc.SubcontractorIndustries__c.contains('ALL'))
                {
                    acc.Search_Services_Industries__c += selectAll('SubcontractorIndustries__c');
                
                } else {
            
                    acc.Search_Services_Industries__c += acc.SubcontractorIndustries__c;
                }
            }
        } 
        if(cpaccountId_lumaaccountId_Map.size() > 0){
            try{
                DDUtility.generateRiskModelScore(cpaccountId_lumaaccountId_Map, newAccountMap);
            }
            catch(Exception ex){
                system.debug('Exception :: '+ex.getMessage());
                listAcc.get(0).addError('Error :: '+ex.getMessage());
            }
        }
        
    }
    
    private static String selectAll(String fieldName)
    {
        String values = '';
        
        Schema.DescribeFieldResult fieldResult = Schema.Sobjecttype.Account.fields.getMap().get(fieldName).getDescribe();
        
        for(Schema.Picklistentry pe: fieldResult.getPicklistValues())
        {
            if(pe.getValue() != 'ALL')
            {
                values += pe.getValue() + '; ';
            }
        }
        
        return values;
        
    }
    
    public static void TriggerAfterUpdate(List<Account> newAccountList, Map<Id, Account> oldMap, Map<Id, Account> newMap){
        
        List<AccountShare> toShareList = new List<AccountShare>();
        List<Id> accountIdWithCounterPartyWithApplicationLicense = new List<Id>();
        List<Id> accountIdWithVerificationLicense = new List<Id>();
        List<Id> watchlistRecurringAccountIdWithChangedFrequencyList = new List<Id>();
        String recordSharingRoleId;
        List<DGL__c> accountGroupList = DGL__c.getall().values();
        system.debug('accountGroupList :: '+accountGroupList);
        List<Id> accountIdList = new List<Id>();
        List<DDSalesInvoiceProxy__c> allSalesInvoiceProxyList = new List<DDSalesInvoiceProxy__c>();
        List<Watchlist_Search_Subject__c> wlssListToUpdate = new List<Watchlist_Search_Subject__c>();
            
        Decimal licenseUpdatedValue = 0;
        system.debug('newAccountList :: '+newAccountList); 
        for(Account newAccountVal : newAccountList){
            accountIdList.add(newAccountVal.Id);
        }    
        List<Account> queriedAccountList = [Select a.DD_Due_Diligence_Portal_Licence__c, a.ParentId, a.isPartner, a.DD_User_Licenses__c, Watchlist_search_frequency__c,
                                            a.RecordType__c, a.recordType.Name, a.ShippingStreet, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Name, c2g__CODAVATRegistrationNumber__c, 
                                                (Select Id, Account_Name__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c,
                                                 Registration_Number__c, Customer_Vat_Number__c
                                                From DDSalesInvoiceProxy__r) From Account a where Id in: accountIdList];
        
        system.debug('queriedAccountList :: '+queriedAccountList);                      
        
        for(Account queriedAccountVal : queriedAccountList){
            system.debug('oldMap.get(queriedAccountVal.Id).DD_User_Licenses__c:: '+oldMap.get(queriedAccountVal.Id).DD_User_Licenses__c);
            system.debug('newMap.get(queriedAccountVal.Id).DD_User_Licenses__c:: '+newMap.get(queriedAccountVal.Id).DD_User_Licenses__c);
            system.debug('oldMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c :: '+oldMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c);
            system.debug('newMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c :: '+newMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c);
            
            if(newMap.get(queriedAccountVal.Id).isPartner 
               && newMap.get(queriedAccountVal.Id).Watchlist_search_frequency__c != oldMap.get(queriedAccountVal.Id).Watchlist_search_frequency__c){
                   watchlistRecurringAccountIdWithChangedFrequencyList.add(queriedAccountVal.Id);                   
            }  
            system.debug('watchlistRecurringAccountIdWithChangedFrequencyList :: '+watchlistRecurringAccountIdWithChangedFrequencyList);
            
            if(newMap.get(queriedAccountVal.Id).isPartner 
               && newMap.get(queriedAccountVal.Id).DD_User_Licenses__c != oldMap.get(queriedAccountVal.Id).DD_User_Licenses__c){
                licenseUpdatedValue += newMap.get(queriedAccountVal.Id).DD_User_Licenses__c - oldMap.get(queriedAccountVal.Id).DD_User_Licenses__c;
                   system.debug('Inside Loop licenseUpdatedValue :: '+licenseUpdatedValue);
            }  
            
            if((oldMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c!=newMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c)){
                if(newMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c != null
                   && newMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c.equals('Counterparty Application with Questionnaire')){
                    accountIdWithCounterPartyWithApplicationLicense.add(queriedAccountVal.Id);
                    system.debug('accountIdWithCounterPartyWithApplicationLicense :: '+accountIdWithCounterPartyWithApplicationLicense);
                }
                if(newMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c != null 
                   && newMap.get(queriedAccountVal.Id).DD_Due_Diligence_Portal_Licence__c.equals('Verification')){
                    accountIdWithVerificationLicense.add(queriedAccountVal.Id);
                    system.debug('accountIdWithVerificationLicense :: '+accountIdWithVerificationLicense);
                }
            }
            
            if(!queriedAccountVal.isPartner && oldMap.get(queriedAccountVal.Id).ShippingStreet!=newMap.get(queriedAccountVal.Id).ShippingStreet
                || oldMap.get(queriedAccountVal.Id).ShippingState!=newMap.get(queriedAccountVal.Id).ShippingState
                || oldMap.get(queriedAccountVal.Id).ShippingPostalCode!=newMap.get(queriedAccountVal.Id).ShippingPostalCode
                || oldMap.get(queriedAccountVal.Id).ShippingCountry!=newMap.get(queriedAccountVal.Id).ShippingCountry
                || oldMap.get(queriedAccountVal.Id).ShippingCity!=newMap.get(queriedAccountVal.Id).ShippingCity
                || oldMap.get(queriedAccountVal.Id).Name!=newMap.get(queriedAccountVal.Id).Name
                || oldMap.get(queriedAccountVal.Id).c2g__CODAVATRegistrationNumber__c!=newMap.get(queriedAccountVal.Id).c2g__CODAVATRegistrationNumber__c){
                List<DDSalesInvoiceProxy__c> salesInvoiceProxyList = queriedAccountVal.DDSalesInvoiceProxy__r;
                system.debug('salesInvoiceProxyList :: '+salesInvoiceProxyList);
                for(DDSalesInvoiceProxy__c salesInvoiceProxyVal : salesInvoiceProxyList){
                    salesInvoiceProxyVal.Account_Name__c= newMap.get(queriedAccountVal.Id).Name;
                    salesInvoiceProxyVal.Shipping_Street__c= newMap.get(queriedAccountVal.Id).ShippingStreet;
                    salesInvoiceProxyVal.Shipping_City__c= newMap.get(queriedAccountVal.Id).ShippingCity;
                    salesInvoiceProxyVal.Shipping_State__c= newMap.get(queriedAccountVal.Id).ShippingState;
                    salesInvoiceProxyVal.Shipping_Zip_Postal_Code__c= newMap.get(queriedAccountVal.Id).ShippingPostalCode;
                    salesInvoiceProxyVal.Shipping_Country__c = newMap.get(queriedAccountVal.Id).ShippingCountry;   
                    //salesInvoiceProxyVal.Registration_Number__c = newMap.get(queriedAccountVal.Id).c2g__CODAVATRegistrationNumber__c;                 
                    salesInvoiceProxyVal.Customer_Vat_Number__c = newMap.get(queriedAccountVal.Id).c2g__CODAVATRegistrationNumber__c;                 
                }
                allSalesInvoiceProxyList.addAll(salesInvoiceProxyList);
            }
            system.debug('queriedAccountVal.RecordType__c :: '+queriedAccountVal.RecordType__c);
            if(queriedAccountVal.ParentId!=null && queriedAccountVal.RecordType__c!=null 
               && (queriedAccountVal.RecordType__c.equals('DD_Counterparty') 
                   || queriedAccountVal.RecordType__c.equals('watchlist')
                   || queriedAccountVal.RecordType__c.equals('watchlistaccountinvitation')
                  || queriedAccountVal.RecordType__c.equals('watchlistaccountnoinvitation'))){
                system.debug('Inside If Condition');
              for(DGL__c accountGroupVal : accountGroupList){                  
                  system.debug('queriedAccountVal.ParentId :: '+queriedAccountVal.ParentId);
                if(accountGroupVal.Account__c!=null && accountGroupVal.Account__c.equals(String.valueOf(queriedAccountVal.ParentId).subString(0,String.valueOf(queriedAccountVal.ParentId).length()-3)+'__CL_PARTNER_USER_ROLE')){
                    system.debug('ROle found :: '+accountGroupVal.Group__c);
                    recordSharingRoleId = accountGroupVal.Group__c;
                    system.debug('recordSharingRoleId :: '+recordSharingRoleId);
                    AccountShare shr = new AccountShare(UserOrGroupId = recordSharingRoleId , accountId = queriedAccountVal.Id, caseaccesslevel = 'read', accountaccesslevel = 'edit',  OpportunityAccessLevel='read');
                    toShareList.add(shr);
                }
            }
          }
          
          system.debug('queriedAccountVal.IsPartner :: '+queriedAccountVal.IsPartner);
            if(queriedAccountVal.IsPartner){
                system.debug('Inside If Condition');
              for(DGL__c accountGroupVal : accountGroupList){
                  system.debug('queriedAccountVal.IsPartner inside if :: '+queriedAccountVal.IsPartner);
                  system.debug('accountGroupVal :: '+accountGroupVal);
                  system.debug('accountGroupVal.Account__c :: '+accountGroupVal.Account__c);
                  system.debug('queriedAccountVal :: '+queriedAccountVal);
                if(accountGroupVal.Account__c!=null && accountGroupVal.Account__c.equals(String.valueOf(queriedAccountVal.Id).subString(0,String.valueOf(queriedAccountVal.Id).length()-3)+'__CL_PARTNER_USER_ROLE')){
                    system.debug('ROle found :: '+accountGroupVal.Group__c);
                    recordSharingRoleId = accountGroupVal.Group__c;
                    system.debug('recordSharingRoleId :: '+recordSharingRoleId);
                    AccountShare shr = new AccountShare(UserOrGroupId = recordSharingRoleId , accountId = queriedAccountVal.Id, caseaccesslevel = 'read', accountaccesslevel = 'edit',  OpportunityAccessLevel='edit');
                    toShareList.add(shr);
                }
            }
          }        
        }
        
        if(watchlistRecurringAccountIdWithChangedFrequencyList.size() > 0){
            List<Watchlist_Search_Subject__c> wlssList = [select Id, Account__c, Account__r.parentId, Account__r.parent.Watchlist_search_frequency__c, 
                                                          Watchlist_Next_Search_Date__c from Watchlist_Search_Subject__c where Account__r.parentId in: watchlistRecurringAccountIdWithChangedFrequencyList];
            system.debug('wlssList :: '+wlssList);
            for(Watchlist_Search_Subject__c wlssVal : wlssList){
                if(wlssVal.Watchlist_Next_Search_Date__c == null){
                    wlssVal.Watchlist_Next_Search_Date__c = system.today().addDays(Integer.valueOf(newMap.get(wlssVal.Account__r.parentId).Watchlist_search_frequency__c));                    
                }            
                else{
                    system.debug('Integer.valueOf(newMap.get(wlssVal.Account__r.parentId).Watchlist_search_frequency__c :: '+Integer.valueOf(newMap.get(wlssVal.Account__r.parentId).Watchlist_search_frequency__c));
                    system.debug('Integer.valueOf(oldMap.get(wlssVal.Account__r.parentId).Watchlist_search_frequency__c :: '+Integer.valueOf(oldMap.get(wlssVal.Account__r.parentId).Watchlist_search_frequency__c));            
                    wlssVal.Watchlist_Next_Search_Date__c = wlssVal.Watchlist_Next_Search_Date__c.addDays(Integer.valueOf(newMap.get(wlssVal.Account__r.parentId).Watchlist_search_frequency__c) - Integer.valueOf(oldMap.get(wlssVal.Account__r.parentId).Watchlist_search_frequency__c));
                	system.debug('wlssVal.Watchlist_Next_Search_Date__c :: '+wlssVal.Watchlist_Next_Search_Date__c);                    
                }
                wlssListToUpdate.add(wlssVal);
            }
        }
        
        system.debug('Final licenseUpdatedValue :: '+licenseUpdatedValue);
        system.debug('allSalesInvoiceProxyList after :: '+allSalesInvoiceProxyList);
        
        if(DDUtility.validateTotalLicences(Integer.valueOf(licenseUpdatedValue))){
            DDUtility.updatePartnerUserLicenseInfo(Integer.valueOf(licenseUpdatedValue));
        }
        else{
            newAccountList.get(0).addError('You do not have sufficient licenses available. Please check company details for more information.');
        }
        if(accountIdWithCounterPartyWithApplicationLicense.size()>0 
           || accountIdWithVerificationLicense.size()>0){
            updatePermissionSetForRelatedUser(accountIdWithCounterPartyWithApplicationLicense, accountIdWithVerificationLicense);
        }
        
        system.debug('wlssListToUpdate final :: '+wlssListToUpdate);
        if(wlssListToUpdate.size() > 0){
            update wlssListToUpdate;
        }
        
        if(allSalesInvoiceProxyList.size()>0){
            update allSalesInvoiceProxyList;
        } 
        system.debug('toShareList :: '+toShareList);
        if(toShareList.size()>0){
            insert toShareList;
        }  
        
    }
    
    @future
    static void updatePermissionSetForRelatedUser(List<Id> accountIdWithCounterPartyWithApplicationLicense, List<Id> accountIdWithVerificationLicense){
        String permSetId;
        List<PermissionSetAssignment> permSetToAddList = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> permSetToRemoveList;
        
        List<User> userWithVerificationRWPermissionSetAdded = [select Id from User where user.Contact.AccountId in: accountIdWithCounterPartyWithApplicationLicense 
                                                                and UserType = 'PowerPartner' and IsActive = true ];
        system.debug('userWithVerificationRWPermissionSetAdded :: '+userWithVerificationRWPermissionSetAdded);
        List<User> userWithVerificationRWPermissionSetRemoved = [select Id from User where user.Contact.AccountId in: accountIdWithVerificationLicense 
                                                                    and UserType = 'PowerPartner' and IsActive = true];
        system.debug('userWithVerificationRWPermissionSetRemoved :: '+userWithVerificationRWPermissionSetRemoved);
        
        if(DD_Module_Permission_Sets_List__c.getall() !=null 
            && DD_Module_Permission_Sets_List__c.getall().get('USER Verification Read Write')!=null){
            permSetId = DD_Module_Permission_Sets_List__c.getall().get('USER Verification Read Write').PermissionSetId__c;
            for(User userWithVerificationRWPermissionSetVal : userWithVerificationRWPermissionSetAdded){
                permSetToAddList.add(new PermissionSetAssignment(AssigneeId = userWithVerificationRWPermissionSetVal.id, PermissionSetId = permSetId));
            } 
            if(permSetToAddList.size()>0){
                insert permSetToAddList;
            }
            
            if(userWithVerificationRWPermissionSetRemoved!=null && userWithVerificationRWPermissionSetRemoved.size()>0){
                //ID permSetId18Digit = permSetId;
                //system.debug('permSetId18Digit :: '+permSetId18Digit);
                permSetToRemoveList = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId in: userWithVerificationRWPermissionSetRemoved
                                                and PermissionSet.id =: permSetId];
            }
            system.debug('permSetToRemoveList :: '+permSetToRemoveList);
            if(permSetToRemoveList!=null && permSetToRemoveList.size()>0){
                delete permSetToRemoveList;
            }  
            system.debug('permSetId in Account Update :: '+permSetId); 
        }                  
        
    
    } 
}