/**
This standard controller
1. creates or update control measure type
2. redirects user to the next page to create instruction check level
*/

public with sharing class DDOBCreateControlMeasureExtension {
	public Integer count = 1;
    public String selectedRowIndex{get;set;}
    public List<innerClass> lstInner {get;set;}
    public List<Control_Measure_Type__c> cmTypeList;
    public boolean requiredFieldMissing {public get; public set;}
    public static Control_Measure_Type__c cmTypeGlobal;
    public String accId {get;set;}
    String accName;
    public pagereference prevPage {get;set;}
    public List<Control_Measure_Type__c> cmTypeToDeleteList;
    public String retURL;
    public PageReference pr;
    public boolean showPreviousButton {get;set;}
    
    	/**
          * Standard Controller constructor
          * 1. Fetches URL parameters 
          * 2. controls the behaviour of back button display 	
          * 3. Determines the return URL
          * 4. pre-populates existing control measure types of an existing Account
        */    
        public DDOBCreateControlMeasureExtension(ApexPages.StandardController ctlr){  
            system.debug('DDOBCreateControlMeasureExtension :: Constructor :: start ');
            Integer recCount=1; 
            List<Account> accList;
            accId = ApexPages.currentPage().getParameters().get('accId');  
            accName = ApexPages.currentPage().getParameters().get('accName'); 
            showPreviousButton = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showPreviousButton'));              
            
            accList = [Select (Select Id, Name, CurrencyIsoCode, DDAccount__c, Type__c From Control_Measure_Types__r) 
                                     From Account a where Id =: accId];
            if(accList!=null && accList.size()>0){
                cmTypeList = accList.get(0).Control_Measure_Types__r;
            }
            if(cmTypeList!=null && cmTypeList.size()>0){       
                lstInner = new List<innerClass>();
                for(Control_Measure_Type__c cmTypeVal : cmTypeList){
                    innerClass iclass = new innerClass();
                    iclass.cmType = cmTypeVal;
                    iclass.recCount = recCount;
                    lstInner.add(iclass);   
                    recCount++;
                } 
                count = cmTypeList.size();                
            }
            else{
                lstInner = new List<innerClass>();
                addMore();  
            }    
            retURL = '/apex/DDOBControlMeasureCreate?accName='+accName+'&accId='+accId;
            pr = new PageReference('/apex/DDOBInstructionCheckCreate');
            system.debug('DDOBCreateControlMeasureExtension :: Constructor :: end ');
        }
    
    	// action method to add rows when add button is clicked on the page
        public void Add(){      
            system.debug('DDOBCreateControlMeasureExtension :: Add :: start ');
            count = count+1;
            addMore();   
            system.debug('DDOBCreateControlMeasureExtension :: Add :: end ');               
        }
        
        // Method to increment the count of control measure type rows
        public void addMore(){
            system.debug('DDOBCreateControlMeasureExtension :: addMore :: start ');
            innerClass objInnerClass = new innerClass(count, accId);
            lstInner.add(objInnerClass);    
            system.debug('DDOBCreateControlMeasureExtension :: addMore :: end ');      
        }
    
        // Method to remove the count of control measure type rows
        public void Del(){
            system.debug('DDOBCreateControlMeasureExtension :: Del :: start ');    
            cmTypeToDeleteList = new List<Control_Measure_Type__c>();
            cmTypeToDeleteList.add(lstInner.get(Integer.valueOf(selectedRowIndex)-1).cmType);
            lstInner.remove(Integer.valueOf(selectedRowIndex)-1);
            count = count - 1;
            system.debug('DDOBCreateControlMeasureExtension :: Del :: end ');        
        }
    
    	// Method to Save all control measure type and is invoked when user click on Save button on the page
        public PageReference Save(){
            system.debug('DDOBCreateControlMeasureExtension :: Save :: Start ');    
            //accId = ApexPages.currentPage().getParameters().get('accId');  
            //accName = ApexPages.currentPage().getParameters().get('accName'); 
            this.requiredFieldMissing = false;
            cmTypeList  = new List<Control_Measure_Type__c>();
            for(Integer j = 0;j<lstInner.size();j++){
                if(lstInner[j]!=null && lstInner[j].cmType!=null && lstInner[j].cmType.Name!=null && lstInner[j].cmType.Type__c!=null){
                            cmTypeList.add(lstInner[j].cmType);
                }
                else{
                    this.requiredFieldMissing = true;
                    break;
                }
            } 
            try{
                if(!this.requiredFieldMissing){
                    system.debug('cmTypeList :: '+cmTypeList);
                    upsert cmTypeList;
                    if(cmTypeToDeleteList!=null && cmTypeToDeleteList.size()>0){
                        delete cmTypeToDeleteList;
                    }
                    //String retURL = '/apex/DDOBControlMeasureCreate?accName='+accName+'&accId='+accId;
                    //PageReference pr = new PageReference('/apex/DDOBInstructionCheckCreate?accId='+accId+'&accName='+accName);
                    pr.getParameters().put('accId',accId);
                    pr.getParameters().put('accName',accName);
                    pr.getParameters().put('showPreviousButton','true');
                    pr.getParameters().put('retURL',retURL);
                    pr.setRedirect(True);
                    return pr;
                }
            }
            catch(Exception ex){
                    new Control_Measure_Type__c().addError('Error creating control measure type');
            }
            system.debug('DDOBCreateControlMeasureExtension :: Save :: end ');  
            return null;
        }
    
    	// Inner class to bound data between visualforce and the controller
        public class innerClass{                
            /*recCount acts as a index for a row. This will be helpful to identify the row to be deleted */
            public Integer recCount{get;set;}
            public Control_Measure_Type__c cmType {get;set;}
            public innerClass(){}
            public innerClass(Integer intCount, Id accId){
                    recCount = intCount;            
                    system.debug('recCount n inner class '+recCount);
                    if(!Test.isRunningTest()){                        
                        cmType = new Control_Measure_Type__c();
                        cmType.DDAccount__c = accId;
                    }
                    else{
                        cmType = cmTypeGlobal;
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