extends State

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim_toggle"):
		_state_machine.transition_to("Camera/Aim_TP")
	else:
		_parent.unhandled_input(event)

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)

func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)

func exit() -> void:
	_parent.exit()
