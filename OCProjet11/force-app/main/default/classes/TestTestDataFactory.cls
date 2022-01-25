@isTest
public with sharing class TestTestDataFactory {
    public static testMethod void TestDataCreation() {

        List<Account> accts;
        List<Order> orders;
        List<OrderItem> orderitems;

        TestDataFactory.createOrders(1, 1, 1);
        Test.startTest();
        
        accts = [SELECT Id FROM Account];
        orders = [SELECT Id FROM Order];
        orderitems = [SELECT Id FROM OrderItem];

        System.assertEquals(accts.size(), 1);
        System.assertEquals(orders.size(), 1);
        System.assertEquals(orderitems.size(), 1);
        
        Test.stopTest();

    }
}