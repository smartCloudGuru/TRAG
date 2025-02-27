/**
This controller checks if client specific branding parameter already exist and if not, clones RAG specific branding by default
create customer branding parameter default to RAG
*/

public with sharing class DDOBBackgroundParameterSuccessController {
		
    public String accId;
    public String accName;
    public Pagereference pr;
    public boolean alreadyExist {get;set;}
    public DDBrandingParameters__c val;
    
    /**
    * Controller constructor
    * 1. Fetches URL parameters                      
    */ 
    public DDOBBackgroundParameterSuccessController(){   
        system.debug('DDOBBackgroundParameterSuccessController :: constructor :: start ');
        accId = ApexPages.currentPage().getParameters().get('accId');  
        accName = ApexPages.currentPage().getParameters().get('accName');    
        system.debug('DDOBBackgroundParameterSuccessController :: constructor :: end ');
    }
    
    /**
     * action method to clone RAG specific branding and redirect user to update branding parameter. 
     * create customer branding parameter default to RAG 
     * Produces message on the page if branding already exist.
     */ 
    public pagereference continueToBrandingParam(){
        system.debug('DDOBBackgroundParameterSuccessController :: continueToBrandingParam :: start ');
        
        String brandingId;        
        DDBrandingParameters__c paramVal;
        DDBrandingParameters__c param2;        
        alreadyExist = false;
        RecordType__c  recType;
        RecordType__c  recType1;
        DDCustomerBrandingParameters__c paramVal1;
        //DDCustomerBrandingParameters__c param3;
        
        if(DDBrandingParameters__c.getAll().get(accName)!=null){
            alreadyExist = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Branding for this client already exist. Click continue to update')); 
            val = [select Id from DDBrandingParameters__c where name =: accName];
        }
        else{
            recType = RecordType__c.getValues('Risk Advisory Client Branding');  
            paramVal = DDBrandingParameters__c.getAll().get(recType.Value__c);
            param2 = paramVal.clone(false, true);
            param2.PartnerAccountId__c = accId;
            param2.name = accName;        
            recType1 = RecordType__c.getValues('Risk Advisory Customer Branding');  
            //paramVal1 = DDCustomerBrandingParameters__c.getAll().get(recType1.Value__c);
            //param3 = paramVal1.clone(false, true);
            //param3.PartnerAccountId__c = accId;
            //param3.name = accName;         
            try{
                insert param2;   
                //insert param3;   
            }catch(Exception ex){
                new DDBrandingParameters__c().addError('Error creating client branding custom settings');
                return pr;
            }
            pr = new PageReference('/apex/DDOBClientMainBrandingCreate');
            pr.getParameters().put('Id', param2.Id);
            pr.getParameters().put('accId', accId);
            pr.getParameters().put('accName', accName);
            pr.setRedirect(true);
        }   
        system.debug('DDOBBackgroundParameterSuccessController :: continueToBrandingParam :: end ');
        return pr;
    }
    
    /**
     * continue to update branding parameters to provide Client specific parameter (different from RAG)
     */ 
    public pagereference continueToUpdate(){
        system.debug('DDOBBackgroundParameterSuccessController :: continueToUpdate :: start ');
        
        pr = new PageReference('/apex/DDOBClientMainBrandingCreate');
        pr.getParameters().put('Id', val.Id);
        pr.getParameters().put('accId', accId);
        pr.getParameters().put('accName', accName);
        pr.setRedirect(true);
        
        system.debug('DDOBBackgroundParameterSuccessController :: continueToUpdate :: end ');
        return pr;
    }
}