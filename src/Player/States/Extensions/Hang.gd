extends PlayerState
"""
State that does not involve gravity or further movement until released.
"""


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("action"):
		_state_machine.transition_to("Move/Idle")
	_parent.unhandled_input(event)
