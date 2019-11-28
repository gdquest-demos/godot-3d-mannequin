extends State
class_name CameraState


var camera_rig: CameraRig


func _ready() -> void:
	yield(owner, "ready")
	camera_rig = owner
