extends Spatial

var _target: Spatial
export var camera_rotation_speed: = Vector2(2.5, 2.5)
export var yinvert_multiplier: = -1
export var camera_backwards_deadzone := 0.3
var _camera_rotating: = false

onready var rotation_delay: Timer = $RotateDelay


func _ready() -> void:
	_target = owner
	set_as_toplevel(true)

func physics_process(delta: float, move_direction: Vector3) -> void:
	#TODO: Remove move direction visual aid - or turn it into a gizmo?
	$MoveDirectionRef.set_translation(move_direction)

	#Snap the camera to the player position
	var pos = get_global_transform()
	pos.origin = owner.get_global_transform().origin
	set_global_transform(pos)

	var camera_direction: = get_camera_direction()
	if camera_direction.length() == 0:
		#Handle automatic camera rotation
		#TODO: Automatically reset camera vertical rotation over time

		#If the player is moving directly towards the camera, don't rotate
		if move_direction.x <= -camera_backwards_deadzone || move_direction.x >= camera_backwards_deadzone:
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
		else:
			if camera_direction.x != 0:
				rotation.y -= camera_direction.x * camera_rotation_speed.x * delta
			if camera_direction.y != 0:
				rotation.x -= camera_direction.y * camera_rotation_speed.y * delta * yinvert_multiplier
				rotation.x = clamp(rotation.x, -0.75, 0.9)
		#TODO: Move camera node along local -Z until no occluding geo is in the way
		#TODO: Make occluding geo transparent?

	#Make sure we don't end up winding
	if rotation.y > PI:
		rotation.y -= 2 * PI
	elif rotation.y < -PI:
		rotation.y += 2 * PI

	if _camera_rotating == false:
		rotation_delay.stop()


static func get_camera_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
			Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		)