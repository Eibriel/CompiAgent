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
var cid = 0
var rid = 2
var tid = 1
var finger_selector = -1


func _physics_process(delta):
	hand_handle.translation = previous_position_3d
	previous_handle.translation = desired_hand_position_3d
	hand_handle.look_at(desired_hand_position_3d*0.1, Vector3.UP)
	hand_rotation.rotation_degrees = Vector3((tid*90)+180, (rid*120)+180, 0)


func redraw_hand():
	#var uv = Rect2(Vector2(cid*96, rid*96), Vector2(96, 96))
	#hand_sprite.get_texture().set_region(uv)
	#hand_sprite.scale.y = tid
	pass


func _ready():
	hand_collision.connect("input_event", self, "_on_Area3D_input_event")


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			hand_selector_initial_position = event.position
			var touch_position = ($ConfigurationArea.to_local(event.position) + Vector2(32, 32)) / Vector2(64,64)
			touch_position *= 10
			cid = floor(touch_position.x/2) + (floor(touch_position.y/5)*5)
			rid = 2
			tid = 1
			finger_selector = event.index
			redraw_hand()


func _input(event):
	if event is InputEventScreenTouch:
		if not event.pressed:
			finger_selector = -1
	if event is InputEventScreenDrag:
		if finger_selector != event.index:
			return
		var touch_position = hand_selector_initial_position - event.position
		rid = max(-1, min(1, touch_position.x/20))
		tid = max(-1, min(1, touch_position.y/20))
		redraw_hand()


func _on_Area2D_input_event_b(viewport, event: InputEvent, shape_idx):
	var local_pos = $PositionArea.to_local(event.position) * $PositionArea.scale
	if event is InputEventScreenTouch:
		if event.pressed:
			previous_position = local_pos # + Vector2(-10, 10)
			follow = false
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
