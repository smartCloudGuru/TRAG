/**
 * SCAccountChangesTriggerHandler 
 *
 * Trigger Logic for SubcontractorAccountChanges__c
 */
public class SCAccountChangesTriggerHandler{

    /**
     * onBeforeInsert
     *
     * notify followers via chatter about pending changes
     */
    public void onAfterInsert(SubcontractorAccountChanges__c[] triggerNew, Map<Id,SubcontractorAccountChanges__c> triggerNewMap){

        FeedItem[] items = new FeedItem[]{};

        for (SubcontractorAccountChanges__c record:triggerNew)
        {
            items.add(SCAccountDataService.getFeedItemNewChanges(record.Subcontractor__c,record.Id,record.Name));
        }

        //database.insert(items,false);

    }


    /**
     * onBeforeUpdate
     *
     * set record status to applied if the changes are approved, onAfterUpdate will prevent DML in case of an error
     */
    public void onBeforeUpdate(SubcontractorAccountChanges__c[] triggerNew, SubcontractorAccountChanges__c[] triggerOld, Map<Id,SubcontractorAccountChanges__c> triggerNewMap, Map<Id,SubcontractorAccountChanges__c> triggerOldMap){

        SubcontractorAccountChanges__c[] records = new SubcontractorAccountChanges__c[]{};

        // check for status changes to 'Approved'
        for (SubcontractorAccountChanges__c record:triggerNew)
        {

            if (spec_isApprvoed(record,triggerOldMap.get(record.Id)))
            {
                record.Status__c = SCAccountDataService.STATUS_APPLY_SUCCESS;
            }
        }

    }


    public void onAfterUpdate(SubcontractorAccountChanges__c[] triggerNew, SubcontractorAccountChanges__c[] triggerOld, Map<Id,SubcontractorAccountChanges__c> triggerNewMap, Map<Id,SubcontractorAccountChanges__c> triggerOldMap){

        SubcontractorAccountChanges__c[] records = new SubcontractorAccountChanges__c[]{};

        // check for status changes to 'Approved'
        for (SubcontractorAccountChanges__c record:triggerNew)
        {

            system.debug('### new=' +record.Status__c);
            system.debug('### old=' +triggerOldMap.get(record.Id).Status__c);
            if (record.Status__c == SCAccountDataService.STATUS_APPLY_SUCCESS
                && triggerOldMap.get(record.Id).Status__c != SCAccountDataService.STATUS_APPLY_SUCCESS)
            {
                system.debug('### meets criteria');
                records.add(record);   
            }
        }

        if (records.size() > 0)
        {
            SCAccountDataService.applyChangesToAccount(records, false);
        }
    }


    private Boolean spec_isApprvoed(SubcontractorAccountChanges__c record, SubcontractorAccountChanges__c recordOld){
        return record.Status__c == SCAccountDataService.STATUS_APPROVED
                && record.Status__c != recordOld.Status__c;
    }

}