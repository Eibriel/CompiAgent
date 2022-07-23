extends Node


func permutations(concepts):
	if concepts.size() == 1:
		return [concepts]
	var result = []
	for i in range(0, concepts.size()):
		var concept = [concepts[i]]
		var first_part = []
		var second_part = []
		if i > 0:
			first_part = concepts.slice(0, i-1)
		second_part = concepts.slice(i + 1, concepts.size())
		var remainingConcepts = first_part + second_part
		for permutation in permutations(remainingConcepts):
			result.append(concept + permutation)
	return result
