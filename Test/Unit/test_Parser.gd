extends 'res://addons/gut/test.gd'

## Parser class
var Parser = load("res://CompiAgent/utils/parser/parser.gd")

## Parser instance
var p

func before_each():
	p = Parser.new()


func after_each():
	p.free()


func test_string():
	var parser = p.build_parser("str", ["hello"])
	p.add_parser(parser)
	var result = p.run("hello word")
	var expected_result = {
		"index":5,
		"result":"hello",
		"targetString":"hello word",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_string_error():
	var parser = p.build_parser("str", ["hello"])
	p.add_parser(parser)
	var result = p.run("")
	var expected_result = {
		"index":0,
		"result":null,
		"targetString":"",
		"isError": true,
		"error": "str: Unexpected end of string"
	}
	assert_eq_deep(result, expected_result)


func test_string_map():
	var parser = p.build_parser("str", ["hello"])
	parser = p.add_function(parser, "map", funcref(self, "toUpper"))
	p.add_parser(parser)
	var result = p.run("hello world")
	var expected_result = {
		"index":5,
		"result":"HELLO",
		"targetString":"hello world",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_string_error_map():
	var parser = p.build_parser("str", ["hello"])
	parser = p.add_function(parser, "error_map", funcref(self, "errorPlus"))
	p.add_parser(parser)
	var result = p.run("")
	var expected_result = {
		"index":0,
		"result":null,
		"targetString":"",
		"isError": true,
		"error": "str: Unexpected end of string0"
	}
	assert_eq_deep(result, expected_result)


func test_letters():
	var parser = p.build_parser("letters")
	p.add_parser(parser)
	var result = p.run("hello123456")
	var expected_result = {
		"index":5,
		"result":"hello",
		"targetString":"hello123456",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_digits():
	var parser = p.build_parser("digits")
	p.add_parser(parser)
	var result = p.run("123456hello")
	var expected_result = {
		"index":6,
		"result":"123456",
		"targetString":"123456hello",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_sequenceOf():
	var parser = p.build_parser("sequenceOf", [
		p.build_parser("str", ["hello"]),
		p.build_parser("str", ["goodbay"]) 
	])
	p.add_parser(parser)
	var result = p.run("hellogoodbay")
	var expected_result = {
		"index":12,
		"result":["hello","goodbay"],
		"targetString":"hellogoodbay",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_choice():
	var parser = p.build_parser("choice", [
		p.build_parser("str", ["hello"]),
		p.build_parser("str", ["goodbay"]) 
	])
	p.add_parser(parser)
	var result = p.run("goodbay")
	var expected_result = {
		"index":7,
		"result":"goodbay",
		"targetString":"goodbay",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_many():
	var parser = p.build_parser(
					"many",
					[p.build_parser("str", ["hello"])]
				)
	p.add_parser(parser)
	var result = p.run("hellohellohello")
	var expected_result = {
		"index":15,
		"result":["hello", "hello", "hello"],
		"targetString":"hellohellohello",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_between():
	var parser = p.build_parser(
					"between",
					[
						p.build_parser("str", ["("]),
						p.build_parser("str", ["hello"]),
						p.build_parser("str", [")"]),
					]
				)
	p.add_parser(parser)
	var result = p.run("(hello)")
	var expected_result = {
		"index":7,
		"result":"hello",
		"targetString":"(hello)",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_betweenBrackets():
	var parser = p.build_parser(
					"betweenBrackets",
					[p.build_parser("str", ["hello"])]
				)
	p.add_parser(parser)
	var result = p.run("(hello)")
	var expected_result = {
		"index":7,
		"result":"hello",
		"targetString":"(hello)",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_chain():
	var parser = p.build_parser("str", ["123"])
	parser = p.add_function(parser, "chain", "digits")
	p.add_parser(parser)
	var result = p.run("12354")
	var expected_result = {
		"index":5,
		"result":"54",
		"targetString":"12354",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_sepBy():
	var parser = p.build_parser(
					"sepBy",
					[
						p.build_parser("digits"),
						p.build_parser("str", [","])
					]
				)

	p.add_parser(parser)
	var result = p.run("1,2,3,4,5")
	var expected_result = {
		"index":9,
		"result":["1","2","3","4","5"],
		"targetString":"1,2,3,4,5",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)


func test_recursion():
	var digitsParser = p.build_parser("digits")
	var commaParser = p.build_parser("str", [","])
	var choiceParser = p.build_parser("choice", [digitsParser, "recursive_array"])
	var sepByCommaParser = p.build_parser("sepBy", [choiceParser, commaParser])

	var parser = p.build_parser(
					"betweenBrackets",
					[sepByCommaParser],
					"recursive_array"
				)
	
	p.add_parser(parser)
	var result = p.run("(1,(2,(3),4),5)")
	var expected_result = {
		"index":15,
		"result":["1",["2",["3"],"4"],"5"],
		"targetString":"(1,(2,(3),4),5)",
		"isError": false,
		"error": null
	}
	assert_eq_deep(result, expected_result)
	
###

func toUpper(currentState):
	var nextState = currentState.duplicate()
	nextState.result = currentState.result.to_upper()
	return nextState

func errorPlus(currentState, index: int):
	var nextState = currentState.duplicate()
	nextState.error = currentState.error + String(index)
	return nextState
