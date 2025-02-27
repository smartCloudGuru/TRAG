public class WLSearchResultDetailExtension {
    
    public Watchlist_Search_Result__c currentSearchResult{get;set;}
    public String retURL {get;set;}
    
    public WLSearchResultDetailExtension(ApexPages.StandardController controller) {
        this.currentSearchResult = (Watchlist_Search_Result__c)controller.getSubject();
        retURL = ApexPages.currentPage().getParameters().get('retURL');         
    } 
    
    public Pagereference prevPage(){
        Pagereference pg = new Pagereference(retURL); 
        pg.setRedirect(true);
        return pg;
    }

}