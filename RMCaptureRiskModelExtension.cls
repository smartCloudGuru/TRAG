public class RMCaptureRiskModelExtension {
    
    public String selectedActivity{get; set;}
    public List<SelectOption> riskModelActivityList{get; set;} 
    public Map<String, Decimal> riskModelActivityName_Score_Map;
    public String selectedCountry{get; set;}
    public List<SelectOption> countryList{get; set;}
    public Map<String, Decimal> countryName_Score_Map;
    public String selectedinteractionList{get; set;}
    public List<SelectOption> govtInteractionList{get; set;} 
    public Map<String, Decimal> govtInteractionName_Score_Map;
    public ApexPages.StandardController controller{get; set;}
    public Account lumaAccount;
    
    public RMCaptureRiskModelExtension(ApexPages.StandardController controller) {
        this.controller = controller;
    	List<User> usrList = [select Id, contact.AccountId from User where Id =: userinfo.getUserId()];
        if(!usrList.isEmpty() && usrList.size() == 1 && usrList.get(0).contact != null && usrList.get(0).contact.AccountId != null){
            lumaAccount = [Select Id, (Select Id, Name, Score__c From Risk_Model_Government_Interaction__r), 
                           (Select Id, Name, Score__c From Risk_Model_Country_CPI_Usage__r), 
                           (Select Id, Name, score__c, visible__c From Risk_Model_Parameters__r) From Account a where Id =: usrList.get(0).contact.AccountId];
            system.debug('lumaAccount :: '+lumaAccount);
            if(lumaAccount !=null){
                system.debug('lumaAccount.Risk_Model_Country_CPI_Usage__r :: '+lumaAccount.Risk_Model_Country_CPI_Usage__r);
                if(!lumaAccount.Risk_Model_Parameters__r.isEmpty()){    
                    lumaAccount.Risk_Model_Parameters__r.sort();
                    riskModelActivityName_Score_Map = new Map<String, Decimal>();        
                    riskModelActivityList = new List<SelectOption>();                        
                    for(Risk_Model_Activity_Type__c riskModelActivity : lumaAccount.Risk_Model_Parameters__r){
                        riskModelActivityList.add(new SelectOption(riskModelActivity.name,riskModelActivity.name));       
                        riskModelActivityName_Score_Map.put(riskModelActivity.name, riskModelActivity.score__c);
                    }
                }  
                if(!lumaAccount.Risk_Model_Country_CPI_Usage__r.isEmpty()){    
                    lumaAccount.Risk_Model_Country_CPI_Usage__r.sort();
                    countryName_Score_Map = new Map<String, Decimal>();        
                    countryList = new List<SelectOption>();                        
                    for(Risk_Model_Country_CPI_Usage__c countryVal : lumaAccount.Risk_Model_Country_CPI_Usage__r){
                        countryList.add(new SelectOption(countryVal.name,countryVal.name));    
                        countryName_Score_Map.put(countryVal.name, countryVal.score__c);
                    }
                }
                if(!lumaAccount.Risk_Model_Government_Interaction__r.isEmpty()){    
                    lumaAccount.Risk_Model_Government_Interaction__r.sort();
                    govtInteractionName_Score_Map = new Map<String, Decimal>();
                    govtInteractionList = new List<SelectOption>();                        
                    for(Risk_Model_Government_Interaction__c govtInteraction : lumaAccount.Risk_Model_Government_Interaction__r){
                        govtInteractionList.add(new SelectOption(govtInteraction.name,govtInteraction.name));     
                        govtInteractionName_Score_Map.put(govtInteraction.name, govtInteraction.score__c);
                    }
                }  
            }
            system.debug('riskModelActivityName_Score_Map :: '+riskModelActivityName_Score_Map);
            system.debug('countryName_Score_Map :: '+countryName_Score_Map);
            system.debug('govtInteractionName_Score_Map :: '+govtInteractionName_Score_Map);
            riskModelActivityList.sort();
            countryList.sort();
            govtInteractionList.sort();
            system.debug('countryList :: '+countryList);
        }
    } 
    
    public pagereference save(){
        try{
            
        controller.save();        
            system.debug('riskModelActivityName_Score_Map.get(selectedActivity) save :: '+riskModelActivityName_Score_Map.get(selectedActivity));
            system.debug('countryName_Score_Map.get(selectedCountry) save :: '+countryName_Score_Map.get(selectedCountry));
            system.debug('govtInteractionName_Score_Map.get(selectedinteractionList) save :: '+govtInteractionName_Score_Map.get(selectedinteractionList));
        Account acc = [select Id, Risk_Model_1_Output__c from Account where Id =: controller.getId()];
            acc.Risk_Model_1_Output__c = (0.35 * riskModelActivityName_Score_Map.get(selectedActivity)) 
                + (0.40 * govtInteractionName_Score_Map.get(selectedinteractionList))
                + (0.25 * countryName_Score_Map.get(selectedCountry));
            update acc;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to save : '+ex.getMessage())); 
        }
        return controller.view();                
    }
}