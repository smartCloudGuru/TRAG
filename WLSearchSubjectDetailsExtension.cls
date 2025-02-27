public with sharing class WLSearchSubjectDetailsExtension {
    
    public String searchSubject;
    public String accId;
    public String lumaAccountId;
    public Pagereference pageRef; 
    public String retURL {get;set;} 
    public String nextPageURL {get;set;} 
    public Watchlist_Search_Subject__c wls;  
    public String selectedAction {get; set;}
    public Id watchlistresult{get; set;}
    public String reRenderColumn {get;set;} 
    public Id watchlistsearchId{get; set;} 
    //public List<SearchSubjectDetails> searchSubjectDetails {get;set;} 
    public String[] countries = new String[]{};        
    
        public String[] getCountries() {
            //If multiselect is false, countries must be of type String 
            return countries;
        }
    
    public void setCountries(String[] countries) {
        //If multiselect is false, countries must be of type String 
        this.countries = countries;
    }  
    
    public Pagereference getActionValue(){
        system.debug('selectedAction :: '+selectedAction);
        system.debug('watchlistresult :: '+watchlistresult);
        reRenderColumn = 'resCol'; 
    	DDUtility.selectedAction(watchlistresult, selectedAction);   
               
        return null;        
    }
    
    public Pagereference markComplete(){ 
        system.debug('this.watchlistsearchId :: '+this.watchlistsearchId);
    	Pagereference pageRef = DDUtility.markComplete(this.watchlistsearchId, 'searchsubject');
        return pageRef;
    }   
    
     public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
         	//options.add(new SelectOption('00','Select'));
            options.add(new SelectOption('01','Match'));
            options.add(new SelectOption('02','No Match'));
            options.add(new SelectOption('03','Potential'));
            return options;
        }
    
    public ApexPages.StandardSetController con {        
        get {
            if(con == null) {  
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select w.truncated__c, w.total_hits__c, w.search_type__c, w.record_type__c, w.id_type_value__c, w.id_type_key__c, 
                                                        w.hits_to__c, w.hits_from__c, w.filter_soc_include_unknown__c, w.filter_soc__c, w.filter_sl_operator__c, 
                                                        w.filter_sl_lrd_to__c, w.filter_sl_lrd_from__c, w.filter_sl__c, w.filter_sic_operator__c, 
                                                        w.filter_sic__c, w.filter_region_operator__c, w.filter_region_keys_operator__c, w.filter_region_keys__c, 
                                                        w.filter_region__c, w.filter_pep_operator__c, w.filter_pep_exclude_adsr__c, w.filter_pep__c, w.filter_ool_operator__c, 
                                                        w.filter_ool_lrd_to__c, w.filter_ool_lrd_from__c, w.filter_ool__c, w.filter_oel_operator__c, w.filter_oel_lrd_to__c, 
                                                        w.filter_oel_lrd_from__c, w.filter_oel__c, w.filter_lrd_to__c, w.filter_lrd_from__c, w.filter_amc_operator__c, 
                                                        w.filter_amc__c, w.exclude_deceased__c, w.date_of_birth_strict__c, w.content_set__c, w.cached_results_id__c, 
                                                        w.backend_version__c, w.api_version__c, w.Watchlist_Search_Subject__c, w.Number_of_hits__c, 
                                                                                    Watchlist_Search_Subject__r.Account__r.Id, Watchlist_Search_Subject__r.Account__r.name,
                                                        w.Name__c, w.Name, w.Middle_Name__c, w.Last_searched__c, w.Last_Name__c, 
                                                        w.First_Name__c, w.Entity_Name__c, w.Email__c, w.Date_of_Birth__c, w.CurrencyIsoCode, w.CreatedDate, w.CreatedById, 
                                                        w.Analysis_completed__c, isAutoapproved__c,
                                                        (Select Id, OwnerId, IsDeleted, Name, lastModifiedDate, lastmodifieddateformatted__c,
                                                        CurrencyIsoCode, RecordTypeId, CreatedDate, Watchlist_Search__c, Address_Details__c, api_version__c, 
                                                         backend_version__c, cached_results_id__c, country_details__c, day__c, gender__c, hits_from__c, hits_to__c, 
                                                         image_details__c, linguistic_variation__c, match_type__c, matched_name__c, month__c, name_type__c, 
                                                         non_linguistic_variation__c, peid__c, primary_country_code__c, primary_name__c, record_type__c, revision__c, 
                                                         risk_icon__c, risk_icon_image__c, score__c, structural_variation__c, subsidiary__c, title__c, total_hits__c, truncated__c, 
                                                         watchlist_content__c, year__c, Date_Of_birth__c, matched_date_of_birth__c, First_name__c, Script_Language_Code__c, 
                                                         Single_String_Name__c, address_city__c, address_country_iso2_code__c, address_country_iso3_code__c, address_country_profile__c, 
                                                         address_country_region_code__c, address_line__c, address_region__c, address_sub_region__c, address_url__c, 
                                                         address_zip_code__c, associate_description2__c, associate_description__c, associate_ex__c, associate_peid__c, 
                                                         associate_primary_name__c, associate_relationship__c, birth_place_country_iso2_code__c, birth_place_country_iso3_code__c, 
                                                         birth_place_country_profile__c, birth_place_country_region_code__c, birth_place_name__c, birth_place_region__c, 
                                                         birth_place_sub_region__c, country_is02_code__c, country_iso3_code__c, country_profile__c, country_region_code__c, 
                                                          date_notes__c, date_type__c, deceased__c, identification_notes__c, identification_type__c, image_url__c, 
                                                         is_Country_territory__c, is_address_country_territory__c, is_birth_place_country_territory__c, maiden_name__c, middle_name__c, 
                                                         osn_language_code__c, so_active_status__c, so_content_notice__c, so_descriptions2__c, so_descriptions3__c, 
                                                         so_descriptions__c, so_djii_industry_Id__c, so_djii_industry_description__c, so_profile_notes__c, so_source_details__c, 
                                                         so_stake_level_1__c, so_stake_level_2__c, so_stake_level_3__c, so_stake_level_end_day__c, so_stake_level_end_month__c, 
                                                         so_stake_level_end_year__c, so_stake_level_notes__c, so_stake_level_ownership_percentage__c, so_stake_level_start_day__c, 
                                                         so_stake_level_start_month__c, so_stake_level_start_year__c, suffix__c, surname__c, title_honorific__c, 
                                                         watchlist_content_active_status__c, watchlist_content_descriptions2__c, watchlist_content_descriptions3__c, 
                                                         watchlist_content_descriptions__c, watchlist_content_notice__c, watchlist_content_role_occup_end_day__c, 
                                                         watchlist_content_role_occup_end_month__c, watchlist_content_role_occup_end_year__c, watchlist_content_role_occup_start_day__c, 
                                                         watchlist_content_role_occup_start_month__c, watchlist_content_role_occup_start_year__c, 
                                                         watchlist_content_role_occupation_cat__c,  watchlist_source_details__c, 
                                                         watckist_content_profile_notes__c, wl_content_profile_notes__c, wl_content_sanc_ref_desc2__c, 
                                                         wl_content_sanc_ref_end_day__c, wl_content_sanc_ref_end_month__c, wl_content_sanc_ref_end_year__c, 
                                                         wl_content_sanc_ref_list_prov_code__c, wl_content_sanc_ref_list_prov_name__c, wl_content_sanc_ref_start_day__c, 
                                                         wl_content_sanc_ref_start_month__c, wl_content_sanc_ref_start_year__c, wl_content_sanc_ref_status__c, wl_content_source__c, 
                                                         Locked__c, Outcome__c,  
                                                         risk_icon_image_am__c, risk_icon_image_brd__c, risk_icon_image_ecr__c, risk_icon_image_oel__c, risk_icon_image_ool__c, risk_icon_image_pep__c, 
                                                   risk_icon_image_rca__c, risk_icon_image_san__c, risk_icon_image_soc__c, risk_icon_image_sor__c, 
                                                   risk_icon_am__c, risk_icon_brd__c, risk_icon_ecr__c, risk_icon_oel__c, risk_icon_ool__c, 
                                                   risk_icon_pep__c, risk_icon_rca__c, risk_icon_san__c, risk_icon_soc__c, risk_icon_sor__c,
                                                         Researcher_comments__c From Watchlist_Search_Results__r),  lastmodifieddate__c From Watchlist_Search__c w where Watchlist_Search_Subject__c =: wls.Id
                                                order by createddate desc]));   
                 con.setPageSize(4); 
            }
            return con;
            }
        set;
    }
    
    public List<SearchSubjectDetails> searchSubjectDetails { 
        get {
            Map<Id, List<Watchlist_Search_Result__c>> search_relatedSearchResults_Map1 = new Map<Id, List<Watchlist_Search_Result__c>>();
            searchSubjectDetails = new List<SearchSubjectDetails>();   
            List<Watchlist_Search_Result__c> searchResultList;
            for(Watchlist_Search__c wls : [Select w.truncated__c, w.total_hits__c, w.search_type__c, 
                                                  w.record_type__c, w.id_type_value__c, w.id_type_key__c, content_set__c,
                                                  w.hits_to__c, lastmodifieddate__c,                                                  
                                                  w.Watchlist_Search_Subject__c, w.SystemModstamp, w.Number_of_hits__c, w.Name__c, w.Name, w.Middle_Name__c, w.Last_searched__c, 
                                                  w.Last_Name__c, w.LastModifiedDate, w.LastModifiedById, w.IsDeleted, w.Id, w.First_Name__c, 
                                                  w.Entity_Name__c, w.Email__c, w.Date_of_Birth__c,
                                                  w.Analysis_completed__c, Account__r.name, 
                                                  (Select Id, OwnerId, Name, RecordTypeId, LastModifiedDate, LastModifiedById, 
                                                   Watchlist_Search__c, Address_Details__c,
                                                   backend_version__c, country_details__c, day__c, gender__c, hits_from__c, hits_to__c, image_details__c, 
                                                   match_type__c, matched_name__c, month__c, name_type__c, non_linguistic_variation__c, peid__c, primary_country_code__c, 
                                                   primary_name__c, record_type__c, revision__c, 
                                                   risk_icon__c, risk_icon_image__c, score__c, structural_variation__c, subsidiary__c, title__c, total_hits__c, truncated__c, 
                                                   watchlist_content__c, year__c, Date_Of_birth__c, 
                                                   matched_date_of_birth__c, First_name__c, Script_Language_Code__c, Single_String_Name__c, address_city__c, address_country_iso2_code__c, 
                                                   address_country_iso3_code__c, 
                                                   address_country_profile__c, address_country_region_code__c, address_line__c, address_region__c, address_sub_region__c, address_url__c, 
                                                   address_zip_code__c, 
                                                   associate_description2__c, associate_description__c, associate_ex__c, associate_peid__c, associate_primary_name__c, 
                                                   associate_relationship__c, 
                                                   birth_place_country_iso2_code__c, birth_place_country_iso3_code__c, birth_place_country_profile__c, 
                                                   birth_place_country_region_code__c, birth_place_name__c, 
                                                   birth_place_region__c, birth_place_sub_region__c, country_is02_code__c, country_iso3_code__c, country_profile__c, 
                                                   country_region_code__c,  
                                                   date_notes__c, date_type__c, deceased__c, identification_notes__c, identification_type__c, image_url__c, 
                                                   is_Country_territory__c, is_address_country_territory__c, 
                                                   is_birth_place_country_territory__c, maiden_name__c, middle_name__c, osn_language_code__c, so_active_status__c, so_content_notice__c, 
                                                   so_descriptions2__c, 
                                                   so_descriptions3__c, so_descriptions__c, so_djii_industry_Id__c, so_djii_industry_description__c, so_profile_notes__c, 
                                                   so_source_details__c, so_stake_level_1__c, 
                                                   so_stake_level_2__c, so_stake_level_3__c, so_stake_level_end_day__c, so_stake_level_end_month__c, so_stake_level_end_year__c, 
                                                   so_stake_level_notes__c, 
                                                   so_stake_level_ownership_percentage__c, so_stake_level_start_day__c, so_stake_level_start_month__c, so_stake_level_start_year__c, 
                                                   suffix__c, surname__c, 
                                                   title_honorific__c, watchlist_content_active_status__c, watchlist_content_descriptions2__c, watchlist_content_descriptions3__c, 
                                                   watchlist_content_descriptions__c, 
                                                   watchlist_content_notice__c, watchlist_content_role_occup_end_day__c, watchlist_content_role_occup_end_month__c, 
                                                   watchlist_content_role_occup_end_year__c, 
                                                   watchlist_content_role_occup_start_day__c, watchlist_content_role_occup_start_month__c, watchlist_content_role_occup_start_year__c, 
                                                   watchlist_content_role_occupation_cat__c,  watchlist_source_details__c, watckist_content_profile_notes__c, 
                                                   wl_content_profile_notes__c, wl_content_sanc_ref_desc2__c, wl_content_sanc_ref_end_day__c, wl_content_sanc_ref_end_month__c, 
                                                   wl_content_sanc_ref_end_year__c, 
                                                   wl_content_sanc_ref_list_prov_code__c, wl_content_sanc_ref_list_prov_name__c, wl_content_sanc_ref_start_day__c, 
                                                   wl_content_sanc_ref_start_month__c, 
                                                   temp__c, wl_content_sanc_ref_start_year__c, wl_content_sanc_ref_status__c, wl_content_source__c, Locked__c, Outcome__c, 
                                                   risk_icon_image_am__c, risk_icon_image_brd__c, risk_icon_image_ecr__c, risk_icon_image_oel__c, risk_icon_image_ool__c, 
                                                   risk_icon_image_pep__c, 
                                                   risk_icon_image_rca__c, risk_icon_image_san__c, risk_icon_image_soc__c, risk_icon_image_sor__c, 
                                                   risk_icon_am__c, risk_icon_brd__c, risk_icon_ecr__c, risk_icon_oel__c, risk_icon_ool__c, 
                                                   risk_icon_pep__c, risk_icon_rca__c, risk_icon_san__c, risk_icon_soc__c, risk_icon_sor__c,
                                                   Researcher_comments__c, lastmodifieddateformatted__c From Watchlist_Search_Results__r ) 
                                                   From Watchlist_Search__c w where Watchlist_Search_Subject__c =: wls.Id
                                                order by createddate desc]){
                                           search_relatedSearchResults_Map1.put(wls.Id, wls.Watchlist_Search_Results__r);
                                       }
            for (Watchlist_Search__c wlsVal_DB : (List<Watchlist_Search__c>)con.getRecords()){
                searchResultList = new List<Watchlist_Search_Result__c>();
                //For(Watchlist_Search_Result__c searchResult : wlsVal_DB.Watchlist_Search_Results__r){
                  //  searchResultList.add(searchResult);
                //}
                searchSubjectDetails.add(new SearchSubjectDetails(wls, wlsVal_DB, search_relatedSearchResults_Map1.get(wlsVal_DB.Id)));               
            }
            
            system.debug('SearchSubjectDetails :: '+SearchSubjectDetails);
            
            return SearchSubjectDetails;
        }
        set;
    }
    
    public class SearchSubjectDetails {
        public Watchlist_Search_Subject__c ssVal {get; set;}
        public Watchlist_Search__c searches {get; set;}
        public List<Watchlist_Search_Result__c> searchResults {get; set;}
        
        public SearchSubjectDetails(Watchlist_Search_Subject__c ssVal, Watchlist_Search__c searches, List<Watchlist_Search_Result__c> searchResults) {
            this.ssVal = ssVal;                
            this.searches = searches;
            this.searchResults = searchResults;
        }
    }
    
    public WLSearchSubjectDetailsExtension(ApexPages.StandardController controller) {
        system.debug('WLSearchSubjectDetailsExtension :: constructor :: start ');
        searchSubject = ApexPages.currentPage().getParameters().get('Id'); 
        accId = ApexPages.currentPage().getParameters().get('accId'); 
        if(accId != null){
            lumaAccountId = [Select Id, ParentId From Account a where Id=: accId].ParentId;
        }
        system.debug('lumaAccountId :: '+lumaAccountId);       
        searchSubjectDetails = new List<SearchSubjectDetails>();
        pageRef = new Pagereference('/client/'+searchSubject);
        wls = (Watchlist_Search_Subject__c)controller.getSubject();
        /*List<Watchlist_Search__c> wlsList_DB = [Select w.truncated__c, w.total_hits__c, w.search_type__c, w.record_type__c, w.id_type_value__c, w.id_type_key__c, 
                                                        w.hits_to__c, w.hits_from__c, w.filter_soc_include_unknown__c, w.filter_soc__c, w.filter_sl_operator__c, 
                                                        w.filter_sl_lrd_to__c, w.filter_sl_lrd_from__c, w.filter_sl__c, w.filter_sic_operator__c, 
                                                        w.filter_sic__c, w.filter_region_operator__c, w.filter_region_keys_operator__c, w.filter_region_keys__c, 
                                                        w.filter_region__c, w.filter_pep_operator__c, w.filter_pep_exclude_adsr__c, w.filter_pep__c, w.filter_ool_operator__c, 
                                                        w.filter_ool_lrd_to__c, w.filter_ool_lrd_from__c, w.filter_ool__c, w.filter_oel_operator__c, w.filter_oel_lrd_to__c, 
                                                        w.filter_oel_lrd_from__c, w.filter_oel__c, w.filter_lrd_to__c, w.filter_lrd_from__c, w.filter_amc_operator__c, 
                                                        w.filter_amc__c, w.exclude_deceased__c, w.date_of_birth_strict__c, w.content_set__c, w.cached_results_id__c, 
                                                        w.backend_version__c, w.api_version__c, w.Watchlist_Search_Subject__c, w.Number_of_hits__c, 
                                                        w.Name__c, w.Name, w.Middle_Name__c, w.Last_searched__c, w.Last_Name__c, 
                                                        w.First_Name__c, w.Entity_Name__c, w.Email__c, w.Date_of_Birth__c, w.CurrencyIsoCode, w.CreatedDate, w.CreatedById, 
                                                        w.Analysis_completed__c, 
                                                        (Select Id, OwnerId, IsDeleted, Name, lastModifiedDate, lastmodifieddateformatted__c,
                                                        CurrencyIsoCode, RecordTypeId, CreatedDate, Watchlist_Search__c, Address_Details__c, api_version__c, 
                                                         backend_version__c, cached_results_id__c, country_details__c, day__c, gender__c, hits_from__c, hits_to__c, 
                                                         image_details__c, linguistic_variation__c, match_type__c, matched_name__c, month__c, name_type__c, 
                                                         non_linguistic_variation__c, peid__c, primary_country_code__c, primary_name__c, record_type__c, revision__c, 
                                                         risk_icon__c, risk_icon_image__c, score__c, structural_variation__c, subsidiary__c, title__c, total_hits__c, truncated__c, 
                                                         watchlist_content__c, year__c, Date_Of_birth__c, matched_date_of_birth__c, First_name__c, Script_Language_Code__c, 
                                                         Single_String_Name__c, address_city__c, address_country_iso2_code__c, address_country_iso3_code__c, address_country_profile__c, 
                                                         address_country_region_code__c, address_line__c, address_region__c, address_sub_region__c, address_url__c, 
                                                         address_zip_code__c, associate_description2__c, associate_description__c, associate_ex__c, associate_peid__c, 
                                                         associate_primary_name__c, associate_relationship__c, birth_place_country_iso2_code__c, birth_place_country_iso3_code__c, 
                                                         birth_place_country_profile__c, birth_place_country_region_code__c, birth_place_name__c, birth_place_region__c, 
                                                         birth_place_sub_region__c, country_is02_code__c, country_iso3_code__c, country_profile__c, country_region_code__c, 
                                                          date_notes__c, date_type__c, deceased__c, identification_notes__c, identification_type__c, image_url__c, 
                                                         is_Country_territory__c, is_address_country_territory__c, is_birth_place_country_territory__c, maiden_name__c, middle_name__c, 
                                                         osn_language_code__c, so_active_status__c, so_content_notice__c, so_descriptions2__c, so_descriptions3__c, 
                                                         so_descriptions__c, so_djii_industry_Id__c, so_djii_industry_description__c, so_profile_notes__c, so_source_details__c, 
                                                         so_stake_level_1__c, so_stake_level_2__c, so_stake_level_3__c, so_stake_level_end_day__c, so_stake_level_end_month__c, 
                                                         so_stake_level_end_year__c, so_stake_level_notes__c, so_stake_level_ownership_percentage__c, so_stake_level_start_day__c, 
                                                         so_stake_level_start_month__c, so_stake_level_start_year__c, suffix__c, surname__c, title_honorific__c, 
                                                         watchlist_content_active_status__c, watchlist_content_descriptions2__c, watchlist_content_descriptions3__c, 
                                                         watchlist_content_descriptions__c, watchlist_content_notice__c, watchlist_content_role_occup_end_day__c, 
                                                         watchlist_content_role_occup_end_month__c, watchlist_content_role_occup_end_year__c, watchlist_content_role_occup_start_day__c, 
                                                         watchlist_content_role_occup_start_month__c, watchlist_content_role_occup_start_year__c, 
                                                         watchlist_content_role_occupation_cat__c,  watchlist_source_details__c, 
                                                         watckist_content_profile_notes__c, wl_content_profile_notes__c, wl_content_sanc_ref_desc2__c, 
                                                         wl_content_sanc_ref_end_day__c, wl_content_sanc_ref_end_month__c, wl_content_sanc_ref_end_year__c, 
                                                         wl_content_sanc_ref_list_prov_code__c, wl_content_sanc_ref_list_prov_name__c, wl_content_sanc_ref_start_day__c, 
                                                         wl_content_sanc_ref_start_month__c, wl_content_sanc_ref_start_year__c, wl_content_sanc_ref_status__c, wl_content_source__c, 
                                                         Locked__c, Outcome__c, 
                                                         risk_icon_image_am__c, risk_icon_image_brd__c, risk_icon_image_ecr__c, risk_icon_image_oel__c, risk_icon_image_ool__c, risk_icon_image_pep__c, 
                                                   risk_icon_image_rca__c, risk_icon_image_san__c, risk_icon_image_soc__c, risk_icon_image_sor__c, 
                                                   risk_icon_am__c, risk_icon_brd__c, risk_icon_ecr__c, risk_icon_oel__c, risk_icon_ool__c, 
                                                   risk_icon_pep__c, risk_icon_rca__c, risk_icon_san__c, risk_icon_soc__c, risk_icon_sor__c,
                                                         Researcher_comments__c From Watchlist_Search_Results__r),  lastmodifieddate__c From Watchlist_Search__c w where Watchlist_Search_Subject__c =: wls.Id
                                                order by createddate desc];*/
       	/*for(Watchlist_Search__c wlsVal_DB : wlsList_DB){                       
            SearchSubjectDetails details = new SearchSubjectDetails(wls, wlsVal_DB, wlsVal_DB.Watchlist_Search_Results__r);   
            searchSubjectDetails.add(details);
            searchSubjectDetails.add(details);
            searchSubjectDetails.add(details);
            searchSubjectDetails.add(details);
            searchSubjectDetails.add(details);
            searchSubjectDetails.add(details);
        }*/
        retURL ='&retURL=/client/WLSearchSubjectDetails?Id='+wls.Id+'&accId='+wls.Account__c;
        system.debug('wls in constructor :: '+wls);
        //populateData();
        system.debug('WLSearchSubjectDetailsExtension :: constructor :: end ');
    }
    
    public Pagereference moveToResultDetailPage(){        
        retURL ='/client/WLSearchSubjectDetails?Id='+wls.Id+'&accId='+wls.Account__c;
        pagereference ref=new PageReference(nextPageURL);
        ref.getParameters().put('retURL', retURL);
        return ref;
        
    }
    
    public Pagereference disableSubject(){      
        wls.Disabled__c = true;
        wls.Disabled_date__c = DDUtility.drop_leading_zeros(system.now().format('dd MMMM yyyy'));
        update wls;
        retURL ='/client/'+wls.Account__c;
        pagereference ref=new PageReference(retURL);  
        ref.setRedirect(true);
        return ref;
        
    }
    
    
	
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         system.debug('con in next :: '+con); 
         con.next();
     }
    
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious(); 
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }        
    
}