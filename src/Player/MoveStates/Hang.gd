extends State


onready var _camera: Spatial = owner.get_node("CameraAnchor")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		#TODO: If on a wall, rotate velocity to push away from the wall
		_state_machine.transition_to("Move/Air", { velocity = _parent.velocity + _parent.jump_velocity })


func physics_process(delta: float) -> void:
	#_parent.physics_process(delta)
	#Don't want any physics/movement to apply when we're attached
	pass


func enter(msg: Dictionary = {}) -> void:
	_parent.enter()


func exit() -> void:
	_parent.exit()
