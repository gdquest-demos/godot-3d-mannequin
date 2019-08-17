extends State


onready var jump_delay: Timer = $JumpDelay


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", { velocity = _parent.velocity })


func physics_process(delta: float) -> void:
	if owner.is_on_floor() and (_parent.get_move_direction().x or _parent.get_move_direction().z):
		_state_machine.transition_to("Move/Run")
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air")


func enter(msg: Dictionary = {}) -> void:
	_parent.velocity = Vector3.ZERO
	if jump_delay.time_left > 0.0:
		_parent.velocity = _parent.calculate_velocity(
				_parent.velocity,
				_parent.MAX_SPEED,
				1.0,
				Vector3.UP)
		_state_machine.transition_to("Move/Air")
	_parent.enter()


func exit() -> void:
	_parent.exit()
