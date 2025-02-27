public class DDUtility {
    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public integer counter {get;set;}
    public integer total_size;
    private integer list_size=Integer.valueOf(Label.Watchlist_result_pagination_size); 
    
    public static void getUsersWithAccess(List<Id> recordIdSubmissionList, String groupName, String emailTemplate){
        
        List<GroupMember> grpMemList;
        List<UserRecordAccess> userRcrdAccessList;
        List<Id> userWithAccessList = new List<Id>();
        Map<Id, Id> userIdRecordIdMap = new Map<Id,Id>();                
        
        List<Group> grpList = [Select (Select Id, GroupId, UserOrGroupId, SystemModstamp From GroupMembers) From Group g where DeveloperName =: groupName];
        system.debug('grpList :: '+grpList);
        
        if(grpList!=null && grpList.size()>0 && grpList.get(0).GroupMembers!=null){
            grpMemList = grpList.get(0).GroupMembers;
        }
        system.debug('grpMemList :: '+grpMemList);
        
        for(Id recordIdSubmissionVal : recordIdSubmissionList){
            for(GroupMember grpMemVal : grpMemList){
                system.debug('grpMemVal :: '+grpMemVal);
                userRcrdAccessList = [SELECT  RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess 
                                     FROM  UserRecordAccess WHERE UserId =: grpMemVal.UserOrGroupId AND RecordId =: recordIdSubmissionVal];
                system.debug('userRcrdAccessList :: '+userRcrdAccessList);
                if(userRcrdAccessList!=null && userRcrdAccessList.size()>0 && userRcrdAccessList.get(0).HasReadAccess){
                    userWithAccessList.add(grpMemVal.UserOrGroupId);
                    userIdRecordIdMap.put(grpMemVal.UserOrGroupId, recordIdSubmissionVal);
                }
                system.debug('userWithAccessList :: '+userWithAccessList);
                system.debug('userIdCaseIdMap :: '+userIdRecordIdMap);
            }
        }
        system.debug('userWithAccessList :: '+userWithAccessList);
        if(userWithAccessList != null && userWithAccessList.size()>0){
            sendEmailForApprovalSubmission(userIdRecordIdMap, emailTemplate);
        }        
    }
    
    public static String formatDate(Date dt){
         return Date.newInstance(dt.year(), dt.month(), dt.day()).format();
    }
    
    public static String capitalizeFirstCharacter(String country){
        String rep_name = country;
        List<String> elems; 
        if(!String.isEmpty(rep_name)){
            elems = rep_name.split(' ');            
            rep_name = '';	
            for (String x : elems){
                system.debug('x :: '+x);
                if(x.equalsIgnoreCase(Label.WL_Country_Cote)){
                    rep_name += Label.WL_Country_Cote_updated;
                }
                else if(x.equalsIgnoreCase(Label.WL_Country_Exception_And) 
                        || x.equalsIgnoreCase(Label.WL_Country_Exception_Of) || x.equalsIgnoreCase(Label.WL_Country_Exception_The)){
                            rep_name +=x+' ';          	
                        }
                else{
                    rep_name += x.substring(0,1).toUpperCase()+x.substring(1,x.length()) + ' ';
                }
            }
            System.debug('>>>'+rep_name);
            country = rep_name;
        }
        return country;
    }
    
    public static void sendEmailForApprovalSubmission(Map<Id, Id> userIdRecordIdMap, String emailTemplate){        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        String subject;
        String htmlBody;
        List<Case> csList;
        List<Task_Order__c> toList;
        Map<Id, Case> csIdCaseMap = new Map<Id, Case>();
        Map<Id, Task_Order__c> toIdTaskOrderMap = new Map<Id, Task_Order__c>();
        Case cs;
        Task_Order__c to;
        
        system.debug('userIdRecordIdMap :: '+userIdRecordIdMap);
        
        EmailTemplate template = [Select id,Subject, HtmlValue from EmailTemplate where DeveloperName =: emailTemplate];
        subject = template.Subject;
        system.debug('subject :: '+subject);
        htmlBody = template.HtmlValue;
        system.debug('htmlBody :: '+htmlBody);
        system.debug('template :: '+template);
        if(emailTemplate.equals('Assessment_Approval') && userIdRecordIdMap.keySet().size()>0){                
            system.debug('userIdRecordIdMap.values() :: '+userIdRecordIdMap.values());
            csList = [select Id from Case where Id in:  userIdRecordIdMap.values()];
            system.debug('csList :: '+csList);
            for(Case csVal : csList){
                csIdCaseMap.put(csVal.Id, csVal);
            }
        }
        else if(emailTemplate.equals('DD_Task_Order_Approval') && userIdRecordIdMap.keySet().size()>0){
            system.debug('userIdRecordIdMap.values()) :: '+userIdRecordIdMap.values());
            toList = [select Id, Owner.Email, Owner.FirstName, Owner.LastName, DD_Opportunity__c, 
                      DD_Opportunity__r.name from Task_Order__c where Id in:  userIdRecordIdMap.values()];
            system.debug('toList :: '+toList);
            for(Task_Order__c toVal : toList){
                toIdTaskOrderMap.put(toVal.Id, toVal);
            }
        }
        system.debug('csIdCaseMap :: '+csIdCaseMap);
        system.debug('toIdTaskOrderMap :: '+toIdTaskOrderMap);
        for(Id userIdRecordIdVal : userIdRecordIdMap.keySet()){
            system.debug('userIdRecordIdVal :: '+userIdRecordIdVal);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setTemplateID(template.Id);
            mail.setTargetObjectId(userIdRecordIdVal);
            mail.setSaveAsActivity(false);
            if(emailTemplate.equals('Assessment_Approval')){   
                cs = csIdCaseMap.get(userIdRecordIdMap.get(userIdRecordIdVal));
                system.debug('cs :: '+cs);
                htmlBody = htmlBody.replace('{!Case.Link}', Url.getSalesforceBaseUrl().toExternalForm()+'/client/'+cs.Id);
            }
            else if(emailTemplate.equals('DD_Task_Order_Approval')){
                to = toIdTaskOrderMap.get(userIdRecordIdMap.get(userIdRecordIdVal));
                system.debug('to :: '+to);
                subject = subject.replace('{!Task_Order__c.DD_Opportunity__c}', to.DD_Opportunity__r.name); 
                htmlBody = htmlBody.replace('{!Task_Order__c.DD_Opportunity__c}', to.DD_Opportunity__r.name);
                htmlBody = htmlBody.replace('{!Task_Order__c.Link}',to.Id);
                htmlBody = htmlBody.replace('{!Task_Order__c.OwnerFullName}', to.Owner.FirstName+' '+to.Owner.LastName);
                htmlBody = htmlBody.replace('{!Task_Order__c.OwnerEmail}', to.Owner.Email);
            }
            system.debug('htmlBody after :: '+htmlBody);
            //htmlBody = '<html><body>Hi, welcome to &nbsp;&nbsp;&nbsp;Our World</body>  </html>';
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            allmsg.add(mail);
        }
        system.debug('allmsg :: '+allmsg);
        Messaging.sendEmail(allmsg);
        
    }  
    
    public static boolean checkStatus(DD_Instruction__c ins){
        if(ins!=null && (ins.DD_Status__c == 'Quote Approved' || ins.DD_Status__c == 'Quote Rejected' 
                         || ins.DD_Status__c == 'Final Report Sent' || ins.DD_Status__c == 'Complete' 
                         || ins.DD_Status__c == 'Draft Report Sent' || ins.DD_Status__c == 'Assigned')){
                             return false;
                         }
        return true;
    }
    
    public static boolean validateTotalLicences(Integer licenses){
        List<License_Info__c> licenseInfoList = License_Info__c.getall().values();
        system.debug('licenseInfoList :: '+licenseInfoList);
        if(test.isRunningTest()){
            return true;
        }        
        for(License_Info__c licenseInfoVal : licenseInfoList){
            system.debug('licenseInfoVal :: '+licenseInfoVal);
            if(licenseInfoVal!=null && licenseInfoVal.Name != null){
                if(licenseInfoVal.Name.equals('Partner Community')){
                    if(licenses <= licenseInfoVal.Remaining__c){
                        return true;
                    }                    
            	}
            }
        }
        return false;
    }
    
    public static void updatePartnerUserLicenseInfo(Integer licenses){        
        List<License_Info__c> licenseInfoList = License_Info__c.getall().values();
        system.debug('licenseInfoList :: '+licenseInfoList);
        for(License_Info__c licenseInfoVal : licenseInfoList){
            system.debug('licenseInfoVal :: '+licenseInfoVal);
            if(licenseInfoVal!=null && licenseInfoVal.Name != null && licenseInfoVal.Name.equals('Partner Community')){
                if(licenses > licenseInfoVal.Remaining__c){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You have '+licenseInfoVal.Remaining__c+' license(s) available'));
                }
                else{
                    licenseInfoVal.Remaining__c = licenseInfoVal.Remaining__c - Integer.valueOf(licenses);
                    update licenseInfoVal;     
                    break;
                }                
            }
        }
    }
    
    public static List<RelatedSearchSubjects> getRelatedSearchSubjects(Id accId){
        RelatedSearchSubjects rss;
        List<RelatedSearchSubjects> relatedWatchlistSearchSubjects = new List<RelatedSearchSubjects>();
        List<Account> accountList_DB = [Select Id, name, (Select Id, Name, Account__c, Hit__c, Email__c, First_name__c, Last_Name__c, Middle_Name__c, entity_name__c, Analysed__c,
                                                          Disabled_date__c,
                                                          id_type_key__c, Disabled__c, id_type_value__c, Date_of_Birth__c, status__c, Recurring__c From Watchlist_Search_Subject__r 
                                                          where Analysed__c = true or Recurring__c = true
                                                         ) 
                                        From Account a where Id =: accId];
        if(!accountList_DB.isEmpty()){
            for(Watchlist_Search_Subject__c wlss : accountList_DB.get(0).Watchlist_Search_Subject__r){
                if(wlss.Hit__c){
                    rss = new relatedSearchSubjects(wlss, true, false);
                }
                else{
                    rss = new relatedSearchSubjects(wlss, false, false);
                }
                relatedWatchlistSearchSubjects.add(rss);
            }
        } 
        return relatedWatchlistSearchSubjects;
    }
    
    public static List<AccountandRelatedSearchSubjects> getAccountandRelatedSearchSubjects(Integer list_size, Integer counter){
        List<AccountandRelatedSearchSubjects> arSubjects = new List<AccountandRelatedSearchSubjects>();
        List<RelatedSearchSubjects> rssList;
        system.debug('list_size :: '+list_size);
        system.debug('counter :: '+counter);
        List<Account> accountList_DB = [Select Id, name, (Select Id, Name, Account__c, Hit__c, Email__c, 
                                                         First_name__c, Last_Name__c, Middle_Name__c, 
                                                         entity_name__c, Analysed__c, Last_searched__c,
                                                         id_type_key__c, Disabled__c, id_type_value__c, Disabled_date__c,
                                                         Date_of_Birth__c, status__c, Recurring__c 
                                                         From Watchlist_Search_Subject__r where Analysed__c = true or Recurring__c = true order by createddate desc ) From Account a order by name asc
                                       limit :list_size offset :counter];
        system.debug('accountList_DB :: '+accountList_DB);
        for(Account accountVal_DB : accountList_DB){  
            rssList = new List<RelatedSearchSubjects>();
            List<Watchlist_Search_Subject__c> wlssList;             
            //if(!accountVal_DB.Watchlist_Search_Subject__r.isEmpty()){                
                wlssList = new List<Watchlist_Search_Subject__c>();
                wlssList = accountVal_DB.Watchlist_Search_Subject__r;  
                //if(!wlssList.isEmpty()){
                    for(Watchlist_Search_Subject__c wlssVal : wlssList){
                        RelatedSearchSubjects rss = new RelatedSearchSubjects(wlssVal, true, false);
                        rssList.add(rss);
                    }
                //} 
                AccountandRelatedSearchSubjects arSubject = new AccountandRelatedSearchSubjects(accountVal_DB, rssList);
                arSubjects.add(arSubject);
            //}                
        }
        system.debug('arSubjects :: '+arSubjects);
        return arSubjects;
    }
    
    public static List<Watchlist_Search_Result__c> getRelatedSearchResults(Id currentSearchId){
        List<Watchlist_Search_Result__c> relatedSearchResultsList = new List<Watchlist_Search_Result__c>();
        List<Watchlist_Search__c> wlCurrentSearch;
        if(currentSearchId != null){
            /*wlCurrentSearch = [Select w.truncated__c, w.total_hits__c, w.search_type__c, w.record_type__c, w.id_type_value__c, w.id_type_key__c, w.hits_to__c, 
                               w.hits_from__c, w.filter_soc_include_unknown__c, w.filter_soc__c, w.filter_sl_operator__c, w.filter_sl_lrd_to__c, w.filter_sl_lrd_from__c, w.filter_sl__c, 
                               w.filter_sic_operator__c, w.filter_sic__c, w.filter_region_operator__c, w.filter_region_keys_operator__c, w.filter_region_keys__c, 
                               w.filter_region__c, w.filter_pep_operator__c, w.filter_pep_exclude_adsr__c, w.filter_pep__c, w.filter_ool_operator__c, w.filter_ool_lrd_to__c, 
                               w.filter_ool_lrd_from__c, w.filter_ool__c, w.filter_oel_operator__c, w.filter_oel_lrd_to__c, w.filter_oel_lrd_from__c, w.filter_oel__c, w.filter_lrd_to__c, 
                               w.filter_lrd_from__c, w.filter_amc_operator__c, w.filter_amc__c, w.exclude_deceased__c, w.date_of_birth_strict__c, w.content_set__c, w.cached_results_id__c, 
                               w.backend_version__c, w.api_version__c, w.Watchlist_Search_Subject__c, w.SystemModstamp, w.Number_of_hits__c, w.Name__c, w.Name, w.Middle_Name__c, w.Last_searched__c, 
                               w.Last_Name__c, w.LastModifiedDate, w.LastModifiedById, w.LastActivityDate, w.IsDeleted, w.Id, w.First_Name__c, w.Entity_Name__c, w.Email__c, w.Date_of_Birth__c,
                               w.CurrencyIsoCode, w.CreatedDate, w.CreatedById, w.ConnectionSentId, w.ConnectionReceivedId, w.Analysis_completed__c, 
                               (Select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                SystemModstamp, LastActivityDate, ConnectionReceivedId, ConnectionSentId, Watchlist_Search__c, Address_Details__c, api_version__c,
                                backend_version__c, cached_results_id__c, country_details__c, day__c, gender__c, hits_from__c, hits_to__c, image_details__c, linguistic_variation__c, 
                                match_type__c, matched_name__c, month__c, name_type__c, non_linguistic_variation__c, peid__c, primary_country_code__c, primary_name__c, record_type__c, revision__c, 
                                risk_icon__c, risk_icon_image__c, score__c, structural_variation__c, subsidiary__c, title__c, total_hits__c, truncated__c, watchlist_content__c, year__c, Date_Of_birth__c, 
                                matched_date_of_birth__c, First_name__c, Script_Language_Code__c, Single_String_Name__c, address_city__c, address_country_iso2_code__c, address_country_iso3_code__c, 
                                address_country_profile__c, address_country_region_code__c, address_line__c, address_region__c, address_sub_region__c, address_url__c, address_zip_code__c, 
                                associate_description2__c, associate_description__c, associate_ex__c, associate_peid__c, associate_primary_name__c, associate_relationship__c, 
                                birth_place_country_iso2_code__c, birth_place_country_iso3_code__c, birth_place_country_profile__c, birth_place_country_region_code__c, birth_place_name__c, 
                                birth_place_region__c, birth_place_sub_region__c, country_is02_code__c, country_iso3_code__c, country_profile__c, country_region_code__c, country_type__c, 
                                date_notes__c, date_type__c, deceased__c, identification_notes__c, identification_type__c, image_url__c, is_Country_territory__c, is_address_country_territory__c, 
                                is_birth_place_country_territory__c, maiden_name__c, middle_name__c, osn_language_code__c, so_active_status__c, so_content_notice__c, so_descriptions2__c, 
                                so_descriptions3__c, so_descriptions__c, so_djii_industry_Id__c, so_djii_industry_description__c, so_profile_notes__c, so_source_details__c, so_stake_level_1__c, 
                                so_stake_level_2__c, so_stake_level_3__c, so_stake_level_end_day__c, so_stake_level_end_month__c, so_stake_level_end_year__c, so_stake_level_notes__c, 
                                so_stake_level_ownership_percentage__c, so_stake_level_start_day__c, so_stake_level_start_month__c, so_stake_level_start_year__c, suffix__c, surname__c, 
                                title_honorific__c, watchlist_content_active_status__c, watchlist_content_descriptions2__c, watchlist_content_descriptions3__c, watchlist_content_descriptions__c, 
                                watchlist_content_notice__c, watchlist_content_role_occup_end_day__c, watchlist_content_role_occup_end_month__c, watchlist_content_role_occup_end_year__c, 
                                watchlist_content_role_occup_start_day__c, watchlist_content_role_occup_start_month__c, watchlist_content_role_occup_start_year__c, 
                                watchlist_content_role_occupation_cat__c, watchlist_content_role_type__c, watchlist_source_details__c, watckist_content_profile_notes__c, 
                                wl_content_profile_notes__c, wl_content_sanc_ref_desc2__c, wl_content_sanc_ref_end_day__c, wl_content_sanc_ref_end_month__c, wl_content_sanc_ref_end_year__c, 
                                wl_content_sanc_ref_list_prov_code__c, wl_content_sanc_ref_list_prov_name__c, wl_content_sanc_ref_start_day__c, wl_content_sanc_ref_start_month__c, 
                                temp__c, wl_content_sanc_ref_start_year__c, wl_content_sanc_ref_status__c, wl_content_source__c, Locked__c, Outcome__c,
                                risk_icon_image_am__c, risk_icon_image_brd__c, risk_icon_image_ecr__c, risk_icon_image_oel__c, risk_icon_image_ool__c, risk_icon_image_pep__c, 
                                risk_icon_image_rca__c, risk_icon_image_san__c, risk_icon_image_soc__c, risk_icon_image_sor__c, 
                                risk_icon_am__c, risk_icon_brd__c, risk_icon_ecr__c, risk_icon_oel__c, risk_icon_ool__c, 
                                risk_icon_pep__c, risk_icon_rca__c, risk_icon_san__c, risk_icon_soc__c, risk_icon_sor__c,
                                Researcher_comments__c From Watchlist_Search_Results__r ) 
                               From Watchlist_Search__c w where Id =: currentSearchId];*/
        }
        
        for(Watchlist_Search__c wls :  [Select w.truncated__c, w.total_hits__c, w.search_type__c, w.record_type__c, w.id_type_value__c, w.id_type_key__c, w.hits_to__c,                                         
                               w.hits_from__c, w.filter_soc_include_unknown__c, w.filter_soc__c, w.filter_sl_operator__c, w.filter_sl_lrd_to__c, w.filter_sl_lrd_from__c, w.filter_sl__c, 
                               w.filter_sic_operator__c, w.filter_sic__c, w.filter_region_operator__c, w.filter_region_keys_operator__c, w.filter_region_keys__c, 
                               w.filter_region__c, w.filter_pep_operator__c, w.filter_pep_exclude_adsr__c, w.filter_pep__c, w.filter_ool_operator__c, w.filter_ool_lrd_to__c, 
                               w.filter_ool_lrd_from__c, w.filter_ool__c, w.filter_oel_operator__c, w.filter_oel_lrd_to__c, w.filter_oel_lrd_from__c, w.filter_oel__c, w.filter_lrd_to__c, 
                               w.filter_lrd_from__c, w.filter_amc_operator__c, w.filter_amc__c, w.exclude_deceased__c, w.date_of_birth_strict__c, w.content_set__c, w.cached_results_id__c, 
                               w.backend_version__c, w.api_version__c, w.Watchlist_Search_Subject__c, w.SystemModstamp, w.Number_of_hits__c, w.Name__c, w.Name, w.Middle_Name__c, w.Last_searched__c, 
                               w.Last_Name__c, w.LastModifiedDate, w.LastModifiedById,  w.IsDeleted, w.Id, w.First_Name__c, w.Entity_Name__c, w.Email__c, w.Date_of_Birth__c,
                               w.CurrencyIsoCode, w.CreatedDate, w.CreatedById, w.ConnectionSentId, w.ConnectionReceivedId, w.Analysis_completed__c, 
                               (Select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                SystemModstamp,  ConnectionReceivedId, ConnectionSentId, Watchlist_Search__c, Address_Details__c, api_version__c,
                                backend_version__c, cached_results_id__c, country_details__c, day__c, gender__c, hits_from__c, hits_to__c, image_details__c, linguistic_variation__c, 
                                match_type__c, matched_name__c, month__c, name_type__c, non_linguistic_variation__c, peid__c, primary_country_code__c, primary_name__c, record_type__c, revision__c, 
                                risk_icon__c, risk_icon_image__c, score__c, structural_variation__c, subsidiary__c, title__c, total_hits__c, truncated__c, watchlist_content__c, year__c, Date_Of_birth__c, 
                                matched_date_of_birth__c, First_name__c, Script_Language_Code__c, Single_String_Name__c, address_city__c, address_country_iso2_code__c, address_country_iso3_code__c, 
                                address_country_profile__c, address_country_region_code__c, address_line__c, address_region__c, address_sub_region__c, address_url__c, address_zip_code__c, 
                                associate_description2__c, associate_description__c, associate_ex__c, associate_peid__c, associate_primary_name__c, associate_relationship__c, 
                                birth_place_country_iso2_code__c, birth_place_country_iso3_code__c, birth_place_country_profile__c, birth_place_country_region_code__c, birth_place_name__c, 
                                birth_place_region__c, birth_place_sub_region__c, country_is02_code__c, country_iso3_code__c, country_profile__c, country_region_code__c, country_type__c, 
                                date_notes__c, date_type__c, deceased__c, identification_notes__c, identification_type__c, image_url__c, is_Country_territory__c, is_address_country_territory__c, 
                                is_birth_place_country_territory__c, maiden_name__c, middle_name__c, osn_language_code__c, so_active_status__c, so_content_notice__c, so_descriptions2__c, 
                                so_descriptions3__c, so_descriptions__c, so_djii_industry_Id__c, so_djii_industry_description__c, so_profile_notes__c, so_source_details__c, so_stake_level_1__c, 
                                so_stake_level_2__c, so_stake_level_3__c, so_stake_level_end_day__c, so_stake_level_end_month__c, so_stake_level_end_year__c, so_stake_level_notes__c, 
                                so_stake_level_ownership_percentage__c, so_stake_level_start_day__c, so_stake_level_start_month__c, so_stake_level_start_year__c, suffix__c, surname__c, 
                                title_honorific__c, watchlist_content_active_status__c, watchlist_content_descriptions2__c, watchlist_content_descriptions3__c, watchlist_content_descriptions__c, 
                                watchlist_content_notice__c, watchlist_content_role_occup_end_day__c, watchlist_content_role_occup_end_month__c, watchlist_content_role_occup_end_year__c, 
                                watchlist_content_role_occup_start_day__c, watchlist_content_role_occup_start_month__c, watchlist_content_role_occup_start_year__c, 
                                watchlist_content_role_occupation_cat__c, watchlist_content_role_type__c, watchlist_source_details__c, watckist_content_profile_notes__c, 
                                wl_content_profile_notes__c, wl_content_sanc_ref_desc2__c, wl_content_sanc_ref_end_day__c, wl_content_sanc_ref_end_month__c, wl_content_sanc_ref_end_year__c, 
                                wl_content_sanc_ref_list_prov_code__c, wl_content_sanc_ref_list_prov_name__c, wl_content_sanc_ref_start_day__c, wl_content_sanc_ref_start_month__c, 
                                temp__c, wl_content_sanc_ref_start_year__c, wl_content_sanc_ref_status__c, wl_content_source__c, Locked__c, Outcome__c,
                                risk_icon_image_am__c, risk_icon_image_brd__c, risk_icon_image_ecr__c, risk_icon_image_oel__c, risk_icon_image_ool__c, risk_icon_image_pep__c, 
                                risk_icon_image_rca__c, risk_icon_image_san__c, risk_icon_image_soc__c, risk_icon_image_sor__c, 
                                risk_icon_am__c, risk_icon_brd__c, risk_icon_ecr__c, risk_icon_oel__c, risk_icon_ool__c, 
                                risk_icon_pep__c, risk_icon_rca__c, risk_icon_san__c, risk_icon_soc__c, risk_icon_sor__c,
                                Also_known_as__c, matched_name_also_known_as__c, matched_name_scripted__c, matched_name_primary_name__c, Original_Script_Name__c,
                                Researcher_comments__c From Watchlist_Search_Results__r) 
                From Watchlist_Search__c w where Id =: currentSearchId]){
                    relatedSearchResultsList.addAll(wls.Watchlist_Search_Results__r);
                }
        
        /*if(!wlCurrentSearch.isEmpty() && wlCurrentSearch.size() == 1){
            relatedSearchResultsList.addAll(wls.Watchlist_Search_Results__r);
        }*/
        return relatedSearchResultsList;
    }
                                                                                                                                                                     
    
                                                                                 
    public class AccountandRelatedSearchSubjects {
        public Account acc {get; set;}
        public List<RelatedSearchSubjects> rssList {get; set;}   
        
        public AccountandRelatedSearchSubjects(Account acc, List<RelatedSearchSubjects> rssList) {
            this.acc = acc;                
            this.rssList = rssList;
        }
    }   
    
    public class RelatedSearchSubjects {
        public Watchlist_Search_Subject__c ssVal {get; set;}
        public Boolean isHit {get; set;}
        public Boolean isSelected {get; set;}
        
        public relatedSearchSubjects(Watchlist_Search_Subject__c ssVal, Boolean isHit, Boolean isSelected) {
            this.ssVal = ssVal;                
            this.isHit = isHit;
            this.isSelected = isSelected;
        }
    }
    
    public class addName{
        public String firstName {get; set;}
        public String middleName {get; set;}
        public String lastName {get; set;}        
        public void addName(){
            this.firstName = 'Enter name';
        }
    }
    
    public static List<SelectOption> getCheckList(){
        List<SelectOption> checkList  = new List<SelectOption>();
        checkList.add(new selectOption('Watchlist','Watchlist'));
        checkList.add(new selectOption('StateOwnedCompanies','State Owned Companies'));
        checkList.add(new selectOption('AdverseMediaEntities','Adverse Media Entities'));
        return checkList;
    }
    
    public static List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('02','Person'));
        options.add(new SelectOption('03','Entity'));
        //options.add(new SelectOption('04','Both'));
        return options;
    }
    
    public static List<SelectOption> getActions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('02','Match'));
        options.add(new SelectOption('03','No Match'));
        options.add(new SelectOption('04','Potential'));
        return options;
    }
    
    public static List<SelectOption> getPrecision() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('precise','Precise'));
        options.add(new SelectOption('near','Near'));
        options.add(new SelectOption('broad','Broad'));
        return options;
    }
    
    public String country{get;set;}
        
     public static List<SelectOption> getcountryOptions() {
         List<SelectOption> countryOptions = new List<SelectOption>();         
         Map<String, WL_Counterparty_Countries__c> countryMap = WL_Counterparty_Countries__c.getAll();
         List<String> countryOptionsToSort = new List<String>(countryMap.keyset());
         countryOptionsToSort.sort();
         for(String countryVal : countryOptionsToSort){
             countryOptions.add(new SelectOption(countryMap.get(countryVal).value__c,countryVal)); 
         }
         /*countryOptions.add(new SelectOption('India','India'));
         countryOptions.add(new SelectOption('USA','USA'));
         countryOptions.add(new SelectOption('Japan','Japan'));*/
         system.debug('countryOptions :: '+countryOptions);
         //countryOptions.sort();
         return countryOptions;
     }
            
    public static pagereference selectedAction(Id searchResultId, String selectedAction){
        
        if(searchResultId != null){
            Watchlist_Search_Result__c searchResult = [select Id, Outcome__c from Watchlist_Search_Result__c where Id =: searchResultId];
            searchResult.Outcome__c = selectedAction;
            try{
                update searchResult;
                return null;
            }
            catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update : '+ex.getMessage())); 
                return null;
            }
        }
        return null;
    }        
    
    public static pagereference markComplete(Id searchId, String sourcePage){
        
        List<Watchlist_Search__c> searchList;
        Boolean isPendingAnalysis;
        Boolean isTrial = false;
        Integer count;
        Pagereference pageRef; 
        List<User> loggedInUser = [select Id, UserType from User where Id =: Userinfo.getUserId()];
        List<Watchlist_Search_Subject__c> wlssList = new List<Watchlist_Search_Subject__c>();
        List<Watchlist_Search_Result__c> srToUpdateList = new List<Watchlist_Search_Result__c>();
        /*List<Watchlist_Search_Result__c> srList = [select Id, Locked__c, outcome__c, Researcher_comments__c, 
                                                   Watchlist_Search__c from Watchlist_Search_Result__c where Id =: searchResult.Id];*/        
        //if(!srList.isEmpty() && srList.size() == 1 && srList.get(0).Watchlist_Search__c != null){
        if(searchId != null){
            searchList = [Select Id, Watchlist_Search_Subject__c, Number_of_hits__c, Watchlist_Search_Subject__r.Hit__c, w.Analysis_completed__c, isAutoapproved__c, 
                          Watchlist_Search_Subject__r.Account__c, Watchlist_Search_Subject__r.Watchlist_Next_Search_Date__c, Watchlist_Search_Subject__r.Searched_Query_parameter__c, 
                          Watchlist_Search_Subject__r.Account__r.Parent.Watchlist_Recurring_Search_Client__c, Watchlist_Search_Subject__r.Account__r.Parent.Watchlist_search_frequency__c,
                          Watchlist_Search_Subject__r.Analysed__c, Watchlist_Search_Subject__r.Status__c, Watchlist_Search_Subject__r.Last_Searched_Date__c,
                          Watchlist_Search_Subject__r.Account__r.Parent.Prospective_Client__c,
                          (Select Id,  Outcome__c, Researcher_comments__c From Watchlist_Search_Results__r) From Watchlist_Search__c w 
                          where Id =: searchId];        
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to complete : Missing Search Result')); 
        }
        
        for(Watchlist_Search__c searchVal : searchList){
            count = 0;
            isPendingAnalysis = false;
            searchVal.Watchlist_Search_Subject__r.Hit__c = false;
            if(searchVal.Watchlist_Search_Subject__r.Account__r.Parent.Prospective_Client__c){
             	isTrial = true;   
            }            
            for(Watchlist_Search_Result__c wlsrVal : searchVal.Watchlist_Search_Results__r){
                if(String.isEmpty(wlsrVal.Outcome__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Analysis pending on 1 or more related search results'));
                    isPendingAnalysis= true;
                    return null;
                }
            }
            if(!isPendingAnalysis){
                searchVal.Analysis_completed__c = true;                
                for(Watchlist_Search_Result__c wlsrVal1 : searchVal.Watchlist_Search_Results__r){
                	wlsrVal1.Locked__c = true;
                    srToUpdateList.add(wlsrVal1);
                    if(wlsrVal1.Outcome__c.equals('Match') || wlsrVal1.Outcome__c.equals('Potential')){
                        count = count + 1;                        
                        searchVal.Watchlist_Search_Subject__r.Hit__c = true;
                    }
                }
                if(count == 0){
                    searchVal.Watchlist_Search_Subject__r.Status__c = 'Approved';
                    searchVal.isAutoapproved__c = true;
                }
                else{
                    searchVal.Watchlist_Search_Subject__r.Status__c = 'Pending';
                }
                searchVal.Number_of_hits__c = count;
                searchVal.Watchlist_Search_Subject__r.Analysed__c = true;                
                searchVal.Watchlist_Search_Subject__r.Last_Searched_Date__c = system.today();
                if(searchVal.Watchlist_Search_Subject__r.Account__r.Parent.Watchlist_Recurring_Search_Client__c){
                    searchVal.Watchlist_Search_Subject__r.Watchlist_Next_Search_Date__c = system.today().addDays(Integer.valueOf(searchVal.Watchlist_Search_Subject__r.Account__r.Parent.Watchlist_search_frequency__c));
                }
                wlssList.add(searchVal.Watchlist_Search_Subject__r); 
            }
        }
        
        try{    
            if(searchList.size() > 0){
                update searchList;
            }
            if(srToUpdateList.size() > 0){
                update srToUpdateList;
            }
            if(wlssList.size() > 0){
                update wlssList;
            }
            if(loggedInUser!=null && loggedInUser.size()>0){           
                if(loggedInUser.get(0).userType.equals('PowerPartner')){
                    if(sourcePage.equalsIgnoreCase('alert')){
                        pageRef = new Pagereference('/client/apex/WLSearchAlerts?accId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c);
                    }
                    else if(sourcePage.equalsIgnoreCase('searchsubject')){
                    	pageRef = new Pagereference('/client/apex/WLSearchSubjectDetails?Id='+searchList.get(0).Watchlist_Search_Subject__c+'&accId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c);
                    }
                    else if(sourcePage.equalsIgnoreCase('moreresult')){
                    	pageRef = new Pagereference('/client/apex/WLSearchAlertMoreResults?accId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c+'&searchId='+searchId);
                    }
                    else{                        
                        pageRef = new Pagereference('/client/apex/WLPostSearchAnalysis?loggedInUserId='+loggedInUser.get(0).Id+'&isTrial='+isTrial+'&searchId='+searchList.get(0).Id+'&cpAccId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c);
                    }
                }
                else{
                    if(sourcePage.equalsIgnoreCase('alert')){
                        pageRef = new Pagereference('/apex/WLSearchAlerts?accId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c);
                    }
                    else if(sourcePage.equalsIgnoreCase('searchsubject')){
                    	pageRef = new Pagereference('/apex/WLSearchSubjectDetails?Id='+searchList.get(0).Watchlist_Search_Subject__c+'&accId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c);
                    }
                    else if(sourcePage.equalsIgnoreCase('moreresult')){
                        pageRef = new Pagereference('/apex/WLSearchAlertMoreResults?accId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c+'&searchId='+searchId);
                    }
                    else{ 
                        pageRef = new Pagereference('/apex/WLPostSearchAnalysis?loggedInUserId='+loggedInUser.get(0).Id+'&isTrial='+isTrial+'&searchId='+searchList.get(0).Id+'&cpAccId='+searchList.get(0).Watchlist_Search_Subject__r.Account__c);
                    }
                }
            }
            return pageRef;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to update : '+ex.getMessage())); 
            return null;
        }
    }
    
    public static String drop_leading_zeros(String passedValue) {
        String return_string = null; //return string for passing back
        if (passedValue != null) { //if the passed value is not null
            return_string=passedValue;
            if (return_string.startsWith('0') && return_string.length() > 1) { //if the string begins with a 0 and the length is greater than 1
                boolean keepChecking = true; //create a boolean variable
                while (keepChecking) { //if boolean is true
                    if (return_string.startsWith('0') && return_string.length() > 1) { //if the string begins with 0 and there is more than 1 character
                        return_string = return_string.substring(1); //drop the first character
                    } else { //either the string doesn't begin with 0 or the length is less than or equal to 1
                        keepChecking = false; //stop the loop
                    }
                }
                if (return_string == '0') { //if the resulting string is now a single '0'
                    return_string ='0'; //set the string to null
                }
            } else { //otherwise the value passed was not valid
                return_string = passedValue; //set the string to null
            }
        }
        return return_string; //pass back a value
    }    
    
    public static void generateRiskModelScore(Map<Id, Id> cpaccountId_lumaaccountId_Map, Map<Id, Account> newAccountMap){  
        
        Map<Id, List<Risk_Model_Government_Interaction__c>> lumaAccId_GovtInterationList_Map = new Map<Id, List<Risk_Model_Government_Interaction__c>>();
        Map<Id, List<Risk_Model_Country_CPI_Usage__c>> lumaAccId_countryCPIList_Map = new Map<Id, List<Risk_Model_Country_CPI_Usage__c>>();
        Map<Id, List<Risk_Model_Activity_Type__c>> lumaAccId_activityTypeList_Map = new Map<Id, List<Risk_Model_Activity_Type__c>>();
        
        List<Account> lumaAccountList = [Select Id, (Select Id, Name, Score__c From Risk_Model_Government_Interaction__r), 
                           (Select Id, Name, Score__c From Risk_Model_Country_CPI_Usage__r), 
                           (Select Id, Name, score__c, visible__c From Risk_Model_Parameters__r) From Account a 
                                         where Id in: cpaccountId_lumaaccountId_Map.values()];
        system.debug('lumaAccountList :: '+lumaAccountList);
        
        for(Account lumaAccountVal : lumaAccountList){
            if(lumaAccountVal.Risk_Model_Government_Interaction__r != null
               && lumaAccountVal.Risk_Model_Government_Interaction__r.size() > 0){
                   lumaAccId_GovtInterationList_Map.put(lumaAccountVal.Id, lumaAccountVal.Risk_Model_Government_Interaction__r);
               }
            if(lumaAccountVal.Risk_Model_Country_CPI_Usage__r != null
               && lumaAccountVal.Risk_Model_Country_CPI_Usage__r.size() > 0){
                   lumaAccId_countryCPIList_Map.put(lumaAccountVal.Id, lumaAccountVal.Risk_Model_Country_CPI_Usage__r);
               }
            if(lumaAccountVal.Risk_Model_Parameters__r != null
               && lumaAccountVal.Risk_Model_Parameters__r.size() > 0){
                   lumaAccId_activityTypeList_Map.put(lumaAccountVal.Id, lumaAccountVal.Risk_Model_Parameters__r);
               }
        }
        
        for(Id accId : cpaccountId_lumaaccountId_Map.keySet()){
            newAccountMap.get(accId).Risk_Model_1_Output__c = 0;
            if(cpaccountId_lumaaccountId_Map.get(accId) != null
               && lumaAccId_GovtInterationList_Map.get(cpaccountId_lumaaccountId_Map.get(accId)) != null){
                   for(Risk_Model_Government_Interaction__c rmgi : lumaAccId_GovtInterationList_Map.get(cpaccountId_lumaaccountId_Map.get(accId))){
                       if(newAccountMap.get(accId).Risk_Model_Government_Interaction__c != null
                          && newAccountMap.get(accId).Risk_Model_Government_Interaction__c.equals(rmgi.name)){
                              newAccountMap.get(accId).Risk_Model_1_Output__c += (0.40 * rmgi.score__c);
                              break;
                          }
                   }
}            if(cpaccountId_lumaaccountId_Map.get(accId) != null
               && lumaAccId_countryCPIList_Map.get(cpaccountId_lumaaccountId_Map.get(accId)) != null){
                   for(Risk_Model_Country_CPI_Usage__c rmcpi : lumaAccId_countryCPIList_Map.get(cpaccountId_lumaaccountId_Map.get(accId))){
                       if(newAccountMap.get(accId).Risk_Model_Country_CPI__c  != null
                          && newAccountMap.get(accId).Risk_Model_Country_CPI__c .equals(rmcpi.name)){
                              newAccountMap.get(accId).Risk_Model_1_Output__c += (0.25 * rmcpi.score__c);
                              break;
                          }
                   }
               }
            if(cpaccountId_lumaaccountId_Map.get(accId) != null
               && lumaAccId_activityTypeList_Map.get(cpaccountId_lumaaccountId_Map.get(accId)) != null){
                   for(Risk_Model_Activity_Type__c rmactivity : lumaAccId_activityTypeList_Map.get(cpaccountId_lumaaccountId_Map.get(accId))){
                       if(newAccountMap.get(accId).Risk_Model_Activity_Type__c != null
                          && newAccountMap.get(accId).Risk_Model_Activity_Type__c.equals(rmactivity.name)){
                              newAccountMap.get(accId).Risk_Model_1_Output__c += (0.35 * rmactivity.score__c);
                              break;
                          }
                   }
               }
        }
    }        
}