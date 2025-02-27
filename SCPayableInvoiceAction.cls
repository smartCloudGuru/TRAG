public class SCPayableInvoiceAction {
    
    private ApexPages.StandardController StdController {get;set;}
    public Proxy_Payable_Invoice__c payableInvoice {get;set;}
    public Attachment[] docLinkList;
    public ContentDocumentLink[] contDocList;
    
    public SCPayableInvoiceAction (ApexPages.StandardController stdController) {                
        system.debug('SCPayableInvoiceAction :: SCPayableInvoiceAction :: start');
        try{
            this.StdController = stdController;            
            Id payableInvoiceId = stdController.getRecord().Id;        
            payableInvoice = [Select Id, Status__c, Subcontractor_Engagement__c, Subcontractor_Engagement__r.Status__c, Subcontractor_Engagement__r.Invoice_Attached__c,
                              Subcontractor_Engagement__r.Subcontractor__r.OwnerId from Proxy_Payable_Invoice__c  where id =:  payableInvoiceId];
            system.debug('payableInvoice :: '+payableInvoice);
            contDocList = [Select c.Visibility, c.ShareType, c.LinkedEntityId, c.Id, c.ContentDocumentId From ContentDocumentLink c WHERE LinkedEntityId =: payableInvoice.Id];
            //docLinkList = [select id, name, body from Attachment where ParentId = :payableInvoice.Id];
            system.debug('contDocList :: '+contDocList);
        }catch(Exception e){
            payableInvoice.addError(e.getMessage());
        }
        system.debug('SCPayableInvoiceAction :: SCPayableInvoiceAction :: End');
    }
        
    public pagereference sumbitInvoice(){
        //List<Attachment> docLinkList = payableInvoice.Attachments;        
        if(payableInvoice.Subcontractor_Engagement__r.Status__c != 'Accepted'){
            payableInvoice.addError(Label.SCEngagementNotAccepted);
            return null;
        }            
        else if(contDocList != null && contDocList.size() != 1){
            payableInvoice.addError(Label.SCInvoiceMissing);
            return null;
        }  
        else{
            if(payableInvoice.Status__c == 'Submitted'){
                payableInvoice.addError(Label.SCInvoiceAlreadySubmitted);
            	return null;
            }
            else{
                payableInvoice.Status__c = 'Submitted';
                payableInvoice.Invoice_Submitted__c  = true;
                update payableInvoice;                
            }            
        }        
        Pagereference pr = new Pagereference('/'+payableInvoice.Subcontractor_Engagement__c);
        pr.setRedirect (true);
        return pr;
    }
    
    public Pagereference continueToEngagement(){
        Pagereference pg = new Pagereference('/'+payableInvoice.Subcontractor_Engagement__c);
        pg.setRedirect(true);
        return pg;
    }

}