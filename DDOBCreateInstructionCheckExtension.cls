/**
This standard controller
1. creates or update instruction check level type
2. redirects user to the next page to groups and queues
*/

public with sharing class DDOBCreateInstructionCheckExtension {
    
    public Integer count = 1;
    public String selectedRowIndex{get;set;}
    public List<innerClass> lstInner {get;set;}
    public List<Instruction_Check_Level_Type__c> iclTypeList;
    public boolean requiredFieldMissing {public get; public set;}
    public static Instruction_Check_Level_Type__c iclTypeGlobal;
    public String accId;
    public String accName;
    public pagereference prevPage {get;set;}    
    public List<Instruction_Check_Level_Type__c> iclTypeToDeleteList;
    public String retURL;
    public pagereference pr;
    public boolean showPreviousButton {get;set;}
    
        /**
          * Standard Controller constructor
          * 1. Fetches URL parameters 
          * 2. controls the behaviour of back button display 	
          * 3. Determines the return URL
          * 4. pre-populates existing instruction check level types of an existing Account
        */   
        public DDOBCreateInstructionCheckExtension(ApexPages.StandardController ctlr){ 
            system.debug('DDOBCreateInstructionCheckExtension :: constructor :: start ');
            Integer recCount=1;     
            List<Account> accList;
            
            accId = ApexPages.currentPage().getParameters().get('accId');  
            accName = ApexPages.currentPage().getParameters().get('accName');  
            showPreviousButton = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showPreviousButton'));    
            
            accList = [Select Id, (Select Id, Name, CurrencyIsoCode, Account__c, DDPrice__c, Expense__c, Expense_Cap__c, Timescale__c 
                                   From Instruction_Check_Level_Types__r) From Account a where Id =: accId];
            if(accList!=null && accList.size()>0){
                iclTypeList = accList.get(0).Instruction_Check_Level_Types__r;
            }
            if(iclTypeList!=null && iclTypeList.size()>0){       
                lstInner = new List<innerClass>();
                for(Instruction_Check_Level_Type__c iclVal : iclTypeList){
                    innerClass iclass = new innerClass();
                    iclass.iclType = iclVal;
                    iclass.recCount = recCount;
                    lstInner.add(iclass);   
                    recCount++;
                } 
                count = iclTypeList.size();                
            }
            else{
                lstInner = new List<innerClass>();
                addMore();  
            }    
            retURL = '/apex/DDOBInstructionCheckCreate?accName='+accName+'&accId='+accId;
            pr = new PageReference('/apex/DDOBBackgroundParameterCreate');
            system.debug('DDOBCreateInstructionCheckExtension :: constructor :: end ');
        }
    
    	// action method to add rows when add button is clicked on the page
        public void Add(){    
            system.debug('DDOBCreateInstructionCheckExtension :: Add :: start ');
            count = count+1;
            addMore();   
            system.debug('DDOBCreateInstructionCheckExtension :: Add :: end ');
        }
        
    	// Method to increment the count of instruction check level type rows
        public void addMore(){
            system.debug('DDOBCreateInstructionCheckExtension :: addMore :: start ');
            innerClass objInnerClass = new innerClass(count, accId);
            lstInner.add(objInnerClass);    
            system.debug('DDOBCreateInstructionCheckExtension :: addMore :: end ');         
        }
    	
    	// Method to remove the count of instruction check level type rows
        public void Del(){
            system.debug('DDOBCreateInstructionCheckExtension :: Del :: start ');
            iclTypeToDeleteList = new List<Instruction_Check_Level_Type__c>();            
            iclTypeToDeleteList.add(lstInner.get(Integer.valueOf(selectedRowIndex)-1).iclType);
            lstInner.remove(Integer.valueOf(selectedRowIndex)-1);
            count = count - 1;
            system.debug('DDOBCreateInstructionCheckExtension :: Del :: end ');    
        }
    	
    	// Method to Save all instruction check level type and is invoked when user click on Save button on the page
        public PageReference Save(){
            system.debug('DDOBCreateInstructionCheckExtension :: Del :: Save ');
            this.requiredFieldMissing = false;            
            iclTypeList  = new List<Instruction_Check_Level_Type__c>();
            system.debug('lstInner :: '+lstInner);
            for(Integer j = 0;j<lstInner.size();j++){
                if(lstInner[j]!=null && lstInner[j].iclType!=null && lstInner[j].iclType.Name!=null){
                    iclTypeList.add(lstInner[j].iclType);
                }
                else{
                    this.requiredFieldMissing = true;
                    break;
                }
            } 
            try{
                if(!this.requiredFieldMissing){
                    system.debug('iclTypeList :: '+iclTypeList);
                    upsert iclTypeList;
                    system.debug('iclTypeToDeleteList :: '+iclTypeToDeleteList);
                    if(iclTypeToDeleteList!=null && iclTypeToDeleteList.size()>0){
                        List<Instruction_Check_Level_Type__c> iclTypeToDeleteList_DB = [select Id from Instruction_Check_Level_Type__c where Id in: iclTypeToDeleteList];
                        if(iclTypeToDeleteList_DB != null  && iclTypeToDeleteList_DB.size() >0){
                            delete iclTypeToDeleteList_DB;
                        }                        
                    }
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
                    new Instruction_Check_Level_Type__c().addError('Error creating Instruction Check Level :: '+ex.getMessage());
            }
            system.debug('DDOBCreateInstructionCheckExtension :: Del :: end ');
            return null;
        }
    
    	// Inner class to bound data between visualforce and the controller
        public class innerClass{                
            /*recCount acts as a index for a row. This will be helpful to identify the row to be deleted */
            public Integer recCount{get;set;}
            public Instruction_Check_Level_Type__c iclType {get;set;}
            public innerClass(){}
            public innerClass(Integer intCount, Id accId1){
                    recCount = intCount;            
                    if(!Test.isRunningTest()){                        
                        iclType = new Instruction_Check_Level_Type__c();
                        iclType.Account__c = accId1;
                    }
                    else{
                        iclType = iclTypeGlobal;
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