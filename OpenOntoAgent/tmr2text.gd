extends Node

var Lexicon = load("res://OpenOntoAgent/lexicon.gd")
var lexicon = Lexicon.new().lexicon

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
