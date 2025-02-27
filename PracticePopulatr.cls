global class PracticePopulatr implements Database.Batchable<sObject>
{
	global PracticePopulatr()
	{
		
	}
	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		String listOfOpportunities = 'select pse__Practice__c,pse__Practice__r.Name,Id,practiceText__c,Name from Opportunity where pse__Practice__c!=null';
        return Database.getQueryLocator(listOfOpportunities);
	}
	global void execute(Database.BatchableContext bc, List<Opportunity> listOfOpportunities)
    {
        System.debug('in');
        List<Opportunity> finalUpdateList = new List<Opportunity>();
       	for(Opportunity opp:listOfOpportunities)
        {
            	if(opp.pse__Practice__c!=null)
                {
                    opp.practiceText__c = opp.pse__Practice__r.Name;
            		finalUpdateList.add(opp);
                }
             System.debug('OPP ID '+opp.Id +'OPP PRACTICE NAME '+ opp.pse__Practice__r.Name);   
             database.update(finalUpdateList);
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        
    }
}