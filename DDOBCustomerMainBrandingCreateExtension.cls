public with sharing class DDOBCustomerMainBrandingCreateExtension {
    
    public pagereference prevPage {get;set;} 
    public String name {get;set;}
    public String partnerAccountId{get;set;} 
    public DDCustomerBrandingParameters__c mainBrandingParam;
    public String retURL ;
    public pagereference pr;
    //public DDCustomerHomePageComponents__c val;
    public boolean mainBrandingUpdateSuccess;
    
    public DDOBCustomerMainBrandingCreateExtension(ApexPages.StandardController ctlr){   
        mainBrandingUpdateSuccess = false;
        system.debug('DDOBCustomerMainBrandingCreateExtension :: constructor :: start ');
        if(ctlr!=null){
        	mainBrandingParam = (DDCustomerBrandingParameters__c)ctlr.getSubject();     
        }
        name = ApexPages.currentPage().getParameters().get('accName');    
        system.debug('name :: '+name);
        partnerAccountId = ApexPages.currentPage().getParameters().get('accId');  
        system.debug('partnerAccountId :: '+partnerAccountId);
        retURL = '/apex/DDOBCustomerMainBrandingCreate';
        pr = new Pagereference('/apex/DDOBCustomerHomePageBrandingCreate');
        system.debug('DDOBCustomerMainBrandingCreateExtension :: constructor :: end ');
    }
    
    public PageReference Save(){   
        system.debug('DDOBCustomerMainBrandingCreateExtension :: Save :: start ');
        if(createCustomerBranding()){
			//mainBrandingUpdateSuccess = true;            
            //if(mainBrandingUpdateSuccess){
                pr = createHomepageDefaultBranding(pr);
                pr.setRedirect(true);
//            }
            return pr;
        }
        system.debug('DDOBCustomerMainBrandingCreateExtension :: Save :: end ');
        return pr;
    }
    
    private pagereference createHomepageDefaultBranding(pagereference pr){
        system.debug('DDOBCustomerMainBrandingCreateExtension :: createHomepageDefaultBranding :: start ');
        
        //DDCustomerHomePageComponents__c paramVal;
        //DDClientHomePageComponents__c param2;
        //RecordType__c  recType;
        RecordType__c  recType1;
        DDCustomerHomePageComponent__c paramVal1;
        DDCustomerHomePageComponent__c param3;
        
    	//recType = RecordType__c.getValues('Risk Advisory Client Branding');  
        
        //if(DDClientHomePageComponents__c.getAll().get(name) != null){
           // val = [select Id from DDClientHomePageComponents__c where name =: name];
        //}
        //else{
            //paramVal = DDClientHomePageComponents__c.getAll().get(recType.Value__c);
            //param2 = paramVal.clone(false, true);
            //param2.PartnerAccountId__c = partnerAccountId;
            //param2.name = name;       
            recType1 = RecordType__c.getValues('Risk Advisory Customer Branding');  
            paramVal1 = DDCustomerHomePageComponent__c.getAll().get(recType1.Value__c);
            param3 = paramVal1.clone(false, true);
        	system.debug('partnerAccountId in save :: '+partnerAccountId);
        	system.debug('name in save :: '+name);
            param3.DDPartnerAccountId__c = partnerAccountId;
            param3.name = name;  
            try{
                //insert param2;
                upsert param3;       
                if(mainBrandingParam!=null){
                    retURL = retURL+'?Id='+mainBrandingParam.Id+'&accId='+partnerAccountId+'&accName='+name;
                }
                pr.getParameters().put('Id',param3.Id);
                pr.getParameters().put('accId',partnerAccountId);
                pr.getParameters().put('accName',name);
                pr.getParameters().put('showPreviousButton','true');
                pr.getParameters().put('retURL',retURL);
                system.debug('pr :: '+pr);
                return pr;
            }        
            catch(Exception ex){
                new DDCustomerHomePageComponent__c().addError('Error inserting customer home page branding custom settings');
                return pr;
            }                        
        //}  
        
        //if(val!=null){
          //  pr.getParameters().put('Id',val.Id);
        //}
        //else{
            
        //}        
        
        //pr.setRedirect(true);
        system.debug('DDOBCustomerMainBrandingCreateExtension :: createHomepageDefaultBranding :: end ');
        return pr;
    }
        
    private boolean createCustomerBranding(){        
        try{
            if(mainBrandingParam!=null){
                upsert mainBrandingParam;
            }
            return true;
        }        
        catch(Exception ex){
            new DDCustomerBrandingParameters__c().addError('Error inserting Customer branding');
            return false;
        }         
        return false;
    } 

}