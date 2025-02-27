/**
This controller is proving dynamic behaviour to the page if a new client or an existing client is onboarded
*/

public with sharing class DDOnboardingWelcomeController {
    
    public boolean dispTextBox {get;set;}
    public String functionalAccount {get;set;}
    public pagereference pgRef;
    
	// Controller constructor
    public DDOnboardingWelcomeController(){
        system.debug('DDOnboardingWelcomeController :: Constructor :: start ');
        dispTextBox = false;
        functionalAccount = null;
        system.debug('DDOnboardingWelcomeController :: Constructor :: end ');
    }
	
    /**
     * Action Method to dynamically display textbox to enter Account Id if 
     * an existing account is to be onboarded
     */ 
    public pagereference dispText(){
        system.debug('DDOnboardingWelcomeController :: dispText :: start ');
        if(dispTextBox){
        	dispTextBox = true;
            functionalAccount = 'Parent Account ID';
        }
        else{
            dispTextBox = false;
            functionalAccount = null;
        }
        system.debug('dispTextBox :: '+dispTextBox);
        system.debug('DDOnboardingWelcomeController :: dispText :: end ');
        return null;
    }
    
    /**
     * Action method to redirect user to the Account create/update page
     * 1. Checks the validity if its an existing account
     */
    public pagereference nextPage(){ 
        system.debug('DDOnboardingWelcomeController :: nextPage :: start ');        
        List<Account> acc;
        if(functionalAccount == null){
            pgRef = new pagereference('/apex/DDOnboardingFunctionalAccountCreate?showPreviousButton=true&retURL=/apex/DDOnboardingWelcome');
            pgRef.setRedirect(true);
        } 
        else{
            acc = [select Id from Account where Id =: functionalAccount];
            if(acc !=null && acc.size()>0 &&  acc.get(0) != null){
                pgRef = new pagereference('/apex/DDOnboardingFunctionalAccountCreate?showPreviousButton=true&retURL=/apex/DDOnboardingWelcome'+'&BillingAccountId='+acc.get(0).Id);
            	pgRef.setRedirect(true);
            }
            else{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a valid account'));                
            }             
        }
        system.debug('DDOnboardingWelcomeController :: nextPage :: end ');
        return pgRef;
    }
}