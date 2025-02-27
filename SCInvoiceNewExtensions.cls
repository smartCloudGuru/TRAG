public class SCInvoiceNewExtensions {
    
    public String invCurrency {get;set;}
    public SubcontractorEngagement__c SCEng {get;set;}
    public Proxy_Payable_Invoice__c prInvoice;
    public Pagereference pg;
    
    public SCInvoiceNewExtensions (ApexPages.StandardController stdController) {  
        String engId = System.currentPageReference().getParameters().get(Label.SC_Engagement_Id_from_URL);
        system.debug('engId :: '+engId);
        SCEng = [Select Id, CurrencyIsocode from SubcontractorEngagement__c  where id =:  engId];
        system.debug('SCEng :: '+SCEng);
        invCurrency = SCEng.CurrencyIsoCode; 
        this.prInvoice = (Proxy_Payable_Invoice__c)stdController.getRecord();
    }
    
    public Pagereference createInvoice(){
        prInvoice.CurrencyIsocode = SCEng.CurrencyIsoCode;
        insert prInvoice;
        pg = new Pagereference('/'+prInvoice.Id);
        pg.setRedirect(true);
        return pg;
    }

}