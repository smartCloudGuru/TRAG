@isTest
private class ProjectSubjectEditControllerTests {
    private static testMethod void testProjectSubjectEditController() {
        Subject__c s = new Subject__c(Name = 'test method subject');
        insert s;
        Projects__c p = new Projects__c(Name='test method test project');
        insert p;
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProjectSubjectEditController controller = new ProjectSubjectEditController(sc);
        controller.subjectNames = 'test Subject__Separator__test Subject 2';
        System.assertEquals(controller.getCurrentSubjects(), '[]');
        System.assert(ProjectSubjectEditController.getAvailableSubjects().contains('test method subject'));
        controller.save();
        
        sc = new ApexPages.StandardController(p);
        controller = new ProjectSubjectEditController(sc);
        controller.subjectNames = 'test Subject__Separator__test Subject 3';
        System.assert(controller.getCurrentSubjects().contains('test Subject 2'));
        System.assert(ProjectSubjectEditController.getAvailableSubjects().contains('test Subject 2'));
        controller.save();
        
        controller = new ProjectSubjectEditController(sc);
        System.assert(!controller.getCurrentSubjects().contains('test Subject 2'));
        System.assert(ProjectSubjectEditController.getAvailableSubjects().contains('test Subject 2'));
        System.assert(ProjectSubjectEditController.getAvailableSubjects().contains('test Subject 3'));
    }
}