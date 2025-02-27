public class WLPrimaryRiskModelActions {
    
    public Primary_Risk_Model__c prm {get;set;}
    private ApexPages.StandardController StdController {get;set;}    
    Pagereference pg;
    
    public WLPrimaryRiskModelActions(ApexPages.StandardController stdController){
        try{
            this.StdController = stdController;  
            prm = [select Id, Account__c, Account__r.ParentId, Acting_as_an_agent__c, Account__r.Risk_Model_1_Output__c,
                   Country__c, Counterparty__c,
                   Corruption_Index__c, Freight_Forwarder__c, Government_Official__c, Risk_Model_Score__c
                   from Primary_Risk_Model__c where Id =: stdController.getRecord().Id];
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }        
    }
    
    public Pagereference getPrimaryRiskModelResults(){
        Map<String, Primary_Risk_Model_Custom__c> prmCustomSettingsMap = Primary_Risk_Model_Custom__c.getAll();
        Map<String, WLCountryCPIUsage__c> countryCPIUsageMap = WLCountryCPIUsage__c.getAll();
        Map<String, WLCounterpartytype__c> counterpartyType = WLCounterpartytype__c.getAll();
        Decimal countrycpiscore = 0.0;
        Decimal counterpartyweight = 0.0;
        prm.Risk_Model_Score__c = 0.0;
        try{
            system.debug('prmCustomSettingsMap :: '+prmCustomSettingsMap);
            system.debug('prm.Account__r.ParentId :: '+prm.Account__r.ParentId);
            system.debug('prm :: '+prm);
            for(Primary_Risk_Model_Custom__c prmCustomSettingsVal : prmCustomSettingsMap.values()){
                if(prmCustomSettingsVal.Name == String.valueOf(prm.Account__r.ParentId).subString(0,15)){
                    if(prm.Acting_as_an_agent__c){
                        prm.Risk_Model_Score__c  += prmCustomSettingsMap.get(prmCustomSettingsVal.name).Acting_as_an_agent__c;
                    }
                    if(prm.Corruption_Index__c > 0){
                        system.debug('String.valueOf(prm.Corruption_Index__c) :: '+String.valueOf(prm.Corruption_Index__c));
                        system.debug('WL_Corruption_Index__c.getAll() :: '+WL_Corruption_Index__c.getAll());
                        system.debug('WL_Corruption_Index__c.getAll().get(String.valueOf(prm.Corruption_Index__c)) :: '+WL_Corruption_Index__c.getAll().get(String.valueOf(prm.Corruption_Index__c)));
                        prm.Risk_Model_Score__c  += WL_Corruption_Index__c.getAll().get(String.valueOf(prm.Corruption_Index__c)).Score__c; 
                    }
                    system.debug('String.valueOf(prm.Country__c) :: '+String.valueOf(prm.Country__c));
                    system.debug('prm.Risk_Model_Score__c :: '+prm.Risk_Model_Score__c);
                    if(prm.Country__c != null){                        
                        system.debug('WLCountryCPIUsage__c.getAll() :: '+WLCountryCPIUsage__c.getAll());
                        system.debug('WLCountryCPIUsage__c.getAll().get(String.valueOf(prm.Country__c)) :: '+WLCountryCPIUsage__c.getAll().get(String.valueOf(prm.Country__c)));
                        countrycpiscore  += WLCountryCPIUsage__c.getAll().get(String.valueOf(prm.Country__c)).CPI_Score__c; 
                    }
                    system.debug('String.valueOf(prm.Counterparty__c) :: '+String.valueOf(prm.Counterparty__c));
                    system.debug('prm.Risk_Model_Score__c :: '+prm.Risk_Model_Score__c);
                    if(prm.Counterparty__c != null){                        
                        system.debug('WLCounterpartytype__c.getAll() :: '+WLCounterpartytype__c.getAll());
                        system.debug('WLCounterpartytype__c.getAll().get(String.valueOf(prm.Counterparty__c)) :: '+WLCounterpartytype__c.getAll().get(String.valueOf(prm.Counterparty__c)));
                        counterpartyweight  += WLCounterpartytype__c.getAll().get(String.valueOf(prm.Counterparty__c)).weighting__c; 
                    }
                    
                    if(countrycpiscore > 0 && counterpartyweight > 0.0){
                        prm.Risk_Model_Score__c = prm.Risk_Model_Score__c + (countrycpiscore * counterpartyweight);
                    }
                    
                    if(prm.Freight_Forwarder__c){
                        prm.Risk_Model_Score__c  += prmCustomSettingsMap.get(prmCustomSettingsVal.name).Freight_Forwarder__c;
                    }
                    if(prm.Government_Official__c){
                        prm.Risk_Model_Score__c  += prmCustomSettingsMap.get(prmCustomSettingsVal.name).Government_Official__c;
                    }            
                }           
            }        
            system.debug('prm.Risk_Model_Score__c :: '+prm.Risk_Model_Score__c);
            
            update prm;
            
            prm.Account__r.Risk_Model_1_Output__c = prm.Risk_Model_Score__c;
            update prm.Account__r;
            pg = new Pagereference('/client/'+prm.Id);
            pg.setRedirect(true);   
            return pg;
        }
        catch(exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        return pg;
    }    
}