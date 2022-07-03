extends 'res://addons/gut/test.gd'

## ExclusionLogic class
var ExclusionLogic = load("res://OpenOntoAgent/utils/exclusion_logic/exclusion_logic.gd")

## ExclusionLogic instance
var el

func before_each():
    el = ExclusionLogic.new()


func after_each():
    el.free()


func test_new():
    var node = el.ExclusionLogicNode.new("a", ".")
    
    assert_eq(node.own_value, "a")
    assert_eq(node.own_label, ".")


func test_parse_expression():
    
    var r = el.parse_expression("a.b")
    var expected_result = [
        {"node": "a", "label": el.MANY_CHILDREN},
        {"node": "b", "label": null}
    ]
    assert_eq_deep(r, expected_result)
    #
    r = el.parse_expression("1d0f.v5d!100")
    expected_result = [
        {"node": "1d0f", "label": el.MANY_CHILDREN},
        {"node": "v5d", "label": el.ONE_CHILDREN},
        {"node": "100", "label": null}
    ]
    assert_eq_deep(r, expected_result)
    

func test_get_label_code():
    var r = el.get_label_code(".")
    assert_eq(r, el.MANY_CHILDREN)
    r = el.get_label_code("!")
    assert_eq(r, el.ONE_CHILDREN)
    r = el.get_label_code("")
    assert_eq(r, null)


func test_add():
    el.add("a.b")
    var child = el.root.get_child("a", el.MANY_CHILDREN)
    assert_eq(child.own_value, "a")
    assert_eq(child.own_label, el.MANY_CHILDREN)


func test_get_child():
    el.add("a.b")
    var child = el.root.get_child("a", el.MANY_CHILDREN)
    child = child.get_child("b", null)
    assert_eq(child.own_value, "b")
    assert_eq(child.own_label, null)


func test_truth():
    el.add("a.b")
    assert_true(el.truth("a.b"))
    assert_false(el.truth("a.c"))
    el.add("a.c")
    assert_true(el.truth("a.b"))
    assert_true(el.truth("a.c"))


func test_incompatibility_a():
    el.add("a.b")
    assert_true(el.truth("a.b"), "a.b -> true")
    el.add("a!c")
    assert_false(el.truth("a.b"), "a.b -> false")
    assert_true(el.truth("a!c"), "a!c -> true")


func test_incompatibility_b():
    el.add("a!b")
    assert_true(el.truth("a!b"), "a!b -> true")
    el.add("a.c")
    assert_true(el.truth("a.c"), "a.c -> true")
    assert_false(el.truth("a!b"), "a!b -> false")
    assert_false(el.truth("a!c"), "a!c -> false")

func test_incompatibility_c():
    el.add("a!b")
    assert_true(el.truth("a!b"), "a!b -> true")
    el.add("a!c")
    assert_false(el.truth("a!b"), "a!b -> false")
    assert_true(el.truth("a!c"), "a!c -> true")
