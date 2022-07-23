extends Control

onready var lineedit_namespace = $VBoxContainer/LineEditNamespace
onready var lineedit_root = $VBoxContainer/LineEditRoot
onready var lineedit_relation = $VBoxContainer/LineEditRelation

onready var frames_tree = $VBoxContainer/VSplitContainer/HSplitContainer/Tree
onready var frame_edit = $VBoxContainer/VSplitContainer/HSplitContainer/RichTextLabel
onready var frame_slots = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ScrollContainer/VBoxContainerSlots
onready var frame_name = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/LineEditName
onready var button_save_frame = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonSaveFrame
onready var button_new_frame = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonNewFrame
onready var button_add_slot = $VBoxContainer/VSplitContainer/HSplitContainer/VBoxContainer/ButtonAddSlot

var FacetEditor = load("res://modules/facet_editor.tscn")
var SlotEditor = load("res://modules/slot_editor.tscn")

var json_path = "res://frames.json"

var onto = CompiAgent.frames
		
# Called when the node enters the scene tree for the first time.
func _ready():
	
	frames_tree.connect("cell_selected", self, "_on_Tree_cell_selected", [])
	button_new_frame.connect("button_up", self, "_on_ButtonNewFrame_button_up", [])
	button_save_frame.connect("button_up", self, "_on_ButtonSaveFrame_button_up", [])
	button_add_slot.connect("button_up", self, "_on_ButtonAddSlot_button_up", [])
	
	lineedit_namespace.connect("text_changed", self, "_on_LineEditNamespace_text_changed", [])
	lineedit_root.connect("text_changed", self, "_on_LineEditRoot_text_changed", [])
	lineedit_relation.connect("text_changed", self, "_on_LineEditRelation_text_changed", [])
	
	var file = File.new()
	
	if file.file_exists(json_path):
		file.open(json_path, File.READ)
		var text = file.get_as_text()
		var frames = parse_json(text)
		file.close()
		onto.load_from_dictionary(frames)
	
	refresh_tree()


func add_item_to_tree(tree, root, frame_name):
	# Create item on tree for frame_name
	var frame_item = tree.create_item(root)
	frame_item.set_text(0, frame_name)

	# Get all frame names
	var frames_names = onto.get_frames_names()

	for id in frames_names:
		# Get is-a elements for id
		var is_a_related = onto.get_related(id, lineedit_relation.get_text())
		if not is_a_related:
			continue
		if lineedit_namespace.get_text() != "" and not id.begins_with(lineedit_namespace.get_text()):
				continue
		# If frame_name in is-a
		# add to tree as child of frame_item
		if is_a_related.get_fillers(false).has(frame_name):
			add_item_to_tree(tree, frame_item, id)


func refresh_tree():
	frames_tree.clear()
	var root_frame = frames_tree.create_item()
	frames_tree.set_hide_root(true)
	
	if lineedit_root.get_text() == "" or lineedit_relation.get_text() == "":
		var frames_names = onto.get_frames_names()
		for id in frames_names:
			if lineedit_namespace.get_text() != "" and not id.begins_with(lineedit_namespace.get_text()):
				continue
			add_item_to_tree(frames_tree, root_frame, id)
	else:
		add_item_to_tree(frames_tree, root_frame, lineedit_root.get_text())


func _on_Tree_cell_selected():
	
	print(frames_tree.get_selected().get_text(0))
	var cname = frames_tree.get_selected().get_text(0)
	display_info(cname)


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

func _on_ButtonSaveFrame_button_up():
	var fname = frame_name.get_text()
	if fname == "":
		return
	
	onto.erase_frame(fname)
	onto.add_frame(fname)
	
	for slot in frame_slots.get_children():
		var slot_name = slot.get_node("SlotName").get_text()
		for facet in slot.get_node("VBoxContainerFacets").get_children():
			var facet_name = facet.get_node("FacetName").get_text()
			for filler in facet.get_node("VBoxContainerFillers").get_children():
				var filler_expression = filler.get_text()
				onto.get_frame(fname).addFiller(slot_name, facet_name, filler_expression)
	
	var onto_dict = onto.turn_into_dictionary()
	
	var file = File.new()
	file.open(json_path, File.WRITE)
	file.store_line(JSON.print(onto_dict, "\t"))
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


func _on_LineEditNamespace_text_changed(text):
	refresh_tree()

func _on_LineEditRoot_text_changed(text):
	refresh_tree()
	
func _on_LineEditRelation_text_changed(text):
	refresh_tree()
