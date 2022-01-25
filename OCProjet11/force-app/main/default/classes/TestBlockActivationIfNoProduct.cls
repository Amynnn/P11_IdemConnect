@isTest
public with sharing class TestBlockActivationIfNoProduct {
    
    public static testMethod  void TestErrorMessageWhenNoProduct()  {
        
        TestDataFactory.createOrders(1, 1, 0);
        
        List<Order> orders = [SELECT Id, Status FROM Order];
        
        Test.startTest();
        for(Order o: orders) {
            o.Status = 'Activated';
        }
        try {
            update orders;         
        } 
        catch(Exception e) 
        {
            System.assert(e.getMessage().contains('Your Order has no Product'));
        }
        Test.stopTest();
    }
    
    public static testMethod  void TestActivationIfProduct()  {
        
        TestDataFactory.createOrders(1, 1, 1);
        
        List<Order> orders = [SELECT Id, Status FROM Order];
        
        Test.startTest();
        for(Order o: orders) {
            o.Status = 'Activated';
        }
        update orders;
        System.assertEquals('Activated', orders[0].Status);
        System.debug('Status 2 is ' + orders[0].Status);
        Test.stopTest();
    }
    
    public static testMethod  void TestActiveCheckbox()  {
        
        TestDataFactory.createOrders(1, 1, 1);
        
        List<Account> accts =[SELECT Id, Active__c FROM Account];
        Order myOrder = [SELECT Id FROM Order LIMIT 1];
        OrderItem myOrderItem = [SELECT Id FROM OrderItem LIMIT 1];
        
        for (Account acct :accts){
            acct.Active__c = true;
        }
        
		delete myOrderItem;
        delete myOrder;
        
        Account acct = [SELECT Id, Active__c FROM Account LIMIT 1];
        
        System.debug(myOrderItem.Id + 'is the item');
        System.debug('Status of the account after deletion is : ' + acct.Active__c);
        Test.startTest();
        System.assertEquals(false, acct.Active__c);  
        Test.stopTest();
    }
}