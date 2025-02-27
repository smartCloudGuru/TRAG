/**
This controller extension 
1. pre-populates account specific information if an existing account is onboarded
2. displays an empty form if a new client is onboarded
3. create or update Account
*/

public with sharing class DDOBFunctionalAccountCreateExtension {
    
    public pagereference nextPage;
    public pagereference prevPage;
    public boolean showPreviousButton {get;set;}
    public Account acc;
    public String BillingAccountId;
    
	// Standard controller constructor     
    public DDOBFunctionalAccountCreateExtension(ApexPages.StandardController controller) {
        system.debug('DDOBFunctionalAccountCreateExtension :: constructor :: start ');
        acc = (Account)controller.getSubject();
        system.debug('acc in constructor :: '+acc);
        showPreviousButton = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showPreviousButton'));  
        BillingAccountId = ApexPages.currentPage().getParameters().get('BillingAccountId');  
        system.debug('DDOBFunctionalAccountCreateExtension :: constructor :: end ');
    }
	
    /**
     * This action method 
     * 1. saves account information
     * 2. redirects user to the next page i.e. create partner contact
     * 3. sets the return url
     */ 
    public pagereference saveandnext(){ 
        system.debug('DDOBFunctionalAccountCreateExtension :: saveandnext :: start ');        
        String apiAccId;        
        try{
            if(DDUtility.validateTotalLicences(Integer.valueOf(acc.DD_User_Licenses__c))){
                if(accountValidationSuccess(acc.Name)){
                    upsert acc;
                    acc.IsPartner = true; 
                    acc.Parent_LUMA_Billing_Account__c = BillingAccountId;
                    update acc;            	        
                    apiAccId = String.valueOf(acc.Id).subString(0,15);            
                    nextPage = new pagereference('/apex/DDOBCreatePartnerContact?showPreviousButton=true&retURL=/apex/DDOnboardingFunctionalAccountCreate?Id='+apiAccId+'&accName='+acc.Name+'&accId='+apiAccId+'&license='+acc.DD_Due_Diligence_Portal_Licence__c+'&watchlistclient='+acc.Watchlist_Client__c);                      
                    nextPage.setRedirect(true);     
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Account Name length : 9-15. Alphanumeric only. No special characters. Account with this name already exists.'));
                }
            }      
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have sufficient licenses available. Please check company details for more information.'));
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to create/update Functional Account'));
        }
        system.debug('DDOBFunctionalAccountCreateExtension :: saveandnext :: end ');
        return nextPage;
    }
    
    private boolean accountValidationSuccess(String accountName){
        if(accountName.length()>8 && accountName.length()<15 && Pattern.matches('^[a-zA-Z0-9]+$', accountName)
           && DGL__c.getAll().get(accountName.substring(0, 9)+' Compl Team') == null){
            return true;
        }
        else{
            return false;
        }
    }
    
    
    
    public pagereference prev(){   
        String prevPageURL = ApexPages.currentPage().getParameters().get('retURL');
        prevPage = new Pagereference(prevPageURL);
        prevPage.setRedirect(true);
        return prevPage;
    }

}