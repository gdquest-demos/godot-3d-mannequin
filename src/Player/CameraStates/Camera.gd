extends State


onready var anchor: Spatial = get_parent().get_parent()


onready var camera: Camera = anchor.get_node("Camera")
onready var initial_position: = camera.translation
onready var initial_anchor_position: = anchor.translation

onready var occlusion_ray: RayCast = anchor.get_node("OcclusionRay")
onready var hook_ray: RayCast = anchor.get_node("HookRay")
onready var hook_target: Sprite3D = anchor.get_node("HookTarget")

export var default_fov: = 70.0
export var is_y_inverted: = true
export var backwards_deadzone := 0.3
export var gamepad_sensivity: = Vector2(2.5, 2.5)
export var mouse_sensitivity := Vector2(0.1, 0.1)

var _relative_input: = Vector2(0, 0)
var _current_fov: float = default_fov
var _offset: = Vector3(0, 0, 0)
var _is_aiming: = false
var _current_y_inversion: = is_y_inverted


func _ready():
	anchor.set_as_toplevel(true)
	occlusion_ray.set_cast_to(initial_position)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func physics_process(delta: float) -> void:
	var current_position = anchor.global_transform
	current_position.origin = owner.global_transform.origin + initial_anchor_position
	anchor.global_transform = current_position
	var absolute_input: = get_input_direction()
	var move_direction: = get_move_direction()

	if _relative_input.length() > 0:
		process_camera_input(_relative_input * mouse_sensitivity * delta)
		_relative_input = Vector2(0, 0)
	if absolute_input.length() > 0:
		process_camera_input(absolute_input * gamepad_sensivity * delta)

	#TODO: switch to using rotational offset between camera and player to determine auto rotation behaviour, and don't rotate while character is turning to face input direction
	#var camera_relative_rotation = fmod(owner.rotation.y - anchor.rotation.y, PI)
	#var is_moving_towards_camera: = abs(camera_relative_rotation) > PI - backwards_deadzone

	var is_moving_towards_camera: = move_direction.x >= -backwards_deadzone and move_direction.x <= backwards_deadzone
	if !is_moving_towards_camera && !_is_aiming:
		auto_rotate(move_direction)

	# Make sure we don't end up winding
	if anchor.rotation.y > PI:
		anchor.rotation.y -= 2 * PI
	elif anchor.rotation.y < -PI:
		anchor.rotation.y += 2 * PI

	if camera.fov != _current_fov:
		camera.fov = lerp(camera.fov, _current_fov, 0.05)

	# If there is a body between the camera and the player, move the camera closer
	occlusion_ray.force_raycast_update()
	if occlusion_ray.is_colliding():
		var global_offset = camera.global_transform
		if global_offset.origin != occlusion_ray.get_collision_point() + _offset:
			global_offset.origin = occlusion_ray.get_collision_point() + _offset
			camera.global_transform = global_offset
	elif camera.translation != initial_position + _offset:
		camera.translation = lerp(camera.translation, initial_position + _offset, 0.05)


func enter(msg: Dictionary = {}) ->void:
	_current_fov = msg["fov"] if "fov" in msg else default_fov
	_offset = msg["offset"] if "offset" in msg else Vector3(0, 0, 0)
	_is_aiming = msg["aiming"] if "aiming" in msg else false
	_current_y_inversion = msg["y_inversion"] if "y_inversion" in msg else is_y_inverted


func update_hook_target() -> void:
	hook_ray.force_raycast_update()
	if hook_ray.is_colliding():
		var global_offset = hook_target.global_transform
		if global_offset.origin != hook_ray.get_collision_point():
			global_offset.origin = hook_ray.get_collision_point()
			hook_target.global_transform = global_offset
			hook_target.look_at(hook_ray.get_collision_point() - hook_ray.get_collision_normal(), global_offset.basis.y.normalized())
		if !hook_target.visible:
			hook_target.visible = true
	else:
		hook_target.visible = false


func auto_rotate(move_direction: Vector3) -> void:
	var offset: float = owner.rotation.y - anchor.rotation.y
	var target_angle: float = (
		owner.rotation.y - 2 * PI if offset > PI 
		else owner.rotation.y + 2 * PI if offset < -PI
		else owner.rotation.y
	)
	anchor.rotation.y = lerp(anchor.rotation.y, target_angle, 0.015)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mousegrab_toggle"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("y_inversion_toggle"):
		is_y_inverted = !is_y_inverted
		_current_y_inversion = !_current_y_inversion
		$Aim_FP.is_y_inverted = !$Aim_FP.is_y_inverted
		$Aim_TP.is_y_inverted = !$Aim_TP.is_y_inverted
	elif event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_relative_input += event.get_relative()


func process_camera_input(input: Vector2) -> void:
	if input.x != 0:
		anchor.rotation.y -= input.x
	if input.y != 0:
		var angle: = input.y
		anchor.rotation.x -= angle * -1.0 if _current_y_inversion else angle
		anchor.rotation.x = clamp(anchor.rotation.x, -0.75, 1.25)
		anchor.rotation.z = 0


static func get_input_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
			Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		).normalized()


static func get_move_direction() -> Vector3:
	return Vector3(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			0,
			Input.get_action_strength("move_back") - Input.get_action_strength("move_front")
		)