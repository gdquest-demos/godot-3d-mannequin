extends State
"""
Basic state when the player is moving around until jumping or lack of input.
"""


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if owner.is_on_floor() and _parent.get_input_direction().length() < 0.001:
		_state_machine.transition_to("Move/Idle")
	elif !owner.is_on_floor():
		_state_machine.transition_to("Move/Air")
	_parent.physics_process(delta)


func enter(msg: = {}) -> void:
	_parent.enter()


func exit() -> void:
	_parent.exit()