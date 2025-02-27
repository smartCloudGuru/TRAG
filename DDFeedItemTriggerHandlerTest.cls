@isTest(SeeAllData=true) 
public class DDFeedItemTriggerHandlerTest {
    
    static testMethod void feedItemTest() { 
        DD_Instruction__c ins;
        User u2;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u2 = TestDataHelper.createPortaluser();
        }
        system.runas(u2){ 
            ins = TestDataHelper.createInstructions();
            insert ins;
            //create and insert post
            FeedItem post = new FeedItem();
            post.Body = 'testFeedBody';
            post.ParentId = ins.Id;
            post.Title = 'FileName';
            insert post;
        }
        
        List<DD_Instruction__Feed> fItemList = [Select d.Id, d.Body  From DD_Instruction__Feed d where parentId =: ins.Id];
        system.assertEquals(fItemList.size(), 1);
        system.assertEquals(fItemList.get(0).body, 'testFeedBody');
    }
}