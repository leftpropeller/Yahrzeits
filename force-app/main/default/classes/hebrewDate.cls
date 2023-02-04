// Steve Berley - steve@leftpropeller.com
// 
public with sharing class hebrewDate {
	public date gDate {get; set;}
	public string hDateInEnglish {get; set;}
	public string hDateInHebrew {get; set;}
	public date nextOccurance {get; set;}
	public date followingOccurance {get; set;}
	public boolean afterSunset {get; set;}
    
    private string hYear {get; set;}
	private string hMonth {get; set;}
	private string hDay {get; set;}
	private string params {get; set;}
	private string error {get; set;}
	private string responseRaw {get; set;}


    public hebrewDate() {
        afterSunset = false;
    }


    public void sync(){
        // synchronizes data w/in the class
        // Assumptions:  
        // 1. It trusts what it's given.  If a non-matching pair of Gregorian and Hebrew date are passed
        //    in - tough shit.  Blank one of the fields to resynchronize them based on the other.
        // 2. hDateInHebrew showns the date in hebrew but not used for any analysis

        if (this.gDate == null && string.isBlank(this.hDateInEnglish)){
            // no Gregorian or Hebrew dates...clear other fields
            this.nextOccurance = null;
            this.followingOccurance = null;
            this.hDateInHebrew = null;
            this.afterSunset = false;
        
        } else {
            // have Gregorian but not Hebrew...
            if (this.gDate != null && string.isBlank(this.hDateInEnglish)) getHebrewDate();
        
            // have Hebrew but not Gregorian...
            else if (this.gDate == null && !string.isBlank(this.hDateInEnglish))getGregDate();
        
            if (this.nextOccurance == null || this.nextOccurance < date.today() || this.followingOccurance == null) getNextOccurance();
        }
    }


    public string getHebrewDate(){      
		if (this.gDate == null) return null;
		GregToHebrewParams();
        ParseHebCalDates parsed = ParseHebCalDates.parse( callHebCal() );
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
        ParseHebCalDates parsed = ParseHebCalDates.parse( callHebCal() );
        if (parsed == null) return null;

        this.gDate = null;

        if ( parsed.gd != null && parsed.gm != null && parsed.gy != null) this.gDate = date.newInstance(parsed.gy, parsed.gm, parsed.gd);

        return this.gDate;
	}


    public date getNextOccurance(){
        if (this.gDate == null) return null;
        NextOccuranceParams();
        ParseHebCalYahrzeits parsed = ParseHebCalYahrzeits.parse( callHebCal());

        if (parsed == null || parsed.items == null ) return null; 
        if ( parsed.items.size() >= 1 && !string.isBlank(parsed.items[0].date_Z) ) this.nextOccurance = date.valueOf(parsed.items[0].date_Z);
        if ( parsed.items.size() >= 2 && !string.isBlank(parsed.items[1].date_Z) ) this.followingOccurance = date.valueOf(parsed.items[1].date_Z);
		return this.nextOccurance;
	}


    public void parseHebrewDate(){
		string space = ' ';
        list<string> parts = this.hDateInEnglish.trim().split(space);
        if (parts.size() < 2) return;

        if (parts[0].isNumeric()) { 
            // dd mm format as in 12 Av
            this.hDay = parts[0];
            this.hMonth = parts[1];
        } else {
            // mm dd format as in Av 12
            this.hDay = parts[1];
            this.hMonth = parts[0];
        } 
        this.hMonth = normalizeHebrewMonth();
        if (parts.size() == 3 && parts[2].isNumeric()) this.hYear = parts[2];

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


	public string NextOccuranceParams(){
        if (this.gDate == null) return '';
		this.params = '/yahrzeit?cfg=json&years=2';
        this.params += '&y1=' + string.valueOf(this.gDate.year());
        this.params += '&m1=' + string.valueOf(this.gDate.month());
        this.params += '&d1=' + string.valueOf(this.gDate.day());
        if (this.afterSunset != null && this.afterSunset) this.params += '&s1=on';
		return this.params;
	}


    public string getHebrewDateInHebrew(){
		//  Builds on info from getHebrewDate() so call afterwards
        this.hDateInHebrew = '';
        if ( string.isBlank(this.hDay) || string.isblank(this.hMonth)) return this.hDateInHebrew;

		map<string,string> hMonths = new map<string,string>{'nisan' => 'ניסן', 'iyyar' => 'אייר', 'sivan' => 'סיון' , 'tamuz' => 'תמוז' , 'av' => 'אב' , 'elul' => 'אלול' , 'tishri' => 'תשרי' , 'cheshvan' => 'אבחשון' , 'kislev' => 'כסלן' , 'tevet' => 'טבמ' , 'shvat' => 'שבט' , 'adar1' => 'אדר' , 'adar2' => 'אדר ב' };

		string mo = hMonth.toLowerCase().trim().replace('  ',' ');
		this.hDateInHebrew = this.hDay + ' ' + hMonths.get(mo); // + ' ' + this.hYear;
		return this.hDateInHebrew;
	}


    public string callHebCal(){
        Map<String, Object> hebCal = new Map<String, Object>();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://www.hebcal.com'+ this.params);
		request.setMethod('GET');
		request.setTimeout(120000);

		integer submitCount = 0;
		try {
			this.error = null;
			HttpResponse response = new http().send(request);
			submitCount++;
			this.responseRaw = response.getBody();

			if (response.getStatusCode() != 200) {
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
		return this.responseRaw;
	}


    public static boolean datesChanged(date newGreg, date oldGreg, string newHeb, string oldHeb){
        // first checks Gregorian dates to see if one has a value and not the other.  if that's the case or if both have values that aren't the same it returns true.
        
        boolean changed = false;
        if (newGreg != null && oldGreg == null) changed = true;
        if (!changed && newGreg == null && oldGreg != null) changed = true;
        if (!changed && newGreg != null && oldGreg != null && newGreg != oldGreg) changed = true;

        // then do similar for Hebrew dates
        if (!changed && newHeb != null && oldHeb == null) changed = true;
        if (!changed && newHeb == null && oldHeb != null) changed = true;
        if (!changed && newHeb != null && oldHeb != null && newHeb != oldHeb) changed = true;

        return changed;
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
        set<string> adar1 = new set<string>{'adar', 'adar1', 'adar 1', 'adar i', 'adar a', 'adara', 'אדר'};
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
}