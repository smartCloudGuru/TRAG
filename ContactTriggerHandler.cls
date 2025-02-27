/**
 * ContactTriggerHandler
 *
 * Trigger Logic for Contact
 */
public with sharing class ContactTriggerHandler {

	public void onAfterInsert(Contact[] triggerNew, Map<Id,Contact> triggerNewMap){

		Contact[] primaryContacts = new Contact[]{};

		for (Contact record:triggerNew)
		{
			if (record.IsPrimaryContact__c && record.AccountId != null)
			{
				primaryContacts.add(record);
			}
		}

		if (primaryContacts.size() > 0)
		{
			setPrimaryContactOnAccount(primaryContacts);
		}
	}


	public void onAfterUpdate(Contact[] triggerNew, Map<Id,Contact> triggerNewMap, Contact[] triggerOld, Map<Id,Contact> triggerOldMap){

		Contact[] primaryContacts = new Contact[]{};

		for (Contact record:triggerNew)
		{
			if (record.IsPrimaryContact__c && !triggerOldMap.get(record.Id).IsPrimaryContact__c && record.AccountId != null)
			{
				primaryContacts.add(record);
			}
		}

		if (primaryContacts.size() > 0)
		{
			setPrimaryContactOnAccount(primaryContacts);
		}
	}


	/**
	 * setPrimaryContactOnAccount
	 *
	 * populate PrimaryContact__c on Account from list of contacts
	 */
	public void setPrimaryContactOnAccount(Contact[] contacts){

		Account[] records = new Account[]{};

		for (Contact record:contacts)
		{
			records.add(new Account(
				  Id = record.AccountId
				, PrimaryContact__c = record.Id
				));
		}

		update records;

	}

}