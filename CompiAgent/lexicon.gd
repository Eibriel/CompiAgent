# extends Node



"""

if CONCEPT = INGEST
	C.THEME in BEVERAGE WATER
	if LANGUAGE = ES
			return "$C.AGENT ingiere $C.THEME"
		LANGUAGE = EN
			if C.AGENT = 
				return "$C.AGENT ingest $C.THEME"
			return "$C.AGENT ingests $C.THEME"


lexeme AGENT(A)
A.is_first_person ->
	language_spanish -> "Yo"
	language_english -> "I"


lexeme HUMAN
CONCEPT is HUMAN ->"!AGENT(HUMAN)"


lexeme DRINK
CONCEPT is INGEST and C.THEME in BEVERAGE,WATER -> is_drink_lexeme
!is_drink_lexeme -> end

C.in_present ->
	C.is_third_person ->
		language_english -> "!AGENT(C.AGENT) drinks $C.THEME"
		language_spanish -> "!AGENT(C.AGENT) bebe $C.THEME"

	C.is_first_person ->
		language_english -> "!AGENT(C.AGENT) drink $C.THEME"
		language_spanish -> "!AGENT(C.AGENT) bebo $C.THEME"

C.in_past ->
	C.is_third_person ->
		language_english -> "!AGENT(C.AGENT) drank $C.THEME"
		language_spanish -> "!AGENT(C.AGENT) bebí $C.THEME"
"""



"""
if
instance.type!ingest
instance.theme.beverage or instance.theme.whater
-
if
instance.happens!now and instance.person!third and language!english
-
"!AGENT(C.AGENT) drinks $C.THEME"
endif
endif

"""

func ingest(instance):
	if instance.type != "ingest":
		return false
	return ""

var lexicon = [
	
]


var lexicon_ = [
	{
		"BASE_PATTERN": {
			"CONCEPT": "INGEST",
			"THEME": ["BEVERAGE", "WATER"]
		},
		"MATCH": {
			"ES": "$AGENT ingiere $THEME",
			"EN": "$AGENT ingest $THEME",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "WATCH-MEDIA"
		},
		"MATCH": {
			"ES": "$AGENT mira $THEME",
			"EN": "$AGENT watchs $THEME",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "I"
		},
		"MATCH": {
			"ES": "yo",
			"EN": "I",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "WATER"
		},
		"MATCH": {
			"ES": "agua",
			"EN": "water",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "BEVERAGE"
		},
		"MATCH": {
			"ES": "bebida",
			"EN": "beverage",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "FOOD"
		},
		"MATCH": {
			"ES": "alimento",
			"EN": "food",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "HUMAN"
		},
		"MATCH": {
			"ES": "ser humano",
			"EN": "human being",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "FILM"
		},
		"MATCH": {
			"ES": "película",
			"EN": "movie",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "ANIMAL"
		},
		"MATCH": {
			"ES": "animal",
			"EN": "animal",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "SQUIRREL"
		},
		"MATCH": {
			"ES": "ardilla",
			"EN": "squirrel",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "NUT-FOODSTUFF"
		},
		"MATCH": {
			"ES": "nuez",
			"EN": "nut",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "PET"
		},
		"MATCH": {
			"ES": "$AGENT acaricia $THEME",
			"EN": "$AGENT pet $THEME",
		}
	},
	
	{
		"BASE_PATTERN": {
			"CONCEPT": "EVENT"
		},
		"MATCH": {
			"ES": "$AGENT hace algo con $THEME",
			"EN": "$AGENT do something with $THEME",
		}
	},
]
