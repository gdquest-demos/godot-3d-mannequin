extends Spatial


signal aim_fired(target_vector)

onready var camera_state: State = $StateMachine/Camera
onready var aim_ray: RayCast = get_node("AimRay")

var player: Player


func _ready() -> void:
	player = get_tree().root.find_node("Player", true, false)
	assert(player)