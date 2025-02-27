public class SCCreateSubcontractorUserExtension {
    
    Contact cont;
    
    public SCCreateSubcontractorUserExtension (ApexPages.StandardController stdController) {        
        
        system.debug('SCCreateSubcontractorUserExtension :: Constructor :: start');
        Id contactId = stdController.getRecord().Id;
        system.debug('contactId :: '+contactId);
        cont = [select Id, Email, FirstName, LastName from Contact where Id =: contactId];
        system.debug('cont :: '+cont);
        
        
        system.debug('SCCreateSubcontractorUserExtension :: Constructor :: End');
    }
    
    public Pagereference createSubcontractorUser(){
        Pagereference pg;        
        try{                              
            String profileId;            
            List<Profile__c> profileIdList = Profile__c.getall().values();
            
            for(Profile__c profileIdVal : profileIdList){
                if(profileIdVal.Name.equals('Subcontractor')){
                    profileId = profileIdVal.Value__c;
                }
            }   
            
            User user1 = new User(
                    Username = cont.Email+'.subcontractor',
                    ContactId = cont.Id,
                    ProfileId = profileId,
                    Alias = getAlias(),
                    Email = cont.Email,   
                    FirstName = cont.FirstName,
                    LastName = cont.LastName,
                    CommunityNickname = cont.Email.split('@')[0]+generateUniqueNickName(),
                    EmailEncodingKey = 'UTF-8',
                    TimeZoneSidKey = 'Europe/London',
                    LocaleSidKey = 'en_GB',
                    LanguageLocaleKey = 'en_US',
                    IsActive=true);  
            insert user1;
            pg = new Pagereference('/'+cont.Id);
            pg.setRedirect(true);            
            
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
            return null;
        }
        return pg;
    }
    
    private String  getAlias(){
        String alias = '';
        if(!String.isEmpty(String.valueOf(contact.firstName))){
            alias = String.valueOf(contact.firstName).subString(0,1);
        }
        if(String.valueOf(contact.LastName).length()>3){
            alias = alias + String.valueOf(contact.LastName).subString(0,4);
        }
        else{
            alias = alias + String.valueOf(contact.LastName).subString(0,String.valueOf(contact.LastName).length());
        }
        return alias;
    }
    
    private String generateUniqueNickName(){
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        system.debug('##########' + hexDigest );
        return hexDigest.substring(0,6);
    }
    

}