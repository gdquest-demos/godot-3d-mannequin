extends State

onready var anchor: Spatial = get_parent().get_parent()

export var default_fov: = 70.0
export var rotation_speed: = Vector2(2.5, 2.5)
export var is_y_inverted: = true
export var backwards_deadzone := 0.3

var current_fov: float = default_fov
var offset: = Vector3(0, 0, 0)
var _is_aiming = false
var _current_y_inversion = is_y_inverted
var _is_auto_rotating: = false setget _set_is_auto_rotating

func physics_process(delta: float) -> void:
	var current_position = anchor.global_transform
	current_position.origin = owner.global_transform.origin + anchor.initial_anchor_position
	anchor.global_transform = current_position
	var input_direction: = get_input_direction()
	var move_direction: = get_move_direction()

	#TODO: switch to using rotational offset between camera and player to determine auto rotation behaviour
	#var camera_relative_rotation = fmod(owner.rotation.y - anchor.rotation.y, PI)
	#var is_moving_towards_camera: = abs(camera_relative_rotation) > PI - backwards_deadzone

	var is_moving_towards_camera: = move_direction.x >= -backwards_deadzone and move_direction.x <= backwards_deadzone
	if input_direction.length() > 0:
		self._is_auto_rotating = false
		if input_direction.x != 0:
			anchor.rotation.y -= input_direction.x * rotation_speed.x * delta
		if input_direction.y != 0:
			var angle: = input_direction.y * rotation_speed.y * delta
			anchor.rotation.x += angle if _current_y_inversion else angle * -1.0
			anchor.rotation.x = clamp(anchor.rotation.x, -0.75, 1.25)
			anchor.rotation.z = 0
	elif not is_moving_towards_camera && !_is_aiming:
		# TODO: Automatically reset camera vertical rotation over time
		auto_rotate(move_direction)
	else:
		self._is_auto_rotating = false

	# Make sure we don't end up winding
	if anchor.rotation.y > PI:
		anchor.rotation.y -= 2 * PI
	elif anchor.rotation.y < -PI:
		anchor.rotation.y += 2 * PI

	if anchor.camera.fov != current_fov:
		anchor.camera.fov = lerp(anchor.camera.fov, current_fov, 0.05)

	# If there is a body between the camera and the player, move the camera closer
	anchor.occlusion_ray.force_raycast_update()
	if anchor.occlusion_ray.is_colliding():
		var global_offset = anchor.camera.global_transform
		if global_offset.origin != anchor.occlusion_ray.get_collision_point() + offset:
			global_offset.origin = anchor.occlusion_ray.get_collision_point() + offset
			anchor.camera.global_transform = global_offset
	elif anchor.camera.translation != anchor.initial_position + offset:
		anchor.camera.translation = lerp(anchor.camera.translation, anchor.initial_position + offset, 0.05)


func enter(msg: Dictionary = {}) ->void:
	current_fov = msg["fov"] if "fov" in msg else default_fov
	offset = msg["offset"] if "offset" in msg else Vector3(0, 0, 0)
	_is_aiming = msg["aiming"] if "aiming" in msg else false
	_current_y_inversion = msg["y_inversion"] if "y_inversion" in msg else is_y_inverted


func update_hook_target() -> void:
	anchor.hook_ray.force_raycast_update()
	if anchor.hook_ray.is_colliding():
		var global_offset = anchor.hook_target.global_transform
		if global_offset.origin != anchor.hook_ray.get_collision_point():
			global_offset.origin = anchor.hook_ray.get_collision_point()
			anchor.hook_target.global_transform = global_offset
			anchor.hook_target.look_at(anchor.hook_ray.get_collision_point() - anchor.hook_ray.get_collision_normal(), global_offset.basis.y.normalized())
		if !anchor.hook_target.visible:
			anchor.hook_target.visible = true
	else:
		anchor.hook_target.visible = false


func auto_rotate(move_direction: Vector3) -> void:
	if not _is_auto_rotating:
		self._is_auto_rotating = true
	elif anchor.rotate_delay.is_stopped():
		var offset: float = owner.rotation.y - anchor.rotation.y
		var target_angle: float = (
			owner.rotation.y - 2 * PI if offset > PI 
			else owner.rotation.y + 2 * PI if offset < -PI
			else owner.rotation.y
		)
		anchor.rotation.y = lerp(anchor.rotation.y, target_angle, 0.015)


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

func _set_is_auto_rotating(value: bool) -> void:
	_is_auto_rotating = value
	if _is_auto_rotating:
		anchor.rotate_delay.start()
	else:
		anchor.rotate_delay.stop()