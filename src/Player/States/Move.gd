extends State

export var max_speed: = Vector3(50.0, 50.0, 500.0)
export var move_speed: = Vector3(500, 500, 500)
export var max_rotation_speed: = 0.5
export var camera_rotation_speed: = Vector2(2.5, 2.5)
export var yinvert_multiplier: = -1

var velocity: = Vector3.ZERO

func physics_process(delta: float) -> void:
	#TODO:Move camera rotation out to Camera.gd
	var prev_camera_rotation: Vector3 = owner.get_node("CameraAnchor").global_transform.basis.get_euler()
	var move_direction: = get_move_direction()
	#Use Vector2 to calculate angle since Vector3.angle_to() returns angular distance/angular diameter rather than the angle itself
	var temp: = Vector2(move_direction.x, move_direction.z)
	var rotation: = temp.angle_to(Vector2.UP)

	#TODO: Remove move direction visual aid - or turn it into a gizmo?
	owner.get_node("CameraAnchor/MoveDirectionRef").set_translation(move_direction)

	var rotdiff: = 0.0
	if temp.length() > 0:
		#Keep track of the new rotation amount to use when calculating manual camera control
		rotdiff = owner.rotation.y - (prev_camera_rotation.y + rotation)
		owner.rotation.y = prev_camera_rotation.y + rotation
		#Make sure we don't end up winding
		if owner.rotation.y > PI:
			owner.rotation.y -= 2 * PI
		if owner.rotation.y < -PI:
			owner.rotation.y += 2 * PI

	velocity = calculate_velocity(velocity, max_speed, move_speed, delta, move_direction.rotated(Vector3.UP, (prev_camera_rotation.y)))
	if velocity.y == 0:
		velocity.y = -0.01

	owner.move_and_slide(velocity, Vector3.UP)

	var camera_direction: = get_camera_direction()
	if camera_direction.length() == 0:
		#TODO: Delayed follow behaviour
		if move_direction.length() > 0:
			owner.get_node("CameraAnchor").rotation.y = 0 - rotation
		pass
	else:
		#Apply manual camera
		if camera_direction.length() > 1:
			camera_direction = camera_direction.normalized()
		if camera_direction.x != 0:
			owner.get_node("CameraAnchor").rotation.y -= camera_direction.x * camera_rotation_speed.x * delta - rotdiff
		if camera_direction.y != 0:
			owner.get_node("CameraAnchor").rotation.x -= camera_direction.y * camera_rotation_speed.y * delta * yinvert_multiplier
			owner.get_node("CameraAnchor").rotation.x = clamp(owner.get_node("CameraAnchor").rotation.x, -0.75, 0.9)
		#TODO: Move camera node along local -Z until no occluding geo is in the way
		#TODO: Make occluding geo transparent?

	#Make sure we don't end up winding
	if owner.get_node("CameraAnchor").rotation.y > PI:
		owner.get_node("CameraAnchor").rotation.y -= 2 * PI
	if owner.get_node("CameraAnchor").rotation.y < -PI:
		owner.get_node("CameraAnchor").rotation.y += 2 * PI

static func get_move_direction() -> Vector3:
	return Vector3(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			0,
			Input.get_action_strength("move_back") - Input.get_action_strength("move_front")
		)

static func get_camera_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
			Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
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

		new_velocity = move_direction * delta * move_speed
		if new_velocity.length() > max_speed.z:
			new_velocity = new_velocity.normalized() * max_speed.z
		new_velocity.y = old_velocity.y

		return new_velocity
