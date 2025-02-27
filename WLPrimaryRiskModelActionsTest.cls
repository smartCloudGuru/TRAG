@isTest(SeeAllData=true) 
public class WLPrimaryRiskModelActionsTest {
    
    static testMethod void WLPrimaryRiskModelScoreTest() {
        User u2;
        User u1;
        WLPrimaryRiskModelActions wlprma;
        Account acc;
        Primary_Risk_Model_Custom__c prmc;
        Primary_Risk_Model__c prm;
        WL_Corruption_Index__c ci;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createWatchListPortalUserManagerRole();
        }
        system.runas(u2){
            User u3 = [select Id, UserRoleId, contactId, contact.AccountId, contact.Account.LUMA_Account__c from User where id =: u2.Id];
            acc = TestDataHelper.createAccount();
            acc.ParentId = u3.contact.AccountId;
            insert acc;   
        }
        system.runas(thisUser){
            prmc = Primary_Risk_Model_Custom__c.getAll().values().get(0);
            prmc.Name = String.valueOf(acc.ParentId).subString(0,15);
            update prmc;
            ci =  WL_Corruption_Index__c.getAll().values().get(0); 
            ci.Name = String.valueOf(acc.ParentId).subString(0,15);
            update ci;            
        }
        system.runas(u2){
            prm = TestDataHelper.getPrimaryRiskModel(acc);
            insert prm;
            test.startTest();
            Apexpages.standardController cont = new Apexpages.standardController(prm);
            wlprma = new WLPrimaryRiskModelActions(cont); 
            wlprma.getPrimaryRiskModelResults();
            Primary_Risk_Model__c prms1 = [select Id, Risk_Model_Score__c from Primary_Risk_Model__c where Id =: prm.Id];
            //system.assert(prms1.Risk_Model_Score__c > 0);
        }
    }

}