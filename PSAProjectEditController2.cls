public with sharing class PSAProjectEditController2 {

    private final pse__Proj__c proj;
    public PSAProjectEditController2(ApexPages.StandardController controller) 
    {
        this.proj=(pse__Proj__c )controller.getRecord();
    }
    public PageReference Save()
    {    
        //System.assertEquals('',this.proj.Name);
        PageReference pageRef = new PageReference('/'+ApexPages.currentPage().getParameters().get('Id'));
        final Boolean needDuplicateNameValidation = this.proj.Name!=''? 'code' != this.proj.Name.toLowerCase() : true;
        //System.assertEquals(5,[select count() from Projects__c where Name =: this.proj.Name]); 
        if (needDuplicateNameValidation && ([select count() from pse__Proj__c where Id!=:this.proj.Id AND Name =: this.proj.Name] >0 ||  [select count() from Projects__c where Name =: this.proj.Name] >0)) 
        {
            //System.assertEquals('','in If');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ProjectEdit_Duplicate_Name + ' ' + this.proj.Name));
            
        }
        else
        {
            //System.assertEquals('','in Else');
            database.update(this.proj);
        }
        return pageRef;
    }
    
}