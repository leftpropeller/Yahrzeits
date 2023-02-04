// Steve Berley - steve@leftpropeller.com
// 
public with sharing class contactTriggerHandler {
	// public contactTriggerHandler() {  }
	public static final string bd = '-birthday';
	public static final string yz = '-yahrzeit';

	public static void updateHebrewDates(map<id, string> needsUpdate){
		if (needsUpdate == null || needsUpdate.size() == 0) return;

		if (!system.isBatch() && !system.isFuture() ) {
			// Dispatch to future context where possible; required for triggered updates
			updateHebrewDates_future(needsUpdate);
			if(!test.isRunningTest()) return; // for test coveage
		}

		//  you can't do callouts from a trigger so below ensures it doesn't happen
		if (trigger.isExecuting && !test.isRunningTest()) return;

		set<id> contactIDs = needsUpdate.keySet();
		list<contact> contacts = [SELECT id, Birthdate, Time_of_Birth__c, Birthdate_Hebrew__c, Birthdate_Hebrew_in_Hebrew__c, Next_Birthday_Hebrew_Calendar__c, Date_of_Death__c, Time_of_Death__c, Date_of_Death_Hebrew__c, Date_of_Death_Hebrew_in_Hebrew__c, Next_Yahrzeit__c FROM contact WHERE id IN :contactIDs];

		for (contact c : contacts){
			string status = needsUpdate.get(c.id);
	        // Assumptions:  The system is biased towards gregorian dates so if a Gregorian and Hebrew dates are both provided, it trusts the Gregorian one and reconverts the Hebrew one.

			if ( status.contains(bd) ) {
				// birthday needs updating - setup conversion
				hebrewCalConverter convert = new hebrewCalConverter();
				if (c.Birthdate != null) {
					convert.gDate = c.Birthdate;
					if (c.Time_of_Birth__c != null && c.Time_of_Birth__c == 'After Sunset') convert.afterSunset = true;
					c.Birthdate_Hebrew__c = null;
					c.Birthdate_Hebrew_in_Hebrew__c = null;
				} else if (c.Birthdate_Hebrew__c != null) {
					convert.hDateInEnglish = c.Birthdate_Hebrew__c;
					c.Birthdate = null;
					c.Time_of_Birth__c = null;
				}
				convert.sync(); // run the conversion

				// store data from conversion
				if (convert.gDate != null) c.Birthdate = convert.gDate;
				if (convert.hDateInEnglish != null) c.Birthdate_Hebrew__c = convert.hDateInEnglish;
				if (convert.hDateInHebrew != null) c.Birthdate_Hebrew_in_Hebrew__c = convert.hDateInHebrew;
				if (convert.nextOccurrence  != null) c.Next_Birthday_Hebrew_Calendar__c = convert.nextOccurrence ;
			}

			if ( status.contains(yz) ) {
				// Yahrzeit needs updating - setup conversion
				hebrewCalConverter convert = new hebrewCalConverter();
				if (c.Date_of_Death__c != null) {
					convert.gDate = c.Date_of_Death__c;
					if (c.Time_of_Death__c != null && c.Time_of_Death__c == 'After Sunset') convert.afterSunset = true;
					c.Date_of_Death_Hebrew__c = null;
					c.Date_of_Death_Hebrew_in_Hebrew__c = null;
				} else if (c.Date_of_Death_Hebrew__c != null) {
					convert.hDateInEnglish = c.Date_of_Death_Hebrew__c;
					c.Date_of_Death__c = null;
					c.Time_of_Death__c = null;
				}
				convert.sync(); // run the conversion

				// store data from conversion
				if (convert.gDate != null) c.Date_of_Death__c = convert.gDate;
				if (convert.hDateInEnglish != null) c.Date_of_Death_Hebrew__c = convert.hDateInEnglish;
				if (convert.hDateInHebrew != null) c.Date_of_Death_Hebrew_in_Hebrew__c = convert.hDateInHebrew;
				if (convert.nextOccurrence != null) c.Next_Yahrzeit__c = convert.nextOccurrence ;
			}
		}
		lpTools.saveList('update', contacts, 'contactTriggerHandler.updateHebrewDates');
	}
	

	@Future (callout=true)
	public static void updateHebrewDates_future(map<id, string> needsUpdate){
		updateHebrewDates(needsUpdate);
	}
}