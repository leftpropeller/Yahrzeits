// Steve Berley - steve@leftpropeller.com
// 
public with sharing class lpTools {
    private static boolean debug = false;
    private static boolean alreadyRan = false;
    public static integer runCount = 0;
    
    public static boolean ranOnce(){
        if ( !alreadyRan) {
            alreadyRan = true;
            return false;
        } else {
            return alreadyRan;
        }
    }
    
    
    public static void saveRec(string command, sobject obj, string caller){
        if ( obj == null ) return;
        list<sobject> objList = new list<SObject>();
        objList.add(obj);
        saveList(command, objList, caller);
    }
    
    
    public static void saveList(string command, list<sobject> objList, string caller){
        if ( objList == null || objList.size() == 0 ) return;
        Schema.DescribeSObjectResult objDesc = objList[0].getSObjectType().getDescribe();

        try {
            if (command == 'insert' && objDesc.isCreateable() ) insert objlist;
            else if (command == 'update' && objDesc.isUpdateable() ) update objlist;
            else logError('inavlid command or user lacks permissions to insert/update record: ' + command + '  -  ' + caller, null);
        } catch (exception e){
            logError(caller, e);
        }
    }
    
    
    public static void logErrorText(string caller, string e){
        insert new YahrzeitErrors__c(caller__c = caller, report__c = e);
    }
    
    
    public static void logError(string caller, exception e){
        insert new YahrzeitErrors__c(caller__c = caller, report__c = makeReport(e));
    }
    
    
    public static string makeReport(exception e){
        if (e == null) return '';
        string br = '\n';
        string msg;
        // msg = '---------------------------------------------------------------'+br;
        msg = e + br + br;
        msg += 'Error Type: ' + e.getTypeName() + br;
        msg += 'Cause: ' + e.getCause() + br;
        msg += 'Line: ' + string.valueof(e.getLineNumber()) + br;
        
        if (e.getTypeName() == 'System.DmlException' || e.getTypeName() == 'System.EmailException') {
            msg += '# Failed Rows: ' + e.getNumDml() + br;
            for(integer i = 0; i < e.getNumDML(); i++){
                msg += '-  Rows: ' + string.valueof(i) + br;
                msg += '-  Field: ' + e.getDmlIndex(i) + br;
                msg += '-  Error: ' + e.getDMLMessage(i) + br;
                msg += '-  Status Code: ' + e.getDmlStatusCode(i) + br;
            }
            msg += br;
        }
        msg += br + br+ br;
        return msg;
    }
}