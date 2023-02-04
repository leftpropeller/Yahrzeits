// Steve Berley - steve@leftpropeller.com
// 
@istest
Private class lpTools_test {
    
    @isTest static void test_ranOnce() {
        boolean ran = lpTools.ranOnce();
        system.assertEquals(ran, false);
        ran = lpTools.ranOnce();
        system.assertEquals(ran, true);
    }
    
    @isTest static void test_logErrorText() {
        string caller = 'test caller';
        string report = 'now is the time for all good men to come to the aid of their country';
        lpTools.logErrorText(caller, report);
        
        YahrzeitErrors__c err = [select caller__c, report__c from YahrzeitErrors__c limit 1];
        system.assertEquals(err.caller__c, caller);
        system.assertEquals(err.report__c, report);
    }
    
    @isTest static void test_saveRec_with_Error() {
        lpTools.saveRec('insert', new lead(),'test_saveList_Errors');
        
        // following shows an error was logged
        YahrzeitErrors__c[] errors = [select id from YahrzeitErrors__c];
        system.assertEquals(errors.size(), 1);
    }
    
    @isTest static void test_saveList_and_saveSet() {
        list<lead> ll = new list<lead>();
        ll.add(new lead(lastName = 'lastname', company='company'));
        lpTools.saveList('insert', ll,'test_saveList');
        
        lead verify = [select lastName, company from lead limit 1];
        system.assertEquals(verify.lastname, 'lastname');
        system.assertEquals(verify.company, 'company');

        
        for (lead l : ll) {
            l.lastName += ' 1';
            l.company += ' 1';
        }
        lpTools.saveList('update', ll,'test_saveList_and_saveSet - list');
        verify = [select lastName, company from lead limit 1];
        system.assertEquals(verify.lastname, 'lastname 1');
        system.assertEquals(verify.company, 'company 1');

        
        for (lead l : ll) {
            l.lastName += '2';
            l.company += '2';
        }
        ll.add(new lead(lastName = 'lastname 47', company='company 47'));
        lpTools.saveList('insert', ll,'test_saveList');

        list<lead> verifySize = [select lastName, company from lead];
        system.assertEquals(verifySize.size(), 1);
        
        lpTools.saveList('cat', ll,'test_saveList');
        YahrzeitErrors__c err = [select caller__c, report__c from YahrzeitErrors__c limit 1];
        system.assert( !err.caller__c.contains('invalid'), 'should have returned invalid call ' + err.caller__c);
    }    
}