/**
    @author         : Mungroo Hasseeb
    Date Created    : 24/03/2010
    Description     : controller for Account Print View
*/  
public with sharing class AccountPrintView {  
    private final Account acc;

	/**
	* Default Constructor
	*/
    public AccountPrintView() {}  
    
    public AccountPrintView(ApexPages.StandardController stdController) {
        this.acc = (Account)stdController.getRecord();
    }
    
    /**
    * Get the 5 Recent Opportunity to display
    */
	public List<Opportunity> getRecentOpportunity() {
		List<Opportunity> recentOpportunities = [Select o.AccountId, o.StageName, o.Service__c, o.Practice_area__c, o.Name, o.CloseDate, o.CreatedDate, o.Amount From Opportunity o where AccountId =:acc.Id order by CreatedDate DESC limit 5];
		return recentOpportunities;
	} 
	
	/**
    * Get the 5 Recent Projects to display
    */
    
    
	public List<Projects__c> getRecentProjects() {
	 List<Projects__c> recentProjects = [Select p.Type__c, p.Subjects_Industry__c, p.Name, p.Code__c, p.Client__c, p.Case_manager__c, p.Budget__c From Projects__c p where Client__c =:acc.Id order by CreatedDate DESC limit 5];
		
		return recentProjects;
	} 
	
	
	//public List<ActivityHistory> getRecentActivityHistory() {
		//List<ActivityHistory> list = new List<ActivityHistory>();
		//Account account = [Select a.Id, (Select Subject, IsTask, ActivityDate, Status, Priority, ActivityType, Summary__c From ActivityHistories order by CreatedDate DESC limit 5) From Account a where Id=:acc.Id limit 1];		
		//return null;
	//}
	
	/**
    * Get the debtors whosw amount owed is greater than zero
    */
	public List<Debtors_information__c> getDebtors() {
		List<Debtors_information__c> debtors = new List<Debtors_information__c>();
		List<Debtors_information__c> allDebtors = [SELECT Id, Amount_owed__c, Days_overdue__c, Original_payment_due_date__c, Name FROM Debtors_information__c WHERE Company__c =: acc.Id];
			for (Debtors_information__c debtor : allDebtors) {
			if (debtor.Amount_owed__c > 0) {
				debtors.add(debtor);
			}
		}
		return debtors;
	}
	
  
}