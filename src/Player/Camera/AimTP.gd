extends State


onready var _camera: Spatial = owner.get_node("CameraAnchor")

export var fov: = 40.0
export var rotation_speed: = Vector2(1.0, 1.0)
export var is_y_inverted: = true
export var camera_offset: = Vector3(0.75, 0.0, 0)

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim_toggle"):
		#TODO: Transition to first person if aim is held down?
		#_state_machine.transition_to("Camera/Aim_FP")
		_state_machine.transition_to("Camera/Default")
	elif event.is_action_pressed("action"):
		_state_machine.transition_to("Camera/Default")
		owner.get_node("StateMachine").transition_to("Move/Zip", { zip_target = _camera.hook_ray.get_collision_point() if _camera.hook_ray.is_colliding() else owner.get_global_transform().origin })


func physics_process(delta: float) -> void:
	#TODO: Prevent jumping? Force us out of aiming when we enter Move/Air?
	_parent.physics_process(delta)
	_parent.update_hook_target()

func enter(msg: Dictionary = {}) -> void:
	msg["fov"] = fov
	msg["offset"] = camera_offset
	msg["aiming"] = true
	msg["y_invert"] = is_y_inverted
	#TODO: Set more generous vertical look limits when aiming?
	_parent.enter(msg)

func exit() -> void:
	_camera.hook_target.visible = false
	_parent.exit()
