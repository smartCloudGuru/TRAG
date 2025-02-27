public with sharing class WLSearchSubjectDisplayExtenstion {
    
    Account currentAccount;
    public List<DDUtility.RelatedSearchSubjects> relatedWatchlistSearchSubjects {get;set;}
    public String newSearchPageURL {get;set;}
    public List<Watchlist_Search_Subject__c> selectedSearchSubjects{get;set;}
    public String currentURL{ get; set; }
    public Boolean refreshPage {get; set;}
    
    public WLSearchSubjectDisplayExtenstion(ApexPages.StandardController controller) {
        selectedSearchSubjects = new List<Watchlist_Search_Subject__c>();
        refreshPage = false;
        this.currentAccount = (Account)controller.getSubject();
        currentURL = '/'+this.currentAccount.Id;
        relatedWatchlistSearchSubjects = DDUtility.getRelatedSearchSubjects(currentAccount.Id);
        newSearchPageURL = '/client/WLSearch?retURL=/client/'+currentAccount.Id+'&accId='+currentAccount.Id;    
    }  
    
    public void approveSearchSubject(){
        refreshPage = true;
        if(selectedSearchSubjects.size() > 0){
            for(Watchlist_Search_Subject__c selectedSearchSubject : selectedSearchSubjects){
                selectedSearchSubject.status__c = 'Approved';
            }
            update selectedSearchSubjects;            
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select 1 search subject')); 
        }
    }
    
    public void rejectSearchSubject(){
        refreshPage = true;
        if(selectedSearchSubjects.size() > 0){
            for(Watchlist_Search_Subject__c selectedSearchSubject : selectedSearchSubjects){
                selectedSearchSubject.status__c = 'Rejected';
            }
            update selectedSearchSubjects;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select 1 search subject')); 
        }
    }
    
    public void getSelected(){
        selectedSearchSubjects.clear();
        for(DDUtility.RelatedSearchSubjects relatedSubjectWrapper : relatedWatchlistSearchSubjects)
            if(relatedSubjectWrapper.isSelected  == true)
            selectedSearchSubjects.add(relatedSubjectWrapper.ssVal);
        system.debug('selectedSearchSubjects :: '+selectedSearchSubjects);
    }              
}