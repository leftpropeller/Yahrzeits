// Steve Berley - steve@leftpropeller.com
// 
@isTest
public class hebrewCalConverter_test implements HttpCalloutMock {
	protected Integer code;
	protected String status;
	protected String bodyAsString;
	protected Blob bodyAsBlob;
	protected Map<String, String> responseHeaders;

    public hebrewCalConverter_test(Integer code, String status, String body, Map<String, String> responseHeaders) {
		this.code = code;
		this.status = status;
		this.bodyAsString = body;
		this.bodyAsBlob = null;
		this.responseHeaders = responseHeaders;
    }


	@isTest static void test_testMode() {
		// just tests when testMode = false (default operation) for test code
        hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.hDateInEnglish = '12 Av 5725';
		hcr.sync();
		// System.assertEquals(greg, date.newInstance(1965,8,10));
	}


	@isTest static void test_getGregDate() {
		hebrewCalConverter_test fakeResponse = new hebrewCalConverter_test(200, 'Complete', '{ "gy": 1965, "gm": 8, "gd": 10 }', null);
	 	Test.setMock(HttpCalloutMock.class, fakeResponse);

        hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.testMode = true;
		hcr.hDateInEnglish = '12 Av 5725';
		date greg = hcr.getGregDate();
		// System.assertEquals(greg, date.newInstance(1965,8,10));
	}


    @isTest static void test_getHebrewDate() {
		hebrewCalConverter_test fakeResponse = new hebrewCalConverter_test(200, 'Complete', '{ "hy": 5725, "hm": "Av", "hd": 12 }',null);
	 	Test.setMock(HttpCalloutMock.class, fakeResponse);

        hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.testMode = true;
        hcr.gDate = date.newInstance(1965,8,10);
	   	string heb = hcr.getHebrewDate();
	   	// System.assertEquals(greg, '12, Av 5725');
    }


    @isTest static void test_getNextOccurrence() {
		hebrewCalConverter_test fakeResponse = new hebrewCalConverter_test(200, 'Complete', json_getNextOccurrence,null);
	 	Test.setMock(HttpCalloutMock.class, fakeResponse);

        hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.testMode = true;
        hcr.gDate = date.newInstance(1965,8,10);
	   	date nextOccurrence = hcr.getNextOccurrence();
	   	// System.assertEquals(greg, '12, Av 5725');
    }


    @isTest static void test_sync_no_data() {
        // all values are null
        hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.testMode = true;
        hcr.sync();
    }


    @isTest static void test_sync_have_greg() {
		hebrewCalConverter_test fakeResponse = new hebrewCalConverter_test(200, 'Complete', '{ "hy": 5725, "hm": "Av", "hd": 12 }',null);
	 	Test.setMock(HttpCalloutMock.class, fakeResponse);

        // only Gregorian is populated
        hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.testMode = true;
        hcr.gDate = date.today();
        hcr.sync();
    }


    @isTest static void test_sync_have_hebrew() {
		hebrewCalConverter_test fakeResponse = new hebrewCalConverter_test(200, 'Complete', '{ "gy": 1965, "gm": 8, "gd": 10 }', null);
	 	Test.setMock(HttpCalloutMock.class, fakeResponse);

        // only Hebrew is populated
        hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.testMode = true;
        hcr.hDateInEnglish = '12 Av 5781';
        hcr.sync();
    }


    @isTest static void test_parseHebrewDate() {
        // in testing parseHebrewDate it also does NormalizeHebrewMonth and validMonth
		hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.testMode = true;
        hcr.hDateInEnglish = '12 Adar 2 5781';
        hcr.parseHebrewDate();

        hcr.hDateInEnglish = 'Adar 2 12 5781';
        hcr.parseHebrewDate();

        // below exercises error handling
        hcr.hDateInEnglish = '12 Ella 5781';
        hcr.parseHebrewDate();
	}


    @isTest static void test_dateNeedsUpdating() {
        // all null is all that's required for coverage
		hebrewCalConverter.dateNeedsUpdating(null, null, null, null, null, null, null);
	}    
	
	
	@isTest static void test_updateToday() {
		hebrewCalConverter_test fakeResponse = new hebrewCalConverter_test(200, 'Complete', '{ "hy": 5781, "hm": "Av", "hd": 12 }', null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.testMode = true;
		hcr.updateToday();
	}			
	
	
	@isTest static void test_updateHolidaysEtc() {
		hebrewCalConverter_test fakeResponse = new hebrewCalConverter_test(200, 'Complete', json_updateHolidaysEtc, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		hebrewCalConverter hcr = new hebrewCalConverter();
		hcr.testMode = true;

		Hebrew_Dates__c settings = hcr.getSettings();
		hcr.updateHolidaysEtc(settings);
	}	


    public HTTPResponse respond(HTTPRequest req) {
		HttpResponse resp = new HttpResponse();
		resp.setStatusCode(code);
		resp.setStatus(status);
		if (bodyAsBlob != null) resp.setBodyAsBlob(bodyAsBlob);
		else resp.setBody(bodyAsString);

		if (responseHeaders != null) {
			for (String key : responseHeaders.keySet()) {
				resp.setHeader(key, responseHeaders.get(key));
			}
		}
		return resp;
	}

	public static string json_getNextOccurrence='{"title":"Yahrzeit","date":"2021-12-23T19:21:38.345Z","items":[{"title":"Person1\'s 1st Yahrzeit (5th of Elul)","date":"2022-09-01" }]}';

	public static string json_updateHolidaysEtc = '{ "title": "Hebcal Diaspora December 2021", "date": "2021-12-23T20:16:59.856Z", "location": { "geo": "none" }, "items": [ { "title": "Chanukah: 4 Candles", "date": "2021-12-01", "category": "holiday", "subcat": "major", "hebrew": "חנוכה: ד׳ נרות", "leyning": { "1": "Numbers 7:24-7:26", "2": "Numbers 7:27-7:29", "3": "Numbers 7:30-7:35", "torah": "Numbers 7:24-35" }, "link": "https://www.hebcal.com/holidays/chanukah-2021?utm_source=js&utm_medium=api", "date": "2021-12-02", "category": "holiday", "subcat": "major", "hebrew": "חנוכה: ה׳ נרות", "leyning": { "1": "Numbers 7:30-7:32", "2": "Numbers 7:33-7:35", "3": "Numbers 7:36-7:41", "torah": "Numbers 7:30-41" }, "link": "https://www.hebcal.com/holidays/chanukah-2021?utm_source=js&utm_medium=api" }, { "title": "Chanukah: 6 Candles", "date": "2021-12-03", "category": "holiday", "subcat": "major", "hebrew": "חנוכה: ו׳ נרות", "leyning": { "1": "Numbers 7:36-7:38", "2": "Numbers 7:39-7:41", "3": "Numbers 7:42-7:47", "torah": "Numbers 7:36-47" }, "link": "https://www.hebcal.com/holidays/chanukah-2021?utm_source=js&utm_medium=api" }, { "title": "Chanukah: 7 Candles", "date": "2021-12-04", "category": "holiday", "subcat": "major", "hebrew": "חנוכה: ז׳ נרות", "leyning": { "7": "Numbers 28:9-28:15", "haftarah": "Zechariah 2:14-4:7", "maftir": "Numbers 7:42-7:47" }, "link": "https://www.hebcal.com/holidays/chanukah-2021?utm_source=js&utm_medium=api" }, { "title": "Rosh Chodesh Tevet", "date": "2021-12-04", "category": "roshchodesh", "hebrew": "ראש חודש טבת", "leyning": { "7": "Numbers 28:9-28:15", "haftarah": "Zechariah 2:14-4:7", "maftir": "Numbers 7:42-7:47" }, "link": "https://www.hebcal.com/holidays/rosh-chodesh-tevet-2021?utm_source=js&utm_medium=api" }, { "title": "Parashat Miketz", "date": "2021-12-04", "category": "parashat", "hebrew": "פרשת מקץ", "leyning": { "1": "Genesis 41:1-41:14", "2": "Genesis 41:15-41:38", "3": "Genesis 41:39-41:52", "4": "Genesis 41:53-42:18", "5": "Genesis 42:19-43:15", "6": "Genesis 43:16-44:17", "7": "Numbers 28:9-28:15 | Shabbat Rosh Chodesh Chanukah", "torah": "Genesis 41:1-44:17; Numbers 28:9-15, 7:42-47", "haftarah": "Zechariah 2:14-4:7 | Shabbat Rosh Chodesh Chanukah", "maftir": "Numbers 7:42-7:47 | Shabbat Rosh Chodesh Chanukah", "triennial": { "1": "Genesis 43:16-43:18", "2": "Genesis 43:19-43:25", "3": "Genesis 43:26-43:29", "4": "Genesis 43:30-43:34", "5": "Genesis 44:1-44:6", "6": "Genesis 44:7-44:17", "7": "Numbers 28:9-28:15", "maftir": "Numbers 7:42-7:47" } }, "link": "https://www.hebcal.com/sedrot/miketz-20211204?utm_source=js&utm_medium=api" }, { "title": "Chanukah: 8 Candles", "date": "2021-12-05", "category": "holiday", "subcat": "major", "hebrew": "חנוכה: ח׳ נרות", "leyning": { "1": "Numbers 28:1-28:5", "2": "Numbers 28:6-28:10", "3": "Numbers 28:11-28:15", "4": "Numbers 7:48-7:53", "torah": "Numbers 28:1-15, 7:48-53" }, "link": "https://www.hebcal.com/holidays/chanukah-2021?utm_source=js&utm_medium=api" }, { "title": "Rosh Chodesh Tevet", "date": "2021-12-05", "category": "roshchodesh", "hebrew": "ראש חודש טבת", "link": "https://www.hebcal.com/holidays/rosh-chodesh-tevet-2021?utm_source=js&utm_medium=api" }, { "title": "Chanukah: 8th Day", "date": "2021-12-06", "category": "holiday", "subcat": "minor", "hebrew": "חנוכה: יום ח׳", "leyning": { "1": "Numbers 7:54-7:56", "2": "Numbers 7:57-7:59", "3": "Numbers 7:60-8:4", "torah": "Numbers 7:54-8:4" }, "link": "https://www.hebcal.com/holidays/chanukah-2021?utm_source=js&utm_medium=api" }, { "title": "Parashat Vayigash", "date": "2021-12-11", "category": "parashat", "hebrew": "פרשת ויגש", "leyning": { "1": "Genesis 44:18-44:30", "2": "Genesis 44:31-45:7", "3": "Genesis 45:8-45:18", "4": "Genesis 45:19-45:27", "5": "Genesis 45:28-46:27", "6": "Genesis 46:28-47:10", "7": "Genesis 47:11-47:27", "torah": "Genesis 44:18-47:27", "haftarah": "Ezekiel 37:15-28", "maftir": "Genesis 47:25-47:27", "triennial": { "1": "Genesis 46:28-46:30", "2": "Genesis 46:31-46:34", "3": "Genesis 47:1-47:6", "4": "Genesis 47:7-47:10", "5": "Genesis 47:11-47:19", "6": "Genesis 47:20-47:22", "7": "Genesis 47:23-47:27", "maftir": "Genesis 47:25-47:27" } }, "link": "https://www.hebcal.com/sedrot/vayigash-20211211?utm_source=js&utm_medium=api" }, { "title": "Parashat Vayechi", "date": "2021-12-18", "category": "parashat", "hebrew": "פרשת ויחי", "leyning": { "1": "Genesis 47:28-48:9", "2": "Genesis 48:10-48:16", "3": "Genesis 48:17-48:22", "4": "Genesis 49:1-49:18", "5": "Genesis 49:19-49:26", "6": "Genesis 49:27-50:20", "7": "Genesis 50:21-50:26", "torah": "Genesis 47:28-50:26", "haftarah": "I Kings 2:1-12", "maftir": "Genesis 50:23-50:26", "triennial": { "1": "Genesis 49:27-49:30", "2": "Genesis 49:31-49:33", "3": "Genesis 50:1-50:6", "4": "Genesis 50:7-50:9", "5": "Genesis 50:10-50:14", "6": "Genesis 50:15-50:20", "7": "Genesis 50:21-50:26", "maftir": "Genesis 50:23-50:26" } }, "link": "https://www.hebcal.com/sedrot/vayechi-20211218?utm_source=js&utm_medium=api" }, { "title": "Parashat Shemot", "date": "2021-12-25", "category": "parashat", "hebrew": "פרשת שמות", "leyning": { "1": "Exodus 1:1-1:17", "2": "Exodus 1:18-2:10", "3": "Exodus 2:11-2:25", "4": "Exodus 3:1-3:15", "5": "Exodus 3:16-4:17", "6": "Exodus 4:18-4:31", "7": "Exodus 5:1-6:1", "torah": "Exodus 1:1-6:1", "haftarah": "Isaiah 27:6-28:13, 29:22-23", "haftarah_sephardic": "Jeremiah 1:1-2:3", "maftir": "Exodus 5:22-6:1", "triennial": { "1": "Exodus 4:18-4:20", "2": "Exodus 4:21-4:26", "3": "Exodus 4:27-4:31", "4": "Exodus 5:1-5:5", "5": "Exodus 5:6-5:9", "6": "Exodus 5:10-5:14", "7": "Exodus 5:15-6:1", "maftir": "Exodus 5:22-6:1" } }, "link": "https://www.hebcal.com/sedrot/shemot-20211225?utm_source=js&utm_medium=api" } ] }';
}