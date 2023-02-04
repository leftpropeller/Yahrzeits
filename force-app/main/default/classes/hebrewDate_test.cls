// Steve Berley - steve@leftpropeller.com
// 
@isTest
public class hebrewDate_test implements HttpCalloutMock {
	protected Integer code;
	protected String status;
	protected String bodyAsString;
	protected Blob bodyAsBlob;
	protected Map<String, String> responseHeaders;

    public hebrewDate_test(Integer code, String status, String body, Map<String, String> responseHeaders) {
		this.code = code;
		this.status = status;
		this.bodyAsString = body;
		this.bodyAsBlob = null;
		this.responseHeaders = responseHeaders;
    }


	@isTest static void test_getGregDate() {
		hebrewDate_test fakeResponse = new hebrewDate_test(200, 'Complete', '{ "gy": 1965, "gm": 8, "gd": 10 }', null);
	 	Test.setMock(HttpCalloutMock.class, fakeResponse);

        hebrewDate hd = new hebrewDate();
		hd.hDateInEnglish = '12 Av 5725';
		date greg = hd.getGregDate();
		// System.assertEquals(greg, date.newInstance(1965,8,10));
	}


    @isTest static void test_getHebrewDate() {
		hebrewDate_test fakeResponse = new hebrewDate_test(200, 'Complete', '{ "hy": 5725, "hm": "Av", "hd": 12 }',null);
	 	Test.setMock(HttpCalloutMock.class, fakeResponse);

        hebrewDate hd = new hebrewDate();
        hd.gDate = date.newInstance(1965,8,10);
	   	string heb = hd.getHebrewDate();
	   	// System.assertEquals(greg, '12, Av 5725');
    }


    @isTest static void test_sync() {
		hebrewDate_test fakeResponse = new hebrewDate_test(200, 'Complete', '{ "hy": 5725, "hm": "Av", "hd": 12 }',null);
	 	Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        // all values are null
        hebrewDate hd = new hebrewDate();
        hd.sync();

        // only Gregorian is populated
        hd = new hebrewDate();
        hd.gDate = date.today();
        hd.sync();

        // only Hebrew is populated
        hd = new hebrewDate();
        hd.hDateInEnglish = '12 Av 5781';
        hd.sync();
    }


    @isTest static void test_parseHebrewDate() {
        // in testing parseHebrewDate it also does NormalizeHebrewMonth and validMonth
        hebrewDate hd = new hebrewDate();
        hd.hDateInEnglish = '12 Adar2 5781';
        hd.parseHebrewDate();

        hd.hDateInEnglish = 'Adar2 12 5781';
        hd.parseHebrewDate();

        // below exercises error handling
        hd.hDateInEnglish = '12 Ella 5781';
        hd.parseHebrewDate();
	}


    @isTest static void test_datesChanged() {
        // all null is all that's required for coverage
		hebrewDate.datesChanged(null, null, null, null);
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

}