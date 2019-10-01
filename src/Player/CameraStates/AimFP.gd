extends State


export var rotation_speed: = Vector2(1.0, 1.0)
export var is_y_inverted: = true

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim_toggle"):
		_state_machine.transition_to("Camera/Default")
	elif event.is_action_pressed("action"):
		_state_machine.transition_to("Camera/Default")
		owner.get_node("StateMachine").transition_to("Move/Zip", { zip_target = _parent.hook_ray.get_collision_point() if _parent.hook_ray.is_colliding() else owner.get_global_transform().origin })
	else:
		_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	_parent.update_hook_target()

func enter(msg: Dictionary = {}) -> void:
	msg["offset"] = - _parent.initial_position - Vector3(0.0, 0, 0.5)
	msg["aiming"] = true
	msg["y_invert"] = is_y_inverted
	_parent.occlusion_ray.set_cast_to(Vector3(0, 0, 0))
	_parent.enter(msg)

func exit() -> void:
	_parent.hook_target.visible = false
	_parent.occlusion_ray.set_cast_to(_parent.initial_position)
	_parent.exit()
