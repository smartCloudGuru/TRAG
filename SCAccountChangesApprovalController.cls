/**
 * SCAccountChangesApprovalController
 *
 * Controller for approving Account Changes
 */
public with sharing class SCAccountChangesApprovalController {

    // public make it accessible for test
    public ApexPages.StandardController stdCon {get;set;}

    //--------------------------------------------------------------
    // Constructor
    //--------------------------------------------------------------
    public SCAccountChangesApprovalController(ApexPages.StandardController controller){
        stdCon = controller;
    }


    //--------------------------------------------------------------
    // Actions
    //--------------------------------------------------------------
    /**
     * approve
     *
     */
    public PageReference approve(){
    
        return saveStatusAndRedirect(SCAccountDataService.STATUS_APPROVED);
    }


    /**
     * approve
     *
     */
    public PageReference reject(){
    
        return saveStatusAndRedirect(SCAccountDataService.STATUS_REJECTED);
    }
    

    /**
     * saveStatusAndRedirect
     *
     * updates record status and redirects to view
     */    
    private PageReference saveStatusAndRedirect(String statusVal){

        PageReference pref = null;

        try
        {

            SubcontractorAccountChanges__c record = (SubcontractorAccountChanges__c)stdCon.getRecord();
            record.Status__c = statusVal;
            update record;
            pref = stdCon.view();
            pref.setRedirect(true);
        }
        catch(Exception ex)
        {
            ApexPages.addMessages(ex);
        }

        return pref;
    }
}