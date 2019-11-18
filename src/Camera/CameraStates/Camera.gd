extends State
"""
Parent state for all camera based states for the Camera. Handles input based on
mouse/gamepad and movement and configuration based on which state we're using.

This state holds all of the main logic, with the state itself being configured
or have its functions overriden or called by the child states. This keeps the
logic contained in a central location while being easily modifiable.
"""


onready var camera: SpringArm = owner.get_node("SpringArm")
onready var camera_view: Camera = camera.get_node("Camera")
onready var initial_position: = camera.translation
onready var initial_anchor_position: Vector3 = owner.translation

onready var aim_target: Sprite3D = owner.get_node("AimTarget")

export var default_fov: = 70.0
export var is_y_inverted: = true
export var backwards_deadzone := 0.3
export var gamepad_sensivity: = Vector2(2.5, 2.5)
export var mouse_sensitivity := Vector2(0.1, 0.1)

var _current_fov: float = default_fov
var _current_y_inversion: bool = is_y_inverted
var _relative_input: = Vector2(0, 0)
var _offset: = Vector3(0, 0, 0)
var _is_aiming: = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func physics_process(delta: float) -> void:
	#pin camera to player position relative to old position
	var current_transform: Transform = owner.global_transform
	var current_position: = current_transform.origin
	var intended_position: Vector3 = owner.player.global_transform.origin + initial_anchor_position
	current_transform.origin = intended_position
	owner.global_transform = current_transform
	
	#respond to input
	var absolute_input: = get_input_direction()
	var move_direction: = get_move_direction()

	if _relative_input.length() > 0:
		process_camera_input(_relative_input * mouse_sensitivity * delta)
		_relative_input = Vector2(0, 0)
	elif absolute_input.length() > 0:
		process_camera_input(absolute_input * gamepad_sensivity * delta)

	#TODO: switch to using rotational offset between camera and player to determine auto rotation behaviour, and don't rotate while character is turning to face input direction
	#var camera_relative_rotation = fmod(owner.rotation.y - anchor.rotation.y, PI)
	#var is_moving_towards_camera: = abs(camera_relative_rotation) > PI - backwards_deadzone

	var is_moving_towards_camera: bool = move_direction.x >= -backwards_deadzone and move_direction.x <= backwards_deadzone
	if not is_moving_towards_camera && not _is_aiming:
		auto_rotate(move_direction)

	# Make sure we don't end up winding
	if owner.rotation.y > PI:
		owner.rotation.y -= 2 * PI
	elif owner.rotation.y < -PI:
		owner.rotation.y += 2 * PI

	if camera_view.fov != _current_fov:
		camera_view.fov = lerp(camera_view.fov, _current_fov, 0.05)

	camera.translation = lerp(camera.translation, initial_position + _offset, 0.05)


func enter(msg: Dictionary = {}) ->void:
	_current_fov = msg["fov"] if "fov" in msg else default_fov
	_offset = msg["offset"] if "offset" in msg else Vector3(0, 0, 0)
	_is_aiming = msg["aiming"] if "aiming" in msg else false
	_current_y_inversion = msg["y_inversion"] if "y_inversion" in msg else is_y_inverted


func update_aim_target() -> void:
	var aim_ray: RayCast = owner.aim_ray
	aim_ray.force_raycast_update()
	if aim_ray.is_colliding():
		var global_offset = aim_target.global_transform
		if global_offset.origin != aim_ray.get_collision_point():
			global_offset.origin = aim_ray.get_collision_point()
			aim_target.global_transform = global_offset
			aim_target.look_at(aim_ray.get_collision_point() - aim_ray.get_collision_normal(), global_offset.basis.y.normalized())
		if !aim_target.visible:
			aim_target.visible = true
	else:
		aim_target.visible = false


func auto_rotate(move_direction: Vector3) -> void:
	var offset: float = owner.player.rotation.y - owner.rotation.y
	var target_angle: float = (
		owner.player.rotation.y - 2 * PI if offset > PI 
		else owner.player.rotation.y + 2 * PI if offset < -PI
		else owner.player.rotation.y
	)
	owner.rotation.y = lerp(owner.rotation.y, target_angle, 0.015)


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
		owner.rotation.y -= input.x
	if input.y != 0:
		var angle: = input.y
		owner.rotation.x -= angle * -1.0 if _current_y_inversion else angle
		owner.rotation.x = clamp(owner.rotation.x, -0.75, 1.25)
		owner.rotation.z = 0


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
