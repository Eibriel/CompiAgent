extends 'res://addons/gut/test.gd'

## TabuSearch class
var TabuSearch = load("res://CompiAgent/utils/tabu_search.gd")

## TabuSearch instance
var ts

## Initial solution
var initial_solution = ["l", "o", " ", "l", "d", "h", "l", "e", "o", "r", "w"]

## Expected final solution
var ground_truth = ["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"]


## Return a value from a proposed solution
func get_value(solution) -> float:
	var value : float = 0.0
	for index in range(solution.size()):
		if solution[index] == ground_truth[index]:
			value += 1.0
	return value

## Get neighbor solutions from one solution
func get_neighborhood(elements):
	if randf() >= 0.5:
		return ts.swap_pair(elements)
	else:
		return ts.invert_position(elements)


func before_each():
	ts = TabuSearch.new()
	var get_value_function = funcref(self, "get_value")
	var get_neighborhood_function = funcref(self, "get_neighborhood")
	var tabu_table_size = initial_solution.size()
	ts.initialize(initial_solution, get_value_function, get_neighborhood_function, tabu_table_size)


func after_each():
	ts.free()


# Full test

func test_search():
	var solution = ts.search()
	assert_eq(solution, ground_truth)





## Test Swap Pair change
func test_swap_pair():
	var res = ts.swap_pair(["a", "b", "c", "d"])
	var solution = [
		["b", "a", "c", "d"],
		["a", "c", "b", "d"],
		["a", "b", "d", "c"],
	]
	assert_eq_deep(res, solution)


## Test Invert Position change
func test_invert_position():
	var res = ts.invert_position(["a", "b", "c", "d"])
	var solution = [
		["d", "b", "c", "a"],
		["a", "c", "b", "d"],
	]
	assert_eq_deep(res, solution)


## Test that the tabu list must be empty
func test_is_in_tabu_list():
	assert_false(ts.is_in_tabu_list_(["c", "b", "a"]))


## Test the values after reseting an iteration
func test_reset_iteration():
	ts.reset_iteration()
	assert_eq(ts.best_value_in_iteration, -999.0)
	assert_eq(ts.best_neighbor_in_iteration, -1)


func test_update_best_value():
	ts.reset_iteration()
	ts.neighborhood = [
		[],[],[],[]
	]
	ts.update_best_value(10, 3)
	assert_eq(ts.best_value_in_iteration, 10.0)
	assert_eq(ts.best_neighbor_in_iteration, 3)


func test_update_best_value_2():
	ts.reset_iteration()
	ts.neighborhood = [
		[],[],[],[]
	]
	ts.update_best_value(10, 3)
	ts.update_best_value(15, 2)
	assert_eq(ts.best_value_in_iteration, 15.0)
	assert_eq(ts.best_neighbor_in_iteration, 2)


func test_check_neighborhood():
	ts.reset_iteration()
	ts.neighborhood = [
		initial_solution,
		ground_truth
	]
	ts.check_neighborhood()
	assert_eq(ts.best_value_in_iteration, 11.0)
	assert_eq(ts.best_neighbor_in_iteration, 1)
	assert_eq(ts.best_value, 11.0)
	assert_eq(ts.best_solution, ground_truth)

func test_check_neighborhood_2():
	ts.reset_iteration()
	
	ts.best_value_in_iteration = 1.0
	ts.best_neighbor_in_iteration = 0
	ts.best_solution = initial_solution
	ts.best_value = 1.0
	
	var solution_2 = ["h", "e", "l", "o", " ", "l", "d", "l", "o", "r", "w"]
	ts.neighborhood = [
		initial_solution,
		solution_2
	]
	ts.check_neighborhood()
	assert_eq(ts.best_value, 3.0)
	assert_eq(ts.best_solution, solution_2)
