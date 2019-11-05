extends KinematicBody
class_name Player


var camera: Camera


func _ready() -> void:
	camera = get_tree().root.find_node("Camera", true, false)
	assert(camera)