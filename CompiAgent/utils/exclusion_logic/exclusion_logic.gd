extends Node

const ONE_CHILDREN = 0
const MANY_CHILDREN = 1

var labels = {
    "!": ONE_CHILDREN,
    ".": MANY_CHILDREN
}

var root = ExclusionLogicNode.new("ROOT", 1)

# LRT labeled rooted tree
var lrt_vertices = []
var lrt_edges = {}
var lrt_vlabels = {}
var lrt_elabels = {}
var lrt_root


class ExclusionLogicNode:
    var childs = []
    var child_labels = []
    var parent
    var own_label
    var own_value
    
    
    func _init(value, label):
        own_value = value
        own_label = label
    
    
    func add_child(child, label):
        if not label in [ONE_CHILDREN, MANY_CHILDREN]:
            return false
        
        if own_label == ONE_CHILDREN and childs.size() > 0:
            childs = []
        
        child.set_parent(self)
        childs.append(child)
        child_labels.append(label)
        return true
    
    
    func remove_child(child):
        childs.erase(child)
    
    
    func get_child(value, label):
        for c in childs:
            
            if c.own_value == value and (c.own_label == label or label == -1):
                return c
    
    func set_parent(parent_):
        parent = parent_


func get_label_code(string):
    if not string in labels:
        return
    else:
        return labels[string]


func parse_expression(expression):
    var nodes=[]
    var regex = RegEx.new()
    regex.compile("(?<node>[a-z0-9]+)(?<label>\\.|\\!)?")
    for result in regex.search_all(expression):
        nodes.append(
            {
                "node": result.get_string("node"),
                "label": get_label_code(result.get_string("label"))
            }
        )
    return nodes
        

func add(expression):
    var parsed = parse_expression(expression)
    var current_node = root
    var previous_node = root
    var previous_label = root.own_label
    for n in parsed:
        var child = current_node.get_child(n.node, n.label)
        if child:
            current_node = child
        else:
            var old_child = current_node.get_child(n.node, -1)
            if old_child:
                old_child.parent.remove_child(old_child)
            current_node = ExclusionLogicNode.new(n.node, n.label)
        current_node.set_parent(previous_node)
        previous_node.add_child(current_node, previous_label)
        previous_node = current_node
        previous_label = current_node.own_label


func truth(expression):
    var parsed = parse_expression(expression)
    var current_node = root
    for n in parsed:
        current_node = current_node.get_child(n.node, n.label)
        if not current_node:
            return false
    return true
