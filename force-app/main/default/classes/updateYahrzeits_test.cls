// Steve Berley - steve@leftpropeller.com
// 
@isTest
private class updateYahrzeits_test {

	@isTest static void test_UpdateYahrzeits() { 
		list<contact> cc = new list<contact>();
		cc.add(new contact(lastname='test 1', Date_of_Death__c=date.today()));
		cc.add(new contact(lastname='test 2', Date_of_Death_hebrew__c='12 av 5725',Next_Yahrzeit__c=date.newinstance(2016,1,1)));
		cc.add(new contact(lastname='test 3', Date_of_Death__c=date.today(), Date_of_Death_hebrew__c='12 av 5725'));
		insert cc;

		test.startTest();
			updateYahrzeits.start(1);
		test.stopTest();
        
        // following tests whether the job was created.
        CronTrigger[] jobs = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger WHERE CronJobDetail.Name like 'Nightly update of yahrzeits%'];
        system.assertEquals(jobs.size(), 1);
	}

}