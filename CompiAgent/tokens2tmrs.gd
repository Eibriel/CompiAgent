extends Node

## Concepts database
var Concepts = load("res://CompiAgent/concepts.gd")

## Concepts instance
var concepts = Concepts.new()

## TabuSearch class
var TabuSearch = load("res://CompiAgent/utils/tabu_search.gd")

## TabuSearch instance
var ts = TabuSearch.new()

var tokens = []
var index = ["*ROOT*"]

var solution = []


func _exit_tree():
	concepts.free()
	ts.free()


func initialize(selected_tokens):
	if ts:
		ts.free()
	ts = TabuSearch.new()
	tokens = selected_tokens
	random_solution()


func generate_commands():
	var get_value_function = funcref(self, "get_value")
	var get_neighborhood_function = funcref(self, "get_neighborhood")
	var tabu_table_size = 10
	
	ts.initialize(solution, get_value_function, get_neighborhood_function, tabu_table_size)
	return ts.search()


func get_neighborhood(elements):
	if randf() >= 0.5:
		return ts.swap_pair(elements)
	else:
		return ts.invert_position(elements)


func random_solution():
	solution = []
	# var keywords = ["SEM", "RELAXABLE-TO", "NOT"]
	var token_idx = 0
	for token in tokens:
		for property in concepts.concepts[token]:
			## TYPE_OBJECT == 18
			if typeof (concepts.concepts[token][property]) != 18:
				if not solution.has(tokens[token_idx]):
					solution.append(tokens[token_idx])
			else:
				index.append(token+"/"+property)
				if not solution.has(tokens[token_idx]):
					solution.append(tokens[token_idx])
		token_idx += 1
	for i in range(solution.size()-index.size()):
		index.append("*")


func concept_distance(concept1, concept2) -> float:
	var distance : float = 0.0
	for i in range(500):
		if concept1 == concept2:
			return distance
		if not concepts.concepts.has(concept1) or concept1 == "ROOT":
			return -1.0
		if concepts.concepts[concept1].has("IS-A"):
			distance += 1.0
			concept1 = concepts.concepts[concept1]["IS-A"]
		else:
			return distance
	return -1.0


func get_value(proposed_solution) -> float:
	var value : float = 0.0
	for idx in range(index.size()):
		if idx >= proposed_solution.size():
			break
		if proposed_solution[idx] == "":
			continue
		var keys = index[idx].split("/")
		if keys.size() < 2:
			continue
		# If the proposed concept is
		# the parent concept, decrease value
		var token = keys[0]
		var property = keys[1]
		if proposed_solution[idx] == token:
			value -= 5.0
		var afinity_array = concepts.concepts[token][property]
		for afinity in afinity_array:
			for concept in afinity_array[afinity]:
				var distance = concept_distance(concept, proposed_solution[idx])
				if distance == -1:
					# TODO not sure if this is needed
					distance = concept_distance(proposed_solution[idx], concept)
				if distance != -1:
					match afinity:
						"SEM":
							value += 3.0 / (distance+1.0)
						"RELAXABLE-TO":
							value += 2.0 / (distance+1.0)
						"NOT":
							value -= 3.0 / (distance+1.0)
		
	return value
