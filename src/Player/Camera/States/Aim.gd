extends CameraState
"""
Logic state for the camera where configuration are made to the camera to set
the field of view, position offset (over the shoulder), etc.
"""


onready var tween: = $Tween

export var is_first_person: bool = false
export var fov: = 40.0
export var offset_camera: = Vector3(0.75, -0.7, 0)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_aim"):
		_state_machine.transition_to("Camera/Default")
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("fire"):
		_state_machine.transition_to("Camera/Default")
		var target_position: Vector3 = (
			camera_rig.aim_ray.get_collision_point()
			if camera_rig.aim_ray.is_colliding()
			else camera_rig.get_global_transform().origin
		)
		camera_rig.emit_signal("aim_fired", target_position)
		get_tree().set_input_as_handled()
	else:
		_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	camera_rig.aim_target.update(camera_rig.aim_ray)


func enter(msg: Dictionary = {}) -> void:
	_parent._is_aiming = true
	camera_rig.aim_target.visible = true

	camera_rig.spring_arm.translation = camera_rig._position_start + offset_camera

	
	tween.interpolate_property(camera_rig.camera, 'fov', camera_rig.camera.fov, fov, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()


func exit() -> void:
	_parent._is_aiming = false
	camera_rig.aim_target.visible = false

	camera_rig.spring_arm.translation = camera_rig._position_start

	tween.interpolate_property(camera_rig.camera, 'fov', camera_rig.camera.fov, _parent.fov_default, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
