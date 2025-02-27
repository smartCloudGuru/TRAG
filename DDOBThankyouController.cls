/**
This controller redirect user to the account record
*/

public class DDOBThankyouController {
    
    public String name {get;set;}
    public String partnerAccountId{get;set;} 
	public pagereference prevPage {get;set;} 
    public pagereference pr;
    
	/**
    * Controller constructor
    * 1. Fetches URL parameters        
    */  
    public DDOBThankyouController(){            
        partnerAccountId = ApexPages.currentPage().getParameters().get('accId');  
        name = ApexPages.currentPage().getParameters().get('accName');                                  
    }
    
    /**
     * action method to redirect user to account record
     */ 
    public PageReference continueToAccount(){  
        List<Account> accList = [select Id, DD_User_Licenses__c from Account where Id =: partnerAccountId];
        if(!accList.isEmpty() && accList.size()==1){
            DDUtility.updatePartnerUserLicenseInfo(Integer.valueOf(accList.get(0).DD_User_Licenses__c));
            pr = new Pagereference('/'+partnerAccountId);
            pr.setRedirect(true);
            return pr;
        }
        else{
            return null;
        }
    }          
    
    /**
     * Action method to determine previous page
     */
    public pagereference prev(){   
        String prevPageURL = ApexPages.currentPage().getParameters().get('retURL');
        prevPageURL = prevPageURL+'&showPreviousButton=false';
        prevPage = new Pagereference(prevPageURL);
        prevPage.setRedirect(true);
        return prevPage;
    }
}