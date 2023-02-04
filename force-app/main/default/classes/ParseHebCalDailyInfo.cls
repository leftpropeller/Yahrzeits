// 
// Generated by JSON2Apex http://JSON2Apex.herokuapp.com/
//
// The supplied json has fields with names that are not valid in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public class ParseHebCalDailyInfo {

	public String title {get;set;} 
	public String date_Z {get;set;} // in json: date
	public Location location {get;set;} 
	public List<Items> items {get;set;} 

	public ParseHebCalDailyInfo(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'title') {
						title = parser.getText();
					} else if (text == 'date') {
						date_Z = parser.getText();
					} else if (text == 'location') {
						location = new Location(parser);
					} else if (text == 'items') {
						items = arrayOfItems(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	// public class Leyning_X {
	// 	public String x1 {get;set;} 
	// 	public String x2 {get;set;} 
	// 	public String x3 {get;set;} 
	// 	public String x4 {get;set;} 
	// 	public String torah {get;set;} 

	// 	public Leyning_X(JSONParser parser) {
	// 		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
	// 			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
	// 				String text = parser.getText();
	// 				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
	// 					if (text == '1') {
	// 						x1 = parser.getText();
	// 					} else if (text == '2') {
	// 						x2 = parser.getText();
	// 					} else if (text == '3') {
	// 						x3 = parser.getText();
	// 					} else if (text == '4') {
	// 						x4 = parser.getText();
	// 					} else if (text == 'torah') {
	// 						torah = parser.getText();
	// 					} else {
	// 						System.debug(LoggingLevel.WARN, 'Leyning_X consuming unrecognized property: '+text);
	// 						consumeObject(parser);
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// }
	
	// public class Leyning_W {
	// 	public String x1 {get;set;} 
	// 	public String x2 {get;set;} 
	// 	public String x3 {get;set;} 
	// 	public String x4 {get;set;} 
	// 	public String x5 {get;set;} 
	// 	public String x6 {get;set;} 
	// 	public String x7 {get;set;} 
	// 	public String torah {get;set;} 
	// 	public String haftarah {get;set;} 
	// 	public String haftarah_sephardic {get;set;} 
	// 	public String maftir {get;set;} 
	// 	public Triennial triennial {get;set;} 

	// 	public Leyning_W(JSONParser parser) {
	// 		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
	// 			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
	// 				String text = parser.getText();
	// 				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
	// 					if (text == '1') {
	// 						x1 = parser.getText();
	// 					} else if (text == '2') {
	// 						x2 = parser.getText();
	// 					} else if (text == '3') {
	// 						x3 = parser.getText();
	// 					} else if (text == '4') {
	// 						x4 = parser.getText();
	// 					} else if (text == '5') {
	// 						x5 = parser.getText();
	// 					} else if (text == '6') {
	// 						x6 = parser.getText();
	// 					} else if (text == '7') {
	// 						x7 = parser.getText();
	// 					} else if (text == 'torah') {
	// 						torah = parser.getText();
	// 					} else if (text == 'haftarah') {
	// 						haftarah = parser.getText();
	// 					} else if (text == 'haftarah_sephardic') {
	// 						haftarah_sephardic = parser.getText();
	// 					} else if (text == 'maftir') {
	// 						maftir = parser.getText();
	// 					} else if (text == 'triennial') {
	// 						triennial = new Triennial(parser);
	// 					} else {
	// 						System.debug(LoggingLevel.WARN, 'Leyning_W consuming unrecognized property: '+text);
	// 						consumeObject(parser);
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// }
	
	// public class Leyning_Z {
	// 	public String x7 {get;set;} 
	// 	public String haftarah {get;set;} 
	// 	public String maftir {get;set;} 

	// 	public Leyning_Z(JSONParser parser) {
	// 		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
	// 			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
	// 				String text = parser.getText();
	// 				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
	// 					if (text == '7') {
	// 						x7 = parser.getText();
	// 					} else if (text == 'haftarah') {
	// 						haftarah = parser.getText();
	// 					} else if (text == 'maftir') {
	// 						maftir = parser.getText();
	// 					} else {
	// 						System.debug(LoggingLevel.WARN, 'Leyning_Z consuming unrecognized property: '+text);
	// 						consumeObject(parser);
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// }
	
	// public class Leyning_Y {
	// 	public String x1 {get;set;} 
	// 	public String x2 {get;set;} 
	// 	public String x3 {get;set;} 
	// 	public String x4 {get;set;} 
	// 	public String x5 {get;set;} 
	// 	public String x6 {get;set;} 
	// 	public String x7 {get;set;} 
	// 	public String torah {get;set;} 
	// 	public String haftarah {get;set;} 
	// 	public String maftir {get;set;} 
	// 	public Triennial triennial {get;set;} 

	// 	public Leyning_Y(JSONParser parser) {
	// 		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
	// 			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
	// 				String text = parser.getText();
	// 				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
	// 					if (text == '1') {
	// 						x1 = parser.getText();
	// 					} else if (text == '2') {
	// 						x2 = parser.getText();
	// 					} else if (text == '3') {
	// 						x3 = parser.getText();
	// 					} else if (text == '4') {
	// 						x4 = parser.getText();
	// 					} else if (text == '5') {
	// 						x5 = parser.getText();
	// 					} else if (text == '6') {
	// 						x6 = parser.getText();
	// 					} else if (text == '7') {
	// 						x7 = parser.getText();
	// 					} else if (text == 'torah') {
	// 						torah = parser.getText();
	// 					} else if (text == 'haftarah') {
	// 						haftarah = parser.getText();
	// 					} else if (text == 'maftir') {
	// 						maftir = parser.getText();
	// 					} else if (text == 'triennial') {
	// 						triennial = new Triennial(parser);
	// 					} else {
	// 						System.debug(LoggingLevel.WARN, 'Leyning_Y consuming unrecognized property: '+text);
	// 						consumeObject(parser);
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// }
	
	// public class Triennial {
	// 	public String x1 {get;set;} 
	// 	public String x2 {get;set;} 
	// 	public String x3 {get;set;} 
	// 	public String x4 {get;set;} 
	// 	public String x5 {get;set;} 
	// 	public String x6 {get;set;} 
	// 	public String x7 {get;set;} 
	// 	public String maftir {get;set;} 

	// 	public Triennial(JSONParser parser) {
	// 		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
	// 			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
	// 				String text = parser.getText();
	// 				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
	// 					if (text == '1') {
	// 						x1 = parser.getText();
	// 					} else if (text == '2') {
	// 						x2 = parser.getText();
	// 					} else if (text == '3') {
	// 						x3 = parser.getText();
	// 					} else if (text == '4') {
	// 						x4 = parser.getText();
	// 					} else if (text == '5') {
	// 						x5 = parser.getText();
	// 					} else if (text == '6') {
	// 						x6 = parser.getText();
	// 					} else if (text == '7') {
	// 						x7 = parser.getText();
	// 					} else if (text == 'maftir') {
	// 						maftir = parser.getText();
	// 					} else {
	// 						System.debug(LoggingLevel.WARN, 'Triennial consuming unrecognized property: '+text);
	// 						consumeObject(parser);
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// }
	
	public class Items {
		public String title {get;set;} 
		public String date_Z {get;set;} // in json: date
		public String category {get;set;} 
		public String subcat {get;set;} 
		public String hebrew {get;set;} 
		// public Leyning leyning {get;set;} 
		public String link {get;set;} 
		// public String memo {get;set;} 

		public Items(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'title') {
							title = parser.getText();
						} else if (text == 'date') {
							date_Z = parser.getText();
						} else if (text == 'category') {
							category = parser.getText();
						} else if (text == 'subcat') {
							subcat = parser.getText();
						} else if (text == 'hebrew') {
							hebrew = parser.getText();
						// } else if (text == 'leyning') {
						// 	leyning = new Leyning(parser);
						} else if (text == 'link') {
							link = parser.getText();
						// } else if (text == 'memo') {
						// 	memo = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Items consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	// public class Leyning {
	// 	public String x1 {get;set;} 
	// 	public String x2 {get;set;} 
	// 	public String x3 {get;set;} 
	// 	public String torah {get;set;} 

	// 	public Leyning(JSONParser parser) {
	// 		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
	// 			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
	// 				String text = parser.getText();
	// 				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
	// 					if (text == '1') {
	// 						x1 = parser.getText();
	// 					} else if (text == '2') {
	// 						x2 = parser.getText();
	// 					} else if (text == '3') {
	// 						x3 = parser.getText();
	// 					} else if (text == 'torah') {
	// 						torah = parser.getText();
	// 					} else {
	// 						System.debug(LoggingLevel.WARN, 'Leyning consuming unrecognized property: '+text);
	// 						consumeObject(parser);
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// }
	
	public class Location {
		public String geo {get;set;} 

		public Location(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'geo') {
							geo = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Location consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ParseHebCalDailyInfo parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ParseHebCalDailyInfo(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	

    private static List<Items> arrayOfItems(System.JSONParser p) {
        List<Items> res = new List<Items>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Items(p));
        }
        return res;
    }
}