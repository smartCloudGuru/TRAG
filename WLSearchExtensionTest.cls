@isTest(SeeAllData=true) 
public class WLSearchExtensionTest {
    
    static testMethod void WLSearchTest() {   
        
        User u2;
        User u1;
        WLSearchExtension wls;
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
            WatchList_Search_Parameters__c wlsp = WatchList_Search_Parameters__c.getAll().values().get(0);
            wlsp.Name = String.valueOf(acc.ParentId).subString(0,15);
            update wlsp;
            Watchlist_Search_Subject__c  wlss = TestDataHelper.getSearchSubject(acc);
            insert wlss;
            test.startTest();
            ApexPages.currentPage().getParameters().put('accId',acc.id);
            Apexpages.standardController cont = new Apexpages.standardController(wlss);
            wls = new WLSearchExtension(cont); 
            wls.lumaAccountId = String.valueOf(acc.ParentId).subString(0,15);
            WLSearchExtension.searchCategory = '02';
            wls.subjectSearch();
            wls.getcategory();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorTest());
            HttpResponse res = wls.callAndHandleResults('name', '?content-set=WL&record-type=P&search-type=broad&name=David%20Cameron');
            System.assertEquals(200, res.getStatusCode());
            test.stopTest();
        }
    }

}