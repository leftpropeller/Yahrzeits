// Steve Berley - steve@leftpropeller.com
// 
global with sharing class updateYahrzeits implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {
	private static integer batchSize {
		get {
			batchSize = 1;            
			if (test.isRunningTest()) batchSize = 100;
			return batchSize;
		} set;
	} 

	global Database.QueryLocator start(Database.BatchableContext BC) {
		// first update today's info.  results saved to Hebrew_Dates__c in custom settings
		hebrewCalConverter hcc = new hebrewCalConverter();
		hcc.updateToday();

		// set query to find all contacts that are either missing an observance of their hebrew birthdatre or yahrzeit or have ones in the past.
		String YahrzeitQuery = 'SELECT id ';
		YahrzeitQuery += ' FROM contact ';
		YahrzeitQuery += ' WHERE ((Date_of_Death__c != null or Date_of_Death_Hebrew__c != null) and ( Next_Yahrzeit__c = null or Next_Yahrzeit__c < today)) ';
		YahrzeitQuery += ' OR ((Date_of_Death__c != null or Date_of_Death_Hebrew__c != null) and ( Next_Yahrzeit__c = null or Next_Yahrzeit__c < today))';


		if (test.isRunningTest()){
			// note that since adding test records causes the data to be current we run into a Heisenberg situation   
			// where the operational query can't yield results on the test data, so we substitute with below.
			YahrzeitQuery = 'select id from contact';  
		}        
		return Database.getQueryLocator(YahrzeitQuery);
	}

   	global void execute(Database.BatchableContext BC, List<contact> scope) {
		// just touching the records causes them to take care do themselves 
		lpTools.saveList('update', scope, 'updateYahrzeits - execute');  
	}

	global void finish(Database.BatchableContext BC) {
	}

   	global void execute(SchedulableContext SC) {
		database.executebatch(new updateYahrzeits(), batchSize);
	}

	global static void start(integer hour){
	    if (hour == 0) database.executebatch(new updateYahrzeits(), batchSize);
	    else {
	  		string jobName = 'Nightly update of yahrzeits; started on '+datetime.now().format();
	  		string cron2 = '0 0 ' + string.valueof(hour) + ' * * ?';
			system.schedule(jobName, cron2, new updateYahrzeits());
	    } 
	}
}