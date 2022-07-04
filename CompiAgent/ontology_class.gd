####
# Class to handle frame structures
####

# A slot is a named set of facets.
# A facet is a named set of views and
# a view is a named set of fillers.
# A filler can be any symbol or a Lisp function call.

# A filler is as follows. It can be a string, a symbol,
# a number, or a (numerical or symbolic) range.
# Strings are typically used as fillers (of value facets) of
# “service” slots representing user-oriented,
# non-ontological properties of a frame, 
# such as DEFINITION or TIME-STAMP.
# A symbol in a filler can be an ontological frame.

# frame = frame "INGEST"
# property = slot "AGENT"
# subproperty? = facet "sem"
# ? = view
# data = filler  "HUMAN"

var frames = {}

class Facet:
	var name = ""
	var fillers = {}
	
	func _init(_name):
		name = _name

	func add_filler(_name, value):
		# TODO Should append to a list
		# TODO if present, return error
		fillers[_name] = value
	
	func erase_filler(_name, comparison_mode):
		# TODO
		pass
	
	func first_filler(inherit):
		# TODO
		# Retrieve the first filler for the given slot and facet.
		# if inherit is False, the value (FrList *)0 will
		# be returned if there are no fillers for the facet in the given frame;
		# otherwise, if there are no fillers, FramepaC
		# attempts to retrieve the first inherited filler.
		pass
	
	func get_fillers(inherit):
		pass
	
	func get_filler(_name):
		return fillers[_name]


class Slot:
	var name = ""
	var facets = {}
	
	func _init(_name):
		name = _name
	
	func add_facet(facet):
		# TODO if present, return error
		facets[facet.name] = facet
		"""
		# Set Inverse
		# Check if has inverse
		var relation_frame = onto.get_frame(facet.name)
		if relation_frame == null:
			return
		var inverse_facet = relation_frame.get_facet("INVERSE")
		if inverse_facet == null:
			return
		# Get the inverse frame
		var inverse_name = inverse_facet.get_filler("sem")
		var apply_inverse_to = facet.get_filler("value")
		var add_inverse_to_frame = onto.get_frame(apply_inverse_to)
		# Add facet to inverse frame
		var new_facet = onto.Facet.new(inverse_name)
		new_facet.add_filler("value", name)
		add_inverse_to_frame.add_facet(new_facet)
		"""
	
	func erase_facet(facet_name, comparison_mode):
		# TODO
		# Call the indicated function once for each nonempty facet in the given slot.
		pass
	
	func get_facet(facet_name):
		if not facets.has(facet_name):
			return
		return facets[facet_name]
	
	func do_facets(function):
		pass


class Frame:
	var name = ""
	var slots = {}

	func _init(_name):
		name = _name

	func add_slot(slot_id):
		var c = Slot.new(slot_id)
		slots[slot_id] = c
		return c
	
	func get_slot(slot_name):
		if not slots.has(slot_name):
			return false
		return slots[slot_name]
		
	func addFiller(slotname, facetname, filler):
		pass
	
	func addFillers(slotname, facetname, fillers):
		pass
	
	func addSem(slotname, facetname, fillers):
		pass
	
	func addSems(slotname, facetname, fillers):
		pass
	
	func addValue(slotname, facetname, fillers):
		pass
	
	func addValues(slotname, facetname, fillers):
		pass
	
	func collectSlots(inherit, allslots):
		# get inherited slots and facets
		pass
	
	func createSlot(inherit, allslots):
		# get inherited slots and facets
		pass



func add_frame(frame_id):
	var f = Frame.new(frame_id)
	frames[frame_id] = f
	return f

func erase_frame(frame_if):
	# TODO
	pass

func erase_slot(frame_id, comparison_mode):
	# TODO
	# Delete all fillers from all facets of the specified slot.
	pass

func do_slots(function):
	# Call the indicated function once for each slot in the given frame. Returns True if all invocations of the
	# function returned True, False if any of them returned False (in which case no further slots are
	# processed)
	pass

func do_all_facets(function):
	# Call the indicated function once for each nonempty facet in the given frame
	pass

func get_frame(frame_id):
	if not frames.has(frame_id):
		return null
	return frames[frame_id]

func doAllFrames(function):
	# Invoke the specified function for each frame which is currently instantiated for the active symbol table
	pass

func inheritable_slots(inherit):
	# TODO
	# Determine (finds) which slots and facets the given frame
	# may inherit from one or more of its ancestors
	# using the indicated inheritance method.
	# Returns slots with available facets
	pass

func inherit_all_fillers(inherit):
	# TODO
	# Finds all inheritable fillers and places them locally
	pass

func get_related(frame_id, relation_id):
	var relation = get_frame(relation_id)
	var frame = get_frame(frame_id)
	
	if relation == null or frame == null:
		return null
	
	return frame.get_facet(relation_id).get_filler("value")

func is_a_p(frame, possible_parent):
	# is ancestor of? true false
	pass

func part_of_p(frame, possible_container):
	# is part of? true false
	pass
