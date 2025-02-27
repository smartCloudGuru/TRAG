global inherited sharing class DDSanofiTaskCreation {

    global class DataTableWrapper {  
        public List<Task> taskList;
        public String loggedInUserId; 
        public String loggedInUserName;  
        public String contactId; 
        public String accountId;                          
    }

    @AuraEnabled(cacheable=true)
    public static String getAssociatedTasks(String recordid) {
        system.debug('recordid :: '+recordid);
        DataTableWrapper dt = new DataTableWrapper();
        List<Case> csList;
        List<Task> tskList;
        List<User> usr = [select Id, FirstName, lastname from User where Id =: UserInfo.getUserId()];
        if(!usr.isEmpty() && usr.size() == 1){
            dt.loggedInUserId =  usr.get(0).Id;
            dt.loggedInUserName=  usr.get(0).FirstName + ' '+usr.get(0).LastName;
        }
        if(recordid != null && recordid != ''){
            csList = [select Id, contactId, AccountId from Case where Id =: recordid];
            if(!csList.isEmpty() && csList.size() == 1){
                dt.contactId = csList.get(0).contactId;
                dt.accountId = csList.get(0).AccountId;
            }
            tskList = [select Id, subject, CallDisposition, Whoid, ActivityDate, whatid, Priority , Status , Owner.name , 
                                GM_Approval__c, BU_Approval__c, Summary__c, Description from task where whatid =: recordid order by createddate desc];
        }
        else{
            tskList = [select Id, subject, CallDisposition, Whoid, ActivityDate, whatid, Priority , Status , Owner.name , 
                                GM_Approval__c, BU_Approval__c, Summary__c, Description from task where ownerid =: UserInfo.getUserId() order by createddate desc];
        }
        
        system.debug('tskList :: '+tskList);
        for(Task  tsk :  tskList){
            tsk.CallDisposition = '/client/'+tsk.Id;
            tsk.CallObject = tsk.Owner.name;
        }
        system.debug('tskList after :: '+tskList);
        dt.taskList = tskList;
        system.debug('dt after :: '+dt);
        return JSON.serialize(dt);
    }
    @AuraEnabled
    public static boolean submitRecords(String selectedaccountId, String selectedcontactId,String selecteduserId,String subject,
                                            Date taskdate,Boolean gmapproval,Boolean buapproval,
                                            String summary, String additionalcomments,
                                            String statusvalue, String priorityvalue, String recordid){
        system.debug('selectedaccountId :: '+selectedaccountId);
        system.debug('selectedcontactId :: '+selectedcontactId);
        system.debug('selecteduserId :: '+selecteduserId);
        system.debug('subject :: '+subject);
        system.debug('taskdate :: '+taskdate);
        system.debug('gmapproval :: '+gmapproval);
        system.debug('buapproval :: '+buapproval);
        system.debug('summary :: '+summary);
        system.debug('additionalcomments :: '+additionalcomments);
        system.debug('statusvalue :: '+statusvalue);
        system.debug('priorityvalue :: '+priorityvalue);
        system.debug('recordid :: '+recordid);
        Task ts = new Task();
        if(selectedaccountId != null){
            ts.whatid = selectedaccountId;
        }
        else{
            if(recordid != null && recordid != ''){
                ts.whatid = recordid;
            }
        }
        if(selectedcontactId != null){
            ts.whoId = selectedcontactId;
        }       
        ts.OwnerId = selecteduserId;
        ts.Subject = subject;       
        ts.ActivityDate = taskdate; 
        ts.GM_Approval__c = gmapproval;
        ts.BU_Approval__c = buapproval;
        ts.Summary__c = summary;
        ts.Description = additionalcomments;
        ts.status = statusvalue;
        ts.priority = priorityvalue;        
        try{
            insert ts;
            return true;
        }
        catch(Exception ex){
            system.debug('Exception : '+ex.getMessage());
            return false;
        }        
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getAssociatedUsers(String recordid, String strUser) {
        system.debug('recordid :: '+recordid);
        List<User> loggedInUser = [select id, contactId, contact.AccountId from user where id =: Userinfo.getUserId()];
        string parentAccountId = loggedInUser.get(0).contact.AccountId;
        string strUserQueried = '%' + String.escapeSingleQuotes(strUser.trim()) + '%';
        String query = 'select Id, firstname, lastname, Role__c from User where contact.AccountId =: parentAccountId and name like: strUserQueried';
        List<User> userList =  Database.query(query);
        system.debug('userList :: '+userList);       
        system.debug('userList.size() :: '+userList.size()); 
        for(User  usr :  userList){
            usr.Role__c = '/client/'+usr.Id;
        }
        system.debug('userList after :: '+userList);
        return userList;
    }    

    @AuraEnabled(cacheable=true)
    public static List<Account> searchCounterpartyAccount(String recordid, String strAccountNumber){
        system.debug('recordid :: '+recordid);
        system.debug('strAccountNumber :: '+strAccountNumber);
        List<User> loggedInUser = [select id, contactId, contact.AccountId from user where id =: Userinfo.getUserId()];
        string parentAccountId = loggedInUser.get(0).contact.AccountId;
        string strAccountNumberQueried = '%' + String.escapeSingleQuotes(strAccountNumber.trim()) + '%';
        String query = 'select id, name from Account where parentid =: parentAccountId and name like: strAccountNumberQueried';
        List<Account> cpAccountList =  Database.query(query);
        system.debug('cpAccountList :: '+cpAccountList);       
        system.debug('cpAccountList.size() :: '+cpAccountList.size());        
        return cpAccountList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> searchClientContact(String recordid, String strContactNumber){
        system.debug('recordid :: '+recordid);
        system.debug('strContactNumber :: '+strContactNumber);
        List<User> loggedInUser = [select id, contactId, contact.AccountId from user where id =: Userinfo.getUserId()];
        string parentAccountId = loggedInUser.get(0).contact.AccountId;
        string strContactNumberQueried = '%' + String.escapeSingleQuotes(strContactNumber.trim()) + '%';
        String query = 'select id, name from Contact where accountid =: parentAccountId and name like: strContactNumberQueried';
        List<Contact> clientContactList =  Database.query(query);
        system.debug('clientContactList :: '+clientContactList);       
        system.debug('clientContactList.size() :: '+clientContactList.size());        
        return clientContactList;
    }

    
}