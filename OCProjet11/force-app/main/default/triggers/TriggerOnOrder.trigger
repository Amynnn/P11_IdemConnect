/*
* Name: TriggerOnOrder
* Description: This trigger is executed before an order's update, or after a deletion
* Author: Amyn Fekkoul
* Date: 25/01/2022
*/ 
trigger TriggerOnOrder on Order (before update, after delete) {

    if(Trigger.IsBefore && Trigger.isUpdate){
        OrderHandler.checkIfOrderHasProducts(Trigger.new);
    }

    if(Trigger.IsAfter && Trigger.isDelete){
        OrderHandler.checkAccountOrders(Trigger.old);
    }
}