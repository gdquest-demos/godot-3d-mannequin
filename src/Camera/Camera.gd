extends Spatial
"""
Simple accessor class to let the nodes in the Camera scene access the player
or some frequently used nodes in the scene itself caching the call to get_node
"""


signal aim_fired(target_vector)

onready var camera_state: State = $StateMachine/Camera
onready var aim_ray: RayCast = get_node("AimRay")

var player: Player


func _ready() -> void:
	player = get_tree().root.find_node("Player", true, false)
	assert(player)