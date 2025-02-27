public class SCContentDocumentLinkTriggerHandler {
    
    public void beforeInsert(List<ContentDocumentLink> newContentList){
        system.debug('newContentList in insert :: '+newContentList);
        if(validateFileAccess(newContentList)){
            validateFileDeletion(newContentList);
        }
    }
    
    public void beforeUpdate(List<ContentDocumentLink> newContentList){
        system.debug('newContentList in update :: '+newContentList);
        validateFileAccess(newContentList);
    }
    
    public void beforeDelete(List<ContentDocumentLink> oldContentList, List<ContentDocumentLink> newContentList){
        system.debug('oldContentList in delete :: '+oldContentList);
        system.debug('newContentList in insert :: '+newContentList);
        if(validateFileAccess(newContentList)){
            validateFileDeletion(oldContentList);           
        }
    }
    
    public void validateFileDeletion(List<ContentDocumentLink> contentList){
        Map<Id, Id> contentLinkId_scInvoiceId_Map = new Map<Id, Id>();
        
        
        for(ContentDocumentLink contentVal : contentList){
            if(contentVal.LinkedEntityId != null && String.valueOf(contentVal.LinkedEntityId).startsWith('aCO')){
            	contentLinkId_scInvoiceId_Map.put(contentVal.Id, contentVal.LinkedEntityId);   
            }            
        }
        
        List<Proxy_Payable_Invoice__c> proxyInvoiceList = [select Id, Status__c from Proxy_Payable_Invoice__c where Id in: contentLinkId_scInvoiceId_Map.values()];
        for(Proxy_Payable_Invoice__c proxyInvoiceVal : proxyInvoiceList){
            if(proxyInvoiceVal.Status__c == 'Submitted'){
                contentList.get(0).addError(Label.SC_File_Upload_Error_message);
            }
        }     
    }
    
    public boolean validateFileAccess(List<ContentDocumentLink> contentList){
        if(contentList != null && !contentList.isEmpty()){
            for(ContentDocumentLink contentVal : contentList){
                if((String.valueOf(contentVal.LinkedEntityId).startsWith('005') && (contentVal.ShareType.equals('C') || contentVal.ShareType.equals('V')))
                  || (String.valueOf(contentVal.LinkedEntityId).startsWith('0DB') && (contentVal.ShareType.equals('C') || contentVal.ShareType.equals('V')))){
                    contentList.get(0).addError(Label.SC_File_Sharing_error_message);
                    return false;
                }
            }
        }
        return true;
    }
}