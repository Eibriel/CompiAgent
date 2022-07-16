extends Control

onready var frames_tree = $VBoxContainer/VSplitContainer/HSplitContainer/Tree
onready var frame_edit = $VBoxContainer/VSplitContainer/HSplitContainer/RichTextLabel
onready var frame_slots = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/VBoxContainerSlots
onready var frame_name = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/LineEditName
onready var button_save_frame = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonSaveFrame
onready var button_new_frame = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonNewFrame
onready var button_add_slot = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonAddSlot

var FacetEditor = load("res://CompiAgent/modules/facet_editor.tscn")
var SlotEditor = load("res://CompiAgent/modules/slot_editor.tscn")

var json_path = "res://frames.json"

## Ontology class
var Ontology = load("res://CompiAgent/ontology_class.gd")

## Ontology instance
var onto = Ontology.new()

var frames = {
	"all": {
		"description": {
			"value": ["\"Origin frame, source for all frames (default frames)\""]
		}
	},
	"event": {
		"description": {
			"value": ["\"Something that happends\""]
		},
		"is-a": {
			"value": ["all"]
		}
	},
	
	"is-a": {
		"domain": {
			"sem": ["*all"]
		},
		"range": {
			"sem": ["*all"]
		}
	}
}

func add_item_to_tree(tree, root, onto, section):
	var section_item = tree.create_item(root)
	section_item.set_text(0, section)

	var frames_names = onto.get_frames_names()

	for id in frames_names:
		var frame = onto.get_frame_by_id(id)
		var is_a_related = onto.get_related(frame.name, "is-a")
		if not is_a_related:
			continue
		if is_a_related.get_fillers(false).has(section):
			add_item_to_tree(tree, section_item, onto, frame.name)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	
	frames_tree.connect("cell_selected", self, "_on_Tree_cell_selected", [])
	button_new_frame.connect("button_up", self, "_on_ButtonNewFrame_button_up", [])
	button_save_frame.connect("button_up", self, "_on_ButtonSaveFrame_button_up", [])
	button_add_slot.connect("button_up", self, "_on_ButtonAddSlot_button_up", [])
	
	var file = File.new()
	
	if file.file_exists(json_path):
		file.open(json_path, File.READ)
		var text = file.get_as_text()
		frames = parse_json(text)
		file.close()
	
	onto.load_from_dictionary(frames)
	
	refresh_tree()


func refresh_tree():
	frames_tree.clear()
	var root_frame = frames_tree.create_item()
	frames_tree.set_hide_root(true)
	
	add_item_to_tree(frames_tree, root_frame, onto, "all")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Tree_cell_selected():
	
	print(frames_tree.get_selected().get_text(0))
	var cname = frames_tree.get_selected().get_text(0)
	display_info(cname)


func display_info(cname):
	frame_name.set_text(cname)

	for m in frame_slots.get_children():
		frame_slots.remove_child(m)

	if cname == "":
		return

	for slot in frames[cname]:
		var slot_editor = addSlot()
		var slot_name = slot_editor.get_node("VBoxContainer/SlotName")
		slot_name.set_text(slot)
		for facet in frames[cname][slot]:
			var facet_editor = addFacet(slot_editor)
			var facet_name = facet_editor.get_node("VBoxContainer/FacetName")
			facet_name.set_text(facet)
			for filler in frames[cname][slot][facet]:
				var filler_editor = addFiller(facet_editor)
				filler_editor.set_text(filler)


func addSlot():
	var slot_editor = SlotEditor.instance()
	var button_add_facet = slot_editor.get_node("VBoxContainer/ButtonAddFacet")
	button_add_facet.connect("button_up", self, "_on_ButtonAddFacet_button_up", [slot_editor])
	frame_slots.add_child(slot_editor)
	return slot_editor


func addFacet(slot_editor):
	var facet_editor = FacetEditor.instance()
	var button_add_filler = facet_editor.get_node("VBoxContainer/ButtonAddFiller")
	button_add_filler.connect("button_up", self, "_on_ButtonAddFiller_button_up", [facet_editor])
	var frame_facets = slot_editor.get_node("VBoxContainer/VBoxContainerFacets")
	frame_facets.add_child(facet_editor)
	return facet_editor

func addFiller(facet_editor):
	var filler_lineedit = LineEdit.new()
	filler_lineedit.placeholder_text = "Expression"
	var frame_fillers = facet_editor.get_node("VBoxContainer/VBoxContainerFillers")
	frame_fillers.add_child(filler_lineedit)
	return filler_lineedit

func _on_ButtonSaveFrame_button_up():
	var cname = frame_name.get_text()
	if cname == "":
		return
	var frame_data = {}
	
	for slot in frame_slots.get_children():
		var slot_name = slot.get_node("VBoxContainer/SlotName").get_text()
		frame_data[slot_name] = {}
		for facet in slot.get_node("VBoxContainer/VBoxContainerFacets").get_children():
			var facet_name = facet.get_node("VBoxContainer/FacetName").get_text()
			frame_data[slot_name][facet_name] = []
			for filler in facet.get_node("VBoxContainer/VBoxContainerFillers").get_children():
				var filler_expression = filler.get_text()
				frame_data[slot_name][facet_name].append(filler_expression)
	
	frames[cname] = frame_data
	
	var file = File.new()
	file.open(json_path, File.WRITE)
	file.store_line(to_json(frames))
	file.close()
	
	refresh_tree()


func _on_ButtonNewFrame_button_up():
	frame_name.set_text("")
	for m in frame_slots.get_children():
		frame_slots.remove_child(m)


func _on_ButtonAddSlot_button_up():
	addSlot()


func _on_ButtonAddFacet_button_up(slot_editor):
	addFacet(slot_editor)


func _on_ButtonAddFiller_button_up(facet_editor):
	addFiller(facet_editor)


func _on_select_question(q, a):
	pass
