@isTest(SeeAllData=true) 
public class WLSearchSubjectCreationExtenstionTest {
    
    static testMethod void WLSearchSubjectCreateTest() {   
        
        User u2;
        User u1;
        WLSearchSubjectCreationExtenstion wlsc;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createWatchListPortalUserManagerRole();
        }
        system.runas(u2){
            User u3 = [select Id, UserRoleId, contactId, contact.AccountId, contact.Account.LUMA_Account__c from User where id =: u2.Id];
            Account acc = TestDataHelper.createAccount();
            acc.ParentId = u3.contact.AccountId;
            insert acc;    
            Watchlist_Search_Subject__c  wlss = TestDataHelper.getSearchSubject(acc);
            //insert prm;
            test.startTest();
            ApexPages.currentPage().getParameters().put('accId',acc.id);
            Apexpages.standardController cont = new Apexpages.standardController(wlss);
            wlsc = new WLSearchSubjectCreationExtenstion(cont); 
            wlsc.createSearchSubject();
            Account acc1 = [Select Id, (Select Id From Watchlist_Search_Subject__r) From Account a where Id=: acc.Id];
            system.assertEquals(1, acc1.Watchlist_Search_Subject__r.size());
            wlsc.pageRef = ApexPages.currentPage();
            wlsc.prev();
            test.stopTest();
        }
    }

}