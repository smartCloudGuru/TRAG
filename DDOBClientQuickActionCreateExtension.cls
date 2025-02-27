/**
This standard controller extension
1. update client quick action branding parameter
*/

public with sharing class DDOBClientQuickActionCreateExtension {
    
    public String name {get;set;}
    public String partnerAccountId{get;set;} 
	public pagereference prevPage {get;set;} 
    public String headerTabColour {get;set;} 
    public String headerTabTextColour {get;set;} 
    public String headerTabTextWeight {get;set;} 
    public String sectionTabColour {get;set;} 
    public String sectionTabTextColour {get;set;} 
    public String sectionTabTextWeight {get;set;} 
    public String sectionBodyColour {get;set;} 
    public String sectionbodyTextColour {get;set;} 
    public String sectionbodyTextWeight {get;set;} 
    public String sectionBodyTextHoverColour {get;set;} 
    public String sectionBodyTextHoverWeight {get;set;} 
    public String popOutButton {get;set;} 
    public String popOutButtonHover {get;set;} 
    public String rightEndBarHoverColour {get;set;} 
    public String backgroundColour {get;set;} 
    public DDQuickActionPageComponents__c quickLinksBrandingParam;
    DDBrandingParameters__c brandingParam;
    public String retURL;
    public pagereference pr;
    public boolean showPreviousButton {get;set;}
    
    /**
    * Standard Controller constructor
    * 1. Fetches URL parameters   
    * 2. Determines the next page URL    
    * 3. Determines the return URL
    * 4. pre-populates existing quick action branding parameter of an existing Account
    */    
    public DDOBClientQuickActionCreateExtension(ApexPages.StandardController ctlr){ 
        system.debug('DDOBClientQuickActionCreateExtension :: constructor :: start ');
        if(ctlr!=null){
            quickLinksBrandingParam = (DDQuickActionPageComponents__c)ctlr.getSubject();
        }
        name = ApexPages.currentPage().getParameters().get('accName');  
        partnerAccountId = ApexPages.currentPage().getParameters().get('accId');              
        showPreviousButton = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showPreviousButton'));  
        brandingParam = DDBrandingParameters__c.getValues(name);
        if(brandingParam!=null){
            headerTabColour = brandingParam.BrandPrimaryBgrBgColor__c;
            headerTabTextColour = brandingParam.ZenTabMenuAColor__c;
            headerTabTextWeight = brandingParam.ZenTabMenuAFontWeight__c;
            sectionTabColour = brandingParam.BrandPrimaryBgrBgColor__c;
            sectionTabTextColour = brandingParam.BrandPrimaryBgrBgColor__c;
            sectionTabTextWeight = brandingParam.BrandPrimaryFgrFontWeight__c;
            sectionBodyColour = brandingParam.SideBarBgColor__c;
            sectionbodyTextColour = brandingParam.SideBarLinkColor__c;
            sectionbodyTextWeight = brandingParam.SideBarFontWeight__c;
            sectionBodyTextHoverColour = brandingParam.AHoverColor__c;
            sectionBodyTextHoverWeight = brandingParam.AHoverWeight__c;        
            popOutButton = brandingParam.HandlebarContainerBg__c;
            popOutButtonHover = brandingParam.SidebarCollapsedBg__c;
            popOutButtonHover = brandingParam.HandlebarContainerBg__c;
            rightEndBarHoverColour = brandingParam.handlebarContainerOnHoverbackground__c;
            backgroundColour = brandingParam.handlebarContainerOnFocusbackground__c;
        }
        retURL = '/apex/DDOBClientQuickActionBrandingCreate';
        system.debug('retURL :: '+retURL);   
        pr = new Pagereference('/apex/DDOBCustomerMainBrandingCreate?accId='+partnerAccountId+'&accName='+name);
        system.debug('DDOBClientQuickActionCreateExtension :: constructor :: end ');
    }
    
    /**
     * action method to 
     * 1. update quick action branding parameter if user has made changes from RAG specific branding
     * 2. updates the next page URL    
     */
    public PageReference Save(){          
        system.debug('DDOBClientQuickActionCreateExtension :: Save :: start ');
        
        if(createPartnerQuickActionBranding()){    
            if(createCustomerMainBranding()){
                if(quickLinksBrandingParam!=null){
                    retURL = retURL+'?Id='+quickLinksBrandingParam.Id+'&accId='+partnerAccountId+'&accName='+name;
                }
                system.debug('retURL :: '+retURL);   
                //pr = new Pagereference('/apex/DDOBThankyou?accId='+partnerAccountId+'&accName='+name);
                //pr = new Pagereference('/apex/DDOBCustomerMainBrandingCreate?accId='+partnerAccountId+'&accName='+name);            
                //pr.getParameters().put('accId',partnerAccountId);
                //pr.getParameters().put('accName',name);
                pr.getParameters().put('showPreviousButton','true');
                pr.getParameters().put('retURL',retURL);
                system.debug('pr :: '+pr);
                pr.setRedirect(true);
                return pr;
            }
        }
        system.debug('DDOBClientQuickActionCreateExtension :: Save :: end ');
        return pr;
    }
    
    private boolean createCustomerMainBranding(){        
        RecordType__c  recType1 = RecordType__c.getValues('Risk Advisory Customer Branding');                  
        DDCustomerBrandingParameters__c paramVal1 = DDCustomerBrandingParameters__c.getAll().get(recType1.Value__c);
        DDCustomerBrandingParameters__c param3 = paramVal1.clone(false, true);
        param3.PartnerAccountId__c = partnerAccountId;
        param3.name = name;   
        try{
            upsert param3;  
            pr.getParameters().put('id',param3.Id);
            return true;
        }catch(Exception ex){
            new DDCustomerBrandingParameters__c().addError('Error creating customer branding custom settings');
            return false;
        }
        return true;
    }
    
    /**
     * action method to 
     * 1. update quick action branding parameter default to RAG
     * 2. update return url
     */ 
    private boolean createPartnerQuickActionBranding(){
        //name = ApexPages.currentPage().getParameters().get('accName');  
        //partnerAccountId = ApexPages.currentPage().getParameters().get('accId'); 
        /*RecordType__c  recType = RecordType__c.getValues('Risk Advisory Client Branding');  
        system.debug('recType :: '+recType);
        DDQuickActionPageComponents__c paramVal = DDQuickActionPageComponents__c.getAll().get(recType.Value__c);
        DDQuickActionPageComponents__c param2 = paramVal.clone(false, true);
        param2.DDPartnerAccountId__c = partnerAccountId;
        param2.name = name;  */      
        //DDBrandingParameters__c brandingParam = DDBrandingParameters__c.getValues(name);
        if(!String.isBlank(headerTabColour)){
            brandingParam.BrandPrimaryBgrBgColor__c = headerTabColour;
        }
        if(!String.isBlank(headerTabTextColour)){
            brandingParam.ZenTabMenuAColor__c = headerTabTextColour;
        }
        if(!String.isBlank(headerTabTextWeight)){
            brandingParam.ZenTabMenuAFontWeight__c = headerTabTextWeight;
        }
        if(!String.isBlank(sectionTabColour)){
            //param2.Subsection_BackgroundColor__c = sectionTabColour;
            brandingParam.BrandPrimaryBgrBgColor__c = sectionTabColour;
        }
        if(!String.isBlank(sectionTabTextColour)){
            //param2.HeaderText_Color__c = sectionTabTextColour;
            brandingParam.BrandPrimaryBgrBgColor__c = sectionTabTextColour;
        }
        if(!String.isBlank(sectionTabTextWeight)){
            //param2.HeaderText_FontWeight__c = sectionTabTextWeight;
            brandingParam.BrandPrimaryFgrFontWeight__c = sectionTabTextWeight;
        }
        if(!String.isBlank(sectionBodyColour)){
            //param2.QuickLinksTable_BackgroundColor__c = sectionBodyColour;
            brandingParam.SideBarBgColor__c = sectionBodyColour;
        }
        if(!String.isBlank(sectionbodyTextColour)){
            //param2.QuickLinks_Color__c = sectionbodyTextColour;
            brandingParam.SideBarLinkColor__c = sectionbodyTextColour;
        }
        if(!String.isBlank(sectionbodyTextWeight)){
            //param2.QuickLinks_FontWeight__c = sectionbodyTextWeight;
            brandingParam.SideBarFontWeight__c = sectionbodyTextWeight;
        }
        if(!String.isBlank(sectionBodyTextHoverColour)){
            //param2.OnHover_Color__c = sectionBodyTextHoverColour;
            brandingParam.AHoverColor__c = sectionBodyTextHoverColour;
        }
        if(!String.isBlank(sectionBodyTextHoverWeight)){
            //param2.onHoverFontWeightQA__c = sectionBodyTextHoverWeight;
            brandingParam.AHoverWeight__c = sectionBodyTextHoverWeight;
        }
        if(!String.isBlank(popOutButton)){
            brandingParam.HandlebarContainerBg__c = popOutButton;
        }
        if(!String.isBlank(popOutButtonHover)){
            brandingParam.SidebarCollapsedBg__c = popOutButtonHover;
            brandingParam.HandlebarContainerBg__c = popOutButtonHover;
        }
        if(!String.isBlank(rightEndBarHoverColour)){
            brandingParam.handlebarContainerOnHoverbackground__c = rightEndBarHoverColour;
        }
        if(!String.isBlank(backgroundColour)){
            brandingParam.handlebarContainerOnFocusbackground__c = backgroundColour;
        }   
        
        try{
            if(quickLinksBrandingParam!=null){
                upsert quickLinksBrandingParam;
            }
            if(brandingParam!=null){
                update brandingParam;
            }
            return true;
        }        
        catch(Exception ex){
            new DDBrandingParameters__c().addError('Error inserting home page custom settings');
            return false;
        } 
        return false;
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