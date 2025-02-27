/**
*   From custom button on the Project record ‘Raise Invoice’ to pre-populate 
*   Invoicing_Instructions_1__c on the Raise Invoice record. The field needs to be 
*   pre-populated with data from the Invoicing_Instructions__c on the Account record.
*   @category Bussinese Logic 
*   @author Phanith Chhun
*/
public with sharing class RaiseInvoiceRedirectorController {
    /**
    *   Previous Button URL there is no matching field for Client_ContactId__c
    *   Details Button
    *   /a04/e?CF00N30000004oRME={!Projects__c.Name}&CF00N30000004oRME_lkid={!Projects__c.Id}
    *   &retURL=%2F{!Projects__c.Id}
    *   &CF00N30000004oRM9_lkid={!Projects__c.ClientId__c}&CF00N30000004oRM9={!Projects__c.Client__c}
    *   &00N30000004oUV3={!Projects__c.Budget_number__c}
    *   &00N30000004oZ4f={!Projects__c.Client_Contact__c}&CF00N30000004oRM9_lkid={!Projects__c.ClientId__c}
    *   &CF00N30000004oRM9={!Projects__c.Client__c}
    *   &CF00N30000004oUe1_lkid={!Projects__c.Case_ManagerId__c}&CF00N30000004oUe1={!Projects__c.Case_Manager__c}
    *   &CurrencyIsoCode={!Projects__c.CurrencyIsoCode}
    *   Related List Button
    *   /a04/e?CF00N30000004oRME={!Projects__c.Name}&CF00N30000004oRME_lkid={!Projects__c.Id}
    *   &retURL=%2F{!Projects__c.Id}
    *   &CF00N30000004oRM9_lkid={!Projects__c.ClientId__c}&CF00N30000004oRM9={!Projects__c.Client__c}
    *   &00N30000004oUV3={!Projects__c.Budget_number__c}
    *   &CF00N30000004oUUj_lkid={!Projects__c.Client_ContactId__c}&CF00N30000004oUUj={!Projects__c.Client_Contact__c}
    *   &CF00N30000004oRM9_lkid={!Projects__c.ClientId__c}
    *   &CF00N30000004oRM9={!Projects__c.Client__c}&CF00N30000004oUe1_lkid={!Projects__c.Case_ManagerId__c}
    *   &CF00N30000004oUe1={!Projects__c.Case_Manager__c}
    */
    RaiseInvoiceRedirectorSetting__c setting = RaiseInvoiceRedirectorSetting__c.getInstance('RaiseInvoiceSetting');
    public String urlPage = '/' + setting.Prefix__c + '/e?';
    /**
    *   Constructor added Invoicing_Instructions value 
    */
    public RaiseInvoiceRedirectorController(ApexPages.StandardController controller) {
        Projects__c pro = (Projects__c)controller.getRecord();
        urlPage += setting.Project_CID__c + '=' + getValueNotNull(pro.Name+'');
        urlPage += '&' + setting.Project_CID__c + '_lkid=' + getValueNotNull(pro.Id+'');
        urlPage += '&retURL=%2F' + getValueNotNull(pro.Id+'');
        urlPage += '&' + setting.Client_CID__c + '_lkid=' + getValueNotNull(pro.Client__c+'');
        urlPage += '&' + setting.Client_CID__c + '=' + getValueNotNull(pro.Client__r.Name+'');
        urlPage += '&' + setting.Budget_Number_CID__c + '=' + getValueNotNull(pro.Budget_number__c+'');
        urlPage += '&' + setting.Client_Contact_CID__c + '=' + getValueNotNull(pro.Client_Contact__r.Name+'');
        urlPage += '&' + setting.Case_Manager_CID__c + '_lkid=' + getValueNotNull(pro.Case_Manager__c+'');
        urlPage += '&' + setting.Case_Manager_CID__c + '=' + getValueNotNull(pro.Case_Manager__r.Name+'');
        urlPage += '&' + setting.CurrencyIsoCode_CID__c + '=' + getValueNotNull(pro.CurrencyIsoCode+'');
        urlPage += '&' + setting.Invoicing_Instructions_CID__c + '=' + getValueNotNull(pro.Client__r.Invoicing_Instructions__c+'');
    }
    
    /**
    *   Get value null as empty
    *   @param val String
    */
    private String getValueNotNull(String val){
        return val=='null' ? '': EncodingUtil.urlEncode(val, 'UTF-8');
    }
    
    public String getURLPAGE(){
         return urlPage;
    }
    /**
    *   Redirect to invoice page
    */ 
    public PageReference doRedirect(){
        return new PageReference(urlPage);
    }

}