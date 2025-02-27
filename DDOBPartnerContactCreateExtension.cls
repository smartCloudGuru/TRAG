/**
This controller extension
1. creates partner contact
2. redirects user tothe next page to create Admin User for Client 
*/

public with sharing class DDOBPartnerContactCreateExtension {
    
    public pagereference nextPage;
    public pagereference prevPage;
    public Contact con;
    public String accountId;
    public String accName;
    public String accLicense;
    public String retURL;
    public boolean showPreviousButton {get;set;}
		
	 /**
	  * Standard controller constructor. 
	  * 1. Fetches URL parameters 
	  * 2. controls the behaviour of back button display 	
	  */      
     public DDOBPartnerContactCreateExtension(ApexPages.StandardController controller) {
         system.debug('DDOBPartnerContactCreateExtension :: Constructor :: Start ');
         
         con = (Contact)controller.getSubject();
     	 
         accountId = ApexPages.currentPage().getParameters().get('accId');  
         accName = ApexPages.currentPage().getParameters().get('accName');  
         accLicense = ApexPages.currentPage().getParameters().get('license');
         
         nextPage = new pagereference('/apex/DDOBCreatePartnerAdminUser');
         retURL = '/apex/DDOBcreatePartnerContact?accId='+accountId+'&accName='+accName+'&license='+accLicense;
         showPreviousButton = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showPreviousButton'));       
         
         system.debug('DDOBPartnerContactCreateExtension :: Constructor :: End ');
     }

    /**
	  * Action method to save the contact and redirects user to next page
	  * Display error on the page if there are any
	  * sets the return url
	  */
    public pagereference saveandnext(){ 
        system.debug('DDOBPartnerContactCreateExtension :: saveandnext :: Start ');
        Id recTypeId;
        /*Contact conNew = new Contact();
        conNew.Salutation = con.Salutation;
        conNew.firstname = con.firstname;
        conNew.lastname = con.lastname;
        conNew.email = con.email;
        conNew.AccountId = ApexPages.currentPage().getParameters().get('accId'); 
        accName = ApexPages.currentPage().getParameters().get('accName');  
        accLicense = ApexPages.currentPage().getParameters().get('license');*/
        try{
            List<RecordType__c> rcTypeList = RecordType__c.getall().values();
            for(RecordType__c rcTypeVal : rcTypeList){
                if(rcTypeVal.Name.equals('Due Diligence Portal Contact')){
                    recTypeId = rcTypeVal.Value__c;
                }
            }
            //con.AccountId = ApexPages.currentPage().getParameters().get('accId'); 
            con.AccountId = accountId;
            con.RecordTypeId = recTypeId;
            upsert con;                        
            //nextPage = new pagereference('/apex/DDOBCreatePartnerAdminUser'+'+''&accName='+accName+'&license='+accLicense);
            nextPage.getParameters().put('conSalutation',con.Salutation);
            nextPage.getParameters().put('conFirstName',con.firstname);
            nextPage.getParameters().put('conLastName',con.lastname);
            nextPage.getParameters().put('conEmail',con.email);
            nextPage.getParameters().put('contactId',con.Id);
            nextPage.getParameters().put('accId',accountId);
            nextPage.getParameters().put('accName',accName);
            nextPage.getParameters().put('license',accLicense);
            nextPage.getParameters().put('showPreviousButton','true');
            retURL = retURL+'&Id='+con.id;
            nextPage.getParameters().put('retURL',retURL);
        	system.debug('nextPage :: '+nextPage);
            nextPage.setRedirect(true);                      
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to insert Partner Contact'));            
        } 
		system.debug('DDOBPartnerContactCreateExtension :: saveandnext :: End ');        
        return nextPage;
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