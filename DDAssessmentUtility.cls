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

 Code purpose  : a. Changes owner of assessment to logged user on click of assign button
                 

 Birthday      : 15/12/2014
 Api version   : v32

 ****************************************************************************************************************************/
 
public  class DDAssessmentUtility{
    
private ApexPages.StandardController StdController {get;set;}

    /**
        1 arg Constructor
        This consctructor fetches the current Assessment from the page
    */
    public DDAssessmentUtility(ApexPages.StandardController stdController) {                
        system.debug('DDAssessmentUtility :: DDAssessmentUtility :: start');
        try{
            this.StdController = stdController;                                      
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        system.debug('DDAssessmentUtility :: DDAssessmentUtility :: End');
    }
    
    /**
        Assign assessment to the logged in user
    */
    public PageReference assignAssessment(){   
    
        system.debug('DDAssessmentUtility :: assignAssessment:: start');     
        PageReference pr;
        try{            
            Case cs = [select OwnerId, Status from Case where Id =: StdController.getRecord().Id];
            system.debug('cs before ::'+cs);
            system.debug('UserInfo.getUserId() :: '+UserInfo.getUserId());
            cs.OwnerId = UserInfo.getUserId();
            cs.Assigned_to_User__c = true;
            //cs.Status = 'In Progress';
            update cs; 
            system.debug('cs after::'+cs);
            pr = stdController.view();    
            pr.setRedirect (true);   
        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;            
        }
        system.debug('DDAssessmentUtility :: assignAssessment:: end');  
        return pr;
    }
    
    /**
        Assign assessment to the logged in user
    */
    public PageReference approveIfNotFlagged(){   
    
        system.debug('DDAssessmentUtility :: assignAssessment:: start');     
        PageReference pr;
        try{            
            Case cs = [select OwnerId, Is_Questionnaire_Flagged__c, Status, Control_Measure_Status__c from Case where Id =: StdController.getRecord().Id];
            system.debug('cs before ::'+cs);
            system.debug('UserInfo.getUserId() :: '+UserInfo.getUserId());
            //cs.OwnerId = UserInfo.getUserId(); 
            if(!cs.Is_Questionnaire_Flagged__c 
               && (cs.Status == 'Complete' || cs.Status == 'Ready For Submission' || cs.Status == 'Rejected') 
               && (cs.Control_Measure_Status__c == 'Completed' || cs.Control_Measure_Status__c == ''
                  || cs.Control_Measure_Status__c == null)){
                   cs.Status = 'Approved';
                   update cs; 
                   system.debug('cs after::'+cs);
                   pr = stdController.view();    
                   pr.setRedirect (true);   
               }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.LUMA_Approval_Error_Message));
            }     
        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;            
        }
        system.debug('DDAssessmentUtility :: assignAssessment:: end');  
        return pr;
    }
    
    /**
        Invalidate related counterparty account
    */
    public PageReference invalidateRelatedCounterPartyAccount(){   
    
        system.debug('DDAssessmentUtility :: invalidateRelatedCounterPartyAccount:: start');     
        PageReference pr;
        try{            
            Case cs = [select Account.IsCounterpartyValid__c, Account.Validity__c from Case where Id =: StdController.getRecord().Id];
            
            cs.Account.IsCounterpartyValid__c= false; 
            cs.Account.Validity__c= system.today().addDays(-1);
            update cs.Account; 
            pr = stdController.view();    
            pr.setRedirect (true);   
        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;            
        }
        system.debug('DDAssessmentUtility :: invalidateRelatedCounterPartyAccount:: end');  
        return pr;
    }
    
    /**
        Invalidate counterparty account
    */
    public PageReference invalidateCounterPartyAccountFromAccount(){   
    
        system.debug('DDAccountUtility :: invalidateCounterPartyAccountFromAccount:: start');     
        PageReference pr;
        try{            
            Account acc = [select Id,  (Select Id, Status From Cases),  IsCounterpartyValid__c, Counterparty_progress_status__c,  Validity__c from Account where Id =: StdController.getRecord().Id];
            //if(acc.IsCounterpartyValid__c){
           	List<Case> csList = acc.Cases;
            if(!csList.isEmpty()){
                for(Case csVal : csList){
                    csVal.status = 'Invalid';
                }       
                update csList;
            }
            acc.IsCounterpartyValid__c= false; 
            acc.Validity__c= system.today().addDays(-1);
            acc.Counterparty_progress_status__c = 'Invalid';
            update acc; 
            pr = stdController.view();    
            pr.setRedirect (true);   
            //}
            //else{
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.DD_Account_Invalidate_Error_Message));
                //return null;
            //}
        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;            
        }
        system.debug('DDAccountUtility :: invalidateCounterPartyAccountFromAccount:: end');  
        return pr;
    }
    
    /**
        Discard assessment
    */
    public PageReference discardAssessment(){   
    
        system.debug('DDAssessmentUtility :: discardAssessment:: start');     
        PageReference pr;
        try{            
            Case cs = [select Status from Case where Id =: StdController.getRecord().Id];
            
            cs.Status= 'Discarded'; 
            update cs; 
            pr = stdController.view();    
            pr.setRedirect (true);   
        }catch(Exception e){
            ApexPages.addMessages(e);
            pr = null;            
        }
        system.debug('DDAssessmentUtility :: discardAssessment:: end');  
        return pr;
    }
}