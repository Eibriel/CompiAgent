extends Node

var lexicon = [
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


func realizate(tmr, lang):
    var match_ = ""
    for l in lexicon:
        if l["BASE_PATTERN"]["CONCEPT"] == tmr["ROOT"]:
            match_ = l["MATCH"][lang]
            for p in tmr[tmr["ROOT"]]:
                var concept = tmr[tmr["ROOT"]][p]
                var subtmr = {
                    "ROOT": concept
                   }
                subtmr[concept] = {}
                var subrealizate = realizate(subtmr, lang)
                match_ = match_.replace("$"+p, subrealizate)
    return match_


func _ready():
    var tmr = {
        "ROOT": "INGEST",
        "INGEST": {
            "THEME": "WATER",
            "AGENT": "I"
           }
       }
    var t = realizate(tmr, "EN")
    print (t)
