@isTest(SeeAllData=true) 
public class WLPrimaryRiskModelCreationExtensionTest {	    
    
    static testMethod void WLPrimaryRiskModelTest() {   
        
        User u2;
        User u1;
        WLPrimaryRiskModelCreationExtension wlprm;
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
            Primary_Risk_Model_Custom__c prmc = Primary_Risk_Model_Custom__c.getAll().values().get(0);
            prmc.Name = acc.Id;
            update prmc;            
            Primary_Risk_Model__c prm = TestDataHelper.getPrimaryRiskModel(acc);
            //insert prm;
            test.startTest();
            ApexPages.currentPage().getParameters().put('accId',acc.id);
            Apexpages.standardController cont = new Apexpages.standardController(prm);
            wlprm = new WLPrimaryRiskModelCreationExtension(cont); 
            wlprm.createPrimaryRiskModel();
            Account acc1 = [Select Id, (Select Id From Primary_Risk_Models__r) From Account a where Id=: acc.Id];
            system.assertEquals(1, acc1.Primary_Risk_Models__r.size());
            wlprm = new WLPrimaryRiskModelCreationExtension(cont); 
            wlprm.createPrimaryRiskModel();            
            Account acc2 = [Select Id, (Select Id From Primary_Risk_Models__r) From Account a where Id=: acc.Id];
            system.assertEquals(1, acc2.Primary_Risk_Models__r.size());            
            wlprm.pageRef = ApexPages.currentPage();
            wlprm.prev();
            test.stopTest();
        }
    }
}