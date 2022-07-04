extends Node

var tabu_size : int
var solution = []
var get_value : FuncRef
var get_neighborhood : FuncRef

var neighborhood = []
var tabu_list = []

var best_neighbor_in_iteration : int
var best_value_in_iteration : float
var best_value : float
var best_solution = []

func initialize(initial_solution, get_value_function, get_neighborhood_function, tabu_table_size):
    solution = initial_solution
    get_value = get_value_function
    get_neighborhood = get_neighborhood_function
    tabu_size = tabu_table_size
    

func search(iterations=1500):
    var iteration = 0
    while iteration < iterations:
        iteration += 1
        reset_iteration()
        populate_neighborhood()
        check_neighborhood()
        update_tabu_list()
        set_new_solution()
    return best_solution


func reset_iteration():
    best_value_in_iteration = -999.0
    best_neighbor_in_iteration = -1


func populate_neighborhood():
    neighborhood = get_neighborhood.call_func(solution)    


func check_neighborhood():
    for neighbor in range(neighborhood.size()):
        var value = get_value.call_func(neighborhood[neighbor])
        update_best_value(value, neighbor)


func update_best_value(value, neighbor):
    if value > best_value_in_iteration:
        if not is_in_tabu_list(neighbor):
            best_value_in_iteration = value
            best_neighbor_in_iteration = neighbor
    
    if value > best_value:
        print("New best solution found: ", neighborhood[neighbor])
        print("value ", value)
        best_value = value
        best_solution = neighborhood[neighbor]


func set_new_solution():
    if best_neighbor_in_iteration != -1:
        solution = neighborhood[best_neighbor_in_iteration]


func update_tabu_list():
    if best_neighbor_in_iteration != -1:
        add_to_tabu_list(neighborhood[best_neighbor_in_iteration])


func add_to_tabu_list(neighbor):
    if tabu_list.has(neighbor):
        return
    tabu_list.append(neighbor)
    if tabu_list.size() > tabu_size:
        tabu_list = tabu_list.slice(1, tabu_list.size())


func is_in_tabu_list(neighbor) -> bool:
    return is_in_tabu_list_(neighborhood[neighbor])


func is_in_tabu_list_(neighbor) -> bool:
    return tabu_list.has(neighbor)



# Changes

# Invert by next pairs (0-1,1-2,2-3)
func swap_pair(elements):
    var neighborgs = []
    for i in range(elements.size()-1):
        var new_elements = elements.duplicate()
        var tmp = new_elements[i]
        new_elements[i] = new_elements[i+1]
        new_elements[i+1] = tmp
        neighborgs.append(new_elements)
    return neighborgs

# Invert by mirror pairs (0-3,1-2,2-1,3-0)
func invert_position(elements):
    var neighborgs = []
    for i in range(elements.size()):
        var new_elements = elements.duplicate()
        var tmp = new_elements[i]
        new_elements[i] = new_elements[new_elements.size()-i-1]
        new_elements[new_elements.size()-i-1] = tmp
        if not neighborgs.has(new_elements):
            neighborgs.append(new_elements)
    return neighborgs
