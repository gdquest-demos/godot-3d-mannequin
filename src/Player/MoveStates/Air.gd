extends State
"""
State for when the player is jumping and falling.
"""


func physics_process(delta: float) -> void:
	_parent.velocity -= Vector3(0, delta * _parent.max_speed.y, 0)
	_parent.physics_process(delta)

	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	if owner.is_on_ceiling():
		_parent.velocity.y = 0


func enter(msg: Dictionary = {}) -> void:
	_parent.velocity = msg.velocity if "velocity" in msg else _parent.velocity
	_parent.enter()


func exit() -> void:
	_parent.exit()
