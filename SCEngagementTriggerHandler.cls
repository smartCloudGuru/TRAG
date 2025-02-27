public class SCEngagementTriggerHandler {
    
    public void beforeInsertOrUpdate(List<SubcontractorEngagement__c> newList, Map<Id, SubcontractorEngagement__c> newMap, List<SubcontractorEngagement__c> oldList, Map<Id, SubcontractorEngagement__c> oldMap){
    	
        Set<Id> projectIdSet = new Set<Id>();
        Map<Id, Id> projectId_PracticeHeadEmail_Map = new Map<Id, Id>();    
        Map<Id, pse__Proj__c> projectId_Project_Map = new Map<Id, pse__Proj__c>();
		Boolean isError = false;        
        
        List<SubcontractorEngagement__c> engagementsList_DB = [select Id, Status__c, Subcontractor__r.SubcontractApprovalResult__c from  SubcontractorEngagement__c where Id in: newList];
        system.debug('engagementsList_DB :: '+engagementsList_DB);
        for(SubcontractorEngagement__c engagementsVal_DB : engagementsList_DB){
            if(newMap.get(engagementsVal_DB.Id).Status__c != oldMap.get(engagementsVal_DB.Id).Status__c
               && newMap.get(engagementsVal_DB.Id).Status__c == 'Pending Approval'
              && engagementsVal_DB.Subcontractor__r.SubcontractApprovalResult__c != 'Certified'){
                  newList.get(0).addError('You can not submit engagement for approval as subcontractor is not vetted');
                  isError = true;
                  break;
               }
        }
        
        system.debug('isError :: '+isError);
        if(!isError){
            for(SubcontractorEngagement__c val : newList){
                projectIdSet.add(val.Project__c);
            }        
            system.debug('projectIdSet :: '+projectIdSet);
            
            List<pse__Proj__c> projectList = [Select Id, Name, ffps_0387__Project_Code__c, pse__Practice__r.pse__Practice_Head__r.pse__Salesforce_User__c
                                              From pse__Proj__c where Id in: projectIdSet];
            
            for(pse__Proj__c projectVal : projectList){
                projectId_PracticeHeadEmail_Map.put(projectVal.Id, projectVal.pse__Practice__r.pse__Practice_Head__r.pse__Salesforce_User__c);
                if(!String.isEmpty(projectVal.ffps_0387__Project_Code__c) && projectVal.ffps_0387__Project_Code__c.length() > 2){
                    projectId_Project_Map.put(projectVal.Id, projectVal);    
                }                
            }
            
            system.debug('projectId_PracticeHeadEmail_Map  :: '+projectId_PracticeHeadEmail_Map);
            
            for(SubcontractorEngagement__c engagementVal : newList){
                system.debug('engagementVal.Project__r.pse__Practice__r.pse__Practice_Head__r.Email :: '+engagementVal.Project__r.pse__Practice__r.pse__Practice_Head__r.Email); 
                engagementVal.Practice_Head_Approver__c = projectId_PracticeHeadEmail_Map.get(engagementVal.Project__c);
                if(oldList == null){
                    String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
                    Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
                    String hexDigest = EncodingUtil.convertToHex(hash);
                    system.debug('##########' + hexDigest );
                    if(!test.isRunningTest()){
                        engagementVal.name = projectId_Project_Map.get(engagementVal.Project__c).ffps_0387__Project_Code__c.subString(8, projectId_Project_Map.get(engagementVal.Project__c).ffps_0387__Project_Code__c.length())+'-'+hexDigest.substring(0,2);
                    }
                }
            }      
        }
    }
    
    public void afterInsertOrUpdate(List<SubcontractorEngagement__c> newList, Map<Id, SubcontractorEngagement__c> newMap, List<SubcontractorEngagement__c> oldList, Map<Id, SubcontractorEngagement__c> oldMap){
        
        system.debug('newList :: '+newList);
        Set<Id> projectIdSet = new Set<Id>();
        Set<Id> subContractorIdSet = new Set<Id>();
        List<String> validStatusList = new List<String>{'Approved', 'Unpaid', 'Paid', 'Part Paid', 'Pending Approval'};                       
        String template;
        List<CurrencyType> cTypeList;
        
        List<User> loggedInUser = [select Id, UserType from User where Id =: Userinfo.getUserId()];
        system.debug('loggedInUser :: '+loggedInUser);
        for(SubcontractorEngagement__c val : newList){            
            if(oldMap!=null && newMap != null && oldMap.get(val.Id).Status__c != newMap.get(val.Id).Status__c){
                if(val.Status__c == 'Approved'){
                    template = 'New_project_request_from_Risk_Advisory1';
                    subContractorIdSet.add(val.Subcontractor__c);
                    projectIdSet.add(val.Project__c);
                }
                else if(val.Status__c == 'Rejected' || val.Status__c == 'Pending Approval'){
                    projectIdSet.add(val.Project__c);
                }
                /*else if(val.Status__c == 'Paid' || val.Status__c == 'Part Paid'){
                    template = 'Engagement_paid_email_for_subcontractor';
                    subContractorIdSet.add(val.Subcontractor__c);
                }*/
            }
        }
        
        system.debug('template :: '+template);
        system.debug('projectIdSet :: '+projectIdSet);
        system.debug('subContractorIdSet :: '+subContractorIdSet);
        List<pse__Proj__c> projectList = [Select ffps_0387__Subcontractor_Labour_Cost_2__c, ffps_0387__Subcontractor_Expenses_2__c, 
                  Subcontractor_Fees_Exceeded__c, Subcontractor_Expense_Exceeded__c, Id, currencyisocode,
                  (Select Id, currencyisocode, Budget__c, Project__c, Status__c, Fees__c, Expense__c From SubcontractorEngagements__r where Status__c in: validStatusList) 
                  From pse__Proj__c where Id in: projectIdSet];
        
        system.debug('projectList before  :: '+projectList);
        if(!loggedInUser.get(0).userType.equals('CspLitePortal')){               
            cTypeList = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE];
            system.debug('cTypeList  :: '+cTypeList);        
            
            for(pse__Proj__c projectVal : projectList){
                Decimal totalApprovedFees = 0.00;
                Decimal totalApprovedExpense = 0.00;
                Decimal totalPendingApprovalFees = 0.00;
                Decimal totalPendingApprovalExpense = 0.00;
                Decimal exceededFee;
                Decimal exceededExpense;
                for(SubcontractorEngagement__c val : projectVal.SubcontractorEngagements__r){
                    system.debug('val :: '+val);
                    if(val.Status__c == 'Approved' /*|| val.Status__c == 'Paid' || val.Status__c == 'Part Paid' || val.Status__c == 'Unpaid'*/){
                        totalApprovedFees += currencyValueInGBP(val.CurrencyIsoCode, val.Fees__c, cTypeList);
                        totalApprovedExpense += currencyValueInGBP(val.CurrencyIsoCode, val.Expense__c, cTypeList);
                    }
                    else if(val.Status__c == 'Pending Approval'){
                        totalPendingApprovalFees += currencyValueInGBP(val.CurrencyIsoCode, val.Fees__c, cTypeList);
                        totalPendingApprovalExpense += currencyValueInGBP(val.CurrencyIsoCode, val.Expense__c, cTypeList);
                    }
                }
                system.debug('totalApprovedFees :: '+totalApprovedFees);
                system.debug('totalApprovedExpense  :: '+totalApprovedExpense);
                system.debug('totalPendingApprovalFees :: '+totalPendingApprovalFees);
                system.debug('totalPendingApprovalExpense  :: '+totalPendingApprovalExpense);
                
                if(totalApprovedFees > currencyValueInGBP(projectVal.CurrencyIsoCode, projectVal.ffps_0387__Subcontractor_Labour_Cost_2__c, cTypeList) && projectVal.Subcontractor_Fees_Exceeded__c != 'Yes'){
                    projectVal.SC_Fee_Exceeded__c = (totalApprovedFees - currencyValueInGBP(projectVal.CurrencyIsoCode, projectVal.ffps_0387__Subcontractor_Labour_Cost_2__c, cTypeList)).setScale(2);
                    projectVal.Subcontractor_Fees_Exceeded__c = 'Yes';
                }
                else if((totalApprovedFees + totalPendingApprovalFees) > currencyValueInGBP(projectVal.CurrencyIsoCode, projectVal.ffps_0387__Subcontractor_Labour_Cost_2__c, cTypeList) && projectVal.Subcontractor_Fees_Exceeded__c != 'Potential'){
                    projectVal.SC_Fee_Exceeded__c = ((totalApprovedFees + totalPendingApprovalFees) - currencyValueInGBP(projectVal.CurrencyIsoCode, projectVal.ffps_0387__Subcontractor_Labour_Cost_2__c, cTypeList)).setScale(2);
                    projectVal.Subcontractor_Fees_Exceeded__c = 'Potential';
                }
                else{
                    projectVal.SC_Fee_Exceeded__c = 0.00;
                    projectVal.Subcontractor_Fees_Exceeded__c = null;
                }
                
                if(totalApprovedExpense > currencyValueInGBP(projectVal.CurrencyIsoCode, projectVal.ffps_0387__Subcontractor_Expenses_2__c , cTypeList) && projectVal.Subcontractor_Expense_Exceeded__c != 'Yes'){
                    projectVal.SC_Expense_Exceeded__c = (totalApprovedExpense - currencyValueInGBP(projectVal.CurrencyIsoCode, projectVal.ffps_0387__Subcontractor_Expenses_2__c , cTypeList)).setScale(2);
                    projectVal.Subcontractor_Expense_Exceeded__c = 'Yes';
                }
                else if((totalApprovedExpense + totalPendingApprovalExpense) > currencyValueInGBP(projectVal.CurrencyIsoCode, projectVal.ffps_0387__Subcontractor_Expenses_2__c , cTypeList) && projectVal.Subcontractor_Expense_Exceeded__c != 'Potential'){
                    projectVal.SC_Expense_Exceeded__c = ((totalApprovedExpense + totalPendingApprovalExpense) - currencyValueInGBP(projectVal.CurrencyIsoCode, projectVal.ffps_0387__Subcontractor_Expenses_2__c , cTypeList)).setScale(2);
                    projectVal.Subcontractor_Expense_Exceeded__c = 'Potential';
                }
                else{
                    projectVal.SC_Expense_Exceeded__c = 0.00;
                    projectVal.Subcontractor_Expense_Exceeded__c = null;
                } 
            }
        }
        
        system.debug('projectList after :: '+projectList);
        
        if(projectList.size() > 0){
            update projectList;
        }        
        if(subContractorIdSet.size() >0){
            notifySubcontractor(newList, subContractorIdSet, template);
        }
    }   
    
    private Decimal currencyValueInGBP(String currencycode, Decimal value, List<CurrencyType> cTypeList){
        Decimal convertedValue;
        if(currencycode != 'GBP'){
            for(CurrencyType cTypeVal : cTypeList){
                system.debug('cTypeVal :: '+cTypeVal);
                if(currencycode == cTypeVal.ISOCode){
                    convertedValue = value/cTypeVal.ConversionRate;
                    break;
                }
            }             
        }
        else{
            return value;
        }
        return convertedValue;
    }

    private void notifySubcontractor(List<SubcontractorEngagement__c> newList, Set<Id> subContractorIdSet, String template){
        List<User> userList;
        EmailTemplate emailTemp;
        Messaging.reserveSingleEmailCapacity(20);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Map<Id, List<User>> sunContractorId_ContactEmailList_Map = new Map<Id, List<User>>(); 
        List<SubcontractorEngagement__c> engagementList_DB = [select Id, Name, Subcontractor__c, Project__c, Status__c, CreatedBy.firstname, CreatedBy.lastname/*, Payable_Invoice__c, Payable_Invoice__r.c2g__InvoiceDate__c, 
                                                             Payable_Invoice__r.c2g__InvoiceCurrency__c, Payable_Invoice__r.c2g__InvoiceCurrency__r.Name, 
                                                             Payable_Invoice__r.c2g__AccountInvoiceNumber__c, Payable_Invoice__r.c2g__InvoiceTotal__c*/
                                                             from SubcontractorEngagement__c where id in: newList];
        
        List<User> subContractorUserList = [select Id, name, Email, contact.AccountId, Engagement_Notification__c from User where Engagement_Notification__c = true and contact.AccountId in: subContractorIdSet];
    	system.debug('subContractorUserList :: '+subContractorUserList);
        
        for(User subContractorUserVal : subContractorUserList){
            if(sunContractorId_ContactEmailList_Map.containsKey(subContractorUserVal.contact.AccountId)){                
                userList = new List<User>();
                userList.addAll(sunContractorId_ContactEmailList_Map.get(subContractorUserVal.contact.AccountId));
                userList.add(subContractorUserVal);
                system.debug('userList :: '+userList);
                sunContractorId_ContactEmailList_Map.put(subContractorUserVal.contact.AccountId, userList);
            }
            else{
                sunContractorId_ContactEmailList_Map.put(subContractorUserVal.contact.AccountId, new List<User>{subContractorUserVal});
            }
            //emailList.clear();
        }
        
        system.debug('sunContractorId_ContactEmailList_Map :: '+sunContractorId_ContactEmailList_Map); 
        //if(!test.isRunningTest()){
            emailTemp = [Select e.Subject, e.BrandTemplateId, e.Name, e.DeveloperName, e.Id, e.HtmlValue, e.Description, e.Body From EmailTemplate e where DeveloperName =: template];
        //}
        //else{
        //    emailTemp = [Select e.Subject, e.BrandTemplateId, e.Name, e.DeveloperName, e.Id, e.HtmlValue, e.Description, e.Body From EmailTemplate e where Id = '00Xa0000002WsFy'];
        //}
        system.debug('emailTemp :: '+emailTemp); 
        
        for(SubcontractorEngagement__c newVal : engagementList_DB){   
            system.debug('Inside 1');
            if(sunContractorId_ContactEmailList_Map.size() > 0){
                system.debug('Inside 2');
                for(User usrVal : sunContractorId_ContactEmailList_Map.get(newVal.Subcontractor__c)){   
                    system.debug('Inside 3');
                    List<String> toaddresses = new List<String>();
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    toaddresses.add(usrVal.email);
                    system.debug('toaddresses :: '+toaddresses);
                    system.debug('mail 1 :: '+mail); 
                    //mail.setTemplateId = emailTemp.Id;
                    mail.setReplyTo('consultants@riskadvisory.com');
                    system.debug('mail 2 :: '+mail); 
                    mail.setSaveAsActivity(false);
                    system.debug('mail 3 :: '+mail); 
                    mail.setTargetObjectId(usrVal.Id);
                    system.debug('mail 4 :: '+mail); 
                    if(template == 'New_project_request_from_Risk_Advisory1'){                        
                    	mail.setHtmlBody(emailTemp.HtmlValue.replace('%Username%', usrVal.Name).replace('%createdBy%', newVal.CreatedBy.firstname + ' '+newVal.CreatedBy.lastname).replace('%EngagementId%', '<a href="'+Label.Consultant_Community_Domain+'/'+newVal.Id+'?retURL=subcontractor/'+newVal.Id+'">here</a>')); 
                        system.debug('mail 5 :: '+mail); 
                    }
                    /*else if(template == 'Engagement_paid_email_for_subcontractor'){
                        mail.setHtmlBody(emailTemp.HtmlValue.replace('%Username%', usrVal.Name).replace('%Paymentdate%', String.valueOf(newVal.Payable_Invoice__r.c2g__InvoiceDate__c)).replace('%Paymentcurrency%', newVal.Payable_Invoice__r.c2g__InvoiceCurrency__r.Name).replace('%Vendorinvoicenumber%', newVal.Payable_Invoice__r.c2g__AccountInvoiceNumber__c).replace('%Engagementname%', newVal.name).replace('%Paymentamount%', newVal.Payable_Invoice__r.c2g__InvoiceCurrency__r.Name+' '+String.valueOf(newVal.Payable_Invoice__r.c2g__InvoiceTotal__c)).replace('%EngagementId%', '<a href="'+Label.LUMA_Community_Domain+'/subcontractor/'+newVal.Id+'">here.</a>')); 
                        system.debug('mail 6 :: '+mail); 
                    }*/
                    mail.setPlainTextBody(emailTemp.Body);
                    system.debug('mail 7 :: '+mail); 
                    mail.setSubject(emailTemp.Subject.replace('%Engagementname%', newVal.name));
                    system.debug('mail 8 :: '+mail); 
                    allmsg.add(mail);                
                    system.debug('mail 9 :: '+mail); 
                }
            }
        }
        system.debug('allmsg :: '+allmsg);
        Messaging.sendEmail(allmsg);      
    }    
}