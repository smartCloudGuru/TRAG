public class DDOBCustomerHomePageCreateExtension {

    public String name {get;set;}
    public String partnerAccountId{get;set;} 
	public pagereference prevPage {get;set;}
    public DDCustomerHomePageComponent__c homepageBrandingParam; 
    public String retURL;
    public pagereference pr;
    //public DDQuickActionPageComponents__c val;
    public boolean showPreviousButton {get;set;}
    
    public DDOBCustomerHomePageCreateExtension(ApexPages.StandardController ctlr){      
        system.debug('DDOBCustomerHomePageCreateExtension :: DDOBClientHomePageCreateExtension :: start ');
        if(ctlr!=null){
       		homepageBrandingParam = (DDCustomerHomePageComponent__c)ctlr.getSubject();
        }
        name = ApexPages.currentPage().getParameters().get('accName');     
        partnerAccountId = ApexPages.currentPage().getParameters().get('accId');  
        showPreviousButton = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showPreviousButton'));    
         
        
        retURL = '/apex/DDOBCustomerMainBrandingCreate';
        pr = new Pagereference('/apex/DDOBThankyou?accId='+partnerAccountId+'&accName='+name);
        
        system.debug('DDOBCustomerHomePageCreateExtension :: DDOBClientHomePageCreateExtension :: end ');    
    }
    
    public pagereference Save(){    
        system.debug('DDOBCustomerHomePageCreateExtension :: Save :: start ');
        if(createCustomerHomePageBranding()){
            //pr = createDefaultQuickLinkBranding(pr);      
            if(homepageBrandingParam!=null){
                retURL = retURL+'?Id='+homepageBrandingParam.Id+'&accId='+partnerAccountId+'&accName='+name;
            }
            pr.getParameters().put('accId',partnerAccountId);
            pr.getParameters().put('accName',name);
            pr.getParameters().put('showPreviousButton','true');
            pr.getParameters().put('retURL',retURL);
            system.debug('pr :: '+pr);
            pr.setRedirect(true);  
            return pr;   
        }
        system.debug('DDOBCustomerHomePageCreateExtension :: Save :: end ');
		return pr;        
    }
    
    private boolean createCustomerHomePageBranding(){
        system.debug('DDOBCustomerHomePageCreateExtension :: createCustomerHomePageBranding :: start ');
        
        //name = ApexPages.currentPage().getParameters().get('accName');  
        //partnerAccountId = ApexPages.currentPage().getParameters().get('accId');                       
        try{
            upsert homepageBrandingParam;
            return true;
        }        
        catch(Exception ex){
            new DDBrandingParameters__c().addError('Error updating home page custom settings');
            return false;
        }    
        system.debug('DDOBCustomerHomePageCreateExtension :: createCustomerHomePageBranding :: end ');
        return false;
    }
    
    public pagereference prev(){   
        String prevPageURL = ApexPages.currentPage().getParameters().get('retURL');
        prevPage = new Pagereference(prevPageURL);
        prevPage.setRedirect(true);
        return prevPage;
    }
}