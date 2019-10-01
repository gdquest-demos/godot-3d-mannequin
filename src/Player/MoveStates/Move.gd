extends State

export var max_speed: = Vector3(50.0, 50.0, 500.0)
export var move_speed: = Vector3(500, 500, 500)
export var max_rotation_speed: = 0.5

var velocity: = Vector3.ZERO
var jump_velocity = Vector3(0, 20, 0)
onready var _camera: Spatial = owner.get_node("CameraAnchor")


func physics_process(delta: float) -> void:
	var input_offset: float = _camera.global_transform.basis.get_euler().y
	var move_direction: = get_move_direction()

	#Use Vector2 to calculate angle since Vector3.angle_to() returns angular distance/angular diameter rather than the angle itself
	var move_direction_2d: = Vector2(move_direction.x, move_direction.z)
	var rotation: = move_direction_2d.angle_to(Vector2.UP) + input_offset

	if move_direction_2d.length() > 0:
		#Make sure we don't end up winding
		if owner.rotation.y - rotation > PI:
			owner.rotation.y -= 2 * PI
		elif owner.rotation.y - rotation < -PI:
			owner.rotation.y += 2 * PI

		owner.rotation.y = lerp(owner.rotation.y, rotation, 0.1)

	var new_velocity = calculate_velocity(velocity, max_speed, move_speed, delta, move_direction.rotated(Vector3.UP, (input_offset)))
	if new_velocity.y == 0:
		new_velocity.y = -0.01
	owner.move_and_slide(new_velocity, Vector3.UP)


static func get_move_direction() -> Vector3:
	return Vector3(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			0,
			Input.get_action_strength("move_back") - Input.get_action_strength("move_front")
		)


static func calculate_velocity(
		old_velocity: Vector3,
		max_speed: Vector3,
		move_speed: Vector3,
		delta: float,
		move_direction: Vector3
	) -> Vector3:
		var new_velocity: = old_velocity

		if move_direction.length() > 1:
			move_direction = move_direction.normalized()

		new_velocity += move_direction * delta * move_speed
		if new_velocity.length() > max_speed.z:
			new_velocity = new_velocity.normalized() * max_speed.z
		new_velocity.y = old_velocity.y

		return new_velocity
