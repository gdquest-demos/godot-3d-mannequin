extends State


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { velocity = _parent.velocity + Vector3(0, 20, 0) })


func physics_process(delta: float) -> void:
	if owner.is_on_floor() and _parent.get_move_direction().length() < 0.001:
		_state_machine.transition_to("Move/Idle")
	elif !owner.is_on_floor():
		_state_machine.transition_to("Move/Air")
	_parent.physics_process(delta)


func exit() -> void:
	_parent.exit()
