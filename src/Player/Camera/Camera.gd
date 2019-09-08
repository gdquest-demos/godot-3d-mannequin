extends Spatial


onready var camera: Camera = $Camera
onready var initial_position: = camera.translation
onready var initial_anchor_position: = translation

onready var rotate_delay: Timer = $RotateDelay
onready var occlusion_ray: RayCast = $OcclusionRay

export var rotation_speed: = Vector2(2.5, 2.5)
export var is_y_inverted: = true
export var backwards_deadzone := 0.3

var _is_auto_rotating: = false setget _set_is_auto_rotating


func _ready() -> void:
	set_as_toplevel(true)
	occlusion_ray.set_cast_to(initial_position)


func physics_process(delta: float, move_direction: Vector3) -> void:
	var current_position = global_transform
	current_position.origin = owner.global_transform.origin + initial_anchor_position
	global_transform = current_position
	var input_direction: = get_input_direction()

	var is_moving_towards_camera: = move_direction.x <= -backwards_deadzone or move_direction.x >= backwards_deadzone
	if not input_direction and is_moving_towards_camera:
		# TODO: Automatically reset camera vertical rotation over time
		auto_rotate(move_direction)
	else:
		self._is_auto_rotating = false
		if input_direction.x != 0:
			rotation.y -= input_direction.x * rotation_speed.x * delta
		if input_direction.y != 0:
			var angle: = input_direction.y * rotation_speed.y * delta
			rotation.x += angle * -1.0 if is_y_inverted else angle
			rotation.x = clamp(rotation.x, -0.75, 1.25)

	# Make sure we don't end up winding
	if rotation.y > PI:
		rotation.y -= 2 * PI
	elif rotation.y < -PI:
		rotation.y += 2 * PI

	# If there is a body between the camera and the player, move the camera closer
	if occlusion_ray.is_colliding():
		var global_offset = camera.global_transform
		if global_offset.origin != occlusion_ray.get_collision_point():
			global_offset.origin = occlusion_ray.get_collision_point()
			camera.global_transform = global_offset
	elif camera.translation != initial_position:
		camera.translation = initial_position


func auto_rotate(move_direction: Vector3) -> void:
	if not _is_auto_rotating:
		_is_auto_rotating = true

	if _is_auto_rotating and rotate_delay.is_stopped():
		var offset: float = owner.rotation.y - rotation.y
		var target_angle: float = (
			owner.rotation.y - 2 * PI if offset > PI 
			else owner.rotation.y + 2 * PI if offset < -PI
			else owner.rotation.y
		)
		rotation.y = lerp(rotation.y, target_angle, 0.015)


static func get_input_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
			Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		).normalized()


func _set_is_auto_rotating(value: bool) -> void:
	_is_auto_rotating = value
	if _is_auto_rotating:
		rotate_delay.start()
	else:
		rotate_delay.stop()
