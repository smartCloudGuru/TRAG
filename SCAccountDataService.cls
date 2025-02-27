/**
 * SCAccountChangesService
 *
 * Service class containing Account changes related constants (e.g. status values)
 * methods for mapping and loading Account & Changes data
 */
public class SCAccountDataService{

    //--------------------------------------------------------------
    // Constants && Vars
    //--------------------------------------------------------------
    public static final String STATUS_PENDING = 'Pending';
    public static final String STATUS_APPROVED = 'Approved';
    public static final String STATUS_APPLY_SUCCESS = 'Applied';
    public static final String STATUS_REJECTED = 'Rejected';
    static String[] CHANGE_FIELDS;


    /**
     * findPendingChanges
     *
     * returns the Id of any pending changes (Draft or In Approval)
     */
    public static Id findPendingChangesId(Id accountId){

        String[] statusArr = new String[]{
              STATUS_PENDING};

        SubcontractorAccountChanges__c[] records = [
            select Id
              from SubcontractorAccountChanges__c
             where Subcontractor__c =: accountId
               and Status__c IN: statusArr];

        return records.size() > 0 ? records[0].Id :null;
    }


    /**
     * getChangeFields
     *
     * List of fields to sync between Account and Changes
     */
    public static String[] getChangeFields(){

        if (CHANGE_FIELDS == null)
        {

            CHANGE_FIELDS = new String[]{
                   'SubcontractorCountriesAmericas__c'
                 , 'SubcontractorCountriesCaucCentAsia__c'
                 , 'SubcontractorCountriesCentralEasternEU__c'
                 , 'SubcontractorCountriesChina__c'
                 , 'SubcontractorCountriesMENA__c'
                 , 'SubcontractorCountriesRussia__c'
                 , 'SubcontractorCountriesSouthEastAsia__c'
                 , 'SubcontractorCountriesSubSaharanAfrica__c'
                 , 'SubcontractorCountriesWesternEurope__c'
                 , 'SubcontractorIndustries__c'
                 , 'SubcontractorServices__c'};
        }

        return CHANGE_FIELDS;
    }


    //--------------------------------------------------------------
    // Account->Changes Mapping && Record Loading
    //--------------------------------------------------------------

    /**
     * applyChangesToAccount
     *
     * method applies approved changes to Accounts
     */
    public static void applyChangesToAccount(SubcontractorAccountChanges__c[] toSync, Boolean saveChanges){

        // save lists
        SubcontractorAccountChanges__c[] records = new SubcontractorAccountChanges__c[]{};
        Account[] accounts = new Account[]{};
        FeedItem[] feedItems = new FeedItem[]{};

        for (SubcontractorAccountChanges__c record:toSync)
        {
            accounts.add(toAccount(record.Subcontractor__c,record));
        }

        // save accounts
        Database.SaveResult[] srl = Database.update(accounts,false);

        for (Integer i=0;i<srl.size();i++)
        {

            Database.SaveResult sr = srl[i];
            SubcontractorAccountChanges__c changes = new SubcontractorAccountChanges__c(Id = toSync[i].Id);
            records.add(changes);

            // saved!
            if (sr.isSuccess())
            {

                // create Chatter Post
                feedItems.add(getFeedItemSuccess(changes.Subcontractor__c,changes.Id,changes.Name));
            }
            // failed
            else
            {
                for (Database.Error e:sr.getErrors())
                {   
                    toSync[i].addError(e.getMessage());
                }
            }
        }

        // save Chatter Posts?
        if (feedItems.size() > 0)
        {
            database.insert(feedItems,false);
        }
    }


    /**
     * getFeedItemSuccess
     *
     * returns a FeedItem that informs Account followers about changes
     */
    public static FeedItem getFeedItemNewChanges(Id accountId, Id changesId, String changesName){
        
        return new FeedItem(
              ParentId = accountId
            , Body =  'New Subcontractor Profile Changes for Approval'
            , LinkUrl = '/' + changesId
            , Title = 'Link to Changes # ' + changesName
            , Type = 'LinkPost');
    }


    /**
     * getFeedItemSuccess
     *
     * returns a FeedItem that informs Account followers about changes
     */
    public static FeedItem getFeedItemSuccess(Id accountId, Id changesId, String changesName){
        
        return new FeedItem(
              ParentId = accountId
            , Body =  'Updated Subcontractor Profile'
            , LinkUrl = '/' + changesId
            , Title = 'Link to Changes # ' + changesName
            , Type = 'LinkPost');
    }


    /**
     * getAccountRecords
     *
     * returns a list of Accounts which ids are included in the idSet
     *
     * commented out XXXCountryCode and XXXStateCode for CountryFix
     */
    public static Account[] getAccountRecords(Set<Id> idSet){

        return [
            select Id
                 , Name
                 , BillingCity
                 , BillingCountry
                 //, BillingCountryCode
                 , BillingPostalCode
                 , BillingState
                 //, BillingStateCode
                 , BillingStreet
                 , OwnerId
                 , Phone
                 , RecordTypeId
                 , ShippingCity
                 , ShippingCountry
                 //, ShippingCountryCode
                 , ShippingPostalCode
                 , ShippingState
                 //, ShippingStateCode
                 , ShippingStreet
                 , SubcontractorCountriesAmericas__c
                 , SubcontractorCountriesCaucCentAsia__c
                 , SubcontractorCountriesCentralEasternEU__c
                 , SubcontractorCountriesChina__c
                 , SubcontractorCountriesMENA__c
                 , SubcontractorCountriesRussia__c
                 , SubcontractorCountriesSouthEastAsia__c
                 , SubcontractorCountriesSubSaharanAfrica__c 
                 , SubcontractorCountriesWesternEurope__c
                 , SubcontractorIndustries__c
                 , SubcontractorSelfDescription__c
                 , SubcontractorServices__c
                 , Website
              from Account
             where Id IN: idSet];

    }


    /**
     * getChangesRecords
     *
     * returns a list of SubcontractorAccountChanges__c which ids are included in the idSet
     */
    public static SubcontractorAccountChanges__c[] getChangesRecords(Set<Id> idSet){

        return [
            select Id
                 , Name
                 , Subcontractor__c
                 , SubcontractorCountriesAmericas__c
                 , SubcontractorCountriesCaucCentAsia__c
                 , SubcontractorCountriesCentralEasternEU__c
                 , SubcontractorCountriesChina__c
                 , SubcontractorCountriesMENA__c
                 , SubcontractorCountriesRussia__c
                 , SubcontractorCountriesSouthEastAsia__c
                 , SubcontractorCountriesSubSaharanAfrica__c 
                 , SubcontractorCountriesWesternEurope__c
                 , SubcontractorIndustries__c
                 , SubcontractorServices__c
              from SubcontractorAccountChanges__c
             where Id IN: idSet];
    }


    /**
     * toChanges
     *
     * map values from Account to Changes
     */
    public static SubcontractorAccountChanges__c toChanges(SubcontractorAccountChanges__c to, Account fromX){

        to.SubcontractorCountriesAmericas__c = fromX.SubcontractorCountriesAmericas__c;
        to.SubcontractorCountriesCaucCentAsia__c = fromX.SubcontractorCountriesCaucCentAsia__c;
        to.SubcontractorCountriesCentralEasternEU__c = fromX.SubcontractorCountriesCentralEasternEU__c;
        to.SubcontractorCountriesChina__c = fromX.SubcontractorCountriesChina__c;
        to.SubcontractorCountriesMENA__c = fromX.SubcontractorCountriesMENA__c;
        to.SubcontractorCountriesRussia__c = fromX.SubcontractorCountriesRussia__c;
        to.SubcontractorCountriesSouthEastAsia__c = fromX.SubcontractorCountriesSouthEastAsia__c;
        to.SubcontractorCountriesSubSaharanAfrica__c = fromX.SubcontractorCountriesSubSaharanAfrica__c;
        to.SubcontractorCountriesWesternEurope__c = fromX.SubcontractorCountriesWesternEurope__c;

        to.SubcontractorServices__c = fromX.SubcontractorServices__c;
        to.SubcontractorIndustries__c = fromX.SubcontractorIndustries__c;

        return to;
    }


    /**
     * toAccount
     *
     * map values from Changes to Account
     */
    public static Account toAccount(Id toId, SubcontractorAccountChanges__c fromX){

        Account to = new Account(Id = toId);

        to.SubcontractorCountriesAmericas__c = fromX.SubcontractorCountriesAmericas__c;
        to.SubcontractorCountriesCaucCentAsia__c = fromX.SubcontractorCountriesCaucCentAsia__c;
        to.SubcontractorCountriesCentralEasternEU__c = fromX.SubcontractorCountriesCentralEasternEU__c;
        to.SubcontractorCountriesChina__c = fromX.SubcontractorCountriesChina__c;
        to.SubcontractorCountriesMENA__c = fromX.SubcontractorCountriesMENA__c;
        to.SubcontractorCountriesRussia__c = fromX.SubcontractorCountriesRussia__c;
        to.SubcontractorCountriesSouthEastAsia__c = fromX.SubcontractorCountriesSouthEastAsia__c;
        to.SubcontractorCountriesSubSaharanAfrica__c = fromX.SubcontractorCountriesSubSaharanAfrica__c;
        to.SubcontractorCountriesWesternEurope__c = fromX.SubcontractorCountriesWesternEurope__c;

        to.SubcontractorServices__c = fromX.SubcontractorServices__c;
        to.SubcontractorIndustries__c = fromX.SubcontractorIndustries__c;

        return to;

    }


    /**
     * getChangedFields
     *
     * returns a list of fields that have differnt values
     */
    public static String[] getChangedFields(Account to, SubcontractorAccountChanges__c fromX){

        String[] output = new String[]{};

        for (String s:getChangeFields())
        {

            if (to.get(s) != fromX.get(s))
            {
                output.add(s);
            }
        }

        return output;
    }
}