@isTest(SeeAllData=true) 
public class ProfileTabUserControllerTest {
    
    static testMethod void myTest(){
        PageReference pageRef = Page.Expertise_tab;
        Test.setCurrentPageReference(pageRef);
        
        //create User
        User thisUser = TestdataHelper.createSalesforceUser('test125test@test123.com', 'test125t', 'test125@test123.com');
        system.runas(thisUser){
            ApexPages.CurrentPage().getparameters().put('sfdc.userId', thisUser.id);
            ApexPages.StandardController sc = new ApexPages.standardController(thisUser);
            ProfileTabUserController sic = new ProfileTabUserController(sc);
            pagereference pg = sic.save();
            system.assertEquals(pageRef, pg); 
            sic.cancel(); 
            system.assertEquals(pageRef, pg);
        }
    }
    
}