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
	var fillers = []
	
	func _init(_name):
		name = _name

	func add_filler(value):
		if fillers.has(value):
			return
		else:
			fillers.append(value)
	
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
		# TODO use inherit
		return fillers
	
	func get_filler(_name):
		return fillers[_name]


class Slot:
	var name = ""
	var facets = {}
	
	func _init(_name):
		name = _name
	
	func add_facet(facet_name):
		var f = get_facet(facet_name)
		if f:
			return f
		f = Facet.new(facet_name)
		facets[facet_name] = f
		return f
	
	func erase_facet(facet_name, comparison_mode):
		# TODO
		# Call the indicated function once for each nonempty facet in the given slot.
		pass
	
	func get_facet(facet_name):
		if not facets.has(facet_name):
			return
		return facets[facet_name]
	
	func get_facet_names():
		return facets.keys()
	
	func do_facets(function):
		pass


class Frame:
	var name = ""
	var slots = {}

	func _init(_name):
		name = _name

	func add_slot(slot_name):
		var s = get_slot(slot_name)
		if s:
			return s
		s = Slot.new(slot_name)
		slots[slot_name] = s
		return s
	
	func get_slot(slot_name):
		if not slots.has(slot_name):
			return false
		return slots[slot_name]
	
	func get_slot_names():
		return slots.keys()
	
	func addFiller(slotname, facetname, filler):
		var s = add_slot(slotname)
		var f = s.add_facet(facetname)
		f.add_filler(filler)
	
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
		# 
		pass



func add_frame(frame_name):
	var f = Frame.new(frame_name)
	frames[frame_name] = f
	return f

func erase_frame(frame_name):
	frames.erase(frame_name)

func erase_slot(frame_name, comparison_mode):
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
	if frame.get_slot(relation_id):
		return frame.get_slot(relation_id).get_facet("value")
	else:
		return false

func is_a_p(frame, possible_parent):
	# is ancestor of? true false
	pass

func part_of_p(frame, possible_container):
	# is part of? true false
	pass

func get_frame_by_id(id):
	return frames[id]

func get_frames_names():
	return frames.keys()

func load_from_dictionary(json_data):
	for frame in json_data:
		var f = add_frame(frame)
		for slot in json_data[frame]:
			for facet in json_data[frame][slot]:
				for filler in json_data[frame][slot][facet]:
					# TODO use addFillers
					f.addFiller(slot, facet, filler)

func turn_into_dictionary():
	var frames_data = {}
	for frame_name in get_frames_names():
		frames_data[frame_name] = {}
		var frame = get_frame(frame_name)
		for slot_name in frame.get_slot_names():
			frames_data[frame_name][slot_name] = {}
			var slot = frame.get_slot(slot_name)
			for facet_name in slot.get_facet_names():
				var facet = slot.get_facet(facet_name)
				frames_data[frame_name][slot_name][facet_name] = facet.get_fillers(false)
	return frames_data

