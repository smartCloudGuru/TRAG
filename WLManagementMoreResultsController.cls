public class WLManagementMoreResultsController {
    
    public String accId {get;set;}
    public Id lumaAccountId  {get;set;}
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public integer counter {get;set;}
    public integer total_size;
    private integer list_size=3;    
    public Integer count {get; set;}
    public String disableOption {get;set;}  
    public List<Watchlist_Search_Subject__c> selectedSearchSubjects{get;set;}
    public Boolean refreshPage {get; set;}
    public List<RelatedSearchSubjects> rssList{get;set;}
    
    public string selectedPage{
        get;
        set{selectedPage=value;}
    }
    
    public WLManagementMoreResultsController(){
        accId = ApexPages.currentPage().getParameters().get('accId'); 
        system.debug('accId :: '+accId);        
        lumaAccountId = [select Id, parentId from Account where Id =: accId].parentId;     
        system.debug('lumaAccountId :: '+lumaAccountId);      
        selectedSearchSubjects = new List<Watchlist_Search_Subject__c>();    
        //rssList = new List<RelatedSearchSubjects>();
        if(ApexPages.currentPage().getParameters().get('counter') != null && Integer.valueOf(ApexPages.currentPage().getParameters().get('counter')) > 1){
            counter = Integer.valueOf(ApexPages.currentPage().getParameters().get('counter'));
        }
        else{
            counter = 0;
        }  
        total_size = [select count() From Watchlist_Search_Subject__c where Analysed__c = true and Account__c =: accId]; 
        system.debug('total_size :: '+total_size);
        selectedPage='0';
        count = 1; 
        
    }
    
     public Pagereference prevPage1(){
        Pagereference pg = new Pagereference('/client/WLManagement');              
        pg.setRedirect(true);
        return pg;
    }
    
    public List<RelatedSearchSubjects> getRelatedSearchSubject(){
        rssList = new List<RelatedSearchSubjects>();
        system.debug('Counter val :: '+ApexPages.currentPage().getParameters().get('counter'));
        if (selectedPage != '0')
            counter = list_size*integer.valueOf(selectedPage)-list_size;
        
        try { 
            List<Watchlist_Search_Subject__c> relatedSearchSubjectList = [Select Id, Name, Account__c, Account__r.name, Hit__c, Email__c, 
                                        First_name__c, Last_Name__c, Middle_Name__c,  
                                        entity_name__c, Analysed__c, Last_searched__c,
                                        id_type_key__c, Disabled__c, id_type_value__c, 
                                        Date_of_Birth__c, status__c, Recurring__c 
                                        From Watchlist_Search_Subject__c where Analysed__c = true 
                                        and Account__c =: accId limit :list_size offset :counter];
            for(Watchlist_Search_Subject__c wlss : relatedSearchSubjectList){
                RelatedSearchSubjects rss = new RelatedSearchSubjects(wlss, true, false);
                rssList.add(rss);
            }
        }
        catch (QueryException e) {                            
            ApexPages.addMessages(e);                   
            return null;
        }        
        system.debug('rssList :: '+rssList);
        return rssList;
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
    
    public void getSelected(){
        selectedSearchSubjects.clear();
        for(RelatedSearchSubjects rssVal : rssList){
                    if(rssVal.isSelected  == true){
                        selectedSearchSubjects.add(rssVal.ssVal);
                    }
                } 
        system.debug('selectedSearchSubjects :: '+selectedSearchSubjects);     
        system.debug('selectedSearchSubjects.size() :: '+selectedSearchSubjects.size());      
    }
    
    public void disableSearchSubject(){
        refreshPage = true;
        if(selectedSearchSubjects.size() > 0){
            for(Watchlist_Search_Subject__c selectedSearchSubject : selectedSearchSubjects){
                selectedSearchSubject.Disabled__c = true;
                selectedSearchSubject.Disabled_date__c = DDUtility.drop_leading_zeros(system.now().format('dd MMMM yyyy'));
            }
            system.debug('selectedSearchSubjects after :: '+selectedSearchSubjects);            
            update selectedSearchSubjects;       
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select 1 search subject')); 
        }
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