tool
extends Spatial
class_name CameraRig
"""
Simple accessor class to let the nodes in the Camera scene access the player
or some frequently used nodes in the scene itself caching the call to get_node
"""


signal aim_fired(target_vector)

onready var camera: InterpolatedCamera = $InterpolatedCamera
onready var spring_arm: SpringArm = $SpringArm
onready var aim_ray: RayCast = $AimRay
onready var aim_target: Sprite3D = $AimTarget

var player: KinematicBody

onready var _position_start: Vector3 = translation

func _ready() -> void:
	set_as_toplevel(true)
	yield(owner, "ready")
	player = owner


func _get_configuration_warning() -> String:
	return "Missing player node" if not player else ""
