public with sharing class DDDisplayPortalContactsExtension {
    
    Account currentAccount;
    public List<Contact> relatedPortalContacts {get;set;}
    public String newContactURL {get;set;}
    
    public DDDisplayPortalContactsExtension(ApexPages.StandardController controller) {
        this.currentAccount = (Account)controller.getSubject();
        List<Account> accountList_DB = [Select Id, name, (Select Id, AccountId, Name, RecordTypeId, MobilePhone, OtherPhone, Email 
                                         From Contacts where recordType.name = 'Due Diligence Portal Contact') 
                                 From Account a where Id =: currentAccount.Id];
        if(!accountList_DB.isEmpty()){
            relatedPortalContacts = accountList_DB.get(0).Contacts;
        }        
        newContactURL = '/client/003/e?retURL=/client/'+currentAccount.Id+'&accId='+currentAccount.Id+'&con4='+accountList_DB.get(0).Name;        
    }        
}