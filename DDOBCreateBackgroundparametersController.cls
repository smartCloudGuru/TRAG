/**
This controller creates
1. client specific groups
2. client specific queues
3. client specific custom settings (DGL, Folderpermission)
*/

public with sharing class DDOBCreateBackgroundparametersController {
	
    public String accId;
    List<Account> accList;
    public String accName;
    public Map<String, Id> bgParamNamebgParamIdMap;
    public pagereference prevPage {get;set;}    
    public boolean bgParamSuccess {get;set;}
    public boolean customSettingSuccess {get;set;}
    public PageReference pr;
    
    	/**
          * Controller constructor
          * 1. Fetches URL parameters           
          * 2. Determines the next page URL         
        */   
        public DDOBCreateBackgroundparametersController(){   
            system.debug('DDOBCreateBackgroundparametersController :: constructor :: start ');
            bgParamSuccess = false;
            customSettingSuccess = false;
            accId = ApexPages.currentPage().getParameters().get('accId');  
            accName = ApexPages.currentPage().getParameters().get('accName');     
            //pr = new PageReference('/apex/DDOBBackgroundParameterSuccess');
            pr = new PageReference('/apex/DDOBCreateQueueMember');
            system.debug('DDOBCreateBackgroundparametersController :: constructor :: end ');
        }
    
    /**
     * This method creates compliance team queue, account team queue, partner user group, partner manager group, partner report group
     * in sequence. Produces an error message on the page if it fails at any point
     */
    public void createMandatoryBackgroundParameters(){   
        system.debug('DDOBCreateBackgroundparametersController :: createMandatoryBackgroundParameters :: start ');
        bgParamSuccess = false;
        accList = [Select Id, DD_Due_Diligence_Portal_Licence__c, Watchlist_Client__c from Account a where Id =: accId];
        if(createComplianceTeamQueue(accName.substring(0, 9)+' Compl Team')){
            if(!accList.isEmpty() && accList.size() == 1 
               && (((accList.get(0).DD_Due_Diligence_Portal_Licence__c.equals('Counterparty Application with Questionnaire')
                    || accList.get(0).DD_Due_Diligence_Portal_Licence__c.equals('Verification'))
                    && createVerificationTeamQueue(accName.substring(0, 9)+' Ver Team') && createAccountTeamQueue(accName.substring(0, 9)+' Acc Team')
                   && createClientWLTeamQueue(accName.substring(0, 9)+' Client WL Team')
                   && createRAGWLTeamQueue(accName.substring(0, 9)+' RAG WL Team'))
                   || createAccountTeamQueue(accName.substring(0, 9)+' Acc Team'))){                              
                if(createPartnerUserGroup(accName.substring(0, 9)+' Partner User')){
                    if(createPartnerManagerGroup(accName.substring(0, 9)+' Partner Manager')){
                        if(createPartnerReportGroup(accName.substring(0, 9)+' Partner Report')){
                            bgParamSuccess = true;
                            pr.getParameters().put('accId',accId);
                    		pr.getParameters().put('accName',accName);
                            if(bgParamNamebgParamIdMap.get('verificationteam') != null){
                                pr.getParameters().put('verTeamQId',bgParamNamebgParamIdMap.get('verificationteam'));
                            }
                            if(bgParamNamebgParamIdMap.get('clientwlteam') != null){
                                pr.getParameters().put('clientwlQId',bgParamNamebgParamIdMap.get('clientwlteam'));
                            }
                            if(bgParamNamebgParamIdMap.get('ragwlteam') != null){
                                pr.getParameters().put('ragwlQId',bgParamNamebgParamIdMap.get('ragwlteam'));
                            }
                            pr.getParameters().put('accTeamQId',bgParamNamebgParamIdMap.get('accountteam'));
                        }                        
                    }              
                }
            }            
        }
		system.debug('DDOBCreateBackgroundparametersController :: createMandatoryBackgroundParameters :: end ');
    }
    
    /**
     * This method create client specific DGL custom setting. Produces a message if custom setting already exists.
     */
    public void createCustomSetting(){               
        system.debug('DDOBCreateBackgroundparametersController :: createCustomSetting :: start ');
        List<DGL__c> dglList = new List<DGL__c>();   
        List<DD_Folder_Permission__c> fpList = new List<DD_Folder_Permission__c>();
        
        bgParamNamebgParamIdMap = getAccountTeamGroup(bgParamNamebgParamIdMap);
        system.debug('bgParamNamebgParamIdMap in custom settings :: '+bgParamNamebgParamIdMap);
        system.debug('accName :: '+accName);
        system.debug('Value :: '+DGL__c.getAll().get(accName+' Compl Team'));
        try{
            if(DGL__c.getAll().get(accName.substring(0, 9)+' Compl Team')!=null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Custom Setting already exist'));   
                customSettingSuccess = true;
            }
            else{
                for(String bgParamNamebgParamIdVal : bgParamNamebgParamIdMap.keySet()){     
                    if(bgParamNamebgParamIdVal.equalsIgnoreCase('complianceteam')){
                        DGL__c dgl = new DGL__c();
                        dgl.Name = accName.substring(0, 9)+' Compl Team';
                        dgl.Account__c = accId+'__CL_COMPLIANCE_TEAM_QUE';
                        dgl.Group__c = bgParamNamebgParamIdMap.get('complianceteam');
                        dglList.add(dgl);
                    }
                    else if(bgParamNamebgParamIdVal.equalsIgnoreCase('accountteam')){
                        DGL__c dgl = new DGL__c();
                        dgl.Name = accName.substring(0, 9)+' Team';
                        dgl.Account__c = accId+'__RA_ACCOUNT_TEAM_QUE';
                        dgl.Group__c = bgParamNamebgParamIdMap.get('accountteam');
                        dglList.add(dgl);
                    }
                    else if(bgParamNamebgParamIdVal.equalsIgnoreCase('verificationteam')){
                        DGL__c dgl = new DGL__c();
                        dgl.Name = accName.substring(0, 9)+' Verification Team';
                        dgl.Account__c = accId+'__RA_VERIFICATION_TEAM_QUE';
                        dgl.Group__c = bgParamNamebgParamIdMap.get('verificationteam');
                        dglList.add(dgl);
                    }
                    else if(bgParamNamebgParamIdVal.equalsIgnoreCase('clientwlteam')){
                        DGL__c dgl = new DGL__c();
                        dgl.Name = accName.substring(0, 9)+' Client WL Team';
                        dgl.Account__c = accId+'__CL_WL_TEAM_QUE';
                        dgl.Group__c = bgParamNamebgParamIdMap.get('clientwlteam');
                        dglList.add(dgl);
                    } 
                    else if(bgParamNamebgParamIdVal.equalsIgnoreCase('ragwlteam')){
                        DGL__c dgl = new DGL__c();
                        dgl.Name = accName.substring(0, 9)+' RAG WL Team';
                        dgl.Account__c = accId+'__RAG_WL_TEAM_QUE';
                        dgl.Group__c = bgParamNamebgParamIdMap.get('ragwlteam');
                        dglList.add(dgl);
                    } 
                    else if(bgParamNamebgParamIdVal.equalsIgnoreCase('partneruser')){
                        DGL__c dgl = new DGL__c();
                        dgl.Name = accName.substring(0, 9)+' Partner User';
                        dgl.Account__c = accId+'__CL_PARTNER_USER_ROLE';
                        dgl.Group__c = bgParamNamebgParamIdMap.get('partneruser');
                        dglList.add(dgl);
                    }
                    /*else if(bgParamNamebgParamIdVal.equalsIgnoreCase('partneruser')){
                        DGL__c dgl = new DGL__c();
                        dgl.Name = accName+' Partner User Role';
                        dgl.Account__c = accId+'__CL_PARTNER_USER_ROLE';
                        dgl.Group__c = bgParamNamebgParamIdMap.get('partneruser');
                        dglList.add(dgl);
                    }*/
                    else if(bgParamNamebgParamIdVal.equalsIgnoreCase('partnermanager')){
                        DGL__c dgl = new DGL__c();
                        dgl.Name = accName.substring(0, 9)+' Partner Manager';
                        dgl.Account__c = accId+'__CL_PARTNER_MANAGER_ROLE';
                        dgl.Group__c = bgParamNamebgParamIdMap.get('partnermanager');
                        dglList.add(dgl);
                    }
                    else if(bgParamNamebgParamIdVal.equalsIgnoreCase('accountteamgroup')){
                        DGL__c dgl = new DGL__c();
                        dgl.Name = accName.substring(0, 9)+' Account Team';
                        dgl.Account__c = accId+'__CL_ACCOUNT_TEAM_GROUP';
                        dgl.Group__c = bgParamNamebgParamIdMap.get('accountteamgroup');
                        dglList.add(dgl);
                    }
                    else if(bgParamNamebgParamIdVal.equalsIgnoreCase('partnereport')){
                        DD_Folder_Permission__c fp = new DD_Folder_Permission__c();
                        fp.Name = accName.substring(0, 9);
                        fp.Client_Account__c = accId+'__CL_REPORT_GROUP_ID';
                        fp.Report_Group_Id__c = bgParamNamebgParamIdMap.get('partnereport');
                        fpList.add(fp);
                    }                
                }            
            }        
        	if(dglList.size()>0){            
                system.debug('dglList :: '+dglList);
                system.debug('fpList :: '+fpList);
            	insert dglList;    
                if(fpList.size()>0){
                	insert fpList;
                    customSettingSuccess = true;
                    //pr.setRedirect(true);
                    //return pr;
                }
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error inserting custom settings'));
            //return pr;
        }              
        system.debug('DDOBCreateBackgroundparametersController :: createCustomSetting :: end ');
        //return pr;        
    }   
	
    // Redirects to success if queue, groups and custom settings are successfully created
    public Pagereference continueToSuccessPage(){
        pr.setRedirect(true);
        return pr;
    }    
    
    /**
     * create compliance team queue. Produces a message if queue already exists.
     */ 
    private boolean createComplianceTeamQueue(String queueName){
        system.debug('DDOBCreateBackgroundparametersController :: createComplianceTeamQueue :: start ');
        List<QueueSObject> qSObjectList = new List<QueueSObject>();     
        List<Group> complianceQList;
        Group g;
       
        QueueSObject q;
        QueueSObject q1;
        QueueSObject q2;
        accName =   accName.replaceAll( '\\s+', '');   
        system.debug('accName in compliance queue :: '+accName);
        String partnerUserRole = accName+'PartnerUser';
        List<Group> gpList = [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Developername =: partnerUserRole limit 1];
        complianceQList = [Select g.Name, g.Id, g.DeveloperName From Group g where Name =: queueName];
        try{
            if(complianceQList != null && complianceQList.size()>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Groups and Queues already exist'));
                bgParamNamebgParamIdMap = new Map<String, Id>();
                bgParamNamebgParamIdMap.put('complianceteam', complianceQList.get(0).Id);
                return true;
            }
            else{
            	g = new Group(Type='Queue', Name=queueName, DoesSendEmailToMembers = true);
                insert g;
                q = new QueueSObject(SobjectType='Case', QueueId=g.Id);
                insert q;
                q1 = new QueueSObject(SobjectType='dd_Questionnaire_Response__c', QueueId=g.Id);
                insert q1;
                q2 = new QueueSObject(SobjectType='Risk_Model_2_Questionnaire_Response__c', QueueId=g.Id);
                insert q2;
                if(!gpList.isEmpty() && gpList.size() == 1){
                    GroupMember gm = new GroupMember(GroupId = g.Id, UserOrGroupId = gpList.get(0).Id); 
                    insert gm;
                }                
                bgParamNamebgParamIdMap = new Map<String, Id>();
                bgParamNamebgParamIdMap.put('complianceteam', g.Id);
                return true;   
            }                        
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating compliance team queue'));
            return false;
        }
        system.debug('DDOBCreateBackgroundparametersController :: createComplianceTeamQueue :: end ');
        return false;
    }
    
    private boolean createClientWLTeamQueue(String queueName){
        system.debug('DDOBCreateBackgroundparametersController :: createWLClientTeamQueue :: start ');
        List<QueueSObject> qSObjectList = new List<QueueSObject>();     
        List<Group> clientwlteamQList;
        Group g;
       
        QueueSObject q;
        QueueSObject q1;
        accName =   accName.replaceAll( '\\s+', '');    
        system.debug('accName in clientwlteamQList queue :: '+accName);
        String partnerUserRole = accName+'PartnerUser';
        //List<Group> gpList = [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Developername =: partnerUserRole limit 1];
        clientwlteamQList = [Select g.Name, g.Id, g.DeveloperName From Group g where Name =: queueName];
        try{
            if(clientwlteamQList != null && clientwlteamQList.size()>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Groups and Queues already exist'));
                //bgParamNamebgParamIdMap = new Map<String, Id>();
                bgParamNamebgParamIdMap.put('clientwlteam', clientwlteamQList.get(0).Id); 
                return true;
            }
            else{
            	g = new Group(Type='Queue', Name=queueName, DoesSendEmailToMembers = true);
                insert g;
                q = new QueueSObject(SobjectType='Watchlist_Search_Result__c', QueueId=g.Id);
                insert q;
                q1 = new QueueSObject(SobjectType='Watchlist_Search_Subject__c', QueueId=g.Id);
                insert q1;
                //if(!gpList.isEmpty() && gpList.size() == 1){
                  //  GroupMember gm = new GroupMember(GroupId = g.Id, UserOrGroupId = gpList.get(0).Id); 
                  //  insert gm;
              //  }                
                //bgParamNamebgParamIdMap = new Map<String, Id>();
                bgParamNamebgParamIdMap.put('clientwlteam', g.Id);
                return true;   
            }                        
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating client watchlist queue'));
            return false;
        }
        system.debug('DDOBCreateBackgroundparametersController :: createWLClientTeamQueue :: end ');
        return false;
    }
    
    private boolean createRAGWLTeamQueue(String queueName){
        system.debug('DDOBCreateBackgroundparametersController :: createWLRAGTeamQueue :: start ');
        List<QueueSObject> qSObjectList = new List<QueueSObject>();     
        List<Group> ragwlteamQList;
        Group g;
       
        QueueSObject q;
        QueueSObject q1;
        accName =   accName.replaceAll( '\\s+', '');   
        system.debug('accName in ragwlteamQList queue :: '+accName);
        String partnerUserRole = accName+'PartnerUser';
        //List<Group> gpList = [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Developername =: partnerUserRole limit 1];
        ragwlteamQList = [Select g.Name, g.Id, g.DeveloperName From Group g where Name =: queueName];
        try{
            if(ragwlteamQList != null && ragwlteamQList.size()>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Groups and Queues already exist'));
                //bgParamNamebgParamIdMap = new Map<String, Id>();
                bgParamNamebgParamIdMap.put('ragwlteam', ragwlteamQList.get(0).Id);
                return true;
            }
            else{
            	g = new Group(Type='Queue', Name=queueName, DoesSendEmailToMembers = true);
                insert g;
                q = new QueueSObject(SobjectType='Watchlist_Search_Result__c', QueueId=g.Id);
                insert q;
                q1 = new QueueSObject(SobjectType='Watchlist_Search_Subject__c', QueueId=g.Id);
                insert q1;
                //if(!gpList.isEmpty() && gpList.size() == 1){
                    //GroupMember gm = new GroupMember(GroupId = g.Id, UserOrGroupId = gpList.get(0).Id); 
                    //insert gm;
                //}                
                //bgParamNamebgParamIdMap = new Map<String, Id>();
                bgParamNamebgParamIdMap.put('ragwlteam', g.Id);
                return true;   
            }                        
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating rag watchlist queue'));
            return false;
        }
        system.debug('DDOBCreateBackgroundparametersController :: createWLRAGTeamQueue :: end ');
        return false;
    }
    
    /**
     * create verification team queue. Produces a message if queue already exists.
     */ 
    private boolean createVerificationTeamQueue(String queueName){
        system.debug('DDOBCreateBackgroundparametersController :: createVerificationTeamQueue :: start ');
        List<QueueSObject> qSObjectList = new List<QueueSObject>();
        List<Group> verificationTeamQList;
        Group g;
        QueueSObject q;
        QueueSObject q1;
        verificationTeamQList = [Select g.Name, g.Id, g.DeveloperName From Group g where Name =: queueName];
        try{
            if(verificationTeamQList != null && verificationTeamQList.size()>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Groups and Queues already exist'));
                bgParamNamebgParamIdMap.put('verificationteam', verificationTeamQList.get(0).Id);
                return true;
            }
            else{
                g = new Group(Type='Queue', Name=queueName, DoesSendEmailToMembers = false);
                insert g;
                q = new QueueSObject(SobjectType='dd_Questionnaire_Response__c', QueueId=g.Id);
                insert q;                
                bgParamNamebgParamIdMap.put('verificationteam', g.Id);
                system.debug('bgParamNamebgParamIdMap inside verification team :: '+bgParamNamebgParamIdMap);
                return true;
            }
            
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating Verification team queue'));
            return false;
        }
        system.debug('DDOBCreateBackgroundparametersController :: createVerificationTeamQueue :: end ');
        return false;
    }
    
    /**
     * create account team queue. Produces a message if queue already exists.
     */ 
    private boolean createAccountTeamQueue(String queueName){
        system.debug('DDOBCreateBackgroundparametersController :: createAccountTeamQueue :: start ');
        List<QueueSObject> qSObjectList = new List<QueueSObject>();
        List<Group> accountTeamQList;
        Group g;
        QueueSObject q;
        QueueSObject q1;
        accountTeamQList = [Select g.Name, g.Id, g.DeveloperName From Group g where Name =: queueName];
        try{
            if(accountTeamQList != null && accountTeamQList.size()>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Groups and Queues already exist'));
                bgParamNamebgParamIdMap.put('accountteam', accountTeamQList.get(0).Id);
                return true;
            }
            else{
                g = new Group(Type='Queue', Name=queueName, DoesSendEmailToMembers = true);
                insert g;
                q = new QueueSObject(SobjectType='Case', QueueId=g.Id);
                insert q;
                q1 = new QueueSObject(SobjectType='DD_Instruction__c', QueueId=g.Id);
                insert q1;
                bgParamNamebgParamIdMap.put('accountteam', g.Id);
                system.debug('bgParamNamebgParamIdMap inside account team :: '+bgParamNamebgParamIdMap);
                return true;
            }
            
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating Account team queue'));
            return false;
        }
        system.debug('DDOBCreateBackgroundparametersController :: createAccountTeamQueue :: end ');
        return false;
    }        
    
    /**
     * create partner user group. Produces a message if group already exists.
     */
    private boolean createPartnerUserGroup(String partnerUserGroupName){
        system.debug('DDOBCreateBackgroundparametersController :: createPartnerUserGroup :: start ');
        List<GroupMember> GMlist = new List<GroupMember>();
        Group gp;
        Group g;
        List<Group> gp1List;
        String partnerUserName;
		String partnerUserGroupName1;
        accName =   accName.replaceAll( '\\s+', '');   
        system.debug('accName :: '+accName);
        partnerUserName = accName+'PartnerUser';
        system.debug('partnerUserName :: '+partnerUserName);
        partnerUserGroupName1 = accName+' Partner User Role';
        system.debug('partnerUserGroupName1 :: '+partnerUserGroupName1);
        
        try{
            gp = [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Developername =: partnerUserName limit 1];
        	gp1List = [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Name =: partnerUserGroupName1 limit 1];
            if(gp1List!=null && gp1List.size()>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Groups and Queues already exist'));
                bgParamNamebgParamIdMap.put('partneruser', gp1List.get(0).Id);
                return true;
            }
            else{
                g = new Group(Type='Regular', Name=partnerUserGroupName);
                insert g;         
                GroupMember GM = new GroupMember();
                GM.GroupId = g.id;
                GM.UserOrGroupId = gp.Id;
                GMList.add(GM);   
                insert GMList;                
                bgParamNamebgParamIdMap.put('partneruser', g.Id);
                if(!accList.isEmpty() && accList.get(0).Watchlist_Client__c){
                    sharePartnerUserGroupWithWatchlistTestAccount(g.Id);
                }
                system.debug('bgParamNamebgParamIdMap inside partner user :: '+bgParamNamebgParamIdMap);
                return true;
            }                        
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating Partner user group :: '+ex.getMessage()));
            return false;
        }
        system.debug('DDOBCreateBackgroundparametersController :: createPartnerUserGroup :: end ');
        return false;
    }
    
    @future
    public static void sharePartnerUserGroupWithWatchlistTestAccount(Id gId){
        AccountShare shr = new AccountShare(UserOrGroupId = gId , accountId = label.Watchlist_Temp_Account_Id, caseaccesslevel = 'read', accountaccesslevel = 'read',  OpportunityAccessLevel='read');
        insert shr;
    }
    
    /**
     * create partner manager group. Produces a message if group already exists.
     */
    private boolean createPartnerManagerGroup(String partnerManagerGroupName){
        system.debug('DDOBCreateBackgroundparametersController :: createPartnerManagerGroup :: start ');
        List<GroupMember> GMlist = new List<GroupMember>();
        Group g;
        Group gp;
        List<Group> gp1List;
        String partnerManagerName;
        String partnerManagerGroupName1;
		
        accName =   accName.replaceAll( '\\s+', '');      
        partnerManagerName = accName+'PartnerManager';
        partnerManagerGroupName1 = accName+' Partner Manager Role';
        system.debug('partnerManagerGroupName1 :: '+partnerManagerGroupName1);
        gp = [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Developername =: partnerManagerName limit 1];
        gp1List = [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Name =: partnerManagerGroupName1 limit 1];
        
        try{
            if(gp1List!=null && gp1List.size()>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Groups and Queues already exist'));
                bgParamNamebgParamIdMap.put('partnermanager', gp1List.get(0).Id);
                return true;
            }
            else{
                g = new Group(Type='Regular', Name=(partnerManagerGroupName));
                insert g;         
                GroupMember GM = new GroupMember();
                GM.GroupId = g.id;
                GM.UserOrGroupId = gp.Id;
                GMList.add(GM);   
                insert GMList;
                bgParamNamebgParamIdMap.put('partnermanager', g.Id);
                return true;
            }
            
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating Partner Manager group'));
            return false;
        }
        system.debug('DDOBCreateBackgroundparametersController :: createPartnerManagerGroup :: end ');
        return false;
    }
    
    /**
     * create partner report group. Produces a message if group already exists.
     */
    private boolean createPartnerReportGroup(String partnerReportGroupName){        
        system.debug('DDOBCreateBackgroundparametersController :: createPartnerReportGroup :: start ');        
        Group g;
        List<Group> gp1List; 
        String partnerReportGroupName1 = accName+' Partner Report Group';
        system.debug('partnerReportGroupName1 :: '+partnerReportGroupName1);
        gp1List = [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Name =: partnerReportGroupName1 limit 1];
        
        try{
            if(gp1List!=null && gp1List.size()>0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Groups and Queues already exist'));
                bgParamNamebgParamIdMap.put('partnereport', gp1List.get(0).Id);
                return true;
            }
            else{
                g = new Group(Type='Regular', Name=partnerReportGroupName);
                insert g;                       
                bgParamNamebgParamIdMap.put('partnereport', g.Id);
                return true;
            }
            
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating Partner Report group'));
            return false;
        }
        system.debug('DDOBCreateBackgroundparametersController :: createPartnerReportGroup :: end ');
        return false;
    }  
    
    /**
     * fetches account team
     */
    private Map<String, Id> getAccountTeamGroup(Map<String, Id> bgParamNamebgParamIdMap1){
        system.debug('DDOBCreateBackgroundparametersController :: getAccountTeamGroup :: start ');
        Group gp;
        
        gp = [Select g.Type, g.Name, g.Id, g.DeveloperName From Group g where Developername = 'BIT1_BIT2_and_BIT3' limit 1];
        bgParamNamebgParamIdMap1.put('accountteamgroup', gp.Id);
        system.debug('DDOBCreateBackgroundparametersController :: getAccountTeamGroup :: end ');
        return bgParamNamebgParamIdMap1;
    }
    
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