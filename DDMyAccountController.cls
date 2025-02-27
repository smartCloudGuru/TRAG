public class DDMyAccountController {
    
    public Contact BillingContact{get;set;}
    public Account Acct{get;set;}
    public static Id testUserId {get; set;}
    public List <DD_Instruction__c> Instrs{get;set;}
    public List <DDSalesInvoiceProxy__c> Invs{get;set;}
    public List<Account> relatedBillingAccounts {get;set;}
    public String accountBalance {get;set;}
    public InstructionSummary InstrSummary{get;set;}
    String[] paymentStatus = new String[]{};
    public Integer paidInvoiceDueDays {get;set;}
    public Boolean displayLUMAAccountsTab {get;set;}
    public Map<String, Decimal> outstandingBalanceMap {get;set;}
    //public ApexPages.StandardSetController con {get;set;}
    //public List<InvoiceListWrapper> proxyInvoices {get;set;}
    
    public String[] getPaymentStatus() {
        return paymentStatus;
    }        
    public void setPaymentStatus(String[] paymentStatus) {
        this.paymentStatus= paymentStatus;
    }
    
    public List<Schema.FieldSetMember> getLicenceFields() {
        return SObjectType.Account.FieldSets.DD_License.getFields();
    }
    
    public List<Schema.FieldSetMember> getInvoiceFields() {
        return SObjectType.DD_Demo_Invoice__c.FieldSets.All.getFields();
    }
    
    public List<Schema.FieldSetMember> getBillingFields() {
        return SObjectType.Account.FieldSets.DD_Billing_Info.getFields();
    }

    
    public List<Schema.FieldSetMember> getInstructionFields() {
        return SObjectType.DD_Instruction__c.FieldSets.My_Account.getFields();
    }
    
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select id, Due_Days__c, Invoice_Total__c, Invoice_Currency__c,Invoice_Date__c, Subject__c, Invoice_Number__c, Invoice_Status__c , 
                                                                                    Print_Status__c , Payment_Status__c , Outstanding_Value__c , Name, Account__c, Bank_Account__c, Billing_Event__c, 
                                                                                    Company__c, Sales_Invoice__c from DDSalesInvoiceProxy__c                                                                                     
                                                                                    where Account__r.LUMA_Account__c =: this.Acct.Id and Invoice_Date__c <=: system.today() 
                                                                                    and Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__r.DD_Instruction__c != null 
                                                                                    order by Payment_Status__c desc, Invoice_Date__c asc]));
                system.debug('con :: '+con);    
                // sets the number of records in each page set
                con.setPageSize(15);
            }
            return con;
        }
        set;
    }
    
    // Method to generate select otion list for all possible invoice state
    public List<SelectOption> getPaymentStatusOptions() {
        
        system.debug('DDMyAccountController :: getPaymentStatusOptions :: start');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Paid','Paid'));
        options.add(new SelectOption('Unpaid','Unpaid'));
        options.add(new SelectOption('Part Paid','Part Paid'));
        system.debug('DDMyAccountController :: getPaymentStatusOptions :: end');
        return options;
    }
        
    // 1 arg Constructor    
    public DDMyAccountController(Id userId) {
      
      system.debug('DDMyAccountController :: DDMyAccountController :: start');
      DDMyAccountController.testUserId = userId;
      new DDMyAccountController();
      system.debug('DDMyAccountController :: DDMyAccountController :: end');
    }
    
    /**
        This method fetches the logged in user account and associate instruction values to it
    */  
    public DDMyAccountController() {
        
        system.debug('DDMyAccountController 1 arg :: DDMyAccountController :: start');
        Id userId;
        displayLUMAAccountsTab = false;
        if(Test.isRunningTest()){
            userId = DDMyAccountController.testUserId;
        }
        else{
            userId = UserInfo.getUserId();
        }
        User Usr = [SELECT Phone, ContactId, Contact.AccountId, profile.name, Id FROM User WHERE Id =: userId];
        if(Usr != null && Usr.profile.name != null && !Usr.profile.name.equals('Client Portal User')){
            displayLUMAAccountsTab = true;
        }
        system.debug('displayLUMAAccountsTab :: '+displayLUMAAccountsTab);
        Account acc = [select Id, DD_Account_Balance__c from Account where Id= : Usr.Contact.AccountId];
        
        this.paidInvoiceDueDays = 0;
        this.Acct = getAccount(acc.Id);
        this.Instrs =  getInstructions();
        this.Invs =  getInvoices(acc.Id); 
        this.relatedBillingAccounts = getRelatedBillingAccounts(acc.Id);
        InstrSummary = new InstructionSummary();        
        InstrSummary.CompletedInvoicedPaid = 2;
        InstrSummary.CompletedInvoicedNotPaid = 3;
        InstrSummary.CompletedNotInvoiced = 2;
        InstrSummary.InProgress = 5;
        InstrSummary.NewlyCreated = 7;        
        
        /*if(con == null) {
            con = new ApexPages.StandardSetController(Database.getQueryLocator([select id, Due_Days__c, Invoice_Total__c, Invoice_Currency__c,Invoice_Date__c, Subject__c, Invoice_Number__c, Invoice_Status__c , 
                                                                                Print_Status__c , Payment_Status__c , Outstanding_Value__c , Name, Account__c, Bank_Account__c, Billing_Event__c, 
                                                                                Company__c, Sales_Invoice__c from DDSalesInvoiceProxy__c 
                                                                                where Account__r.LUMA_Account__c =: this.Acct.Id and Invoice_Date__c <=: system.today() order by createddate desc]));
            system.debug('con :: '+con);    
            // sets the number of records in each page set
            con.setPageSize(20);
        }*/
        
        //this.proxyInvoices = getProxyInvoices();
        system.debug('DDMyAccountController 1 arg :: DDMyAccountController :: end');
    }
    
    public List<InvoiceListWrapper> proxyInvoices {
        get {
            proxyInvoices = new List<InvoiceListWrapper>();
            
            for (DDSalesInvoiceProxy__c inv : (List<DDSalesInvoiceProxy__c>)con.getRecords()){
                proxyInvoices.add(new InvoiceListWrapper(inv));
            }
            
            system.debug('proxyInvoices :: '+proxyInvoices);
            
            return proxyInvoices;
        }
        set;
    }
    
    /*public List<InvoiceListWrapper> getProxyInvoices() {
        
        system.debug('con in getProxyInvoices :: '+con);
        proxyInvoices = new List<InvoiceListWrapper>();
                
        for (DDSalesInvoiceProxy__c inv : (List<DDSalesInvoiceProxy__c>)con.getRecords()){
            proxyInvoices.add(new InvoiceListWrapper(inv));
        }
        
        system.debug('proxyInvoices :: '+proxyInvoices);
        
        return proxyInvoices;
    }*/
    
    /**
        This metod calculates total outstanding balance to a client
    */
    public String getBalance() {
    
        system.debug('DDMyAccountController :: getBalance :: start');
        if(this.Acct.DD_Account_Balance__c!=null){
            return String.valueOf(this.Acct.DD_Account_Balance__c)+' GBP';
        }
        else{
            return '0';
        }
  
    }
    
    public List<Account> getRelatedBillingAccounts(Id accId){
        List<Account> accountList = [Select Id,  
                                 (Select Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, 
                                  ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, 
                                  ShippingCountry From Accounts__r) From Account a where Id =: accId];
        system.debug('accountList :: '+accountList);
        if(accountList != null 
           && accountList.size() == 1){
            return accountList.get(0).Accounts__r;
        }
        return new List<Account>();
    }

    /**
        This method fetches all the invoice specific to a client
    */
    public List<DDSalesInvoiceProxy__c> getInvoices(Id accId) {
        
        system.debug('DDMyAccountController :: getInvoices :: start');
        Decimal acctBal = 0.00;
        List<DDSalesInvoiceProxy__c> ddSalesInvoiceProxyList;
        outstandingBalanceMap = new Map<String, Decimal>();        
        //Date dt = system.today();                        
        
        if(!Test.isRunningTest()){
            ddSalesInvoiceProxyList = [select id, Due_Days__c, Invoice_Total__c, Invoice_Currency__c,Invoice_Date__c, Subject__c, Invoice_Number__c, Invoice_Status__c , 
                                                                    Print_Status__c , Payment_Status__c , Outstanding_Value__c , Name, Account__c, Bank_Account__c, Billing_Event__c, 
                                                                    Company__c, Sales_Invoice__c from DDSalesInvoiceProxy__c 
                                                                where Account__r.LUMA_Account__c =: accId and Invoice_Date__c <=: system.today() 
                                                               and Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__r.DD_Instruction__c != null 
                                                                order by createddate desc
                                                               /*and DDDimension_3__r.ffps_0387__Project__r.pse__Opportunity__r.DD_Instruction__c != null*/];
        }
        else{
            ddSalesInvoiceProxyList = [select id, Due_Days__c, Invoice_Total__c, Invoice_Currency__c,Invoice_Date__c, Subject__c, Invoice_Number__c, Invoice_Status__c , 
                                                                    Print_Status__c , Payment_Status__c , Outstanding_Value__c , Name, Account__c, Bank_Account__c, Billing_Event__c, 
                                                                    Company__c, Sales_Invoice__c from DDSalesInvoiceProxy__c 
                                                                where Account__r.LUMA_Account__c =: accId and Invoice_Date__c <=: system.today() 
                                                               /*and Sales_Invoice__r.c2g__Dimension3__r.ffps_0387__Project__r.pse__Opportunity__r.DD_Instruction__c != null */
                                                                order by createddate desc
                                                               /*and DDDimension_3__r.ffps_0387__Project__r.pse__Opportunity__r.DD_Instruction__c != null*/];
        }
        system.debug('ddSalesInvoiceProxyList :: '+ddSalesInvoiceProxyList);
        for(DDSalesInvoiceProxy__c ddSalesInvoiceProxyVal : ddSalesInvoiceProxyList){
            if(!outstandingBalanceMap.containsKey(ddSalesInvoiceProxyVal.Invoice_Currency__c)){
                outstandingBalanceMap.put(ddSalesInvoiceProxyVal.Invoice_Currency__c, ddSalesInvoiceProxyVal.Outstanding_Value__c);
            }
            else{
                acctBal = outstandingBalanceMap.get(ddSalesInvoiceProxyVal.Invoice_Currency__c);
                outstandingBalanceMap.put(ddSalesInvoiceProxyVal.Invoice_Currency__c, acctBal + ddSalesInvoiceProxyVal.Outstanding_Value__c);
            }
            /*accountBalanceList.add(ddSalesInvoiceProxyVal.Invoice_Currency__c + String.valueOf(ddSalesInvoiceProxyVal.Outstanding_Value__c));
            acctBal += ddSalesInvoiceProxyVal.Outstanding_Value__c ; */
        }
        //this.AccountBalance = String.valueOf(acctBal);
        system.debug('DDMyAccountController :: getInvoices :: end');
        return ddSalesInvoiceProxyList;
    }  
    
    
    /**
        This method fetches the instructions to be displayed on account
    */
    private List <DD_Instruction__c> getInstructions() {
    
        system.debug('DDMyAccountController :: getInstructions :: start');
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getInstructionFields()) {
            query += f.getFieldPath() + ', ';
        }

        query += 'Id FROM DD_Instruction__c where DD_Type__c != null';
        system.debug('DDMyAccountController :: getInstructions :: end');
        return Database.query(query);
    }
    
    /**
        This method fetches the looged user account with relevant fields
    */
    private Account getAccount(Id accId) {
    
        system.debug('DDMyAccountController :: getAccount :: start');
        String query = 'SELECT DD_Account_Balance__c,';
        for(Schema.FieldSetMember f : this.getLicenceFields()) {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getBillingFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, DD_Billing_Contact__c, Billing_Contact__c, Name FROM Account where Id = \'' + accId + '\'';
        system.debug('DDMyAccountController :: getAccount :: end');
        return Database.query(query);
    }
    
    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         system.debug('con in next :: '+con); 
         con.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }
    
     public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    // Wrapper class
    public class InstructionSummary{
        
        public Integer CompletedInvoicedPaid {get;set;}
        public Integer CompletedInvoicedNotPaid {get;set;}
        public Integer CompletedNotInvoiced {get;set;}
        public Integer InProgress {get;set;}
        public Integer NewlyCreated {get;set;}                
    }
    
    public class InvoiceListWrapper {        
        public DDSalesInvoiceProxy__c invVal{get;set;}
               
        public InvoiceListWrapper(DDSalesInvoiceProxy__c inv){
            this.invVal = inv;
        }               
    }
}