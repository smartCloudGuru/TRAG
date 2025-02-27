public with sharing class WLSearchAlertMoreResultsController {
    
    public String accId {get;set;}
    public Id lumaAccountId  {get;set;}
    public String selectedAction {get; set;}
    public Id watchlistresult{get; set;}
    public Id watchlistsearchId{get; set;} 
	public String reRenderColumn {get;set;}  
	Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public integer counter {get;set;}
    public integer total_size;
    public boolean analysed {get; set;}
    private integer list_size=Integer.valueOf(Label.Watchlist_result_pagination_size);    
    public Integer count {get; set;}
    
    public string selectedPage{
        get;
        set{selectedPage=value;}
    }

    public Pagereference getActionValue(){
        system.debug('selectedAction :: '+selectedAction);
        system.debug('watchlistresult :: '+watchlistresult);
        reRenderColumn = 'resCol';        
    	DDUtility.selectedAction(watchlistresult, selectedAction);           
        return null;        
    }  
    
    public Pagereference markComplete(){
        system.debug('watchlistsearchId :: '+watchlistsearchId);
        Pagereference pageRef = DDUtility.markComplete(watchlistsearchId, 'moreresult');
        return pageRef;
    }
    
    public WLSearchAlertMoreResultsController() { 
		analysed = false;        
        accId = ApexPages.currentPage().getParameters().get('accId'); 
        system.debug('accId :: '+accId);
        watchlistsearchId = ApexPages.currentPage().getParameters().get('searchId'); 
        system.debug('watchlistsearchId :: '+watchlistsearchId);
        lumaAccountId = [select Id, parentId from Account where Id =: accId].parentId;     
        //search_relatedSearchResults_Map1 = new Map<Id, List<Watchlist_Search_Result__c>>();
        system.debug('lumaAccountId :: '+lumaAccountId);      
        String analysedParam = ApexPages.currentPage().getParameters().get('analysed');
        if(!String.isEmpty(analysedParam)){
            analysed = Boolean.valueOf(analysedParam);
        }
        if(ApexPages.currentPage().getParameters().get('counter') != null && Integer.valueOf(ApexPages.currentPage().getParameters().get('counter')) > 1){
            counter = Integer.valueOf(ApexPages.currentPage().getParameters().get('counter'));
        }
       else{
            counter = 0;
       }  
        total_size = [select count() From Watchlist_Search_Result__c where Watchlist_Search__c =: watchlistsearchId]; //set the total size in the constructor
        system.debug('total_size :: '+total_size);
        selectedPage='0';
        count = 1; 
    }        
    
    public List<Watchlist_Search_Result__c> getRelatedSearchResults(){
        List<Watchlist_Search_Result__c> relatedSearchResultsList;
        system.debug('selectedPage :: '+selectedPage);
        system.debug('Counter val :: '+ApexPages.currentPage().getParameters().get('counter'));
        if (selectedPage != '0')
            counter = list_size*integer.valueOf(selectedPage)-list_size;
        
        try { 
            relatedSearchResultsList = [Select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                        SystemModstamp,  ConnectionReceivedId, ConnectionSentId, Watchlist_Search__c, 
                                        Watchlist_Search__r.Account__r.name, Watchlist_Search__r.record_type__c,
                                        Address_Details__c, api_version__c,
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
                                        Researcher_comments__c From Watchlist_Search_Result__c where Watchlist_Search__c =: watchlistsearchId limit :list_size
                                        offset :counter];
        }
        catch (QueryException e) {                            
            ApexPages.addMessages(e);                   
            return null;
        }        
        system.debug('relatedSearchResultsList :: '+relatedSearchResultsList);
        return relatedSearchResultsList;
        //return DDUtility.getRelatedSearchResults(currentSearch.Id);
    }       
    
    public Component.Apex.pageBlockButtons getMyCommandButtons() {
        Set<string> theSet = new Set<string>();
        theSet.add('myPanel');
        theSet.add('myButtons');
        integer totalPages;
        if (math.mod(total_size, list_size) > 0) {
            totalPages = total_size/list_size + 1;
        } else {
            totalPages = (total_size/list_size);
        }
        integer currentPage;        
        if (selectedPage == '0') {
        	currentPage = counter/list_size + 1;
        } else {
        	currentPage = integer.valueOf(selectedPage);
        }
        Component.Apex.pageBlockButtons pbButtons = new Component.Apex.pageBlockButtons();        
        pbButtons.location = 'top';
        pbButtons.id = 'myPBButtons';
        
        Component.Apex.outputPanel opPanel = new Component.Apex.outputPanel();
        opPanel.id = 'myButtons';
                                
		//the Previous button will alway be displayed
        Component.Apex.commandButton b1 = new Component.Apex.commandButton();
        b1.expressions.action = '{!Previous}';
        if (counter>0) 
             b1.rendered = true; 
        else  b1.rendered = false;
        b1.title = 'Previous';
        b1.value = 'Previous';
        b1.expressions.disabled = '{!disablePrevious}';        
        b1.reRender = theSet;

        opPanel.childComponents.add(b1);        
                        
        for (integer i=0;i<totalPages;i++) {
            Component.Apex.commandButton btn = new Component.Apex.commandButton();
            
            if (i+1==1) {
	            btn.title = 'First Page';
	            btn.value = 'First Page';
	            btn.rendered = true;	          	                      	
            } else if (i+1==totalPages) {
	            btn.title = 'Last Page';
	            btn.value = 'Last Page';
	            btn.rendered = true;	                      	
            } else {
	            btn.title = 'Page ' + string.valueOf(i+1) + ' ';
	            btn.value = ' ' + string.valueOf(i+1) + ' ';
	            btn.rendered = false;	          
            }
            
            if (   (i+1 <= 5 && currentPage < 5)
                || (i+1 >= totalPages-4 && currentPage > totalPages-4)
                || (i+1 >= currentPage-2 && i+1 <= currentPage+2))
            {
            	btn.rendered = true;
            }
        	        	        	 
        	if (i+1==currentPage) {
        		btn.disabled = true; 
        		btn.style = 'color:blue;';
    		}  
			
			btn.onclick = 'queryByPage(\''+string.valueOf(i+1)+'\');return false;';
			     
            opPanel.childComponents.add(btn);
            
            if (i+1 == 1 || i+1 == totalPages-1) { //put text after page 1 and before last page
            	Component.Apex.outputText text = new Component.Apex.outputText();
	        	text.value = '...';        
    	    	opPanel.childComponents.add(text);
            } 
        }
        //the Next button will alway be displayed
        Component.Apex.commandButton b2 = new Component.Apex.commandButton();
        b2.expressions.action = '{!Next}';
        if (counter + list_size < total_size) 
             b2.rendered = true; 
        else  b2.rendered = false;
        
        b2.title = 'Next';
        b2.value = 'Next';
        b2.expressions.disabled = '{!disableNext}';        
        b2.reRender = theSet;
        opPanel.childComponents.add(b2);
        		
		//add all buttons as children of the outputPanel        		
		pbButtons.childComponents.add(opPanel);  
  
        return pbButtons;
    }
    
   public PageReference refreshGrid() { //user clicked a page number        
        system.debug('**** ' + selectedPage);
        return null;
    }
    
    public PageReference Previous() { //user clicked previous button
    	selectedPage = '0';
        counter -= list_size;
        return null;
    }

    public PageReference Next() { //user clicked next button
    	selectedPage = '0';
        counter += list_size;
        return null;
    }

    public PageReference End() { //user clicked end
    	selectedPage = '0';
        counter = total_size - math.mod(total_size, list_size);
        return null;
    }
    
    public Boolean getDisablePrevious() { //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }

    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_size < total_size) return false; else return true;
    }

    public Integer getTotal_size() {
        return total_size;
    }
    
    public Integer getPageNumber() {
        return counter/list_size + 1;
    }

    public Integer getTotalPages() {
        if (math.mod(total_size, list_size) > 0) {
            return total_size/list_size + 1;
        } else {
            return (total_size/list_size);
        }
    }    
}