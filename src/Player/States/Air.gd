tool
extends State


onready var jump_delay: Timer = $JumpDelay


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	#TODO: Adjust peak of jump height depending on when jump input is released
	_parent.velocity -= Vector3(0, delta * 50, 0)
	_parent.physics_process(delta)

	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	if owner.is_on_ceiling():
		_parent.velocity.y = 0
	#if at ledge, transition to ledge


func enter(msg: Dictionary = {}) -> void:
	_parent.velocity = msg.velocity if "velocity" in msg else _parent.velocity
	_parent.enter()


func exit() -> void:
	_parent.exit()
