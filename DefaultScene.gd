extends Control

var token_buttons = []
var commands_buttons = []
var selected_token_buttons = []

var selected_tokens = []

var token_pagination : int  = 0

var lang = "EN"

func _ready():
    token_buttons = [
        $MarginContainer/VSplitContainer/VBoxContainer2/GridContainer/Button,
        $MarginContainer/VSplitContainer/VBoxContainer2/GridContainer/Button2,
        $MarginContainer/VSplitContainer/VBoxContainer2/GridContainer/Button3,
        $MarginContainer/VSplitContainer/VBoxContainer2/GridContainer/Button4,
        $MarginContainer/VSplitContainer/VBoxContainer2/GridContainer/Button5,
        $MarginContainer/VSplitContainer/VBoxContainer2/GridContainer/Button6
    ]

    selected_token_buttons = [
        $MarginContainer/VSplitContainer/VBoxContainer2/HBoxContainer/Button2,
        $MarginContainer/VSplitContainer/VBoxContainer2/HBoxContainer/Button3,
        $MarginContainer/VSplitContainer/VBoxContainer2/HBoxContainer/Button4
    ]

    commands_buttons = [
        $MarginContainer/VSplitContainer/VBoxContainer2/VBoxContainer2/Button,
        $MarginContainer/VSplitContainer/VBoxContainer2/VBoxContainer2/Button2,
        $MarginContainer/VSplitContainer/VBoxContainer2/VBoxContainer2/Button3
    ]

    for button in range(token_buttons.size()):
        token_buttons[button].connect("button_up", self, "_on_select_token", [button])

    for button in range(commands_buttons.size()):
        commands_buttons[button].connect("button_up", self, "_on_select_command", [button])

    var reset_button = $MarginContainer/VSplitContainer/VBoxContainer2/HBoxContainer2/Button7
    reset_button.connect("button_up", self, "_on_reset")

    var refresh_button = $MarginContainer/VSplitContainer/VBoxContainer2/HBoxContainer2/Button8
    refresh_button.connect("button_up", self, "_on_refresh")

    var english_button = $MarginContainer/VSplitContainer/VBoxContainer2/HBoxContainer3/Button7
    english_button.connect("button_up", self, "_on_set_lang", ["EN"])
    
    var spanish_button = $MarginContainer/VSplitContainer/VBoxContainer2/HBoxContainer3/Button8
    spanish_button.connect("button_up", self, "_on_set_lang", ["ES"])

    get_tokens()



class MyCustomSorter:
    static func sort_descending(a, b):
        if a["PROB"] > b["PROB"]:
            return true
        return false


func get_tokens():
    var concepts_array = []
    for c in Concepts.concepts:
        var cc = Concepts.concepts[c].duplicate()
        cc["NAME"] = c
        concepts_array.append(cc)

    concepts_array.sort_custom(MyCustomSorter, "sort_descending")

    var tokens = []
    for c in concepts_array:
        tokens.append(c["NAME"])
    
    #if token_pagination >= tokens.size():
    #    token_pagination = 0

    for button in token_buttons:
        if token_pagination >= tokens.size():
            token_pagination = 0
        button.set_text(tokens[token_pagination])
        token_pagination += 1

func _on_select_token(index : int) -> void:
    var token_name = token_buttons[index].get_text()
    if not selected_tokens.has(token_name):
        selected_tokens.append(token_name)
    print("selected_tokens ", selected_tokens)
    refreshSelectedTokens()
    refreshCommands()

func _on_select_command(index : int) -> void:
    
    var questions = {
        "ingest": ["Drink or Eat", "What is eating?"],
        "ingest t: food": ["Eats food", "Who eats food?"],
        "ingest t: food a: squirrel": ["A squirrel eats food", "Must be happy"],
        "ingest a: squirrel": ["A squirrel ears", "What is eating?"],
        
        "ingest t: water": ["Drinks water", "Who drinks water?"],
        "ingest t: water a: squirrel": ["A squirrel drinks water", "A thirsty squirrel"],
        
        
        "watch-media": ["Watch something", "Who whatches what?"],
        "watch-media t: film": ["Watchs a movie", "Who is watching a movie?"],
        "watch-media a: i": ["I watch something", "What are you watching?"],
        "watch-media t: film a: i": ["I watch a movie", "Hope it is good!"],
        
        "pet": ["Pets", "Who is petting what?"],
        "pet a: i": ["I pet", "What are you petting?"],
        "pet t: squirrel a: i": ["I pet a squirrel", "They are adorable!"],
        
        "pet t: animal": ["Pets an animal", "Who pets an animal?"],
        "pet t: animal a: i": ["I pet an animal", "They are adorable!"],
    }
    
    var cmm = commands_buttons[index].get_text().to_lower()
    
    var q : String = ""
    var a : String = ""
    
    if questions.has(cmm):
        q = questions[cmm][0]
        a = questions[cmm][1]
    else:
        q = cmm
        a = "?"
    
    var RichText = $MarginContainer/VSplitContainer/VBoxContainer/RichTextLabel
    
    RichText.bbcode_text = ""
    RichText.append_bbcode("[b]Human:[/b] " + q + "\n[color=aqua][b]Compi:[/b] " + a + "[/color]\n\n")
    
    selected_tokens = []
    get_tokens()
    refreshSelectedTokens()
    refreshCommands()

func refreshSelectedTokens():
    var tokens_label = $MarginContainer/VSplitContainer/VBoxContainer2/HBoxContainer/Label
    var t_text : String = ""
    for t in selected_tokens:
        t_text +=  t + " - "
    t_text = t_text.substr(0, t_text.length()-3)
    t_text = t_text.to_lower()
    tokens_label.set_text(t_text)

func refreshCommands():
    
    var r = TabuSearch.get_combinations(selected_tokens)
    
    if r[0].size() == 0:
        return
    
    var index = r[0]
    var selected_commands = r[1][0]
    
    print("selected_commands ", selected_commands)
    
    var tmr = {}
    for i in range(index.size()):
        if index[i] == "*":
            continue
        elif index[i] == "*ROOT*":
            tmr["ROOT"] = selected_commands[i]
            tmr[selected_commands[i]] = {}
        else:
            if i >= selected_commands.size():
                continue
            var keys = index[i].split("/")
            var token = keys[0]
            var property = keys[1]
            if not tmr.has(token):
                tmr[token] = {}
            tmr[token][property] = selected_commands[i]
    
    print("tmr ", tmr)
    var text_ = [Lexicon.realizate(tmr, lang)]
    print(text_)
    
    if selected_commands == null:
        return
    
    for button in commands_buttons:
        button.set_text("")
        button.disabled = true
    
    var count : int = 0
    for text in text_:
        if count > 2:
            break
        commands_buttons[count].set_text(text)
        commands_buttons[count].disabled = false
        count += 1

func _on_reset() -> void:
    selected_tokens = []
    get_tokens()
    refreshSelectedTokens()
    refreshCommands()

func _on_refresh() -> void:
    get_tokens()
    refreshSelectedTokens()
    refreshCommands()

func _on_set_lang(lang_) -> void:
    lang = lang_
    refreshCommands()
