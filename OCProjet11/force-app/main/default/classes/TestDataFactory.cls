public with sharing class TestDataFactory {
    public static void createOrders(Integer nAccounts, Integer nOrders, Integer nItems) {
        
        //Create Accounts, Orders, Order items lists
        List<Account> accts = new List<Account>();
        List<Order> orders = new List<Order>();
        List<OrderItem> oitems = new List<OrderItem>();
        
        //Create Product
        Product2 pd1 = new Product2(Name = 'Gene100W', IsActive = true);
        insert pd1;

        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), 
            Product2Id = pd1.Id, 
            UnitPrice = 1, 
            IsActive = true
            );
        insert pbe;
        
        //Create a defined number of Accounts
        for (Integer i = 0; i < nAccounts; i++) {
            Account acc = new Account(
                Name = 'Test Account n°' + i
            );
        accts.add(acc);
        }
        insert accts;
        
        //Create a defined number of Orders, associated with Accounts thanks to the AccountId
        for(Integer i = 0; i < accts.size(); i++) {
            Account acc = accts[i];

            for(Integer o = 0 ; o < nOrders ; o++) { 
                orders.add(new Order(
                    AccountID = acc.id, 
                    EffectiveDate = Date.today(), 
                    Pricebook2Id = Test.getStandardPricebookId(), 
                    Status = 'Draft'
                    ));
                }
            }
        insert orders;

        //Create a defined number of Items, associated with Orders thanks to the OrderId
        for (Integer i = 0; i < orders.size(); i++) {
            Order testOrds = orders[i];

            for(Integer oi = 0; oi < nItems; oi++ ) {
                oitems.add(new OrderItem(
                    OrderID             = testOrds.Id, 
                    Product2Id          = pd1.Id, 
                    PricebookEntryId    = pbe.Id,
                    UnitPrice           = 1, 
                    Quantity            = 1
                    ));
                }
            }
        insert oitems;
    }
    }