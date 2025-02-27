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

 Code purpose  : Update Proxysalesinvoice on update of relevant fields on Billing event


 Birthday      : 15/05/2014
 Api version   : v30

 ****************************************************************************************************************************/

public class DDBillingEventTriggerHandler{

    /** 
        after update on Billing Event
        this method updates proxyinvoice on the basis of relevant fields update on Billing event
    */
    public void afterUpdate(List<pse__Billing_Event__c> newBillingEventList, Map<Id, pse__Billing_Event__c> oldMap, Map<Id, pse__Billing_Event__c> newMap){
        
        system.debug('DDBillingEventTriggerHandler :: afterUpdate ::  start');
        List<Id> billingEventIdList = new List<Id>();
        List<DDSalesInvoiceProxy__c> allSalesInvoiceProxyList = new List<DDSalesInvoiceProxy__c>();
        for(pse__Billing_Event__c newBillingEventVal : newBillingEventList){
            billingEventIdList.add(newBillingEventVal.Id);
        }    
        List<pse__Billing_Event__c> queriedBillingEventList = [Select Id, pse__Date__c, pse__Project__r.ffps_0387__Client_Contact__r.Name, pse__Project__r.ffps_0387__Subject_s__c,
                                                                pse__Project__r.ffps_0387__Country_ies__c, pse__Project__r.ffps_0387__Project_Code__c,   
                                                                 (Select Id, Client_Contact__c, Subject__c, Project_Code__c, Country_ies__c From DDSalesInvoiceProxy__r) 
                                                                 from pse__Billing_Event__c where Id in: billingEventIdList];
                                        
        for(pse__Billing_Event__c queriedBillingEventVal : queriedBillingEventList){
            if(oldMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Client_Contact__r.Name!=newMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Client_Contact__r.Name
                || oldMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Subject_s__c!=newMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Subject_s__c
                || oldMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Country_ies__c!=newMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Country_ies__c
                || oldMap.get(queriedBillingEventVal.Id).pse__Date__c!=newMap.get(queriedBillingEventVal.Id).pse__Date__c 
                || oldMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Project_Code__c!=newMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Project_Code__c){
                List<DDSalesInvoiceProxy__c> salesInvoiceProxyList = queriedBillingEventVal.DDSalesInvoiceProxy__r;
                for(DDSalesInvoiceProxy__c salesInvoiceProxyVal : salesInvoiceProxyList){
                    salesInvoiceProxyVal.Client_Contact__c = newMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Client_Contact__r.Name;
                    salesInvoiceProxyVal.Subject__c = newMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Subject_s__c;
                    salesInvoiceProxyVal.Project_Code__c = newMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Country_ies__c;
                    salesInvoiceProxyVal.Country_ies__c  = newMap.get(queriedBillingEventVal.Id).pse__Project__r.ffps_0387__Project_Code__c;                    
                }
                allSalesInvoiceProxyList.addAll(salesInvoiceProxyList);
            }
        }
        if(allSalesInvoiceProxyList.size()>0){
            update allSalesInvoiceProxyList;
        }                               
        system.debug('DDBillingEventTriggerHandler :: afterUpdate ::  end');
    }
}