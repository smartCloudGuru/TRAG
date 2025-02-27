/**
This controller
1. creates partner admin user
2. redirects user to the next page to create Instruction Check Level or Counterparty type depending on account license
*/
public with sharing class DDOBPartnerAdminUserCreateController {
  
    public String fName{get;set;}
    public String lName{get;set;}
    public String alias{get;set;}
    public String email{get;set;}
    public String userName{get;set;}
    public String nickName{get;set;}
    public String contactId{get;set;} 
    public boolean generatePasswordandNotifyUser{get;set;}
    public String userId;
    public String accountId;
    public String accLicense;
    public String accName;    
    public pagereference nextPage;
    public pagereference prevPage;
    public String retURL;
    public boolean showPreviousButton {get;set;}
    public User user1;
    
    /**
    * Controller constructor. 
    * 1. Fetches URL parameters 
    * 2. controls the behaviour of back button display   
    * 3. Determines the return URL
  */ 
    public DDOBPartnerAdminUserCreateController() {      
        system.debug('DDOBPartnerAdminUserCreateController :: Constructor :: start ');
        fName = ApexPages.currentPage().getParameters().get('conFirstName');  
        lName = ApexPages.currentPage().getParameters().get('conLastName');    
        contactId = ApexPages.currentPage().getParameters().get('contactId'); 
        accountId = ApexPages.currentPage().getParameters().get('accId');
        accLicense = ApexPages.currentPage().getParameters().get('license');
        accName = ApexPages.currentPage().getParameters().get('accName');
        system.debug('accName :: '+accName);
        userId = ApexPages.currentPage().getParameters().get('userId');
        if(fName != null && fName.length()>0 && lName!=null && lName.length()>0){
            if(lName.length()>3){
                alias = fName.subString(0,1)+lName.subString(0,4);
            }        
            else{
                alias = fName.subString(0,1)+lName.subString(0,lName.length());
            }
        }        
        email = ApexPages.currentPage().getParameters().get('conEmail');
        userName = email;
        nickName = email.split('@')[0];
        generatePasswordandNotifyUser = false;
        retURL = '/apex/DDOBCreatePartnerAdminUser';
        system.debug('retURL :: '+retURL);  
        showPreviousButton = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showPreviousButton'));       
        system.debug('DDOBPartnerAdminUserCreateController :: Constructor :: end ');
     }
    
    /**
    * Action method to save the user
    * redirects user to create counterparty page or create instruction check level page depending on Account license
    * Display error on the page if there are any
    * sets the return url
    * controls if email is to be sent on user creation
    */
    public pagereference saveandnext(){   
        system.debug('DDOBPartnerAdminUserCreateController :: saveandnext :: start ');        
        Profile portalProfile;
        Database.DMLOptions dmlo = new Database.DMLOptions();
        /*contactId = ApexPages.currentPage().getParameters().get('contactId');  
        accountId = ApexPages.currentPage().getParameters().get('accId');
        accLicense = ApexPages.currentPage().getParameters().get('license');
        accName = ApexPages.currentPage().getParameters().get('accName');
        userId = ApexPages.currentPage().getParameters().get('userId');
        system.debug('userId :: '+userId);*/
        system.debug('generatePasswordandNotifyUser :: '+generatePasswordandNotifyUser);
        dmlo.EmailHeader.triggerUserEmail = generatePasswordandNotifyUser;   
        dmlo.EmailHeader.triggerOtherEmail = generatePasswordandNotifyUser;   
        system.debug('dmlo.EmailHeader.triggerUserEmail :: '+dmlo.EmailHeader.triggerUserEmail);
        portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Client Admin User%' Limit 1];
        try{  
          if(userId!=null){            
                user1 = [select Id, Username, ContactId, ProfileId, Alias, Email, FirstName, LastName, CommunityNickname, EmailEncodingKey, TimeZoneSidKey, LocaleSidKey,
                         LanguageLocaleKey from User where Id =: userId];
                    user1.Username = userName;
                    //user1.ContactId = contactId;
                    user1.ProfileId = portalProfile.Id;
                    user1.Alias = alias;
                    user1.Email = email;   
                    user1.FirstName = fName;
                    user1.LastName = lName;
                    user1.CommunityNickname = nickName;
                    user1.EmailEncodingKey = 'UTF-8';
                    user1.TimeZoneSidKey = 'Europe/London';
                    user1.LocaleSidKey = 'en_GB';
                    user1.LanguageLocaleKey = 'en_US'; 
                  user1.setOptions(dmlo);
                  Database.update(user1, dmlo);
              	updateContactOwner(user1.Id, contactId);
                    //update user1;            
            }
            else{
                system.debug('userName:: '+userName);
                system.debug('contactId:: '+contactId);
                system.debug('portalProfile.Id:: '+portalProfile.Id);
                system.debug('alias:: '+alias);
                system.debug('email:: '+email);
                system.debug('fName:: '+fName);
                system.debug('lName:: '+lName);
                system.debug('nickName:: '+nickName);
                user1 = new User(
                    Username = userName,
                    ContactId = contactId,
                    ProfileId = portalProfile.Id,
                    Alias = alias,
                    Email = email,   
                    FirstName = fName,
                    LastName = lName,
                    CommunityNickname = nickName,
                    EmailEncodingKey = 'UTF-8',
                    TimeZoneSidKey = 'Europe/London',
                    LocaleSidKey = 'en_GB',
                    LanguageLocaleKey = 'en_US',
                    IsActive=true);  
                insert user1;
                updateContactOwner(user1.Id, contactId);
                //user1.setOptions(dmlo);
                //Database.insert(user1, dmlo);
            } 
            
      		//addUserToDahsboarFolder(user1.Id);
            // give true if you want to send email notification.
                        
            //String retURL = '/apex/DDOBCreatePartnerAdminUser?userId='+user1.Id+'&accId='+accountId+'&accName='+accName+'&conEmail='+email+'&conFirstName='+fName+'&conLastName='+lName+'&contactId='+contactId+'&license='+accLicense;
            retURL = retURL+'?userId='+user1.Id+'&accId='+accountId+'&accName='+accName+'&conEmail='+email+'&conFirstName='+fName+'&conLastName='+lName+'&contactId='+contactId+'&license='+accLicense;            
            system.debug('accLicense :: '+accLicense);
            if(accLicense.equalsIgnoreCase('Platform')){
                nextPage = new pagereference('/apex/DDOBInstructionCheckCreate');                
            }            
            else{
              nextPage = new pagereference('/apex/DDOBCounterpartyTypeCreate');                
            }
            nextPage.getParameters().put('accName',accName);
            nextPage.getParameters().put('accId',accountId);
            nextPage.getParameters().put('showPreviousButton','true');
            nextPage.getParameters().put('retURL',retURL);
          nextPage.setRedirect(true);       
            if(generatePasswordandNotifyUser){
                Database.DMLOptions dlo = new Database.DMLOptions();
                dlo.EmailHeader.triggerUserEmail= true;
                user1.setOptions(dlo);
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to insert Partner Admin user :: '+ex.getMessage()));
            return nextPage;
        } 
        system.debug('DDOBPartnerAdminUserCreateController :: saveandnext :: end ');        
        return nextPage;
    }
    
    @future
    public static void updateContactOwner(Id userId, Id contactId){  
        Contact cont = [select Id, ownerId from Contact where Id =: contactId];
        cont.ownerId = userId;
        update cont;
    }

    
    /*private void addUserToDahsboarFolder(Id userId){
        List<Account> accountList = [select Id, DD_Due_Diligence_Portal_Licence__c from Account where Id =: accountId];
        List<DD_Folder_Permission__c> fpList;
        Id groupId;
        if(!accountList.isEmpty() && accountList.size() == 1){
            if(accountList.get(0).DD_Due_Diligence_Portal_Licence__c == 'Platform'){                    
                groupId = DD_Folder_Permission__c.getAll().get('PlatformUserGroup').Report_Group_Id__c;                    
            }
            else{
                groupId = DD_Folder_Permission__c.getAll().get('NonPlatformUserGroup').Report_Group_Id__c;  
            }
            if(groupId!=null){
            	GroupMember gm = new GroupMember(GroupId = groupId, UserOrGroupId = userId);
                insert gm;
            }            
        }                        
    }*/
    
    /**
     * Action method to determine previous page
     */
    public pagereference prev(){   
        String prevPageURL = ApexPages.currentPage().getParameters().get('retURL');
        prevPageURL = prevPageURL+'&showPreviousButton=false';
        prevPage = new Pagereference(prevPageURL);
        prevPage.setRedirect(true);
        return prevPage;
    }  
    
}