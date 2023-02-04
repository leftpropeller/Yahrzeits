// Steve Berley - steve@leftpropeller.com
// 
@isTest
private class contactTriggerHandler_test {
    
    @isTest static void test_Inserts() {
        list<contact> cc = new list<contact>();
        cc.add(new contact(lastname='test 1', Date_of_Death__c=date.today()));
        cc.add(new contact(lastname='test 2', Date_of_Death_hebrew__c='12 av 5725'));
        cc.add(new contact(lastname='test 3', Date_of_Death__c=date.today(), Date_of_Death_hebrew__c='12 av 5725'));
        cc.add(new contact(lastname='test 4', birthdate=date.today()) ) ;
        cc.add(new contact(lastname='test 5', Birthdate_Hebrew__c='12 av 5725'));

        insert cc;
    }

    
    @isTest static void test_Updates() {
		contact c = new contact(lastname='update', Date_of_Death_hebrew__c='12 av 5781');
        insert c;

        c.Date_of_Death_hebrew__c ='12 av 5765';
        update c;

        c.Time_of_Death__c ='After Sunset';
        update c;
    }
}