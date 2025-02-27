@isTest(SeeAllData=true) 
public class BankdetailsTriggerHandlerTest {
    
    static testMethod void bankDetailsApprovalsTest() {
    	Bank_details__c bd = Testdatahelper.createBankDetails();
        insert bd;
        bd.Approval_status__c = 'Approved';
        update bd;
        Bank_details__c bd1 = Testdatahelper.createBankDetails();
        insert bd1;
    	bd1.Approval_status__c = 'Submitted';
        update bd1;
        Bank_details__c bd_db = [select Id, Approval_status__c from Bank_details__c where Id =: bd.Id]; 
        system.assertEquals(bd_db.Approval_status__c, 'Superseded');
    }

}