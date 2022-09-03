extends Control

onready var button_add_instance_node = $"%ButtonAddInstanceNode"
onready var button_add_setattribute_node = $"%ButtonAddSetAttributeNode"
onready var button_add_realize_node = $"%ButtonAddRealizeNode"
onready var button_add_string_node = $"%ButtonAddStringNode"
onready var button_add_instance_input = $"%ButtonAddInstanceInput"
onready var button_add_string_input = $"%ButtonAddStringInput"
onready var tmr_graph_edit = $"%TMRGraphEdit"

var graph_node_instance = preload("res://modules/GraphNodeInstance.tscn")
var graph_node_setattribute = preload("res://modules/GraphNodeSetAttribute.tscn")
var graph_node_realize = preload("res://modules/GraphNodeRealize.tscn")
var graph_node_string = preload("res://modules/GraphNodeString.tscn")

var nodes = []

var instance_list = {
	"ingest.1": ["theme", "agent"],
	"apple.1": ["color"],
	"human.1": ["name"]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	button_add_instance_node.connect("button_up", self, "_on_button_add_node", ["instance"])
	button_add_setattribute_node.connect("button_up", self, "_on_button_add_node", ["setattribute"])
	button_add_realize_node.connect("button_up", self, "_on_button_add_node", ["realize"])
	button_add_string_node.connect("button_up", self, "_on_button_add_node", ["string"])
	
	button_add_instance_input.connect("button_up", self, "_on_button_add_slot", ["instance"])
	button_add_string_input.connect("button_up", self, "_on_button_add_slot", ["string"])
	
	tmr_graph_edit.connect("connection_request", self, "_on_connection_request", [])
	tmr_graph_edit.connect("disconnection_request", self, "_on_disconnection_request", [])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_button_add_node(node_type):
	var new_node
	match(node_type):
		"instance":
			new_node = graph_node_instance.instance()
			# new_node.add_color_override("title_color", Color.aqua)
			var menu: OptionButton = new_node.get_node("OptionButton")
			for i in range(instance_list.keys().size()):
				menu.add_item(instance_list.keys()[i], i)
		"setattribute":
			new_node = graph_node_setattribute.instance()
		"realize":
			new_node = graph_node_realize.instance()
		"string":
			new_node = graph_node_string.instance()
	
	nodes.append(new_node)
	
	tmr_graph_edit.add_child(new_node)

func _on_button_add_slot(slot_type):
	for node in nodes:
		if node.selected:
			print(node)
			var l = LineEdit.new()
			l.text = "Attribute"
			node.add_child(l)
			var c = node.get_child_count()
			match(slot_type):
				"instance":
					node.set_slot(c-1, true, 0, Color.red, false, 0, Color.aqua)
				"string":
					node.set_slot(c-1, true, 1, Color.white, false, 1, Color.white)
			var menu: OptionButton = node.get_node("OptionButton")
			var instance_id: String = menu.get_item_text(menu.selected)
			if c-2 < instance_list[instance_id].size():
				l.text = instance_list[instance_id][c-2]

func _on_connection_request(from, from_slot, to, to_slot):
	tmr_graph_edit.connect_node(from, from_slot, to, to_slot)

func _on_disconnection_request(from, from_slot, to, to_slot):
	tmr_graph_edit.disconnect_node(from, from_slot, to, to_slot)

