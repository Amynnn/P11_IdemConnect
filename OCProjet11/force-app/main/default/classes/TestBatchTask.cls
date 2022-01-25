@isTest
public class TestBatchTask {
    
    @testSetup
    static void setup() {
    	TestDataFactory.createOrders(100, 0, 0);
    }
    
     @isTest static void testExecuteBatch() {
         
        Test.startTest();
        BatchTask bt = new BatchTask();
        Id batchId = Database.executeBatch(bt);
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(100, tasks.size());
    }

}