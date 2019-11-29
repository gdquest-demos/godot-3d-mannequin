extends CameraState
"""
Logic state for the camera - implies no modification to the camera settings.
"""


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_aim"):
		_state_machine.transition_to("Camera/Aim")
	else:
		_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
