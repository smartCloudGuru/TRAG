@isTest(seeAllData = true)
private class EmployeeOpenObjectivesReminderTest {

   // CRON expression: midnight on March 15.
   // Because this is a test, job executes
   // immediately after Test.stopTest().
   //public static String CRON_EXP  = '0 0 0 22 10 ?';
   public static String CRON_EXP  = '0 0 0 1 11 ?';

   static testmethod void test() { 
       
       
       Test.startTest();

      // Schedule the test job
      //String jobId = EmployeeOpenObjectivesReminder.employeeReminderSchedule(); //System.schedule('EmployeeOpenObjectivesReminderTest',CRON_EXP, new EmployeeOpenObjectivesReminder());
         
      // Get the information from the CronTrigger API object
      /*CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];*/

      // Verify the expressions are the same
      /*System.assertEquals(CRON_EXP, 
                          ct.CronExpression);*/

      // Verify the job has not run
      /*System.assertEquals(0, ct.TimesTriggered);      */
     Test.stopTest();
   }
}