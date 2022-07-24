extends Control


onready var textAnswers = $MainContainer/TextRealizedText
onready var textRawTMR = $MainContainer/TextTMR

onready var buttonSendTMR = $MainContainer/ButtonSendTMR
onready var buttonReset = $MainContainer/ButtonReset
onready var containerSelectedTokens = $MainContainer/GridButtonsSelectedTokens
onready var containerAvailableTokens = $MainContainer/GridButtonsAvailableTokens

onready var textConceptInfo = $MainContainer/TextConceptInfo

# var frames = {}
# var instances = {}
var instances_frames = {}
var selected_tokens = []
var tmr = {}

var onto = CompiAgent.frames

# Called when the node enters the scene tree for the first time.
func _ready():
	buttonReset.connect("button_up", self, "_on_reset_tokens")
	buttonSendTMR.connect("button_up", self, "_on_send_tmr")
	drawTokenButtons()

# Draw de buttons for the tokens.
# get tokens from frames and instances vars
# and place buttons in containerAvailableTokens
func drawTokenButtons():
	for c in containerAvailableTokens.get_children():
		containerAvailableTokens.remove_child(c)
	for token in onto.get_frames_names():
		if token.begins_with("*."):
			continue
		var button = Button.new()
		button.text = token
		button.connect("button_up", self, "_on_select_token", [token])
		containerAvailableTokens.add_child(button)

func _on_select_token(token_name):
	if token_name.begins_with("onto."):
		var instance_name = CompiAgent.createInstance(token_name)
		selected_tokens.append(instance_name)
		drawTokenButtons()
	else:
		if not selected_tokens.has(token_name):
			selected_tokens.append(token_name)
	textConceptInfo.clear()
	updateCandidates()

func _on_remove_token(token_name):
	if selected_tokens.has(token_name):
		selected_tokens.remove(selected_tokens.find(token_name))
		textConceptInfo.clear()
		updateCandidates()

func updateCandidates():
	for c in containerSelectedTokens.get_children():
		containerSelectedTokens.remove_child(c)
	for st in selected_tokens:
		var button = Button.new()
		button.text = st
		button.connect("button_up", self, "_on_remove_token", [st])
		containerSelectedTokens.add_child(button)
	
	#var used_tokens = []
	tmr = CompiAgent.buildTMR(selected_tokens)
	textRawTMR.clear()
	var text = JSON.print(tmr, "\t")
	textRawTMR.append_bbcode(text)

func _on_reset_tokens():
	selected_tokens = []
	updateCandidates()
	print("RESET!")


func _on_send_tmr():
	var text = ""
	textAnswers.set_text(text)
	# _on_reset_tokens()
	print("Send!")
