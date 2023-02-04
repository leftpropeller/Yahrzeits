// Steve Berley - steve@leftpropeller.com
// 
trigger contactTrigger on contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	
	if(trigger.isBefore && trigger.isUpdate){
		// cleansout extraneous fields - only relevant for updates
		for (contact so : trigger.new){
			if (so.Birthdate == null && string.isblank(so.Birthdate_Hebrew__c)) {
				so.Time_of_Birth__c = null;
				so.Birthdate_Hebrew_in_Hebrew__c = null;
				so.Next_Birthday_Hebrew_Calendar__c = null;
			}
			if (so.Date_of_Death__c == null && string.isblank(so.Date_of_Death_Hebrew__c)) {
				so.Time_of_Death__c = null;
				so.Date_of_Death_Hebrew_in_Hebrew__c = null;
				so.Next_Yahrzeit__c = null;
			}
		}
	}


	if(trigger.isAfter && !trigger.isDelete){
		if (lpTools.ranOnce() && !test.isRunningTest() ) return;  // preventing trigger recursion

		map<id, string> needsUpdate = new map<id, string>();  // map<contact id, status>

		for (contact so : trigger.new){
			string status = '';
			string analysis;
			// updating hebrew dates - checking on insert
			if (trigger.isInsert ) {
				if (so.birthdate != null || !string.isblank(so.Birthdate_Hebrew__c)) status += contactTriggerHandler.bd;
				if (so.Date_of_Death__c != null || !string.isblank(so.Date_of_Death_Hebrew__c)) status += contactTriggerHandler.yz;
			}

			// updating hebrew dates - checking on update
			else if (trigger.isUpdate){
				contact was = trigger.oldMap.get(so.id);
				if (!string.isblank(hebrewCalConverter.dateNeedsUpdating(so.birthdate, was.birthdate, so.Time_of_Birth__c, was.Time_of_Birth__c, so.Birthdate_Hebrew__c, was.Birthdate_Hebrew__c, so.Next_Birthday_Hebrew_Calendar__c))) status += contactTriggerHandler.bd;
				
				if (!string.isblank(hebrewCalConverter.dateNeedsUpdating(so.Date_of_Death__c, was.Date_of_Death__c,  so.Time_of_Death__c, was.Time_of_Death__c, so.Date_of_Death_Hebrew__c, was.Date_of_Death_Hebrew__c, so.Next_Yahrzeit__c))) status += contactTriggerHandler.yz;
			}

			if ( !string.isblank(status) ) needsUpdate.put(so.id, status);  // if there's a status save it to the map
		} 
		contactTriggerHandler.updateHebrewDates(needsUpdate);
	}
}