// Steve Berley - steve@leftpropeller.com
// 
public with sharing class hebrewCalConverter {
	public date gDate {get; set;}
	public string hDateInEnglish {get; set;}
	public string hDateInHebrew {get; set;}
	public date nextOccurrence  {get; set;}
	// public date followingoccurrence  {get; set;}
	public boolean afterSunset {get; set;}
    public string hYear {get; set;}

	// Delineates between this code being tested and code that uses this class being tested.  Since this code relies on callouts to external systems, isolating its internal testing from that of other classes which use it makes life a ton easier.
	public boolean testMode {get; set;}

	private string hMonth {get; set;}
	private string hDay {get; set;}
	private string params {get; set;}
	private string error {get; set;}
	private static date today = date.today();

    public hebrewCalConverter() {
		testMode = false;
        afterSunset = false;
    }


    public void sync(){
        // synchronizes data w/in the class
        // hDateInHebrew showns the date in hebrew but not used for any analysis

		if (test.isRunningTest() && !testMode) {
			// If something is being tested, but not this class, returns dummy values.
			this.gDate = today;
			this.hYear = '5781';
			this.hDateInEnglish = '12 Av 5871';
			this.hDateInHebrew = getHebrewDateInHebrew();
			this.nextOccurrence = this.gDate.addDays(1);
			return;
		}
		
		// have Gregorian but not Hebrew...
		if (this.gDate != null && string.isBlank(this.hDateInEnglish)) getHebrewDate();
	
		// have Hebrew but not Gregorian...
		if (this.gDate == null && !string.isBlank(this.hDateInEnglish))getGregDate();
	
		getnextOccurrence ();
		// if ((this.nextOccurrence  == null || this.nextOccurrence  < today) && !test.isRunningTest()) getnextOccurrence ();
    }


    public string getHebrewDate(){      
		if (this.gDate == null) return null;
		GregToHebrewParams();
		string json = callHebCal();
		if (string.isBlank(json)) return null;
        ParseHebCalDates parsed = ParseHebCalDates.parse( json );
        if (parsed == null) return null;

        if ( parsed.hd != null ) this.hDay = string.valueOf(parsed.hd);
        if ( parsed.hm != null ) this.hMonth = parsed.hm;
        if ( parsed.hy != null ) this.hYear = string.valueOf(parsed.hy);    

		this.hDateInEnglish = this.hDay + ' ' + this.hMonth + ' ' + this.hYear;

		getHebrewDateInHebrew(); // update the date in Hebrew as well
		return this.hDateInEnglish;
    }


    public date getGregDate(){
		parseHebrewDate();
		HebrewToGregParams();
		string json = callHebCal();
		if (string.isBlank(json)) return null;
        ParseHebCalDates parsed = ParseHebCalDates.parse( json );
        if (parsed == null) return null;

        this.gDate = null;

        if ( parsed.gd != null && parsed.gm != null && parsed.gy != null) this.gDate = date.newInstance(parsed.gy, parsed.gm, parsed.gd);

        return this.gDate;
	}


    public date getnextOccurrence (){
        if (this.gDate == null) return null;
        nextOccurrenceParams();
		string json = callHebCal();
		if (string.isBlank(json)) return null;
		ParseHebCalYahrzeits parsed = ParseHebCalYahrzeits.parse(json);

        if (parsed == null || parsed.items == null ) return null; 
                   
        if ( parsed.items.size() >= 1  ) {
          //  && !string.isBlank(parsed.items[0].date_Z)
            for (ParseHebCalYahrzeits.items i : parsed.items){
                date d = date.valueOf(i.date_Z);
                if (d >= today) {
                    this.nextOccurrence = d;
                    break;
                }
            }
        }
        //    this.nextOccurrence  = date.valueOf(parsed.items[0].date_Z);
        // if ( parsed.items.size() >= 2 && !string.isBlank(parsed.items[1].date_Z) ) this.followingoccurrence  = date.valueOf(parsed.items[1].date_Z);
		return this.nextOccurrence ;
	}


    public void parseHebrewDate(){
		string space = ' ';
        list<string> parts = this.hDateInEnglish.trim().split(space);
        if (parts.size() < 2) return;

		// when reading below, notice that lists are zero based, so element 1 has an index of zero; xxx[0]
		boolean leapMonth = false;
		if (parts.size() == 4 && parts[3].isNumeric()) leapMonth = true; // as in Adar 2

		if (leapMonth) this.hYear = parts[3];
		else this.hYear = parts[2];
		
        if (parts[0].isNumeric()) { 
            // dd mm format as in 12 Adar
            this.hDay = parts[0];
            this.hMonth = parts[1];
			if (leapMonth) {
				// as in 12 Adar 2 
				this.hMonth += space + parts[2];
			} 
        } else {
            // mm dd format as in Adar 12
            this.hMonth = parts[0];
            this.hDay = parts[1];
			if (leapMonth) { 
				// as in Adar 2 12
				this.hMonth += space + parts[1];
				this.hDay = parts[2];
			}
        } 
        this.hMonth = normalizeHebrewMonth();

        if ( !validMonth(this.hMonth) ) {
            // if the month isn't valid don't trust anything
            this.hDay = null;
            this.hMonth = null;
            this.hYear = null;
        }
        getHebrewDateInHebrew(); // update the date in Hebrew as well
	}


    public string GregToHebrewParams(){
		this.params = '/converter?cfg=json&g2h=1';
		this.params += '&gy='+string.valueof(this.gDate.year());
		this.params += '&gm='+string.valueof(this.gDate.month());
		this.params += '&gd='+string.valueof(this.gDate.day());
		if (this.afterSunset != null && this.afterSunset) this.params += '&gs=on';
		return this.params;
	}


	public string HebrewToGregParams(){
		this.params = '/converter?cfg=json&h2g=1';
		if ( string.isNotBlank(this.hMonth) ) this.params += '&hm=' + this.hMonth.trim();
		if ( string.isNotBlank(this.hDay) ) this.params += '&hd=' + this.hDay.trim();
		if ( string.isNotBlank(this.hYear) ) this.params += '&hy=' + this.hYear.trim();
		return this.params;
	}


	public string nextOccurrenceParams(){
        if (this.gDate == null) return '';
		this.params = '/yahrzeit?cfg=json&years=2';
        this.params += '&y1=' + string.valueOf(this.gDate.year());
        this.params += '&m1=' + string.valueOf(this.gDate.month());
        this.params += '&d1=' + string.valueOf(this.gDate.day());
        if (this.afterSunset != null && this.afterSunset) this.params += '&s1=on';
		return this.params;
	}


	public string UpdateTodayParams(){
		this.params = '/hebcal?cfg=json&v=1&maj=on&min=on&s=on&nx=on&mod=on';
        this.params += '&start=' + string.valueOf(today);
        this.params += '&end=' + string.valueOf(nextShabbat());
		return this.params;
	}


    public string getHebrewDateInHebrew(){
		//  Builds on info from getHebrewDate() so call afterwards
        this.hDateInHebrew = '';
        if ( string.isBlank(this.hDay) || string.isblank(this.hMonth)) return this.hDateInHebrew;

		map<string,string> hMonths = new map<string,string>{'nisan' => 'ניסן', 'iyyar' => 'אייר', 'sivan' => 'סיון' , 'tamuz' => 'תמוז' , 'av' => 'אב' , 'elul' => 'אלול' , 'tishri' => 'תשרי' , 'cheshvan' => 'אבחשון' , 'kislev' => 'כסלן' , 'tevet' => 'טבמ' , 'shvat' => 'שבט' , 'adar' => 'אדר' , 'adar1' => 'אדר' ,  'adar2' => 'אדר ב' };

		string mo = normalizeHebrewMonth(); // normalize so the month is in the map index
		mo = mo.toLowerCase().trim().replace('  ',' ');
		// hebrew characters cause havoc when the year is included so it's omitted
		this.hDateInHebrew = this.hDay + ' ' + hMonths.get(mo); // + ' ' + this.hYear;  
		return this.hDateInHebrew;
	}


    public string callHebCal(){
        Map<String, Object> hebCal = new Map<String, Object>();
		string responseRaw;
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://www.hebcal.com'+ this.params);
		request.setMethod('GET');
		request.setTimeout(120000);


		integer submitCount = 0;
		try {
			this.error = null;
			HttpResponse response = new http().send(request);
			submitCount++;
			responseRaw = response.getBody();

			if (response.getStatusCode() != 200 || test.isRunningTest()) {
				string err = params + '    --\n';
				for (string s : hebCal.keyset()) err += s +':   '+(string) hebCal.get(s);
				this.error = err;
                lpTools.logErrorText('HebrewCalConverter.callHebCal - not 200', this.error);
			}

		} catch (exception e) {
			lpTools.logErrorText('HebrewCalConverter.callHebCal - exception',
				params + '         --\n'
				+ 'Cause:  ' + e.getCause() + '         --\n'
				+ 'Message:  ' + e.getMessage() + '         --\n'
				+ lpTools.makeReport(e));
            this.error = 'error';
		}
		return responseRaw;
	}


	public Hebrew_Dates__c updateToday(){
		Hebrew_Dates__c settings = updateTodaysDate();

		if (!test.isRunningTest()) settings = updateHolidaysEtc(settings); // if not test prevents false testing errors.

		lpTools.saveRec('upsert', settings, 'hebrewCalConverter.updateToday');
		return settings;
	}


	public Hebrew_Dates__c updateTodaysDate(){
		Hebrew_Dates__c settings = getSettings();

		this.gDate = today;
		sync();

		if (!string.isblank(this.hYear)) settings.Current_Year_Hebrew__c = this.hYear;
		if (!string.isblank(this.hDateInEnglish)) settings.Today_Hebrew__c = this.hDateInEnglish;
		if (!string.isblank(this.hDateInHebrew)) settings.Today_Hebrew_in_Hebrew__c = this.hDateInHebrew;
		return settings;
	}


	public Hebrew_Dates__c updateHolidaysEtc(Hebrew_Dates__c settings){
		// while breaking this to a separate method may be a bit extreme, it makes the test class a ton easier
		if (settings == null) return settings;
		string today = string.valueOf(today);

		// Update information about the upcoming shabbat and if the current day is a holday
		UpdateTodayParams();
		string json = callHebCal();
		if (string.isBlank(json)) return null;
		ParseHebCalDailyInfo parsed = ParseHebCalDailyInfo.parse(json);

		if (parsed == null || parsed.items == null ) return settings; 
		for (ParseHebCalDailyInfo.items item : parsed.items){

			// Parashat are for the upcoming shabbat 
			if (!string.isblank(item.category) && item.category == 'parashat') {
				if (!string.isblank(item.title)) settings.Parashat_English__c = item.title;
				if (!string.isblank(item.hebrew)) settings.Parashat_Hebrew__c = item.hebrew;
			}
			
			// Holidays are shown only for the current day
			if (!string.isblank(item.date_Z) && (item.date_Z == today || test.isRunningTest()) ) {
				if (!string.isblank(item.category) && item.category == 'roshchodesh') {
					if (!string.isblank(item.title)) settings.Rosh_Chodesh__c = item.title;
					if (!string.isblank(item.hebrew)) settings.Rosh_Chodesh_Hebrew__c = item.hebrew;
				}
				
				else if (!string.isblank(item.category) && item.category == 'holiday') {
					if (!string.isblank(item.subcat) && item.subcat == 'major') {
						if (!string.isblank(item.title)) settings.Major_Holiday__c = item.title;
						if (!string.isblank(item.hebrew)) settings.Major_Holiday_Hebrew__c = item.hebrew;
					} 

					else if (!string.isblank(item.subcat) && item.subcat == 'minor') {
						if (!string.isblank(item.title)) settings.Minor_Holiday__c = item.title;
						if (!string.isblank(item.hebrew)) settings.Minor_Holiday_Hebrew__c = item.hebrew;
					}
				}
			}
		}
		return settings;
	}


	public Hebrew_Dates__c getSettings(){
		list<Hebrew_Dates__c> AllSettings = [SELECT id, Current_Year_Hebrew__c, Major_Holiday__c, Minor_Holiday__c, Parashat_English__c, Parashat_Hebrew__c, Rosh_Chodesh__c, Today_Hebrew__c, Rosh_Chodesh_Hebrew__c, Today_Hebrew_in_Hebrew__c, Major_Holiday_Hebrew__c, Minor_Holiday_Hebrew__c FROM Hebrew_Dates__c LIMIT 1];

		Hebrew_Dates__c settings = new Hebrew_Dates__c();
		if (AllSettings != null && AllSettings.size() > 0) settings = AllSettings[0];

		// clear out all relevant fields for the new day
		settings.Current_Year_Hebrew__c = null;
		settings.Major_Holiday__c  = null;
		settings.Major_Holiday_Hebrew__c  = null;
		settings.Minor_Holiday__c = null;
		settings.Minor_Holiday_Hebrew__c = null;
		settings.Parashat_English__c = null;
		settings.Parashat_Hebrew__c = null;
		settings.Rosh_Chodesh__c = null;
		settings.Rosh_Chodesh_Hebrew__c = null;
		settings.Today_Hebrew__c = null;
		settings.Today_Hebrew_in_Hebrew__c = null;

		return settings;
	}


    public static string dateNeedsUpdating(date newGreg, date oldGreg, string newSunset, string oldSunset, string newHeb, string oldHeb, date nextOccurrence ){
		string needs = '';

        // first checks Gregorian dates to see if one has a value and not the other.  if that's the case or if both have values that aren't the same it returns true.        
        if (newGreg != null && oldGreg == null) needs += '-Greg';
        if (newGreg == null && oldGreg != null) needs += '-Greg';
        if (newGreg != null && oldGreg != null && newGreg != oldGreg) needs += '-Greg';

		// check for a change in before/after sunset
        if (newSunset != null && oldSunset == null) needs += '-Greg';
        if (newSunset == null && oldSunset != null) needs += '-Greg';
        if (newSunset != null && oldSunset != null && newSunset != oldSunset) needs += '-Greg';

        // look for changes to the Hebrew dates
        if (newHeb != null && oldHeb == null) needs += '-Hebrew';
        if (newHeb == null && oldHeb != null) needs += '-Hebrew';
        if (newHeb != null && oldHeb != null && newHeb != oldHeb) needs += '-Hebrew';

		// ensure that we have both a gregorian and hebrew date (i.e. an incomplete pair)
        if (newGreg != null && newHeb == null) needs += '-Hebrew';
        if (newGreg == null && newHeb != null) needs += '-Greg';

		// finally, check if the next occurrence  has passed
		if ((newGreg != null || newHeb != null) && (nextOccurrence == null || nextOccurrence < today) ) needs += '-Occur';

        return needs;
    }


    public string normalizeHebrewMonth(){
        if(this.hMonth == null) return null;
        string mo = this.hMonth.toLowerCase().trim().replace('  ',' ');
    
        set<string> nisan = new set<string>{'nisan', 'nissan', 'ניסן'};
        set<string> iyyar = new set<string>{'iyyar', 'iyar', 'אייר'};
        set<string> sivan = new set<string>{'sivan', 'סיון'};
        set<string> tamuz = new set<string>{'tamuz', 'tammuz', 'תמוז'};
        set<string> av = new set<string>{'av', 'אב'};
        set<string> elul = new set<string>{'elul', 'אלול'};
        set<string> tishri = new set<string>{'tishri', 'תשרי'};
        set<string> cheshvan = new set<string>{'cheshvan', 'kheshvan', 'Chesvan', 'חשון'};
        set<string> kislev = new set<string>{'kislev', 'כסלן'};
        set<string> tevet = new set<string>{'tevet', 'teves', 'טבמ'};
        set<string> shvat = new set<string>{'shvat', 'sh\'vat', 'shevat', 'שבט'};
        set<string> adar1 = new set<string>{'adar', 'adar1', 'adar 1', 'adar i', 'adar a', 'adara', 'אדר', 'אדר א'};
        set<string> adar2 = new set<string>{'adar2', 'adar 2', 'adar ii', 'adar b', 'adarb', 'אדר ב'};

        if (nisan.contains(mo.toLowerCase())) mo = 'nisan';
        else if (iyyar.contains(mo.toLowerCase())) mo = 'iyyar';
        else if (sivan.contains(mo.toLowerCase())) mo = 'sivan';
        else if (tamuz.contains(mo.toLowerCase())) mo = 'tamuz';
        else if (av.contains(mo.toLowerCase())) mo = 'av';
        else if (elul.contains(mo.toLowerCase())) mo = 'elul';
        else if (tishri.contains(mo.toLowerCase())) mo = 'tishri';
        else if (cheshvan.contains(mo.toLowerCase())) mo = 'cheshvan';
        else if (kislev.contains(mo.toLowerCase())) mo = 'kislev';
        else if (tevet.contains(mo.toLowerCase())) mo = 'tevet';
        else if (shvat.contains(mo.toLowerCase())) mo = 'shvat';
        else if (adar1.contains(mo.toLowerCase())) mo = 'adar1';
        else if (adar2.contains(mo.toLowerCase())) mo = 'adar2';

        this.hMonth = mo.capitalize();
        return this.hMonth;
    }   


    public boolean validMonth(string mo){
        set<string> months = new set<string>{'nisan', 'iyyar', 'sivan', 'tamuz', 'av', 'elul', 'tishrei', 'cheshvan', 'kislev', 'tevet', 'shvat', 'adar1', 'adar2'};
        if(mo != null && months.contains(mo.toLowerCase())) return true;
        else return false;
    }


	public date nextShabbat(){
		map<string,integer> daysToShabbat = new map<string, integer>{'Sat' => 0, 'Fri' => 1, 'Thu' => 2, 'Wed' => 3, 'Tue' => 4, 'Mon' => 5, 'Sun' => 6 };

		String dayOfWeek = DateTime.now().format('E');
		date shabbat = today.addDays( daysToShabbat.get(dayOfWeek));
		return shabbat;
	}
}