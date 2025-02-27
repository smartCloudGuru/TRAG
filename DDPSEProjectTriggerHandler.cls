public class DDPSEProjectTriggerHandler {
    
    public void beforeInsertPSEProject(List<pse__Proj__c> pseProjectList) {
        for (pse__Proj__c pseProjVal : pseProjectList) {
            pseProjVal.Project_Passcode__c = generateProjectPasscode(Integer.valueOf(Label.Passcode_Length));
        }                
    }

   public void afterInsertPSEProject(List<pse__Proj__c> pseProjectList, Map<Id, pse__Proj__c> newMap, Map<Id, pse__Proj__c> oldMap) {
        List<DD_Instruction__c> insList = new List<DD_Instruction__c>();
        List<pse__Proj__c> pseProjList = [
            SELECT  Id,
                    pse__Opportunity__r.DD_Instruction__r.DD_Status__c,
                    pse__Opportunity__r.DD_Instruction__r.Billing_Account__c,
                    pse__Stage__c,pse__Account__r.Id,
                    pse__Account__r.Hierarchy_Group_ID__c,
                    RecordTypeID
            FROM pse__Proj__c
            WHERE Id IN :pseProjectList
        ];

        for (pse__Proj__c pseProjVal : pseProjList) {
            if (pseProjVal != NULL && pseProjVal.pse__Opportunity__r != NULL && pseProjVal.pse__Opportunity__r.DD_Instruction__r != NULL) {
                pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'In Progress';
                pseProjVal.pse__Opportunity__r.DD_Instruction__r.Billing_Account__c = pseProjVal.pse__Account__r.Id;
                insList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
            }
        }

        if (insList.size() > 0) {
            update insList;
        }
        //Calculate project count
        CalculateProjectCount(pseProjectList, NULL, false);
    }
    
     public static String generateProjectPasscode(Integer len){
        
        final String chars = Label.Passcode_Characters ;
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr;       
    }


    public void afterUpdatePSEProject(List<pse__Proj__c> pseProjectList, Map<Id, pse__Proj__c> newMap, Map<Id, pse__Proj__c> oldMap) {
        List<Id> pseProjectIdList = new List<Id>();
        List<c2g__codaDimension3__c> dim3List;
        List<Id> dim3IdList = new List<Id>();
        List<DD_Instruction__c> instructionList = new List<DD_Instruction__c>();
        List<DDSalesInvoiceProxy__c> allSalesInvoiceProxyList = new List<DDSalesInvoiceProxy__c>();
        List<DDSalesInvoiceProxy__c> proxyInvoiceList = new List<DDSalesInvoiceProxy__c>();
        system.debug('oldMap :: '+oldMap);
        system.debug('newMap :: '+newMap);
        for (pse__Proj__c pseProjectVal : pseProjectList) {
            pseProjectIdList.add(pseProjectVal.Id);
        }

        List<pse__Proj__c> pseProjList = [
            SELECT  Id,
                    Interim_Report__c,
                    Draft_Report__c,
                    Final_Report__c,
                    (Select Id From ffps_0387__Dimension_3__r),
                    ffps_0387__Client_Contact__r.Name,
                    Invoicing_Contact__r.Name,
                    ffps_0387__Subject_s__c,
                    ffps_0387__Country_ies__c,
                    ffps_0387__Project_Code__c,
                    pse__Stage__c,
                    pse__Opportunity__r.DD_Instruction__c,
                    pse__Opportunity__r.DD_Instruction__r.DD_Status__c,
                    pse__Opportunity__r.DD_Instruction__r.Billing_Account__c,
                    pse__Account__r.Id,
                    pse__Account__r.Hierarchy_Group_ID__c,
                    RecordTypeID
            FROM pse__Proj__c
            WHERE Id IN :pseProjectIdList
        ];

        for (pse__Proj__c pseProjVal : pseProjList) {
            if(oldMap.get(pseProjVal.Id).Invoicing_Contact__c != newMap.get(pseProjVal.Id).Invoicing_Contact__c
              || oldMap.get(pseProjVal.Id).ffps_0387__Subject_s__c != newMap.get(pseProjVal.Id).ffps_0387__Subject_s__c
              || oldMap.get(pseProjVal.Id).ffps_0387__Project_Code__c != newMap.get(pseProjVal.Id).ffps_0387__Project_Code__c
              || oldMap.get(pseProjVal.Id).ffps_0387__Country_ies__c != newMap.get(pseProjVal.Id).ffps_0387__Country_ies__c){
                dim3List = pseProjVal.ffps_0387__Dimension_3__r;
                for (c2g__codaDimension3__c dim3Val : dim3List) {
                    dim3IdList.add(dim3Val.Id);
                }
            }
            
            system.debug('oldMap.get(pseProjVal.Id).pse__Account__c :: '+oldMap.get(pseProjVal.Id).pse__Account__c);
            system.debug('newMap.get(pseProjVal.Id).pse__Account__c :: '+newMap.get(pseProjVal.Id).pse__Account__c);
            if (pseProjVal.pse__Stage__c.equals('Practice Approved') || (pseProjVal.pse__Stage__c.equals('Rejected'))) {
                if (pseProjVal.pse__Opportunity__r != NULL && pseProjVal.pse__Opportunity__r.DD_Instruction__r != NULL) {
                    /*if (!(pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c.equals('Draft Report Sent')
                            || pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c.equals('Interim Update Sent')
                            || pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c.equals('Final Report Sent')
                            || pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c.equals('Cancelled')
                            || pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c.equals('Complete'))) {*/

                    if(oldMap.get(pseProjVal.Id).pse__Account__c != newMap.get(pseProjVal.Id).pse__Account__c){
                        pseProjVal.pse__Opportunity__r.DD_Instruction__r.Billing_Account__c = pseProjVal.pse__Account__c;
                    }    
                    pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'In Progress';
                        instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
                    /*}
                    else {
                        Trigger.new[0].addError(' due diligence project status must be in sequence. Interim -> Draft -> Final');
                    }*/
                }
            }
            /*else if ((pseProjVal.pse__Stage__c.equals('Cancelled'))) {
                if (pseProjVal.pse__Opportunity__r != NULL && pseProjVal.pse__Opportunity__r.DD_Instruction__r != NULL) {*/
                    /*if (!(pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c.equals('Draft Report Sent')
                            || pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c.equals('Interim Update Sent')
                            || pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c.equals('Final Report Sent')
                            || pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c.equals('Complete'))) {*/
                        /*if(oldMap.get(pseProjVal.Id).pse__Account__c != newMap.get(pseProjVal.Id).pse__Account__c){
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.Billing_Account__c = pseProjVal.pse__Account__c;
                        }
                        pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'Cancelled';
                        instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);*/
                    /*}
                    else {
                        Trigger.new[0].addError(' due diligence project status must be in sequence. Interim -> Draft -> Final');
                    }*/
                /*}
            }*/
            else if( newMap.get(pseProjVal.Id).Interim_Report__c != oldMap.get(pseProjVal.Id).Interim_Report__c){
                system.debug('Inside Interim');
                if(pseProjVal.pse__Opportunity__r!=null && pseProjVal.pse__Opportunity__r.DD_Instruction__r!=null){                    
                    /*if(!pseProjVal.Draft_Report__c && !pseProjVal.Final_Report__c && !pseProjVal.pse__Stage__c.equals('Closed and Billed')){*/
                        if(oldMap.get(pseProjVal.Id).pse__Account__c != newMap.get(pseProjVal.Id).pse__Account__c){
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.Billing_Account__c = pseProjVal.pse__Account__c;
                        }
                        if(pseProjVal.Interim_Report__c){
                            system.debug('Interim Update checked');
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'Interim Update Sent';
                            instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
                        }
                        else{
                            system.debug('Interim Update unchecked');
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'In Progress';
                            instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
                        }
                    /*}
                    else{
                        Trigger.new[0].addError(' due diligence project status must be in sequence. Interim -> Draft -> Final');
                    }*/
                }                    
            }                    
            else if(newMap.get(pseProjVal.Id).Draft_Report__c != oldMap.get(pseProjVal.Id).Draft_Report__c){
                if(pseProjVal.pse__Opportunity__r!=null && pseProjVal.pse__Opportunity__r.DD_Instruction__r!=null){
                    /*if(pseProjVal.Interim_Report__c && !pseProjVal.Final_Report__c && !pseProjVal.pse__Stage__c.equals('Closed and Billed')){*/
                        if(oldMap.get(pseProjVal.Id).pse__Account__c != newMap.get(pseProjVal.Id).pse__Account__c){
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.Billing_Account__c = pseProjVal.pse__Account__c;
                        }
                        if(pseProjVal.Draft_Report__c){
                            system.debug('Draft Report checked');
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'Draft Report Sent';
                            instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
                        }
                        else{
                            system.debug('Draft Report unchecked');
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'Interim Update Sent';
                            instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
                        }
                    /*}
                    else{
                        Trigger.new[0].addError(' due diligence project status must be in sequence. Interim -> Draft -> Final');
                    }*/
                }                
            }
            else if(newMap.get(pseProjVal.Id).Final_Report__c != oldMap.get(pseProjVal.Id).Final_Report__c){
                if(pseProjVal.pse__Opportunity__r!=null && pseProjVal.pse__Opportunity__r.DD_Instruction__r!=null){
                    /*if(pseProjVal.Interim_Report__c && pseProjVal.Draft_Report__c && !pseProjVal.pse__Stage__c.equals('Closed and Billed')){      */               
                        if(oldMap.get(pseProjVal.Id).pse__Account__c != newMap.get(pseProjVal.Id).pse__Account__c){
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.Billing_Account__c = pseProjVal.pse__Account__c;
                        }
                        if(pseProjVal.Final_Report__c){   
                            system.debug('Final Report checked');
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'Final Report Sent';
                            instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
                        }
                        else{
                            system.debug('Final Report unchecked');
                            pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'Draft Report Sent';
                            instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
                        }
                    /*}
                    else{
                        Trigger.new[0].addError(' due diligence project status must be in sequence.Interim -> Draft -> Final');
                    }*/
                }                
            }
            else if (pseProjVal.pse__Stage__c.equals('Closed and Billed')) {
                if (pseProjVal.pse__Opportunity__r != NULL && pseProjVal.pse__Opportunity__r.DD_Instruction__r != NULL) {
                    if(oldMap.get(pseProjVal.Id).pse__Account__c != newMap.get(pseProjVal.Id).pse__Account__c){
                        pseProjVal.pse__Opportunity__r.DD_Instruction__r.Billing_Account__c = pseProjVal.pse__Account__c;
                    }
                    pseProjVal.pse__Opportunity__r.DD_Instruction__r.DD_Status__c = 'Complete';
                    instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
                }
            }
            else{                
                if(oldMap.get(pseProjVal.Id).pse__Account__c != newMap.get(pseProjVal.Id).pse__Account__c
                  && pseProjVal.pse__Opportunity__r != NULL && pseProjVal.pse__Opportunity__r.DD_Instruction__r != NULL){
                    pseProjVal.pse__Opportunity__r.DD_Instruction__r.Billing_Account__c = pseProjVal.pse__Account__c;
                    instructionList.add(pseProjVal.pse__Opportunity__r.DD_Instruction__r);
                }
            }
        }
        
        List<c2g__codaDimension3__c> querieddim3List = [
            SELECT  Id,
                    ffps_0387__Project__r.ffps_0387__Client_Contact__r.Name,
                    ffps_0387__Project__r.Invoicing_Contact__r.Name,
                    ffps_0387__Project__r.ffps_0387__Subject_s__c,
                    ffps_0387__Project__r.ffps_0387__Country_ies__c,
                    ffps_0387__Project__r.ffps_0387__Project_Code__c,
                    (
                        SELECT  Id,
                                Client_Contact__c,
                                Subject__c,
                                Project_Code__c,
                                Country_ies__c
                        FROM Invoice1__r
                    )
            FROM c2g__codaDimension3__c
            WHERE Id IN :dim3IdList
        ];
        
        for(c2g__codaDimension3__c querieddim3Val : querieddim3List){
            List<DDSalesInvoiceProxy__c> proxyInvoiceList1 = querieddim3Val.Invoice1__r;
            proxyInvoiceList.addAll(proxyInvoiceList1);
        }

        for (pse__Proj__c pseProjVal : pseProjList) {
            //for (pse__Billing_Event__c queriedBillingEventVal : queriedBillingEventList) {
                    //List<DDSalesInvoiceProxy__c> salesInvoiceProxyList = queriedBillingEventVal.DDSalesInvoiceProxy__r;
                    for (DDSalesInvoiceProxy__c proxyInvoiceVal : proxyInvoiceList) {
                        proxyInvoiceVal.Client_Contact__c = pseProjVal.Invoicing_Contact__r.Name;//pseProjVal.ffps_0387__Client_Contact__r.Name;
                        proxyInvoiceVal.Subject__c = pseProjVal.ffps_0387__Subject_s__c;
                        proxyInvoiceVal.Project_Code__c = pseProjVal.ffps_0387__Project_Code__c; 
                        proxyInvoiceVal.Country_ies__c  = pseProjVal.ffps_0387__Country_ies__c;
                        allSalesInvoiceProxyList.add(proxyInvoiceVal);
                    }                    
            //}
        }
        
        system.debug('allSalesInvoiceProxyList :: '+allSalesInvoiceProxyList);

        if (allSalesInvoiceProxyList != NULL && allSalesInvoiceProxyList.size() > 0) {
            update allSalesInvoiceProxyList;
        }
        system.debug('instructionList in after update of Save :: '+instructionList);
        if (!Test.isRunningTest() && instructionList.size() > 0) {
            update instructionList;
        }
        if (!Test.isRunningTest() && pseProjectList.size() > 0) {
            //Calculate project count
            CalculateProjectCount(pseProjectList, oldMap, false);
        }

    }


    public void afterDeletePSEProject(List<pse__Proj__c> pseProjectList) {
        //Calculate project count
        CalculateProjectCount(pseProjectList, NULL, true);
    }


    public void afterUnDeletePSEProject(List<pse__Proj__c> pseProjectList) {
        //Calculate project count
        CalculateProjectCount(pseProjectList, NULL, false);
    }

    public void CalculateProjectCount(List<pse__Proj__c> pseProjectList, Map<Id, pse__Proj__c> oldMap, Boolean isdelete) {

        system.debug('Inside CalculateProjectCount :: ');
        Map<Id,Account> accUpdatedMap = new Map<Id,Account>();//To contain updated account object
        Set<String> hierarchySet = new Set<String>();
        Map<String,Account> parentAccMap = new Map<String,Account>();
        List<pse__Proj__c> psepjList = new List<pse__Proj__c>();
        //After delete won't find record for the below soql query
        if (!isdelete) {
            psepjList = [
                SELECT Id, pse__Stage__c, pse__Account__r.Id, pse__Account__r.Name, pse__Account__r.Hierarchy_Group_ID__c, RecordTypeID
                FROM pse__Proj__c
                WHERE Id IN :pseProjectList
            ];
        } else {
            psepjList = pseProjectList;
        }

        //Get recordtypeID for pse__Proj__c recordtype Admin_Project
        for (pse__Proj__c pp : psepjList) {
            Boolean isOldVal = true;

            //Check old and new stage value.
            if (oldMap != NULL) {
               isOldVal = false;
               if (pp.pse__Stage__c != oldMap.get(pp.Id).pse__Stage__c) {
                    isOldVal = true;
               }
            }

            if ((pp.pse__Account__c != NULL) && pp.RecordTypeID == NULL && isOldVal) {
                //Add Hierarchy_Group_ID__c value to the hierarchySet.
                if (!hierarchySet.contains(pp.pse__Account__r.Hierarchy_Group_ID__c)) {
                    hierarchySet.add(pp.pse__Account__r.Hierarchy_Group_ID__c);
                }
            }
        }
        /*
          Get all accounts with the same Hierarchy_Group_ID__c and account list ordery by Parent_Company__c desc
          Reason : By getting orderby Parent_Company__c desc we always get Parent Hierarchy record first so that
          Group_project_count__c can be calculated without one more time using the account for loop
          Add only parent record and updated Project count account records to accUpdatedMap to avoid DML on account records.
        */
        List<Account> accList = [
            SELECT  Id,
                    Name,
                    Group_project_count__c,
                    New_Project_Count__c,
                    Parent_Company__c,
                    Hierarchy_Group_ID__c,
                    ParentId,
                    (
                        SELECT Id,
                            pse__Stage__c,
                            RecordTypeID
                        FROM pse__Projects__r
                        WHERE (pse__Stage__c = 'Live Project' OR pse__Stage__c = 'Closed and Billed' OR pse__Stage__c = 'Report Sent')
                        AND RecordTypeID = NULL
                    )
            FROM Account
            WHERE Hierarchy_Group_ID__c IN :hierarchySet
            ORDER BY Parent_Company__c DESC
        ];

        //Number of all projects in this Account's hierarchy
        Map<String, Integer> hierarchyToNumberOfProjects = new Map<String, Integer>();

        for (Account acc : accList) {
            //Check for parent account and add it to parentAccMap collection
            System.debug(
                '\nChecking account: ' + acc.Name +
                '\nGroup_project_count__c: ' + acc.Group_project_count__c +
                '\nNew_Project_Count__c: ' + acc.New_Project_Count__c +
                '\nParent Company: ' + acc.Parent_Company__c
            );

            if (acc.Parent_Company__c == true && acc.ParentId == NULL) {
                //acc.Group_project_count__c = 0;
                parentAccMap.put(acc.Hierarchy_Group_ID__c, acc);
            }
            //Update New_Project_Count__c for only accounts related to pseProjectList collection to avoid dml on every account in a hierarchy
            //if (acc.pse__Projects__r != NULL && acc.pse__Projects__r.size() > 0 && accIdSet.contains(acc.Id)) {
            if (acc.pse__Projects__r != NULL && acc.pse__Projects__r.size() > 0) {
                acc.New_Project_Count__c = acc.pse__Projects__r.size();
                //System.debug(acc.Name + ' Account Project count: ' + acc.New_Project_Count__c);
                if (hierarchyToNumberOfProjects.get(acc.Hierarchy_Group_ID__c) != NULL) {
                    Integer numberOfProject = hierarchyToNumberOfProjects.get(acc.Hierarchy_Group_ID__c) + acc.pse__Projects__r.size();
                    hierarchyToNumberOfProjects.put(acc.Hierarchy_Group_ID__c, numberOfProject);
                } else {
                    hierarchyToNumberOfProjects.put(acc.Hierarchy_Group_ID__c, acc.pse__Projects__r.size());
                }
                accUpdatedMap.put(acc.Id, acc);
            }

        }

        for (String eachHierarchy : parentAccMap.keySet()) {
            Integer totalNumberOfProjectsForAccount = hierarchyToNumberOfProjects.get(eachHierarchy);
            parentAccMap.get(eachHierarchy).Group_project_count__c = totalNumberOfProjectsForAccount;
            accUpdatedMap.put(parentAccMap.get(eachHierarchy).Id, parentAccMap.get(eachHierarchy));
        }

        //System.debug('accUpdatedMap: ' +  accUpdatedMap);
        if (accUpdatedMap.size() > 0) {
            System.debug('!!!accUpdatedMap: ' +  accUpdatedMap);
            update accUpdatedMap.values();
        }

    }

}