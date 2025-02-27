public with sharing class SCPayableInvoiceTriggerHandler {
    
    public void beforeInsertOrUpdate(List<Proxy_Payable_Invoice__c> newList, Map<Id, Proxy_Payable_Invoice__c> newMap, List<Proxy_Payable_Invoice__c> oldList, Map<Id, Proxy_Payable_Invoice__c> oldMap){
    	
        Set<Id> engagementIdSet = new Set<Id>();
        Map<Id, String> engagementId_Region_Map = new Map<Id, String>();
        
        for(Proxy_Payable_Invoice__c val : newList){
            engagementIdSet.add(val.Subcontractor_Engagement__c);
        }         
        List<SubcontractorEngagement__c> engagementList = [Select Id, Project__c, Project__r.pse__Region__r.name, Project__r.pse__Region__r.ffpsai__OwnerCompany__r.Name, 
                                                           Name From SubcontractorEngagement__c where Id in: engagementIdSet];
        system.debug('engagementList :: '+engagementList);
        
        for(SubcontractorEngagement__c engagementVal : engagementList){
            if(engagementVal.Project__r.pse__Region__r!=null && !String.isEmpty(engagementVal.Project__r.pse__Region__r.ffpsai__OwnerCompany__c)
              && !String.isEmpty(engagementVal.Project__r.pse__Region__r.ffpsai__OwnerCompany__r.Name) )
            engagementId_Region_Map.put(engagementVal.Id, engagementVal.Project__r.pse__Region__r.ffpsai__OwnerCompany__r.Name);
        }
        system.debug('engagementId_Region_Map :: '+engagementId_Region_Map);
        
        for(Proxy_Payable_Invoice__c newVal : newList){
            newVal.Invoice_Entity__C = engagementId_Region_Map.get(newVal.Subcontractor_Engagement__c);
        }        
    }
}