extends KinematicBody
class_name Player
"""
Helper class for the Player scene's scripts to be able to have access to the
camera and its orientation.
"""


var camera: Spatial


func _ready() -> void:
	camera = get_tree().root.find_node("CameraAnchor", true, false)
	assert(camera)