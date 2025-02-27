global class WLTempRecordsCleanupSchedule implements Schedulable{
    
    global void execute(SchedulableContext SC) {   
        
        List<Id> watchlistSearchSubjectIdList = new List<Id>();
        List<Watchlist_Search_Subject__c> tempWLSearchSubjectList;
        List<Id> tempWLSearchSubjectIdList = new List<Id>();
        List<Watchlist_Search_Result__c> tempSearchResultList;
        List<Watchlist_Search__c> tempWLSearchList;
        List<Id> tempWLSearchIdList = new List<Id>();
        Date dt = system.today();
        try{
            tempSearchResultList = [select Id, Watchlist_Search__c, Watchlist_Search__r.Watchlist_Search_Subject__c, Watchlist_Search__r.Analysis_completed__c,
                                                                     Watchlist_Search__r.Watchlist_Search_Subject__r.Account__c, Watchlist_Search__r.is_Recurring_Search__c  from Watchlist_Search_Result__c 
                                                                     where Watchlist_Search__r.Watchlist_Search_Subject__r.Account__c =: Label.Watchlist_Temp_Account_Id
                                    OR (createddate <: dt and Watchlist_Search__r.Watchlist_Search_Subject__r.Analysed__c = false 
                                        and Watchlist_Search__r.Watchlist_Search_Subject__r.Recurring__c = false) limit 3000];
            
            system.debug('tempSearchResultList :: '+tempSearchResultList);
            
            tempWLSearchList = [select Id, Watchlist_Search_Subject__c from Watchlist_Search__c where Watchlist_Search_Subject__r.Account__c =: Label.Watchlist_Temp_Account_Id
                                          OR (createddate <: dt and Watchlist_Search_Subject__r.Analysed__c = false 
                                        and Watchlist_Search_Subject__r.Recurring__c = false) limit 3000];            
            system.debug('tempWLSearchList :: '+tempWLSearchList);
            
            if(tempWLSearchList != null && !tempWLSearchList.isEmpty()){
                for(Watchlist_Search__c tempWLSearchVal : tempWLSearchList){
                    tempWLSearchSubjectIdList.add(tempWLSearchVal.Watchlist_Search_Subject__c);
                }
            }
            
            if(!tempWLSearchSubjectIdList.isEmpty()){            
                tempWLSearchSubjectList =  [select Id from Watchlist_Search_Subject__c where Id in: tempWLSearchSubjectIdList limit 3000];            
            }
            
            if(tempSearchResultList != null && !tempSearchResultList.isEmpty()){
                delete tempSearchResultList;
            }
            
            if(tempWLSearchList != null && !tempWLSearchList.isEmpty()){
                delete tempWLSearchList;
            }
            
            if(tempWLSearchSubjectList != null && !tempWLSearchSubjectList.isEmpty()){  
                delete tempWLSearchSubjectList;
            }
        }catch(Exception ex){
            system.debug('Exception :: '+ex.getMessage());      
            throw ex;
        }
    }
}