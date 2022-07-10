extends Control


onready var textAnswers = $MainContainer/TextAnswers
onready var textRawTMR = $MainContainer/TextRawTMR

onready var buttonCube = $MainContainer/GridButtons/ButtonCube
onready var buttonSphere = $MainContainer/GridButtons/ButtonSphere
onready var buttonCylinder = $MainContainer/GridButtons/ButtonCylinder
onready var buttonPaint = $MainContainer/GridButtons/ButtonPaint
onready var buttonApplyPaint = $MainContainer/GridButtons/ButtonApplyPaint
onready var buttonHuman = $MainContainer/GridButtons/ButtonHuman
onready var buttonBlueColored = $MainContainer/GridButtons/ButtonBlueColored
onready var buttonRedColored = $MainContainer/GridButtons/ButtonRedColored
onready var buttonAssert = $MainContainer/GridButtons/ButtonAssert
onready var buttonRequestInfo = $MainContainer/GridButtons/ButtonRequestInfo

onready var buttonSendTMR = $MainContainer/ButtonSendTMR
onready var buttonReset = $MainContainer/ButtonReset

onready var textConceptInfo = $MainContainer/TextConceptInfo


var concepts = {
	"all": {},
	"object": {
		"is-a": "all"
	},
	"event": {
		"is-a": "all"
	},
	
	# Objects
	"physical-object": {
		"is-a": "object"
	},
	"cube": {
		"is-a": "physical-object"
	},
	"sphere": {
		"is-a": "physical-object"
	},
	"cylinder": {
		"is-a": "physical-object"
	},
	"paint": {
		"is-a": "physical-object"
	},
	"human": {
		"is-a": "physical-object"
	},
	
	# Events
	"applypaint": {
		"is-a": "event",
		"agent": "human",
		"theme": "object",
		"instrument": "paint"
	}
	# generic event CHANGE-IN-QUALITY
}

var properties = {
	"color": {
		"range": "physical-object",
		"domain": ["blue", "red"]
	},
	"agent": {
		"range": "event",
		"domain": "object"
	},
	"theme": {
		"range": "event",
		"domain": "object"
	},
	"instrument": {
		"range": "event",
		"domain": "object"
	},
	"modality": {
		"range": "tmr",
		# epistemic: Assertion
		"domain": ["epistemic"]
	},
	"requestinfo": {
		"range": "tmr",
		"domain": []
	}
}

var selected_tokens = []
var selected_preperties = []
var tmr = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	buttonCube.connect("button_up", self, "_on_select_token", ["cube"])
	buttonSphere.connect("button_up", self, "_on_select_token", ["sphere"])
	buttonCylinder.connect("button_up", self, "_on_select_token", ["cylinder"])
	buttonPaint.connect("button_up", self, "_on_select_token", ["paint"])
	buttonApplyPaint.connect("button_up", self, "_on_select_token", ["applypaint"])
	buttonHuman.connect("button_up", self, "_on_select_token", ["human"])
	buttonBlueColored.connect("button_up", self, "_on_select_token", ["color.red"])
	buttonRedColored.connect("button_up", self, "_on_select_token", ["color.blue"])
	buttonAssert.connect("button_up", self, "_on_select_token", ["modality.epistemic"])
	buttonRequestInfo.connect("button_up", self, "_on_select_token", ["requestinfo.value"])
	
	buttonReset.connect("button_up", self, "_on_reset_tokens")
	buttonSendTMR.connect("button_up", self, "_on_send_tmr")
	


func _on_select_token(token_name):
	print(token_name)
	textConceptInfo.clear()
	var type
	if concepts.has(token_name):
		var text = JSON.print(concepts[token_name], "\t")
		type = "concept"
		textConceptInfo.append_bbcode(type)
		textConceptInfo.append_bbcode(text)
		selected_tokens.append(token_name)
	else:
		type = "property"
		var t = token_name.split(".")[0]
		var text = JSON.print(properties[t], "\t")
		textConceptInfo.append_bbcode(type)
		textConceptInfo.append_bbcode(text)
		selected_preperties.append(token_name)
	updateCandidates()

func updateCandidates():
	var used_tokens = []
	tmr = {}
	for token in selected_tokens:
		if used_tokens.has(token):
			continue
		if concepts[token]["is-a"] == "event":
			used_tokens.append(token)
			tmr[token] = {"agent": "", "theme": "", "instrument": ""}
			for token2 in selected_tokens:
				if used_tokens.has(token2):
					continue
				if token2 == "human":
					used_tokens.append(token2)
					tmr[token]["agent"] = token2
					tmr[token2] = {}
					continue
				if token2 in ["cube", "cylinder", "sphere"]:
					used_tokens.append(token2)
					tmr[token]["theme"] = token2
					tmr[token2] = {}
					continue
				if token2 == "paint":
					used_tokens.append(token2)
					tmr[token]["instrument"] = token2
					tmr[token2] = {}
					continue
	
	for prop in selected_preperties:
		var pname = prop.split(".")[0]
		var pvalue = prop.split(".")[1]
		if pname == "color":
			if "paint" in tmr:
				tmr["paint"] = {
					pname: pvalue
				}
		elif pname == "modality":
			tmr["modality"] = {
				"type": pvalue
			}
		elif pname == "requestinfo":
			tmr["requestinfo"] = {
				"type": pvalue
			}
	
	textRawTMR.clear()
	var text = JSON.print(tmr, "\t")
	textRawTMR.append_bbcode(text)

func _on_reset_tokens():
	print("RESET!")
	selected_tokens = []
	selected_preperties = []
	updateCandidates()


func _on_send_tmr():
	var text = ""
	if "applypaint" in tmr:
		var data = {
			"agent": tmr["applypaint"]["agent"],
			"theme": tmr["applypaint"]["theme"],
			"color": "",
			"instrument": tmr["applypaint"]["instrument"]
		}
		if "paint" in tmr:
			data["color"] = tmr["paint"]["color"]
		if "requestinfo" in tmr:
			if "modality" in tmr:
				text = "{agent} paints a {theme} with {color} {instrument}?".format(data)
			else:
				if data["agent"] == "":
					text = "Who paints a {theme} with {color} {instrument}?".format(data)
				elif data["theme"] == "":
					text = "What object {agent} paints with {color} {instrument}?".format(data)
				elif data["instrument"] == "":
					text = "{agent} paints a {theme} with what?".format(data)
				elif data["color"] == "":
					text = "{agent} paints a {theme} with {instrument} of what color?".format(data)
				else:
					text = "???"
		else:
			text = "{agent} paints a {theme} with {color} {instrument}".format(data)
	textAnswers.set_text(text)
	_on_reset_tokens()
	print("Send!")
