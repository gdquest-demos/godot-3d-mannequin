extends State
"""
Parent state for all movement-related states for the Player.

Holds all of the base movement logic. 
Child states can override this state's functions or change its properties. 
This keeps the logic grouped in one location.
"""


export var max_speed: = Vector3(50.0, 50.0, 500.0)
export var move_speed: = Vector3(500, 500, 500)
export var max_rotation_speed: = 0.5

var velocity: = Vector3.ZERO
var jump_velocity = Vector3(0, 20, 0)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { velocity = velocity + jump_velocity })


func physics_process(delta: float) -> void:
	var input_direction: = get_input_direction()

	# Calculate a move direction vector relative to the camera
	# The basis stores the (right, up, -forwards) vectors of our camera.
	var forwards: Vector3 = owner.camera.global_transform.basis.z * input_direction.z
	var right: Vector3 = owner.camera.global_transform.basis.x * input_direction.x
	var move_direction: = (forwards + right).normalized()
	move_direction.y = 0
	
	# Rotation
	if move_direction:
		owner.look_at(owner.global_transform.origin + move_direction, Vector3.UP)
	
	# Movement
	var new_velocity = calculate_velocity(velocity, max_speed, move_speed, delta, move_direction)
	if new_velocity.y == 0:
		new_velocity.y = -0.01
	owner.move_and_slide(new_velocity, Vector3.UP)


func enter(msg: Dictionary = {}) -> void:
	return


func exit() -> void:
	return


"""Callback to transition to the optional Zip state
It only works if the Zip state node exists"""
func _on_Camera_aim_fired(target_vector: Vector3) -> void:
	_state_machine.transition_to("Move/Zip", { zip_target = target_vector })


static func get_input_direction() -> Vector3:
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
