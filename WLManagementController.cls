public with sharing class WLManagementController {
    
    //public List<DDUtility.AccountandRelatedSearchSubjects> relatedAccountandWatchlistSearchSubjects {get;set;} 
    public String disableOption {get;set;}
    public Id watchlistsearchSubjectId{get; set;}
    public List<Watchlist_Search_Subject__c> selectedSearchSubjects{get;set;} 
    public Boolean refreshPage {get; set;}
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public integer counter;
    public integer total_size;
    private integer list_size=Integer.valueOf(Label.Watchlist_result_pagination_size);    
    public Integer count {get; set;}
    public string selectedPage{
        get;
        set{selectedPage=value;}
    }
    
    public WLManagementController() {  
        refreshPage = false;
        selectedSearchSubjects = new List<Watchlist_Search_Subject__c>();
        system.debug('counter before :: '+counter);
        counter = 0;
        system.debug('counter after :: '+counter);         
        //relatedAccountandWatchlistSearchSubjects = DDUtility.getAccountandRelatedSearchSubjects(list_size, counter);
        total_size = [Select count() From Account a ]; //set the total size in the constructor
        system.debug('total_size :: '+total_size);
        selectedPage='0'; 
        count = 1; 
    }
    
    public List<DDUtility.AccountandRelatedSearchSubjects> relatedAccountandWatchlistSearchSubjects{ 
        get{   
            if (selectedPage != '0')
            counter = list_size*integer.valueOf(selectedPage)-list_size;        
            return DDUtility.getAccountandRelatedSearchSubjects(list_size, counter);
        }
        set;
    }
    
    public void getActionValue(){
        system.debug('watchlistsearchSubjectId :: '+watchlistsearchSubjectId);
    	List<Watchlist_Search_Subject__c> wlss = [Select Id, Disabled__c From Watchlist_Search_Subject__c
                                                  where Id =: watchlistsearchSubjectId];
        if(!wlss.isEmpty() && wlss.size() ==1){
            wlss.get(0).Disabled__c = true;
        }
        update wlss;       
    } 
    
    public static List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('02','Disable'));
        return options;
    }
    
    public void getSelected(){
        selectedSearchSubjects.clear();
        system.debug('relatedAccountandWatchlistSearchSubjects :: '+relatedAccountandWatchlistSearchSubjects);
        for(DDUtility.AccountandRelatedSearchSubjects relatedAccountAndSubjectWrapper : relatedAccountandWatchlistSearchSubjects){
            system.debug('relatedAccountAndSubjectWrapper.rssList :: '+relatedAccountAndSubjectWrapper.rssList);
            if(relatedAccountAndSubjectWrapper != null && relatedAccountAndSubjectWrapper.rssList != null && !relatedAccountAndSubjectWrapper.rssList.isEmpty()){
                for(DDUtility.RelatedSearchSubjects rssVal : relatedAccountAndSubjectWrapper.rssList){
                    if(rssVal.isSelected  == true){
                        selectedSearchSubjects.add(rssVal.ssVal);
                    }
                } 
            }
        }        
        system.debug('selectedSearchSubjects :: '+selectedSearchSubjects);     
        system.debug('selectedSearchSubjects.size() :: '+selectedSearchSubjects.size());      
    }
    
    /*public void disableSearchSubject(){
        //refreshPage = true;
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
    }*/
    
    public void disableSearchSubject(){     
        
        List<Watchlist_Search_Subject__c> wlss = [Select Id, Disabled__c From Watchlist_Search_Subject__c
                                                  where Id =: watchlistsearchSubjectId];
        system.debug('wlss :: '+wlss);
        if(!wlss.isEmpty() && wlss.size() == 1){
            wlss.get(0).Disabled__c = true;
            wlss.get(0).Disabled_date__c = DDUtility.drop_leading_zeros(system.now().format('dd MMMM yyyy'));
            update wlss;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Search Subject')); 
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