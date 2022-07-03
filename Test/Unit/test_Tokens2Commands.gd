extends 'res://addons/gut/test.gd'

## Tokens2Commands class
var Tokens2Commands = load("res://OpenOntoAgent/tokens2tmrs.gd")

## Tokens2Commands instance
var t2c

func before_each():
    t2c = Tokens2Commands.new()


func after_each():
    t2c.free()


func test_initialize():
    var tokens = [
        "NUT-FOODSTUFF",
        "INGEST",
        "SQUIRREL"
    ]
    var ground_truth = [
        "*ROOT*",
        "INGEST/AGENT",
        "INGEST/THEME"
    ]
    t2c.initialize(tokens)
    assert_eq(t2c.index, ground_truth)


func test_initialize_2():
    var tokens = [
        "INGEST",
        "WATCH-MEDIA"
    ]
    var ground_truth = [
        "*ROOT*",
        "INGEST/AGENT",
        "INGEST/THEME",
        "WATCH-MEDIA/AGENT",
        "WATCH-MEDIA/THEME"
    ]
    t2c.initialize(tokens)
    assert_eq(t2c.index, ground_truth)


func test_search():
    var tokens = [
        "NUT-FOODSTUFF",
        "INGEST",
        "SQUIRREL"
    ]
    var ground_truth = [
        "INGEST",
        "SQUIRREL",
        "NUT-FOODSTUFF"
    ]
    t2c.initialize(tokens)
    var solution = t2c.generate_commands()
    assert_eq(solution, ground_truth)
