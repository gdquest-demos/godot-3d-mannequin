extends PlayerState
# Hookshot style state for the player - gets a destination from an outside
# piece of logic (in this case, the Camera's aim state firing with a raycast)
# and flies through the air to reach it.


var speed: = 10.0
var target: = Vector3.ZERO


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_state_machine.transition_to("Move/Idle")


func physics_process(delta: float) -> void:
	var direction: = (target - player.get_global_transform().origin).normalized()
	var aim_length: float = player.camera.aim_ray.cast_to.length() - target.length() + 1.0

	_parent.velocity = direction * speed
	_parent.physics_process(delta)

	if player.get_slide_count() > 0:
		if Input.is_action_pressed("interact"):
			_parent.velocity = Vector3.ZERO
			_state_machine.transition_to("Move/Hang")
		else:
			_parent.velocity = Vector3.ZERO
			_state_machine.transition_to("Move/Air")


func enter(msg: Dictionary = {}) -> void:
	_parent.gravity = 0.0
	if "target" in msg:
		target = msg.target
	else:
		_state_machine.transition_to("Move/Idle")


func exit() -> void:
	# FIXME: redo this bit
	_parent.gravity = -80.0
	target = Vector3.ZERO
