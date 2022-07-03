extends 'res://addons/gut/test.gd'

## Ontology class
var Ontology = load("res://OpenOntoAgent/ontology_class.gd")

## Ontology instance
var onto

func before_each():
	onto = Ontology.new()


func after_each():
	#onto.free()
	pass


func test_add_frame():
	var expected_text = "TEST-CONCEPT"
	var concept = onto.add_frame(expected_text)
	assert_eq(concept.name, expected_text)


func test_get_frame():
	var expected_text = "TEST-CONCEPT"
	onto.add_frame(expected_text)
	var frame = onto.get_frame(expected_text)
	assert_eq(frame.name, expected_text)


func test_get_nonexistent_frame():
	var frame = onto.get_frame("")
	assert_null(frame)

"""
func test_add_frame():
	var expected_text = "TEST-PROPERTY"
	var slot = onto.add_frame(expected_text)
	assert_eq(slot.name, expected_text)
"""

func test_add_slot():
	var expected_text = "TEST-SLOT"
	
	var frame = onto.add_frame("TEST-PROPERTY")
	
	frame.add_slot(expected_text)
	assert_eq(frame.get_slot(expected_text).name, expected_text)

"""
func test_direct_relation():
	# if "DOMAIN" is present, is a relation
	var frame_is_a = onto.add_frame("IS-A")
	var slot_domain = onto.Slot.new("DOMAIN")
	slot_domain.add_filler("sem", "ALL")
	frame_is_a.add_facet(slot_domain)
	var slot_inverse = onto.Slot.new("INVERSE")
	slot_inverse.add_filler("sem", "SUBCLASSES")
	frame_is_a.add_facet(slot_inverse)
	
	var frame_all = onto.add_frame("ALL")
	
	var frame_object = onto.add_frame("OBJECT")
	var slot_is_a = onto.Slot.new("IS-A")
	slot_is_a.add_filler("value", "ALL")
	frame_object.add_facet(slot_is_a)
	
	var related = onto.get_related("OBJECT", "IS-A")
	assert_eq(related, "ALL")


func test_inverse_relation():
	# if "DOMAIN" is present, is a relation
	var frame_is_a = onto.add_frame("IS-A")
	var slot_domain = onto.Slot.new("DOMAIN")
	slot_domain.add_facet("sem") #, "ALL")
	frame_is_a.add_slot(slot_domain)
	var slot_inverse = onto.Slot.new("INVERSE")
	slot_inverse.add_facet("sem") #, "SUBCLASSES")
	frame_is_a.add_slot(slot_inverse)
	
	var concept_subclasses = onto.add_frame("SUBCLASSES")
	
	var frame_all = onto.add_frame("ALL")
	
	var frame_object = onto.add_frame("OBJECT")
	var slot_is_a = onto.Slot.new("IS-A")
	slot_is_a.add_facet("value") # , "ALL")
	frame_object.add_slot(slot_is_a)
	
	var related = onto.get_related("ALL", "SUBCLASSES")
	assert_eq(related, "OBJECT")


# This is not a test really
func test_add_full_concept():
	return
	var frame_is_a = onto.add_frame("IS-A")
	
	var slot_domain = onto.Slot.new("DOMAIN")
	frame_is_a.add_slot(slot_domain)
	slot_domain.add_facet("sem") # , "*all")
	
	var slot_range = onto.Facet.new("RANGE")
	frame_is_a.add_facet(slot_range)
	slot_range.add_facet("sem") #, "*all")
	
	#
	
	var concept_agent = onto.add_frame("AGENT")
	
	var facet_is_a = onto.Facet.new("IS-A")
	concept_agent.add_facet(facet_is_a)
	facet_is_a.add_filler("value", "*case-role")
	
	var facet_domain2 = onto.Facet.new("DOMAIN")
	concept_agent.add_facet(facet_domain2)
	facet_domain2.add_filler("sem", "*all")
	
	var facet_relation_range = onto.Facet.new("RELATION-RANGE")
	concept_agent.add_facet(facet_relation_range)
	facet_relation_range.add_filler("sem", "*animal *force")
	facet_relation_range.add_filler("default", "*intentional-agent")
	
"""
