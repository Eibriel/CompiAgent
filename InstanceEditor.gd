extends Control


onready var instance_list = $HSplitContainer/VBoxContainer/ItemList
onready var instance_code = $HSplitContainer/TextEdit
onready var button_add_instance = $HSplitContainer/VBoxContainer/ButtonAddInstance
onready var button_save_instance = $HSplitContainer/VBoxContainer/ButtonSaveInstance
onready var lineedit_instancename = $HSplitContainer/VBoxContainer/LineEditInstanceName

var json_path = "res://instances.json"

var instances

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
		instances = parse_json(text)
		file.close()
	else:
		instances = {}

# Read instances and fill instance_list
func _fill_instance_list():
	instance_list.clear()
	for instance_name in instances:
		instance_list.add_item(instance_name)

# Add instance to instances var
# get name from lineedit_instancename
func _add_instance():
	if lineedit_instancename.get_text() == "":
		return
	var instance_name = lineedit_instancename.get_text()
	instances[instance_name] = {}
	_fill_instance_list()

# Save instances var to json_path
func _save_instances():
	var file = File.new()
	file.open(json_path, File.WRITE)
	instances[lineedit_instancename.get_text()] = parse_json(instance_code.get_text())
	file.store_line(JSON.print(instances, "\t"))
	file.close()

func _on_ButtonAddInstance_button_up():
	_add_instance()

func _on_ButtonSaveInstance_button_up():
	_save_instances()

func _on_ItemList_item_selected(item: int):
	var instance_name = instance_list.get_item_text(item)
	instance_code.set_text(JSON.print(instances[instance_name], "\t"))
	lineedit_instancename.set_text(instance_name)
