public with sharing class WLSearchAlertsController {
    
    public Map<Watchlist_Search__c, List<Watchlist_Search_Result__c>> search_relatedSearchResults_Map {set;} 
    public String accId {get;set;}
    public Id lumaAccountId  {get;set;}
    public String country = null;
	public String selectedAction {get; set;}
    public Id watchlistresult{get; set;}
    public Id watchlistsearchId{get; set;} 
    public Map<Id, List<Watchlist_Search_Result__c>> search_relatedSearchResults_Map1;
    public String reRenderColumn {get;set;} 
    
    public String getCountry() {
        return country;
    }
    public void setCountry(String country) { this.country = country; }
	
    public Pagereference getActionValue(){
        system.debug('selectedAction :: '+selectedAction);
        system.debug('watchlistresult :: '+watchlistresult);
    	reRenderColumn = 'resCol'; 
        DDUtility.selectedAction(watchlistresult, selectedAction);   
        
        return null;        
    }  
    
    public Pagereference markComplete(){
        system.debug('watchlistsearchId :: '+watchlistsearchId);
        Pagereference pageRef = DDUtility.markComplete(watchlistsearchId, 'alert');
        return pageRef;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('01','Match'));
        options.add(new SelectOption('02','No Match'));
        options.add(new SelectOption('03','Potential'));   
        return options;
    }
    
    public WLSearchAlertsController() {         
        accId = ApexPages.currentPage().getParameters().get('accId'); 
        system.debug('accId :: '+accId);
        lumaAccountId = [select Id, parentId from Account where Id =: accId].parentId;     
        //search_relatedSearchResults_Map1 = new Map<Id, List<Watchlist_Search_Result__c>>();
        system.debug('lumaAccountId :: '+lumaAccountId);         
    }
            
    public ApexPages.StandardSetController con {        
        get {
            if(con == null) {  
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select w.truncated__c, w.total_hits__c, w.search_type__c, w.record_type__c, w.id_type_value__c, w.id_type_key__c, w.hits_to__c, lastmodifieddate__c,                                                  
                                                  w.Watchlist_Search_Subject__c, w.SystemModstamp, w.Number_of_hits__c, w.Name__c, w.Name, w.Middle_Name__c, w.Last_searched__c, is_Recurring_Search__c ,
                                                  w.Last_Name__c, w.LastModifiedDate, w.LastModifiedById, w.IsDeleted, w.Id, w.First_Name__c, w.Entity_Name__c, w.Email__c, w.Date_of_Birth__c,
                                                  w.CurrencyIsoCode, w.CreatedDate, w.CreatedById, w.ConnectionSentId, w.ConnectionReceivedId, w.Analysis_completed__c, Account__r.name
                                                  From Watchlist_Search__c w where  total_hits__c > 0 and Analysis_completed__c = false 
                                                                                    and is_Recurring_Search__c = true and temp__c = false order by createddate desc]));                                
                system.debug('con :: '+con);    
                // sets the number of records in each page set 
                con.setPageSize(Integer.valueOf(Label.Watchlist_alert_pagination_size)); 
            }
            return con;
        }
        set;
    }
    
    public List<WLSearchAlertWrapper> watchlistAlerts {         
        get {
            Map<Id, List<Watchlist_Search_Result__c>> search_relatedSearchResults_Map1 = new Map<Id, List<Watchlist_Search_Result__c>>();
            for(Watchlist_Search__c wls : [Select w.truncated__c, w.total_hits__c, w.search_type__c, 
                                                  w.record_type__c, w.id_type_value__c, w.id_type_key__c, 
                                                  w.hits_to__c, lastmodifieddate__c, is_Recurring_Search__c,                                                  
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
                                                   Researcher_comments__c, lastmodifieddateformatted__c From Watchlist_Search_Results__r 
                                                   where temp__c = false) 
                                                   From Watchlist_Search__c w where total_hits__c > 0 and is_Recurring_Search__c = true
                                       and Analysis_completed__c = false and temp__c = false order by createddate desc]){
                                           if(wls != null)
                                           search_relatedSearchResults_Map1.put(wls.Id, wls.Watchlist_Search_Results__r);
                                       }    
        system.debug('search_relatedSearchResults_Map1 inside constructor :: '+search_relatedSearchResults_Map1);
            watchlistAlerts = new List<WLSearchAlertWrapper>();                 
            for (Watchlist_Search__c wlsearch : (List<Watchlist_Search__c>)con.getRecords()){                
               if(!wlsearch.Analysis_completed__c && wlsearch.is_Recurring_Search__c){
                    watchlistAlerts.add(new WLSearchAlertWrapper(wlsearch, search_relatedSearchResults_Map1.get(wlsearch.Id)));
               }
            }           
            system.debug('watchlistAlerts :: '+watchlistAlerts);            
            return watchlistAlerts;
        }
        set;
    }
    
    public class WLSearchAlertWrapper {        
        public Watchlist_Search__c wlSearch {get;set;}
        public List<Watchlist_Search_Result__c> wlSearchResultList {get;set;}
               
        public WLSearchAlertWrapper(Watchlist_Search__c wlSearch, List<Watchlist_Search_Result__c> wlSearchResultList){
            this.wlSearch = wlSearch;
            this.wlSearchResultList = wlSearchResultList;
        }               
    }
    
    // returns the first page of records
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