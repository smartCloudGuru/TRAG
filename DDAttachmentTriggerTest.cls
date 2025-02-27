@isTest(SeeAllData=true) 
public class DDAttachmentTriggerTest {
    
    static testMethod void attachmentOnInstructionTest() { 
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
            attachment att = new attachment();
            att.name = 'test name';
            att.body = Blob.valueOf('test body');
            att.Description = 'test Desc';
            att.ParentId = ins.Id;
            insert att;
        }
        
        List<DD_Instruction__Feed> fItemList = [Select d.Id, d.Body  From DD_Instruction__Feed d where parentId =: ins.Id];
        system.assertEquals(fItemList.size(), 1);
    }
}