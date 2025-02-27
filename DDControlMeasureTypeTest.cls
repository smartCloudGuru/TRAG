/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true) 
/* Seealldata is true because user creation in Risk Advisory depends on 
Financial Force Managed Package in which current company needs to be set 
and user to be assigned to multiple Financialforce queues which is not possible through test data creation. 
This has been checked with Financial Force Team */

public class DDControlMeasureTypeTest {

    /**
        Test if Control Measure record is updated correctly with the chosen Control measure type
    */
    static testMethod void controlMeasureSaveTest() {
        
        system.debug('DDControlMeasureTypeTest :: controlMeasureSaveTest :: start');
        User u1;
        User u2;
        User u3;
        Control_Measure_Type__c cmType1;
        Control_Measure_Type__c cmType2;
        Control_Measure_Type__c cmType3;
        DD_Control_Measure__c cm; 
        DDControlMeasureType cmType;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runas(thisUser){
            u1 = TestDataHelper.createSalesforceUser('test@test.com.testt', 'tAlias', 'test@test.com');
            u2 = TestDataHelper.createPortalUserManagerRoleWithVerificationPermSet();            
        }
        system.runas(u1){
            u3 = [select Id, UserRoleId, contact.AccountId from User where id =: u2.Id];
            cmType1 = TestDataHelper.createControlMeaureType();
            cmType1.Name = 'Risk Advisory'; 
            cmType1.DDAccount__c = u3.contact.AccountId;
            insert cmType1;
            cmType2 = TestDataHelper.createControlMeaureType();
            cmType2.DDAccount__c = u3.contact.AccountId;
            cmType2.Type__c = 'Internal';    
            insert cmType2;
            cmType3 = TestDataHelper.createControlMeaureType();
            cmType3.DDAccount__c = u3.contact.AccountId;
            cmType3.Type__c = 'External';    
            insert cmType3;
       }
       system.runas(u2){
            List<RecordType> rcList = [Select r.SobjectType, r.Name, r.Id From RecordType r 
                                        where r.SobjectType = 'DD_Control_Measure__c' and Name = 'Risk Advisory'];
            cm = TestDataHelper.createControlMeasure();
            cm.RecordTypeId = rcList.get(0).Id;
            cm.DD_Type__c = 'Risk Advisory';
            insert cm;
            ApexPages.currentPage().getParameters().put('id', cm.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(cm);
            cmType = new DDControlMeasureType(sc);
            cmType.testAcctId = u3.contact.AccountId;
            cmType.obj = cm;
            SelectOption[] selOpt = cmType.getcontrolMeasureList();
            system.assertEquals(2, selOpt.size());
            //system.assertEquals(cmType1.Id, selOpt.get(0).value.subString(0,15));
            Pagereference pg = cmType.save();
            DD_Control_Measure__c cm1 = [select Id, DD_Type__c from DD_Control_Measure__c where Id =: cm.Id];
            system.assertEquals(cm1.DD_Type__c, 'Risk Advisory');
        }
        system.debug('DDControlMeasureTypeTest :: controlMeasureSaveTest :: end');
    }
 }