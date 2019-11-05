extends State


export var first_person_aiming: bool = false
export var fov: = 40.0
export var is_y_inverted: = true
export var third_person_camera_offset: = Vector3(0.75, 0.0, 0)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim_toggle"):
		_state_machine.transition_to("Camera/Default")
	elif event.is_action_pressed("action"):
		_state_machine.transition_to("Camera/Default")
		owner.emit_signal("aim_fired", 
				owner.aim_ray.get_collision_point() if owner.aim_ray.is_colliding() 
				else owner.get_global_transform().origin)
	else:
		_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	_parent.update_aim_target()


func enter(msg: Dictionary = {}) -> void:
	if first_person_aiming:
		_parent.occlusion_ray.set_cast_to(Vector3(0, 0, 0))
		msg["offset"] = -_parent.initial_position - Vector3(0.0, 0, 0.5)
	else:
		msg["fov"] = fov
		msg["offset"] = third_person_camera_offset
	msg["aiming"] = true
	msg["y_invert"] = is_y_inverted
	_parent.enter(msg)


func exit() -> void:
	_parent.aim_target.visible = false
	if first_person_aiming:
		_parent.occlusion_ray.set_cast_to(_parent.initial_position)