extends Node2D

var configurations = [
	"B",
	"C",
	"D",
	"F",
	"G",
	"H",
	"J",
	"K",
	"L",
	"M"
]

var configurations_b = [
	"a",
	"e",
	"i",
	"o"
]

onready var label = $Label
onready var hand_sprite = $HandSprite
onready var hand_sprite_preview = $HandSpritePreview
onready var hand_handle = $Character/Pirate_B_workaround/RightHandHandle
onready var hand_rotation = $Character/Pirate_B_workaround/RightHandHandle/RightHandRotation
onready var hand_target = $Character/Pirate_B_workaround/RightHandHandle/RightHandRotation/RightHandTarget
onready var previous_handle = $Character/Pirate_B_workaround/CSGBox
onready var hand_collision = $Character/Area

var hand_selector_initial_position: Vector2 = Vector2()
var desired_hand_position: Vector2 = Vector2(646, 200)
var desired_hand_position_3d: Vector3
var desired_hand_rotation: float = 0
var previous_position = Vector2(646, 200)
var previous_position_3d: Vector3
var follow = false
var selected_cid = 0
var selected_rid = 0
var cid = 0
var rid = 0
var tid = 0
var finger_selector = -1
var is_signing = false
var first_configuration = false

var hand_textures = []

var hand_rects = [
	Rect2(Vector2(521, 3), Vector2(84, 105)), # 2
	Rect2(Vector2(509, 198), Vector2(112, 119)), # 5
	Rect2(Vector2(310, 0), Vector2(93, 112)), # 1
	Rect2(Vector2(99, 199), Vector2(94, 121)), # 3
	Rect2(Vector2(91, 2), Vector2(96, 113)), # 0
	Rect2(Vector2(300, 401), Vector2(101, 125)), # 7
	Rect2(Vector2(507, 411), Vector2(109, 107)), # 8
	Rect2(Vector2(299, 172), Vector2(94, 160)), # 4
	Rect2(Vector2(88, 370), Vector2(112, 197)), # 6
]


func _physics_process(delta):
	hand_sprite.position = previous_position + Vector2(646, 200)
	hand_sprite.rotation = desired_hand_rotation


func redraw_hand():
	if is_signing:
		var uv = hand_rects[rid]
		var a = AtlasTexture.new()
		a.atlas = hand_textures[cid]
		a.set_region(uv)
		hand_sprite.set_texture(a)
	
	var uv2 = hand_rects[selected_rid]
	var a2 = AtlasTexture.new()
	a2.atlas = hand_textures[selected_cid]
	a2.set_region(uv2)
	hand_sprite_preview.set_texture(a2)


func _ready():
	for n in range(10):
		var p:String = "res://hand_textures/hand_texture_"+String(n+1)+".png"
		hand_textures.append(load(p))


# Configuration selection
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			hand_selector_initial_position = event.position
			var touch_position = ($ConfigurationArea.to_local(event.position) + Vector2(32, 32)) / Vector2(64,64)
			touch_position *= 10
			selected_cid = floor(touch_position.x/2) + (floor(touch_position.y/5)*5)
			selected_cid = 9 - selected_cid
			selected_rid = 2
			tid = 0
			finger_selector = event.index
			if first_configuration or not is_signing:
				cid = selected_cid
				rid = selected_rid
			redraw_hand()


# Configuration movement
func _input(event):
	if event is InputEventScreenTouch:
		if not event.pressed:
			finger_selector = -1
			cid = selected_cid
			rid = selected_rid
			if is_signing:
				first_configuration = false
				animate_hand("middle")
			redraw_hand()
	if event is InputEventScreenDrag:
		if finger_selector != event.index:
			return
		var touch_position = hand_selector_initial_position - event.position
		selected_rid = max(-2, min(6, floor(touch_position.x/30)))+2
		# tid = max(0, min(1, touch_position.y/20))
		if first_configuration or not is_signing:
			cid = selected_cid
			rid = selected_rid
		redraw_hand()


# Movement
func _on_Area2D_input_event_b(viewport, event: InputEvent, shape_idx):
	var local_pos = $PositionArea.to_local(event.position) * $PositionArea.scale
	if event is InputEventScreenTouch:
		if event.pressed:
			previous_position = local_pos
			follow = false
			is_signing = true
			first_configuration = true
			print("start signing")
			animate_hand("start")
		else:
			is_signing = false
			first_configuration = false
			print("end signing")
			animate_hand("end")
			detect_letter()
		redraw_hand()
	if event is InputEventScreenDrag:
		desired_hand_position = local_pos + Vector2(646, 200)
		desired_hand_rotation = local_pos.angle_to_point(previous_position) + PI/2
		
		$HandPreviousPosition.position = previous_position + Vector2(646, 200)
		$HandCurrentPosition.position = local_pos + Vector2(646, 200)
		
		if local_pos.distance_to(previous_position) > 30:	
			follow = true
		if follow:
			var target_pos = previous_position - local_pos
			target_pos = target_pos.normalized()
			target_pos *= 30
			previous_position = lerp(previous_position, local_pos+target_pos, 0.2)
		redraw_hand()


func _on_Area3D_input_event(camera, event, _position: Vector3, normal, shape_idx):
	if finger_selector != -1:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			desired_hand_position_3d = _position * 10
			previous_position_3d = _position *10
			follow = false
	if event is InputEventScreenDrag:
		desired_hand_position_3d = _position * 10
		if desired_hand_position_3d.distance_to(previous_position_3d) > 10:
			follow = true
		if follow:
			var target_pos = previous_position_3d - desired_hand_position_3d
			target_pos = target_pos.normalized()
			target_pos *= 10
			previous_position_3d = lerp(previous_position_3d, desired_hand_position_3d+target_pos, 0.2)

func animate_hand(event: String):
	var tween = create_tween()
	tween.tween_property(hand_sprite, "scale", Vector2(1.5, 1.5), 0.1)
	tween.tween_property(hand_sprite, "scale", Vector2(1, 1), 0.1)
	if event == "end":
		tween.tween_property(hand_sprite, "scale", Vector2(0.5, 0.5), 0.1)

func detect_letter():
	var letters = {
		"a": [1, 7, 0], # c, r, d
		"b": [5, 0, 0],
		"c": [7, 2, 0],
		"ch": [5, 6, 0],
		"d": [2, 0, 0],
		"e": [4, 2, 0],
		"f": [5, 4, 0],
		"g": [9, 5, 0],
		"h": [3, 5, 0],
		"i": [2, 5, 0],
		"j": [5, 0, 0],
		"k": [3, 1, 0],
		"l": [2, 2, 0],
		"ll": [2, 2, 0],
		"m": [5, 5, 0],
		"n": [3, 5, 0],
		"ñ": [3, 5, 0],
		"o": [6, 1, 0],
		"q": [2, 1, 0],
		"p": [6, 5, 0],
		"r": [3, 2, 0],
		"s": [2, 5, 0],
		"t": [2, 0, 0],
		"u": [7, 5, 0],
		"v": [3, 2, 0],
		"w": [3, 2, 0],
		"x": [2, 5, 0],
		"y": [8, 5, 0],
		"z": [8, 2, 0],
	}
	label.text = ""
	for l in letters:
		if letters[l][0] == cid and letters[l][1] == rid:
			label.text += "-"+l
	print(cid, rid)
