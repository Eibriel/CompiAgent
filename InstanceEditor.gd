extends Control

onready var frames_tree = $VBoxContainer/VSplitContainer/HSplitContainer/Tree
onready var frame_edit = $VBoxContainer/VSplitContainer/HSplitContainer/RichTextLabel
onready var frame_slots = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer2/ScrollContainer/VBoxContainerSlots
onready var frame_name = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer2/LineEditName
onready var button_save_frame = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer2/ButtonSaveFrame
onready var button_new_frame = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer2/ButtonNewFrame
onready var button_add_slot = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer2/ButtonAddSlot

onready var instance_list = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ItemList
onready var instance_code = $VBoxContainer/VSplitContainer/HSplitContainer/TextEdit
onready var button_add_instance = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonAddInstance
onready var button_save_instance = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonSaveInstance
onready var lineedit_instancename = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/LineEditInstanceName

var FacetEditor = load("res://modules/facet_editor.tscn")
var SlotEditor = load("res://modules/slot_editor.tscn")

var json_path = "res://instances.json"

var onto = CompiAgent.frames

func _ready():
	_load_instances()
	_fill_instance_list()

	# connect buttons with signals
	button_add_instance.connect("button_up", self, "_on_ButtonAddInstance_button_up", [])
	button_save_instance.connect("button_up", self, "_on_ButtonSaveInstance_button_up", [])
	instance_list.connect("item_selected", self, "_on_ItemList_item_selected", [])

# If json_path exists, load it into instances var
func _load_instances():
	var file = File.new()
	
	if file.file_exists(json_path):
		file.open(json_path, File.READ)
		var text = file.get_as_text()
		var instances = parse_json(text)
		file.close()
		onto.load_from_dictionary(instances)
	else:
		onto.load_from_dictionary({})

func display_info(fname):
	frame_name.set_text(fname)

	for m in frame_slots.get_children():
		frame_slots.remove_child(m)

	if fname == "":
		return
	
	var frame = onto.get_frame_by_id(fname)
	
	for slot in frame.get_slot_names():
		var slot_editor = addSlot()
		var slot_name = slot_editor.get_node("SlotName")
		slot_name.set_text(slot)
		for facet in frame.get_slot(slot).get_facet_names():
			var facet_editor = addFacet(slot_editor)
			var facet_name = facet_editor.get_node("FacetName")
			facet_name.set_text(facet)
			for filler in frame.get_slot(slot).get_facet(facet).get_fillers(false):
				var filler_editor = addFiller(facet_editor)
				filler_editor.set_text(filler)


func addSlot():
	var slot_editor = SlotEditor.instance()
	var button_add_facet = slot_editor.get_node("ButtonAddFacet")
	button_add_facet.connect("button_up", self, "_on_ButtonAddFacet_button_up", [slot_editor])
	frame_slots.add_child(slot_editor)
	return slot_editor


func addFacet(slot_editor):
	var facet_editor = FacetEditor.instance()
	var button_add_filler = facet_editor.get_node("ButtonAddFiller")
	button_add_filler.connect("button_up", self, "_on_ButtonAddFiller_button_up", [facet_editor])
	var frame_facets = slot_editor.get_node("VBoxContainerFacets")
	frame_facets.add_child(facet_editor)
	return facet_editor

func addFiller(facet_editor):
	var filler_lineedit = LineEdit.new()
	filler_lineedit.placeholder_text = "Expression"
	var frame_fillers = facet_editor.get_node("VBoxContainerFillers")
	frame_fillers.add_child(filler_lineedit)
	return filler_lineedit

# Read instances and fill instance_list
func _fill_instance_list():
	instance_list.clear()
	var instances_names = onto.get_frames_names()
	for instance_name in instances_names:
		instance_list.add_item(instance_name)

# Add instance to instances var
# get name from lineedit_instancename
func _add_instance():
	if lineedit_instancename.get_text() == "":
		return
	var instance_name = lineedit_instancename.get_text()
	# instances[instance_name] = {}
	onto.add_frame(instance_name)
	_fill_instance_list()

# Save instances var to json_path
func _save_instances():
	var file = File.new()
	file.open(json_path, File.WRITE)
	# instances[lineedit_instancename.get_text()] = parse_json(instance_code.get_text())
	var onto_dict = onto.turn_into_dictionary()
	file.store_line(JSON.print(onto_dict, "\t"))
	file.close()

func _on_ButtonAddInstance_button_up():
	_add_instance()

func _on_ButtonSaveInstance_button_up():
	_save_instances()

func _on_ItemList_item_selected(item: int):
	var instance_name = instance_list.get_item_text(item)
	# instance_code.set_text(JSON.print(instances[instance_name], "\t"))
	display_info(instance_name)
	lineedit_instancename.set_text(instance_name)
