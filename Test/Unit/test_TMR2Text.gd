extends 'res://addons/gut/test.gd'

## TMR2Text class
var TMR2Text = load("res://CompiAgent/tmr2text.gd")

## TMR2Text instance
var t2t

func before_each():
	t2t = TMR2Text.new()


func after_each():
	t2t.free()


func test_realizate():
	return
	var tmr = {
		"ROOT": "INGEST",
		"INGEST": {
			"THEME": "WATER",
			"AGENT": "I"
		}
	}
	var text = t2t.realizate(tmr, "EN")
	var expected_text = "I ingest water"
	assert_eq(text, expected_text)
