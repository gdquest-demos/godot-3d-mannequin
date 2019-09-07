extends Spatial

onready var camera: Camera = $Camera
onready var initial_position: = camera.get_translation()
onready var initial_anchor_position: = get_translation()
onready var rotation_delay: Timer = $RotateDelay
onready var occlusion_ray: RayCast = $OcclusionRay

enum invert {INVERTED = -1, NON_INVERTED = 1}

export var rotation_speed: = Vector2(2.5, 2.5)
export (invert) var y_input_inversion = invert.INVERTED
export var backwards_deadzone := 0.3
var _camera_rotating: = false

func _ready() -> void:
	set_as_toplevel(true)
	occlusion_ray.set_cast_to(initial_position)


func physics_process(delta: float, move_direction: Vector3) -> void:
	#Snap the camera to point at the player's head
	var current_position = get_global_transform()
	current_position.origin = owner.get_global_transform().origin + initial_anchor_position
	set_global_transform(current_position)

	var camera_direction: = get_camera_direction()
	if camera_direction.length() == 0:
		#Handle automatic camera rotation
		#TODO: Automatically reset camera vertical rotation over time

		#If the player is moving directly towards the camera, don't rotate
		if move_direction.x <= -backwards_deadzone || move_direction.x >= backwards_deadzone:
			if !_camera_rotating:
				rotation_delay.start()
				_camera_rotating = true
			elif rotation_delay.time_left <= 0.0:
				var target_angle: float = owner.rotation.y
				var camera_offset: float = owner.rotation.y - rotation.y
				#Unwind rotation in case we're outside the domain that player rotation works within
				if camera_offset > PI:
						target_angle -= 2 * PI
				elif camera_offset < - PI:
						target_angle += 2 * PI
				rotation.y = lerp(rotation.y, target_angle, 0.015)
		else:
			_camera_rotating = false
	else:
		_camera_rotating = false

		#Apply manual camera input
		if camera_direction.length() > 1:
			camera_direction = camera_direction.normalized()
		if camera_direction.x != 0:
			rotation.y -= camera_direction.x * rotation_speed.x * delta
		if camera_direction.y != 0:
			rotation.x -= camera_direction.y * rotation_speed.y * delta * y_input_inversion
			rotation.x = clamp(rotation.x, -0.75, 1.25)

	#Make sure we don't end up winding
	if rotation.y > PI:
		rotation.y -= 2 * PI
	elif rotation.y < -PI:
		rotation.y += 2 * PI

	if _camera_rotating == false:
		rotation_delay.stop()

	#If there is a body between the camera and the player, move the camera closer
	if occlusion_ray.is_colliding():
		var offset_pos = camera.get_global_transform()
		if offset_pos.origin != occlusion_ray.get_collision_point():
			offset_pos.origin = occlusion_ray.get_collision_point()
			camera.set_global_transform(offset_pos)
	else:
		if camera.get_translation() != initial_position:
			camera.set_translation(initial_position)


static func get_camera_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
			Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		)