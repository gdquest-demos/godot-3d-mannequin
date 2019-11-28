extends CameraState
"""
Logic state for the camera where configuration are made to the camera to set
the field of view, position offset (over the shoulder), etc.
"""


export var is_first_person: bool = false
export var fov: = 40.0
export var offset_third_person: = Vector3(0.75, -0.7, 0)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim_toggle"):
		_state_machine.transition_to("Camera/Default")
	elif event.is_action_pressed("action"):
		_state_machine.transition_to("Camera/Default")
		camera_rig.emit_signal("aim_fired",
				camera_rig.aim_ray.get_collision_point() if camera_rig.aim_ray.is_colliding()
				else camera_rig.get_global_transform().origin)
	else:
		_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	camera_rig.aim_target.update(camera_rig.aim_ray)


func enter(msg: Dictionary = {}) -> void:
	if is_first_person:
		_parent.occlusion_ray.set_cast_to(Vector3(0, 0, 0))
		msg["offset"] = -_parent.initial_position - Vector3(0.0, 0, 0.5)
	else:
		msg["fov"] = fov
		msg["offset"] = offset_third_person
	msg["is_aiming"] = true
	_parent.enter(msg)


func exit() -> void:
	camera_rig.aim_target.visible = false
	if is_first_person:
		_parent.occlusion_ray.set_cast_to(_parent.initial_position)
