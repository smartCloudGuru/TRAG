/* Seealldata is true because user creation in Risk Advisory depends on 
    Financial Force Managed Package in which current company needs to be set 
    and user to be assigned to multiple Financialforce queues which is not possible through test data creation. 
    This has been checked with Financial Force Team */
    /**
        Tests if styling related to home page is loaded correctly
    */    
    @isTest(SeeAllData=true)
private class DDCustomerHomePageControllerTest {

    static testMethod void customizableInterfaceTest() {
        system.debug('DDCustomerHomePageControllerTest :: customizableInterfaceTest :: start');
        User u1;
        User u5;
        User u6;
        Id accId;
       List<DDCustomerHomePageComponent__c> customerHomePageParamentersList = DDCustomerHomePageComponent__c.getall().values();
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            u1 = TestDataHelper.createPortalUserManagerRolePortalProfile();
            User u4 = [select Id, UserRoleId, contact.AccountId from User where id =: u1.Id];
            accId = u4.contact.AccountId;
            u5 = TestDataHelper.createCPPortalUserWithoutVerificationAccount();
            u6 = [select Id, contact.Account.ParentId, contact.AccountId from User where id =: u5.Id];
            u6.contact.Account.ParentId = accId;
            update u6.contact.Account;                
        }
        system.runas(u6){
            //List<AccountShare> accSAsPartner = [Select a.UserOrGroupId, a.OpportunityAccessLevel, a.Id, a.AccountId, a.AccountAccessLevel From AccountShare a where AccountId =: accId];
            //List<ContactShare> conSAsPartner = [Select a.UserOrGroupId, a.Id, a.ContactId From ContactShare a where ContactId =: conId];
            
            customerHomePageParamentersList.get(0).DDPartnerAccountId__c = String.valueOf(accId).subString(0,15);
            update customerHomePageParamentersList.get(0);
            DDCustomerHomePageController customerHomePage = new DDCustomerHomePageController();
            //system.assertEquals(customerHomePage.CustomerInformation, customerHomePageParamentersList.get(0).DDCustomerInformation__c);
            //system.assertEquals(customerHomePage.TopRightVideo, customerHomePageParamentersList.get(0).DDTopRightVideo__c);
            system.assertEquals(customerHomePage.pageBackgroundColor, customerHomePageParamentersList.get(0).Page_BackgroundColor__c);
            /*system.assertEquals(customerHomePage.bodyBackgroundColor, customerHomePageParamentersList.get(0).Body_BackgroundColor__c);
            system.assertEquals(customerHomePage.brandQuaternaryBgrBackgroud, customerHomePageParamentersList.get(0).BrandQuaternaryBgr_Backgroud__c);
            system.assertEquals(customerHomePage.quickLinksTableHeight, customerHomePageParamentersList.get(0).QuickLinksTable_Height__c);
            system.assertEquals(customerHomePage.quickLinksTableWidth, customerHomePageParamentersList.get(0).QuickLinksTable_Width__c);
            system.assertEquals(customerHomePage.bodyTDWidth, customerHomePageParamentersList.get(0).BodyTD_Width__c);
            system.assertEquals(customerHomePage.bodyTDVerticalAlign, customerHomePageParamentersList.get(0).BodyTD_VerticalAlign__c);
            system.assertEquals(customerHomePage.customizeTextFontSize, customerHomePageParamentersList.get(0).CustomizeText_FontSize__c);
            system.assertEquals(customerHomePage.customizeTextFontFamily, customerHomePageParamentersList.get(0).CustomizeText_FontFamily__c);
            system.assertEquals(customerHomePage.customizeTextColor, customerHomePageParamentersList.get(0).CustomizeText_Color__c);*/
            
        }        
        system.debug('DDCustomerHomePageControllerTest :: customizableInterfaceTest :: end');
    }
}