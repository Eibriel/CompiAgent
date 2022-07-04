extends Control

onready var concepts_tree = $VBoxContainer/VSplitContainer/HSplitContainer/Tree
onready var concept_edit = $VBoxContainer/VSplitContainer/HSplitContainer/RichTextLabel
onready var concept_properties = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/VBoxContainer
onready var concept_name = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/LineEditName
onready var concept_description = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/LineEditDescription
onready var button_save_concept = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonSaveConcept
onready var button_new_concept = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonNewConcept
onready var button_add_property = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonAddProperty

# var ConceptEditor = load("res://CompiAgent/modules/concept_editor.tscn")
var ConceptItem = load("res://CompiAgent/modules/concept_item.tscn")

var json_path = "res://concepts.json"

# var C = load("res://OpenOntoAgent/concepts.gd")
# var concepts = C.new()

var ed

var concepts = {
	"ROOT": {
		"DESCRIPTION": "Origin concept, source for all concepts"
	},
	"EVENT": {
		"DESCRIPTION": "Something that happends",
		"IS-A": "ROOT"
	},
}

var questions = [
	{
		"question":"-",
		"type": "none",
		"arity": "one",
		"tip": "Keeps the slot empty",
		"property_name": ""
	},
	
	# Objects & Events
	{
		"question":"What kind of concept is it?",
		"type": "concept",
		"arity": "one",
		"tip": "This concept forms part of a larger group, for example an APPLE is part of FRUIT",
		"property_name": "IS-A"
	},
	
	# Events
	{
		"question":"Who usually performs the event?",
		"type": "concept",
		"arity": "many",
		"tip": "What kind of concept is often present as the Agent of Event, for example who READS is often a HUMAN",
		"property_name": "AGENT"
	},
	{
		"question":"Towards what concept is the event directed?",
		"type": "concept",
		"arity": "many",
		"tip": "For example a human can read a BOOK",
		"property_name": "THEME"
	},
	{
		"question":"What is used to perform the event?",
		"type": "concept",
		"arity": "many",
		"tip": "For example a human can write with a PEN",
		"property_name": "INSTRUMENT"
	},
	
	# Objects
	{
		"question":"What concept has as part?",
		"type": "concept",
		"arity": "many",
		"tip": "For example a car has wheels as part",
		"property_name": "HAS-AS-PART"
	},
	{
		"question":"Is part of what concept?",
		"type": "concept",
		"arity": "many",
		"tip": "For example a wheel is part of a car",
		"property_name": "PART-OF"
	},
	{
		"question":"Belonds to what concept?",
		"type": "concept",
		"arity": "many",
		"tip": "For example iPhone belongs to Apple",
		"property_name": "BELONGS-TO"
	},
	{
		"question":"How old is it?",
		"type": "concept",
		"arity": "many",
		"tip": "",
		"property_name": "AGE"
	},
	{
		"question":"Where is located?",
		"type": "concept",
		"arity": "many",
		"tip": "Earth is located in the solar system",
		"property_name": "LOCATION"
	}
]

var concept_tree = {}

func build_concept_tree():
	concept_tree = {}
	for item in concepts:
		concept_tree[item] = {}

func add_item_to_tree(tree, root, dict, section):
	if concept_tree.has(section):
		return
	var the_root = root
	if dict[section].has("IS-A"):
		if not concept_tree.has(dict[section]["IS-A"]):
			add_item_to_tree(tree, root, dict, dict[section]["IS-A"])
		the_root = concept_tree[dict[section]["IS-A"]]
	var section_item = tree.create_item(the_root)
	concept_tree[section] = section_item
	section_item.set_text(0, section)

func add_to_tree(tree, root, dict):
	for section in dict:
		add_item_to_tree(tree, root, dict, section)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	# build_concept_tree()
	
	concepts_tree.connect("cell_selected", self, "_on_Tree_cell_selected", [])
	button_new_concept.connect("button_up", self, "_on_ButtonNewConcept_button_up", [])
	button_save_concept.connect("button_up", self, "_on_ButtonSaveConcept_button_up", [])
	button_add_property.connect("button_up", self, "_on_ButtonAddProperty_button_up", [])
	
	var file = File.new()
	
	if file.file_exists(json_path):
		file.open(json_path, File.READ)
		var text = file.get_as_text()
		concepts = parse_json(text)
		file.close()
	
	refresh_tree()


func refresh_tree():
	concept_tree = {}
	concepts_tree.clear()
	var root_concept = concepts_tree.create_item()
	concepts_tree.set_hide_root(true)
	
	add_to_tree(concepts_tree, root_concept, concepts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Tree_cell_selected():
	
	print(concepts_tree.get_selected().get_text(0))
	var cname = concepts_tree.get_selected().get_text(0)
	display_info(cname)


func display_info(cname):
	concept_name.set_text(cname)
	concept_description.set_text(concepts[cname]["DESCRIPTION"])

	for m in concept_properties.get_children():
		concept_properties.remove_child(m)

	if cname == "":
		return

	for prop in concepts[cname]:
		for possible_questions in questions:
			if prop == possible_questions["property_name"]:
				ed = ConceptItem.instance()
				var q = ed.get_node("VBoxContainer/Questions")
				var a = ed.get_node("VBoxContainer/Answer")
				a.set_text(concepts[cname][prop])
				for qid in range(questions.size()):
					q.add_item(questions[qid]["question"], qid)
					if prop == questions[qid]["property_name"]:
						q.select(qid)
				concept_properties.add_child(ed)
		


func _on_ButtonSaveConcept_button_up():
	var cname = concept_name.get_text()
	if cname == "":
		return
	var cdescription = concept_description.get_text()
	
	var concept_data = {
		"DESCRIPTION": cdescription
	}
	
	for prop in concept_properties.get_children():
		var q = prop.get_node("VBoxContainer/Questions")
		var a = prop.get_node("VBoxContainer/Answer")
		for qq in questions:
			if qq["question"] == q.get_item_text(q.get_selected_id()):
				var prop_name = qq["property_name"]
				concept_data[prop_name] = a.get_text()
	
	concepts[cname] = concept_data
	
	var file = File.new()
	file.open(json_path, File.WRITE)
	file.store_line(to_json(concepts))
	file.close()
	
	refresh_tree()


func _on_ButtonNewConcept_button_up():
	concept_name.set_text("")
	concept_description.set_text("")
	for m in concept_properties.get_children():
		concept_properties.remove_child(m)


func _on_ButtonAddProperty_button_up():
	ed = ConceptItem.instance()
	var q = ed.get_node("VBoxContainer/Questions")
	var a = ed.get_node("VBoxContainer/Answer")
	for qid in range(questions.size()):
		q.add_item(questions[qid]["question"], qid)
	concept_properties.add_child(ed)


func _on_select_question(q, a):
	pass
