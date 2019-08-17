extends State


export var max_speed: = 220.0

var velocity: = Vector3.ZERO


func physics_process(delta: float) -> void:
	var move_direction: = get_move_direction()
	velocity = move_direction * max_speed * delta
	owner.move_and_slide(velocity, Vector3.UP)
	owner.rotation.y = -Vector3.FORWARD.angle_to(move_direction) * move_direction.x


static func get_move_direction() -> Vector3:
	return Vector3(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			0.0,
			Input.get_action_strength("move_back") - Input.get_action_strength("move_front")
		).normalized()
