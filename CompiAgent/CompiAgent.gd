extends Node2D

var Frames = load("res://CompiAgent/frames.gd")

var frames = Frames.new()

func buildTMR(concepts):
	var onto_dict = frames.turn_into_dictionary()
	var tmr_dict = {}
	for c in concepts:
		tmr_dict[c] = onto_dict[c]
	return tmr_dict

func createInstance(concept_name):
	if not concept_name.begins_with("onto."):
		return
	var new_name
	var number = 1
	while true:
		new_name = "env." + concept_name.substr(5) + "." + String(number)
		if not frames.get_frame(new_name):
			break
		number += 1
	frames.copy_frame(concept_name, new_name)
	
	# Clean up
	var instance_frame = frames.get_frame(new_name)
	instance_frame.remove_slot("*.is-a")
	instance_frame.remove_slot("*.description")
	
	instance_frame.addFiller("*.instance-of", "value", concept_name)
	
	return new_name
