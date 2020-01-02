extends PlayerState
# State for when the player is jumping and falling.


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)

	if player.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	elif player.is_on_ceiling():
		_parent.velocity.y = 0


func enter(msg: Dictionary = {}) -> void:
	match msg:
		{"velocity": var v, "jump_impulse": var ji}:
			_parent.velocity = v + Vector3(0, ji, 0)
	skin.transition_to(skin.States.AIR)
	_parent.enter()


func exit() -> void:
	_parent.exit()
