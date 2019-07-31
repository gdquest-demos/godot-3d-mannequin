extends State


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air")


func physics_process(delta: float) -> void:
	var move: = get_parent()
	if owner.is_on_floor() and move.get_move_direction().length() < 0.001:
		_state_machine.transition_to("Move/Idle")
	move.physics_process(delta)
