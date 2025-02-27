/**
This standard controller extension
1. update client branding parameter
2. create client home page and customer home page default to RAG
*/

public with sharing class DDOBClientMainBrandingCreateExtension {

    public pagereference prevPage {get;set;} 
    public String name {get;set;}
    public String partnerAccountId{get;set;} 
    /*public String mozContentWrapper{get;set;}
    public String webContentWrapper{get;set;}
    public String msContentWrapper{get;set;}
    public String bodyBgcolor{get;set;}
    public String mozButtonBgImage{get;set;}
    public String webButtonBgImage{get;set;}
    public String MsButtonBgImage{get;set;}
    public String primaryBorderTopColor{get;set;}
    public String communityFooterBgColor{get;set;}
    public String tabMenuAColor{get;set;}
    public String brandPrimaryBgColor{get;set;}
    public String activeAHoverColor{get;set;}
    public String menuAHoverColor{get;set;}
    public String communityLogoBgURL{get;set;}
    public String brandPrimaryfgrColor{get;set;}
    public String sidebarBgColor{get;set;}
    public String communityFooterBgURL{get;set;}
    public String footerContentColor{get;set;}
    public String AHoverColor{get;set;}
    public String brandSecondaryBorderColor{get;set;}*/
    public DDBrandingParameters__c mainBrandingParam;
    public String retURL ;
    public pagereference pr;
    public DDClientHomePageComponents__c val;
    public boolean mainBrandingUpdateSuccess;
    
    
    /**
    * Standard Controller constructor
    * 1. Fetches URL parameters   
    * 2. Determines the next page URL    
    * 3. Determines the return URL
    * 4. pre-populates existing branding parameter of an existing Account
    */ 
    public DDOBClientMainBrandingCreateExtension(ApexPages.StandardController ctlr){   
        mainBrandingUpdateSuccess = false;
        system.debug('DDOBClientMainBrandingCreateExtension :: constructor :: start ');
        mainBrandingParam = (DDBrandingParameters__c)ctlr.getSubject();        
        name = ApexPages.currentPage().getParameters().get('accName');    
        partnerAccountId = ApexPages.currentPage().getParameters().get('accId');  
        retURL = '/apex/DDOBClientMainBrandingCreate';
        pr = new Pagereference('/apex/DDOBClientHomePageBrandingCreate');
        system.debug('DDOBClientMainBrandingCreateExtension :: constructor :: end ');
    }
    
    /**
     * action method to 
     * 1. update branding parameter if user has made changes from RAG specific branding
     */ 
    public PageReference Save(){   
        system.debug('DDOBClientMainBrandingCreateExtension :: Save :: start ');
        if(createPartnerBranding()){
			mainBrandingUpdateSuccess = true;            
            pr = createHomepageDefaultBranding(pr);                                    
        }
        system.debug('DDOBClientMainBrandingCreateExtension :: Save :: end ');
        return pr;
    }
    
    /**
     * action method to 
     * 1. create home page branding parameter default to RAG
     * 2. update return url
     * 3. create customer branding parameter default to RAG 
     */ 
    private pagereference createHomepageDefaultBranding(pagereference pr){
        system.debug('DDOBClientMainBrandingCreateExtension :: createHomepageDefaultBranding :: start ');
        
        DDClientHomePageComponents__c paramVal;
        DDClientHomePageComponents__c param2;
        RecordType__c  recType;
        //RecordType__c  recType1;
        //DDCustomerHomePageComponent__c paramVal1;
        //DDCustomerHomePageComponent__c param3;
        
    	recType = RecordType__c.getValues('Risk Advisory Client Branding');  
        
        if(DDClientHomePageComponents__c.getAll().get(name) != null){
            val = [select Id from DDClientHomePageComponents__c where name =: name];
        }
        else{
            paramVal = DDClientHomePageComponents__c.getAll().get(recType.Value__c);
            param2 = paramVal.clone(false, true);
            param2.PartnerAccountId__c = partnerAccountId;
            param2.name = name;       
            //recType1 = RecordType__c.getValues('Risk Advisory Customer Branding');  
            //paramVal1 = DDCustomerHomePageComponent__c.getAll().get(recType1.Value__c);
            //param3 = paramVal1.clone(false, true);
            //param3.DDPartnerAccountId__c = partnerAccountId;
            //param3.name = name;  
            try{
                insert param2;
                //insert param3;                
            }        
            catch(Exception ex){
                new DDBrandingParameters__c().addError('Error inserting client home page branding custom settings');
                return pr;
            }                        
        }  
        retURL = retURL+'?Id='+mainBrandingParam.Id+'&accId='+partnerAccountId+'&accName='+name;
        if(val!=null){
            pr.getParameters().put('Id',val.Id);
        }
        else{
            pr.getParameters().put('Id',param2.Id);
        }        
        pr.getParameters().put('accId',partnerAccountId);
        pr.getParameters().put('accName',name);
        pr.getParameters().put('showPreviousButton','true');
        pr.getParameters().put('retURL',retURL);
        system.debug('pr :: '+pr);
        pr.setRedirect(true);
        system.debug('DDOBClientMainBrandingCreateExtension :: createHomepageDefaultBranding :: end ');
        return pr;
    }
    
    /**
     * action method to 
     * 1. update branding parameter if user has made changes from RAG specific branding     
     */
    private boolean createPartnerBranding(){        
        try{
            upsert mainBrandingParam;
            return true;
        }        
        catch(Exception ex){
            new DDBrandingParameters__c().addError('Error inserting custom settings');
            return false;
        }         
        return false;
    }        
    
    /*private boolean createCustomerBranding(){
    	name = ApexPages.currentPage().getParameters().get('accName');  
        partnerAccountId = ApexPages.currentPage().getParameters().get('accId'); 
        RecordType__c  recType = RecordType__c.getValues('Risk Advisory Customer Branding');  
        system.debug('recType :: '+recType);
        DDCustomerBrandingParameters__c paramVal = DDCustomerBrandingParameters__c.getAll().get(recType.Value__c);
        DDCustomerBrandingParameters__c param2 = paramVal.clone(false, true);
        param2.PartnerAccountId__c = partnerAccountId;
        param2.name = name;   
        try{
            upsert param2;
            return true;
        }        
        catch(Exception ex){
            new DDBrandingParameters__c().addError('Error inserting customer branding custom settings');
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