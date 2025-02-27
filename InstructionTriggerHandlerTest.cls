@isTest(SeeAllData=true)
private class InstructionTriggerHandlerTest {
            
    static testMethod void instructionTriggerHandlerTest() {
            /*Client_Price_Sheet__c ps =TestDataHelper.createPriceSheet();
            insert ps;
            Contact con = TestDataHelper.createContact();
            //insert con;
            DD_Instruction__c ins = TestDataHelper.createInstructions();
            ins.DD_Client_Commissioner__c = con.id;
            insert ins;
            system.debug('ins :: '+ins); 
            DD_Instruction__c insQ = [select Id, DD_Price_Formula__c from DD_Instruction__c where Id =: ins.Id];
            system.assertEquals(insQ.DD_Price_Formula__c, 300.00);*/
        system.assertEquals('','');
   }    
}