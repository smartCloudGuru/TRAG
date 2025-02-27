/**
This standard controller extension
1. update client home page branding parameter
2. create client quick action branding default to RAG
*/

public with sharing class DDOBClientHomePageCreateExtension {
	
    public String name {get;set;}
    public String partnerAccountId{get;set;} 
	public pagereference prevPage {get;set;} 
	/*public String bgColor{get;set;}
    public String edgeLineColour{get;set;}
    public String titleTextSize{get;set;}
    public String titleTextWeight{get;set;}
    public String tableHeadingColour{get;set;}
    public String tableBorderColour{get;set;}
    public String tableBorderWidth{get;set;}
    public String tableHeadingLineColour{get;set;}
    public String tableHeadingTextSize{get;set;}
    public String tableHeadingTextWeight{get;set;}
    public String tableTextSize{get;set;}
    public String tableTextWeight{get;set;}
    public String createInstructionbuttonDesign{get;set;}
    public String reviewInstructionbuttonDesign{get;set;}*/
    public DDClientHomePageComponents__c homepageBrandingParam;
    public String retURL;
    public pagereference pr;
    public DDQuickActionPageComponents__c val;
    public boolean showPreviousButton {get;set;}
	    
    /**
    * Standard Controller constructor
    * 1. Fetches URL parameters   
    * 2. Determines the next page URL    
    * 3. Determines the return URL
    * 4. pre-populates existing home page branding parameter of an existing Account
    */     
    public DDOBClientHomePageCreateExtension(ApexPages.StandardController ctlr){      
        system.debug('DDOBClientMainBrandingCreateExtension :: DDOBClientHomePageCreateExtension :: start ');
        
        homepageBrandingParam = (DDClientHomePageComponents__c)ctlr.getSubject();
        name = ApexPages.currentPage().getParameters().get('accName');     
        partnerAccountId = ApexPages.currentPage().getParameters().get('accId');  
        showPreviousButton = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showPreviousButton'));    
         
        
        retURL = '/apex/DDOBClientHomePageBrandingCreate';
        pr = new Pagereference('/apex/DDOBClientQuickActionBrandingCreate');
        
        system.debug('DDOBClientMainBrandingCreateExtension :: DDOBClientHomePageCreateExtension :: end ');    
    }
    
    /**
     * action method to 
     * 1. update home page branding parameter if user has made changes from RAG specific branding
     */ 
    public pagereference Save(){    
        system.debug('DDOBClientMainBrandingCreateExtension :: Save :: start ');
        if(createPartnerHomePageBranding()){
            pr = createDefaultQuickLinkBranding(pr);                                        
        }
        system.debug('DDOBClientMainBrandingCreateExtension :: Save :: end ');
		return pr;        
    }
    
    /**
     * action method to 
     * 1. create quick action branding parameter default to RAG
     * 2. update return url
     */ 
    private pagereference createDefaultQuickLinkBranding(pagereference pr){   
        system.debug('DDOBClientMainBrandingCreateExtension :: createDefaultQuickLinkBranding :: start ');
        
        DDQuickActionPageComponents__c paramVal;
        DDQuickActionPageComponents__c param2;  
        RecordType__c  recType;
        
    	recType = RecordType__c.getValues('Risk Advisory Client Branding');  
        try{
            if(DDQuickActionPageComponents__c.getAll().get(name) != null){
                val = [select Id from DDQuickActionPageComponents__c where name =: name];
            }
            else{
                paramVal = DDQuickActionPageComponents__c.getAll().get(recType.Value__c);
                param2 = paramVal.clone(false, true);
                param2.DDPartnerAccountId__c = partnerAccountId;
                param2.name = name;                
                insert param2;                                         
            }
        }        
        catch(Exception ex){
            new DDBrandingParameters__c().addError('Error inserting quick action branding parameters');
            return pr;
        }
        if(val!=null){
            pr.getParameters().put('Id',val.Id);
        }
        else{
            pr.getParameters().put('Id',param2.Id);
        }  
        retURL = retURL+'?Id='+homepageBrandingParam.Id+'&accId='+partnerAccountId+'&accName='+name;
        system.debug('retURL :: '+retURL);            
        pr.getParameters().put('accId',partnerAccountId);
        pr.getParameters().put('accName',name);
        pr.getParameters().put('showPreviousButton','true');
        pr.getParameters().put('retURL',retURL);
        pr.setRedirect(true);
        
        system.debug('DDOBClientMainBrandingCreateExtension :: createDefaultQuickLinkBranding :: end ');
        return pr;
    }
    
    
    /**
     * action method to 
     * 1. update home page branding parameter if user has made changes from RAG specific branding     
     */
    private boolean createPartnerHomePageBranding(){
        system.debug('DDOBClientMainBrandingCreateExtension :: createPartnerHomePageBranding :: start ');
        
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
        system.debug('DDOBClientMainBrandingCreateExtension :: createPartnerHomePageBranding :: end ');
        return false;
    }
    
    /*private boolean createCustomerHomePageBranding(){
    	name = ApexPages.currentPage().getParameters().get('accName');  
        partnerAccountId = ApexPages.currentPage().getParameters().get('accId'); 
        RecordType__c  recType = RecordType__c.getValues('Risk Advisory Customer Branding');  
        system.debug('recType :: '+recType);
        DDCustomerHomePageComponent__c paramVal = DDCustomerHomePageComponent__c.getAll().get(recType.Value__c);
        DDCustomerHomePageComponent__c param2 = paramVal.clone(false, true);
        param2.DDPartnerAccountId__c = partnerAccountId;
        param2.name = name;   
        try{
            insert param2;
            return true;
        }        
        catch(Exception ex){
            new DDBrandingParameters__c().addError('Error inserting customer home page branding custom settings');
            return false;
        }         
        return false;
    }*/
    
    /**
     * Action method to determine previous page
     */
    public pagereference prev(){   
        String prevPageURL = ApexPages.currentPage().getParameters().get('retURL');
        prevPage = new Pagereference(prevPageURL);
        prevPage.setRedirect(true);
        return prevPage;
    }
}