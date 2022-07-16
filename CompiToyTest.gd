extends Control


onready var textAnswers = $MainContainer/TextRealizedText
onready var textRawTMR = $MainContainer/TextTMR

onready var buttonSendTMR = $MainContainer/ButtonSendTMR
onready var buttonReset = $MainContainer/ButtonReset
onready var containerAvailableTokens = $MainContainer/GridButtonsAvailableTokens

onready var textConceptInfo = $MainContainer/TextConceptInfo

var frames = {}
var instances = {}
var instances_frames = {}
var selected_tokens = []
var tmr = {}
	
var frames_json_path = "res://frames.json"
var instances_json_path = "res://instances.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	
	if file.file_exists(frames_json_path):
		file.open(frames_json_path, File.READ)
		var text = file.get_as_text()
		frames = parse_json(text)
		file.close()
	
	if file.file_exists(instances_json_path):
		file.open(instances_json_path, File.READ)
		var text = file.get_as_text()
		instances = parse_json(text)
		file.close()
	
	buttonReset.connect("button_up", self, "_on_reset_tokens")
	buttonSendTMR.connect("button_up", self, "_on_send_tmr")
	drawTokenButtons()

# Draw de buttons for the tokens.
# get tokens from frames and instances vars
# and place buttons in containerAvailableTokens
func drawTokenButtons():
	for token in frames:
		var button = Button.new()
		button.text = token
		button.connect("button_up", self, "_on_token_selected", [token])
		containerAvailableTokens.add_child(button)
	for token in instances:
		var button = Button.new()
		button.text = token
		button.connect("button_up", self, "_on_token_selected", [token])
		containerAvailableTokens.add_child(button)

func _on_select_token(token_name):
	print(token_name)
	textConceptInfo.clear()
	updateCandidates()

func updateCandidates():
	var used_tokens = []
	tmr = {}
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
