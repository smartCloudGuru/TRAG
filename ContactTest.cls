/**
 * ContactTest
 *
 * contains Contact related unit methods
 */
@isTest
private class ContactTest {

	static Account account;
	static Contact primaryContact;


	static void startTest(Boolean doStart){

		if (account == null)
		{
			// fix for Westbrook bullshit
			insert new Triggers__c(
				  Name = 'AccountCalcCodeNew'
				, Enable__c = false);

			account = new Account(
				Name = 'TEST_ACCOUNT');
			insert account;

			// dont save contact, to test insert event
			primaryContact = new Contact(
				  AccountId = account.Id
				, LastName = 'TEST_CONTACT'
				, IsPrimaryContact__c = false);
		}

		if (doStart)
		{
			Test.startTest();
		}
	}


	@isTest static void primaryContactTest() {

		startTest(true);

		// save the contact
		primaryContact.IsPrimaryContact__c = true;
		insert primaryContact;

		system.assertEquals(primaryContact.Id,getAccountsPrimaryContactId(account.Id),'Primary contact should be populated');

		// unset primary flag
		primaryContact.IsPrimaryContact__c = false;
		update primaryContact;

		account.PrimaryContact__c = null;
		update account;

		system.assertEquals(null,getAccountsPrimaryContactId(account.Id),'Primary Contact should be null');

		// make contact primary again
		primaryContact.IsPrimaryContact__c = true;
		update primaryContact;

		system.assertEquals(primaryContact.Id,getAccountsPrimaryContactId(account.Id),'Primary contact should be re-populated');

		Test.stopTest();
	}


	static Id getAccountsPrimaryContactId(Id accountId){
		return [select PrimaryContact__c from Account where Id =: accountId].PrimaryContact__c;
	}
}