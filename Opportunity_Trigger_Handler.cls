public class Opportunity_Trigger_Handler{

    private static Opportunity_Trigger_Handler instance;
    public static Opportunity_Trigger_Handler getInstance()
    {
        if (instance == null) instance = new Opportunity_Trigger_Handler();
    return instance;
    }
    //-- PUBLIC METHODS 
    public static Boolean isWorking = false;
    public void onBeforeInsert(final List<Opportunity > newObjects) 
    {
        if(!isWorking)
        this.populatePractice(newObjects);
    }
    public void onBeforeUpdate(final List<Opportunity > oldObjects, final Map<Id, Opportunity > oldObjectsMap,
                           final List<Opportunity > newObjects, final Map<Id, Opportunity > newObjectsMap) 
                           {
                               if(!isWorking)
                               this.populatePracticeUpdate(newObjects,oldObjectsMap); 
                           }
    public void onAfterUpdate(final List<Opportunity > oldObjects, final Map<Id, Opportunity > oldObjectsMap,
                          final List<Opportunity > newObjects, final Map<Id, Opportunity > newObjectsMap) 
                          {
                            
                          }
    public void onAfterInsert(final List<Opportunity > newObjects, final Map<Id, Opportunity > newObjectsMap)
    {
        
    }
    //--PRIVATE METHODS
        private Map<Id,Opportunity> populatePractice(final List<Opportunity> newObjects){
        //Method to populate the practiceText with Name of Practice
        //in Opportunity Record
            isWorking = true;
            Map<Id,Id> oppOwnerIdnId = new Map<Id,Id>();
           
            Map<Id,String> oppIdPractName = new Map<Id,String>();
                    
            //Practice in Opportunity needs to get populated from OppOwners Department.
            //In Order to do that we need to pull Practice record Id matching the Department Name.
            //First we map owners to Opps.
            for(Opportunity opp:newObjects){
                if(opp.pse__Practice__c!=null)
                oppOwnerIdnId.put(opp.pse__Practice__c,opp.Id);
                //System.assertEquals(null,opp.pse__Practice__c);
            }
                               
            //Get all practice records matching the Opp.
            List<pse__Practice__c> practiceList = [select Id,Name from pse__Practice__c where Id IN:oppOwnerIdnId.keyset()];
            
            //Map name to Practice object so that we can pull them by owner's Department 
            for(pse__Practice__c instanc:practiceList){
                //System.assertEquals(null,instanc.Name);
                oppIdPractName.put(oppOwnerIdnId.get(instanc.id),instanc.Name);
            }
            
            //Populate Practice Lookup on Opportunity.
            for(Opportunity opp:newObjects){
                opp.practiceText__c = oppIdPractName.get(opp.Id);
                
                //System.assertEquals(null,opp.practiceText__c);
            }
               
            return null;
        }
        private Map<Id,Opportunity> populatePracticeUpdate(final List<Opportunity> newObjects,final Map<Id, Opportunity > oldObjectsMap){
        //Method to populate the practiceText with Name of Practice
        //in Opportunity Record
            isWorking = true;
            Map<Id,Id> oppOwnerIdnId = new Map<Id,Id>();
           
            Map<Id,String> oppIdPractName = new Map<Id,String>();
                    
            //Practice in Opportunity needs to get populated from OppOwners Department.
            //In Order to do that we need to pull Practice record Id matching the Department Name.
            //First we map owners to Opps.
            for(Opportunity opp:newObjects){
                if(opp.pse__Practice__c!=oldObjectsMap.get(opp.Id).pse__Practice__c)
                oppOwnerIdnId.put(opp.pse__Practice__c,opp.Id);
            }
                               
            //Get all practice records matching the Opp.
            List<pse__Practice__c> practiceList = [select Id,Name from pse__Practice__c where Id IN:oppOwnerIdnId.keyset()];
            
            //Map name to Practice object so that we can pull them by owner's Department 
            for(pse__Practice__c instanc:practiceList){
                oppIdPractName.put(oppOwnerIdnId.get(instanc.id),instanc.Name);
            }
            
            //Populate Practice Lookup on Opportunity.
            for(Opportunity opp:newObjects){
                opp.practiceText__c = oppIdPractName.get(opp.Id);
            }
                
            return null;
        }
}