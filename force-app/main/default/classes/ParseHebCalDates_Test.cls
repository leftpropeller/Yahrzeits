//
// Generated by JSON2Apex http://JSON2Apex.herokuapp.com/
//

@IsTest
public class ParseHebCalDates_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"gy\": 1965,'+
		'  \"gm\": 8,'+
		'  \"gd\": 10,'+
		'  \"afterSunset\": false,'+
		'  \"hy\": 5725,'+
		'  \"hm\": \"Av\",'+
		'  \"hd\": 12,'+
		'  \"hebrew\": \"י״ב בְּאָב תשכ״ה\",'+
		'  \"events\": ['+
		'    \"Parashat Vaetchanan\"'+
		'  ]'+
		'}';
		ParseHebCalDates obj = ParseHebCalDates.parse(json);
		System.assert(obj != null);
	}
}