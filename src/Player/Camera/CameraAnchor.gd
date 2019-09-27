extends Spatial


onready var camera: Camera = $Camera
onready var initial_position: = camera.translation
onready var initial_anchor_position: = translation

onready var rotate_delay: Timer = $RotateDelay
onready var occlusion_ray: RayCast = $OcclusionRay
onready var hook_ray: RayCast = $HookRay
onready var hook_target: Sprite3D = $HookTarget


func _ready() -> void:
	set_as_toplevel(true)
	occlusion_ray.set_cast_to(initial_position)



