/*
* Name: BatchTask
* Description: This class launches a batch which assigns a new call task for each account without any order nor call task
* Author: Amyn Fekkoul
* Date: 25/01/2022
*/ 

public with sharing class BatchTask implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        System.debug('batch start ');
        
		return Database.getQueryLocator([SELECT Id, Name, OwnerId FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order)]);

        //select id, whatid from task where what.type = 'Account'

    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records

        System.debug('Nombre de Account : ' + scope.size());
        
        List<Task> taskList = new List<Task>();
        Integer recordsProcessed = 0;
        
		System.debug('Nombre de Account : ' + scope.size());
        
        for (Account account : scope) {

            List<Task> tasks = [SELECT Id, Subject FROM Task WHERE WhatId =:account.Id AND Subject = 'Call'];

            if(tasks.isEmpty()){
        		System.debug('Account trouvé, nom : ' + account.Name);
                Task task = new Task();

                task.Subject = 'Call';
                task.Status = 'New';
                task.Priority = 'Normal';
                task.WhatId = account.Id;
                task.OwnerId = account.OwnerId;

                task.IsReminderSet = true;
                task.ReminderDateTime = Date.today()+5;

                    // add task to list to be updated
                taskList.add(task);
                    // increment the instance member counter
                recordsProcessed = recordsProcessed + 1;
            } 
            else{delete tasks;}
        }
        System.debug('taille de la tasklist : ' + taskList.size());
        if (taskList.size() > 0){
          insert taskList; 
        }
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
		                    FROM AsyncApexJob
		                    WHERE Id = :bc.getJobId()];
		System.debug(job);
		// Display total of processed records in debug console
		//System.debug(recordsProcessed + ' records processed.');
        System.debug('batch finish');
    }
}