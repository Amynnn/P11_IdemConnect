
/**
* Name: OrderHandler
* Description: This class has 2 methods:
* checks if an order has order products, and blocks modifications if not
* checks if an account has at least an Order, and uncheck "Active" checkbox if not
* Author: Amyn Fekkoul
* Date: 25/01/2022
*/ 
public with sharing class OrderHandler {
    
    //blocks the modification if the Order has no related Product - RG-01
    
    
    public static void checkIfOrderHasProducts (List<Order> orders) {

        for (Order o : orders){

            if (o.Number_of_Products__c == 0 && o.Status == 'Activated'){
                o.addError('Your Order has no Product');
            }
        }
    }

    public static void checkAccountOrders(List <Order> ordersDeleted) {

        List<Account> accounts  = new List<Account>();
        Set<Id> accIds          = new Set<Id>();

        for(Order ord : ordersDeleted){
           
            accIds.add(ord.AccountId);  
            //accounts = [SELECT Id, Active__c FROM Account WHERE Id IN :accIds]; 
        }

        accounts = [SELECT Id, Active__c FROM Account WHERE Id IN :accIds];

        for (Account acc : accounts){
            
            List<Order> orders = [SELECT Id FROM Order WHERE AccountId =:acc.Id];

            if (orders.size() == 0){
                acc.Active__c = false;
            }
        }
        update accounts;
    }
}