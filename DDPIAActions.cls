/************************************************************************************************************************                                                                                         
 
              ***                                                            ***          *****                          
            ****                                                            *****       *****                            
          ****                                                                         *****                             
    ****************         **********         ****       *****        *****       *****             ************      
       ****             *****                *****       *****       *****       ******         *******                
      ***            ****       ****       *****       *****        ****        *****        ******      *****         
    ****           *****       ****       *****       *****       *****       *****        *****        ****           
   ****       ********       ****     *******       *****      ******       ******      *******       *****      ***** 
  *************** ***** *********  **********************************************************************************   
   ********          *****************     *******      ******     ********     *******       *******    *******         
                           ******                                                                                        
                         ******                                                                                          
                        ****                                                                          
                       ***                                                                         SOCIAL | MOBILE | WEB  
  
 
  
Crafted by    : Mayank Sharma
               : msharma@tquila.com 
               : www.tquila.com

 Code purpose  : a. Fetches the correct Instruction
                 b. Submit the instruction created by client
                 c. RAG can accept the instruction

 Birthday      : 13/05/2014
 Api version   : v29

 ****************************************************************************************************************************/
 
public class DDPIAActions {
    
    public DD_Instruction__c Instr {get;set;}
    public DD_Instruction__c TestInstr {get;set;}
    private ApexPages.StandardController StdController {get;set;}
    public Id queueIdTest{get;set;}
    public PageReference pr;
    
    //Constructor
    private DDPIAActions(){}
    
    /**
        1 arg Constructor
        This consctructor fetches the current Instruction from the page
    */
    public DDPIAActions (ApexPages.StandardController stdController) {        
        
        system.debug('DDPIAActions :: DDPIAActions :: start');
        try{
            this.StdController = stdController;            
            Id InstrId = stdController.getRecord().Id;        
            Instr = [Select DD_Check_Level__c, RecordTypeId, Billing_Account__c, Instruction_Category__c, DD_Status__c,
                     Billing_Account__r.Billing_Account_By_Client__c, Billing_Account__r.Notify_teams_of_new_billing_account__c, 
                     OwnerId, DD_Client_Commissioner__r.Account.ParentId, DD_Questionnaire_Response__r.Id, DD_Client_Commissioner__r.AccountId, Id, 
                      (Select Id From DD_Opportunities__r)
                     From DD_Instruction__c where id =:  InstrId];
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        system.debug('DDPIAActions :: DDPIAActions :: End');
    }
        
    /**
        Redirect user to Instruction record
    */
    public PageReference returnToRecord(){  
          
        system.debug('DDPIAActions :: returnToRecord :: start');
        PageReference pr = null;        
        try{
            pr = stdController.view();    
            pr.setRedirect (true);        
        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;            
        }
        system.debug('DDPIAActions :: returnToRecord :: End');
        return pr;
        
    }  
    
    /**
        Submit Instruction RAG and then share the Instruction back to Client
    */
    public PageReference submitToRag(){   
    
        system.debug('DDPIAActions :: submitToRag :: start');     
        PageReference pr = null;
        List<QueueSobject> queueList;
        String ownerId;
        String accountTeamGroupId;
        String recordSharingRoleId;
        try{
            
            List<DGL__c> accountGroupList = DGL__c.getall().values();
            if(Test.isRunningTest()){
                DD_Instruction__c InstrTemp = TestInstr;
                Instr = [select Id, DD_Check_Level__c, Billing_Account__c, Instruction_Category__c, DD_Status__c,
                         Billing_Account__r.Billing_Account_By_Client__c, Billing_Account__r.Notify_teams_of_new_billing_account__c, 
                         DD_Client_Commissioner__c, DD_Questionnaire_Response__r.Id, 
                         DD_Client_Commissioner__r.Account.ParentId, DD_Client_Commissioner__r.AccountId,
                         (Select Id From DD_Opportunities__r)
                         from DD_Instruction__c where Id =: InstrTemp.Id];
            }
            
            system.debug('Instr :: '+Instr);
            system.debug('Instr.Billing_Account__r.Notify_teams_of_new_billing_account__c :: '+Instr.Billing_Account__r.Notify_teams_of_new_billing_account__c);
            system.debug('Instr.Billing_Account__r.Billing_Account_By_Client__c :: '+Instr.Billing_Account__r.Billing_Account_By_Client__c);
			if(Instr.Instruction_Category__c =='Admin' || Instr.Billing_Account__c != null){
	            for(DGL__c accountGroupVal : accountGroupList){
	                if(accountGroupVal.Account__c.equals(String.valueOf(Instr.DD_Client_Commissioner__r.AccountId).subString(0,15)+'__RA_ACCOUNT_TEAM_QUE')){
	                    ownerId = accountGroupVal.Group__c;	
	                }
	                if(accountGroupVal.Account__c.equals(String.valueOf(Instr.DD_Client_Commissioner__r.AccountId).subString(0,15)+'__CL_PARTNER_USER_ROLE')){
	                    recordSharingRoleId = accountGroupVal.Group__c;			
	                }
	                if(accountGroupVal.Account__c.equals(String.valueOf(Instr.DD_Client_Commissioner__r.AccountId).subString(0,15)+'__CL_ACCOUNT_TEAM_GROUP')){
	                    accountTeamGroupId = accountGroupVal.Group__c;	
	                }
	            }
	            system.debug('ownerId  :: '+ownerId );
	            system.debug('accountTeamGroupId  :: '+accountTeamGroupId );
	            if(ownerId!=null){
	                Instr.ownerId = ownerId;
	            }
                if(Instr.Billing_Account__r.Billing_Account_By_Client__c && !Instr.Billing_Account__r.Notify_teams_of_new_billing_account__c){
                    Instr.Billing_Account__r.Notify_teams_of_new_billing_account__c = true;
                }
	            Instr.DD_Status__c = 'Submitted';
	            if(Instr.Instruction_Category__c =='Admin' || (Instr.DD_Check_Level__c != null && Instr.DD_Check_Level__c != '')){
	                update Instr;   
                    update Instr.Billing_Account__r;
	                DD_Instruction__Share shr = new DD_Instruction__Share(UserOrGroupId=recordSharingRoleId, ParentId = Instr.id, AccessLevel = 'edit');                          
	                insert shr;
	                system.debug('Instr.DD_Questionnaire_Response__r.Id :: '+Instr.DD_Questionnaire_Response__r.Id);
	                system.debug('accountTeamGroupId :: '+accountTeamGroupId);
	                
	                if(Instr.DD_Questionnaire_Response__r.Id != null){
	                    try{
	                        dd_Questionnaire_Response__Share shr1 = new dd_Questionnaire_Response__Share(UserOrGroupId=accountTeamGroupId, ParentId = Instr.DD_Questionnaire_Response__r.Id, AccessLevel = 'read');                    
	                        insert shr1;
	                    }catch(exception ex){
	                        system.debug('Exception :: '+ex.getMessage());
	                    }
	                }
                    /*if(Instr.DD_Opportunities__r != null && Instr.DD_Opportunities__r.size() > 0){
                        updateOpportunity(Instr);
                    }*/
	                pr = stdController.view();    
	                pr.setRedirect (true);
	            }
	            else{
	                Instr.addError('You have not chosen check level');
	            }
			}
        else{
            Instr.addError('Billing Account is mandatory');
        }
            
        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;            
        }
        system.debug('DDPIAActions :: submitToRag :: end');  
        return pr;
    }
    
    /**
        Cancel Instruction and assign Instruction back to client
    */
    public PageReference cancelInstruction(){   
        system.debug('DDPIAActions :: cancelInstruction :: start');     
        PageReference pr = null;        
        try{                        
            system.debug('Instr :: '+Instr);                        
            //Instr.ownerId = Userinfo.getUserId();
            if(DDUtility.checkStatus(Instr)){      
                Instr.DD_Status__c = 'Cancelled';
                update Instr; 
                pr = stdController.view();    
            }
            else{
                Instr.addError('Can not Amend/Cancel this Instruction');
            }

        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;            
        }
        system.debug('DDPIAActions :: cancelInstruction :: end');  
        return pr;
    }
    
    /**
        Amend Instruction and assign Instruction back to client
    */
    public PageReference amendInstruction(){   
        system.debug('DDPIAActions :: amendInstruction :: start');     
        PageReference pr = null;        
        try{                        
            system.debug('Instr :: '+Instr);                        
            if(DDUtility.checkStatus(Instr)){                         
            	Instr.ownerId = Userinfo.getUserId();
            	Instr.DD_Status__c = 'Amend';
            	update Instr; 
            	pr = stdController.view();    
            }
            else{
                Instr.addError('Can not Amend/Cancel this Instruction');
            }
        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;            
        }
        system.debug('DDPIAActions :: amendInstruction :: end');  
        return pr;
    }
   
    /**
        RAG can accespt the Instrcution and on acceptance creates the Opportunity
    */
    public PageReference accept(){
        
        system.debug('DDPIAActions :: accept :: start');          
        String recordSharingRoleId;
        List<DGL__c> accountGroupList = DGL__c.getall().values();
        for(DGL__c accountGroupVal : accountGroupList){
            if(accountGroupVal.Account__c.equals(String.valueOf(Instr.DD_Client_Commissioner__r.AccountId).subString(0,15)+'__CL_PARTNER_USER_ROLE')){
                recordSharingRoleId = accountGroupVal.Group__c;
            }
        }
                
        try{
            
            //Instr.ownerId = UserInfo.getUserId();            
            DD_Instruction__Share shr = new DD_Instruction__Share(UserOrGroupId=recordSharingRoleId, ParentId = Instr.id, AccessLevel = 'edit');            
            insert shr;
            updateOpportunity(Instr);
                  
        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;
            
        }
        system.debug('DDPIAActions :: accept :: end');  
        return pr;
    }
    
    public void updateOpportunity(DD_Instruction__c Instr){
        
        Opportunity opp;
        List<DD_Instruction__c> instList = [Select Id, DD_Start_Date__c, DD_Agreed_Budget__c, Billing_Account__c, DD_Task_Order_Required__c, (select Id from DD_Opportunities__r), DDPhone__c
                                                    , DD_Client_Commissioner__r.Name, Name, DD_Client_Commissioner__r.AccountId, DD_Price_Formula__c, Currency_on_Acceptance__c
                                                    , CreatedBy.ContactId, DD_Date_of_Birth_Incorporation__c, DD_Nationality_Country_of_Registration__c,
                                                DD_Expenses__c, DD_Expenses_Cap__c, DD_Timescale_working_days__c,
                                                    DD_Main_Countries_of_Operation__c, DD_Specific_Instructions__c , DD_Address__c, DD_Type__c, DD_Desired_Delivery_Date__c , 
                                                    DD_Other_Information__c, DD_Additional_Subjects__c, DD_Check_Level__c From DD_Instruction__c where Id =: Instr.id];
            
        if(instList!=null && instList.size()>0){
            if((instList.get(0).DD_Opportunities__r == null || instList.get(0).DD_Opportunities__r.size()==0)){
                opp = new Opportunity();
            }
            /*else{                        
                instList.get(0).addError('Instruction has been accepted but you can have only 1 opportunity with an Instruction');
            }*/
            else{
                opp = instList.get(0).DD_Opportunities__r.get(0);                    
            }
                opp.AccountId =  instList.get(0).Billing_Account__c; //instList.get(0).DD_Client_Commissioner__r.AccountId;
                opp.DD_Check_Level__c = instList.get(0).DD_Check_Level__c;
                opp.DDPortal__c = true;
                opp.Type = instList.get(0).DD_Type__c;
                opp.Name = instList.get(0).Name;
                opp.Amount = instList.get(0).DD_Agreed_Budget__c;
                opp.DD_Expenses__c = instList.get(0).DD_Expenses__c;
                opp.Expenses_Cap__c = instList.get(0).DD_Expenses_Cap__c;
                opp.Timescale_working_days__c = instList.get(0).DD_Timescale_working_days__c;
                opp.description = 'Generated from LUMA platform. Subject : '+instList.get(0).Name;
                //opp.Primary_client_contact__c = instList.get(0).CreatedBy.ContactId;
                if(!instList.get(0).DD_Task_Order_Required__c){
                    opp.Amount = instList.get(0).DD_Price_Formula__c;
                    opp.StageName = 'Proposal Sent / Price Quoted';
                }
                else{
                    opp.StageName = 'Proposal Preparation';
                }
                opp.DD_Task_Order_Required__c = instList.get(0).DD_Task_Order_Required__c;
                opp.DD_Instruction__c = instList.get(0).Id;
                opp.CloseDate = System.today().addMonths(2);
                opp.DD_Desired_Delivery_Date__c = instList.get(0).DD_Desired_Delivery_Date__c;
                opp.DD_Other_Information__c = instList.get(0).DD_Other_Information__c;
                opp.DD_Standard_Price__c = instList.get(0).DD_Price_Formula__c;
                opp.DD_Date_of_Birth_Incorporation__c = instList.get(0).DD_Date_of_Birth_Incorporation__c;
                opp.Country_of_Registration_Nationality__c = instList.get(0).DD_Nationality_Country_of_Registration__c ;
                opp.DD_Address__c = instList.get(0).DD_Address__c;
                opp.DD_Additional_Subjects__c = instList.get(0).DD_Additional_Subjects__c;
                opp.DD_Specific_Instructions__c = instList.get(0).DD_Specific_Instructions__c;
                opp.DD_Client_Commissioner__c = instList.get(0).DD_Client_Commissioner__r.Name;
                opp.DD_Primary_Subject__c = instList.get(0).Name;
                opp.DD_Address__c= instList.get(0).DD_Address__c;
                opp.DDPhone__c= instList.get(0).DDPhone__c;
                opp.CurrencyIsoCode = instList.get(0).currencyISOCode;
                upsert opp;
                Instr.Worked_By__c = UserInfo.getUserId();
                Instr.DD_Status__c = 'Accepted';
                Instr.DD_Client_Account_Team_Member__c = UserInfo.getUserId();
                Instr.DD_Start_Date__c = system.today();
                Instr.Currency_on_Acceptance__c = instList.get(0).currencyISOCode;
                update Instr;
	            pr = new Pagereference(Label.DDAcceptRedirect1+opp.id+Label.DDAcceptRedirect2);    
                pr.setRedirect(true);                               
            }                       
            system.debug(pr);  
    }
}