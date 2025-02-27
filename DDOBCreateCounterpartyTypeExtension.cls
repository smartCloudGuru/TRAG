/**
This standard controller
1. creates or update counterparty type
2. redirects user to the next page to create control measure type
*/

public with sharing class DDOBCreateCounterpartyTypeExtension {
		
    public Integer count = 1;
    public String selectedRowIndex{get;set;}
    public List<innerClass> lstInner {get;set;}
    public List<DD_Counterparty_Type__c> cpTypeList;
    public boolean requiredFieldMissing {public get; public set;}
    public static DD_Counterparty_Type__c cpTypeGlobal;
    public String accId ;
    public String accName;
    public pagereference prevPage {get;set;}
    public List<DD_Counterparty_Type__c> cpTypeToDeleteList;
    public String retURL;
    public PageReference pr;
    public boolean showPreviousButton {get;set;}
    
    	/**
          * Standard Controller constructor
          * 1. Fetches URL parameters 
          * 2. controls the behaviour of back button display 	
          * 3. Determines the return URL
          * 4. pre-populates existing counterparty types of an existing Account
        */  
        public DDOBCreateCounterpartyTypeExtension(ApexPages.StandardController ctlr){        
            system.debug('DDOBCreateCounterpartyTypeExtension :: Constructor :: Start ');
            List<Account> accList;
            Integer recCount=1; 
            
            accId = ApexPages.currentPage().getParameters().get('accId');  
            accName = ApexPages.currentPage().getParameters().get('accName');  
            showPreviousButton = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showPreviousButton'));  
            
            accList = [Select Id, DD_Due_Diligence_Portal_Licence__c,
                       (Select Id, Name, CurrencyIsoCode, Account__c, DD_validity_in_months__c, Questionnaire_Name__c, Questionnaire_URL__c From Counterparty_Types__r) 
                                     from Account a where Id =: accId];
            if(accList!=null && accList.size()>0){
                cpTypeList = accList.get(0).Counterparty_Types__r;
            }
            if(cpTypeList!=null && cpTypeList.size()>0){       
                lstInner = new List<innerClass>();
                for(DD_Counterparty_Type__c cpTypeVal : cpTypeList){
                    innerClass iclass = new innerClass();
                    iclass.cpType = cpTypeVal;
                    iclass.recCount = recCount;
                    lstInner.add(iclass);   
                    recCount++;
                } 
                count = cpTypeList.size();                
            }
            else{
                lstInner = new List<innerClass>();
                addMore();  
            }    
            system.debug('count in constructor :: '+count);       
            
            retURL = '/apex/DDOBCounterpartyTypeCreate?accName='+accName+'&accId='+accId;
            if(!accList.isEmpty() && accList.size() == 1 && accList.get(0).DD_Due_Diligence_Portal_Licence__c.equals('Counterparty Application with Questionnaire')){
                pr = new PageReference('/apex/DDOBBackgroundParameterCreate');
            }
            else{
            	pr = new PageReference('/apex/DDOBControlMeasureCreate');    
            }            
            
            system.debug('DDOBCreateCounterpartyTypeExtension :: Constructor :: End ');
        }
    
        // action method to add rows when add button is clicked on the page
        public void Add(){      
            system.debug('DDOBCreateCounterpartyTypeExtension :: Add :: start ');
            count = count+1;
            addMore();   
            system.debug('DDOBCreateCounterpartyTypeExtension :: Add :: end ');
        }
        
        // Method to increment the count of counterparty type rows
        public void addMore(){
            system.debug('DDOBCreateCounterpartyTypeExtension :: addMore :: start ');
            innerClass objInnerClass = new innerClass(count, accId);
            lstInner.add(objInnerClass);    
            system.debug('DDOBCreateCounterpartyTypeExtension :: addMore :: start ');              
        }
    
        // action method to remove rows when remove button is clicked on the page
        public void Del(){
            system.debug('DDOBCreateCounterpartyTypeExtension :: Del :: start ');
            cpTypeToDeleteList = new List<DD_Counterparty_Type__c>();
            cpTypeToDeleteList.add(lstInner.get(Integer.valueOf(selectedRowIndex)-1).cpType);
            lstInner.remove(Integer.valueOf(selectedRowIndex)-1);
            count = count - 1;
            system.debug('DDOBCreateCounterpartyTypeExtension :: Del :: end ');    
        }
    
    	// Method to Save all counterparty type and is invoked when user click on Save button on the page
        public PageReference Save(){
            system.debug('DDOBCreateCounterpartyTypeExtension :: Save :: start ');   
            //accId = ApexPages.currentPage().getParameters().get('accId');  
            //accName = ApexPages.currentPage().getParameters().get('accName');  
            this.requiredFieldMissing = false;
            cpTypeList  = new List<DD_Counterparty_Type__c>();
            for(Integer j = 0;j<lstInner.size();j++){
                if(lstInner[j]!=null && lstInner[j].cpType!=null && lstInner[j].cpType.Name!=null && lstInner[j].cpType.Questionnaire_Name__c!=null 
                        && lstInner[j].cpType.Questionnaire_URL__c!=null && lstInner[j].cpType.DD_validity_in_months__c!=null){
                            cpTypeList.add(lstInner[j].cpType);
                }
                else{
                    this.requiredFieldMissing = true;
                    break;
                }
            } 
            try{
                if(!this.requiredFieldMissing){
                    system.debug('cpTypeList :: '+cpTypeList);
                    upsert cpTypeList;
                    if(cpTypeToDeleteList!=null && cpTypeToDeleteList.size()>0){
                        delete cpTypeToDeleteList;
                    }
                    //String retURL = '/apex/DDOBCounterpartyTypeCreate?accName='+accName+'&accId='+accId;
                    //PageReference pr = new PageReference('/apex/DDOBControlMeasureCreate?accId='+accId+'&accName='+accName);
                    pr.getParameters().put('accId',accId);
                    pr.getParameters().put('accName',accName);
                    pr.getParameters().put('showPreviousButton','true');
                    pr.getParameters().put('retURL',retURL);
                    system.debug('pr :: '+pr);
                    pr.setRedirect(true);
                    return pr;
                }
            }
            catch(Exception ex){
                    new DD_Counterparty_Type__c().addError('Error creating counterparty type');
            }
            system.debug('DDOBCreateCounterpartyTypeExtension :: Save :: end ');   
            return null;
        }
    
    	// Inner class to bound data between visualforce and the controller
        public class innerClass{             
            /*recCount acts as a index for a row. This will be helpful to identify the row to be deleted */
            public Integer recCount{get;set;}
            public DD_Counterparty_Type__c cpType {get;set;}
            public innerClass(){}
            public innerClass(Integer intCount, Id accId){
                    recCount = intCount;            
                    system.debug('recCount n inner class '+recCount);
                    if(!Test.isRunningTest()){                        
                        cpType = new DD_Counterparty_Type__c();
                        cpType.Account__c = accId;
                    }
                    else{
                        cpType = cpTypeGlobal;
                    }
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