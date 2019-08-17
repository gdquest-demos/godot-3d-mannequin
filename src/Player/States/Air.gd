tool
extends State


onready var jump_delay: Timer = $JumpDelay


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")


func enter(msg: Dictionary = {}) -> void:
	_parent.velocity = msg.velocity if "velocity" in msg else _parent.velocity
	_parent.enter()


func exit() -> void:
	_parent.exit()
