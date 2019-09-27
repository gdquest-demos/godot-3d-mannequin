extends State


onready var _camera: Spatial = owner.get_node("CameraAnchor")

var zip_speed:= 10.0
var zip_target: Vector3 = Vector3(0, 0, 0)

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		_state_machine.transition_to("Move/Idle")


func physics_process(delta: float) -> void:
	var zipdest = zip_target - owner.get_global_transform().origin + Vector3(0, -1.6, 0)

	_parent.velocity += zipdest.normalized() * delta * (_camera.hook_ray.cast_to.length() - zip_target.length() + 1) * zip_speed
	_parent.physics_process(delta)
	if owner.get_slide_count() > 0:
		if Input.is_action_pressed("action"):
			_parent.velocity = Vector3(0, 0, 0)
			_state_machine.transition_to("Move/Hang")
		else:
			_parent.velocity = Vector3(0, 0, 0)
			_state_machine.transition_to("Move/Air")


func enter(msg: Dictionary = {}) -> void:
	if "zip_target" in msg:
		zip_target = msg.zip_target 
		_parent.enter()
	else:
		_state_machine.transition_to("Move/Idle")


func exit() -> void:
	zip_target = Vector3(0, 0, 0)
	_parent.exit()
