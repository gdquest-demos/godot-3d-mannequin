extends Spatial
class_name SkinMannequiny
"""
Controls the animation tree's transitions for this animated character.

It has a signal connected to the player state machine, and uses the resulting
state names to translate them into the states for the animation tree.
"""


onready var animation_tree: AnimationTree = $AnimationTree

var player_direction: = Vector3.ZERO

onready var _playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]


func _ready() -> void:
	animation_tree.active = true


func _on_StateMachine_transitioned(state_name) -> void:
	_change_animation(state_name)


func _physics_process(delta: float) -> void:
	match _playback.get_current_node():
		"move_ground":
			animation_tree["parameters/move_ground/blend_position"] = player_direction.length()
	


"""
Callback to automatically change the animation when the 
player changes state.
"""
func _change_animation(state_name: String) -> void:
	var node: = state_name.split("/")[-1].to_lower()
	match node:
		"idle":
			_playback.travel("idle")
			animation_tree["parameters/conditions/is_moving"] = false
		"run":
			_playback.travel("move_ground")
			animation_tree["parameters/conditions/is_moving"] = true
		"air":
			_playback.travel("jump")
			animation_tree["parameters/conditions/is_moving"] = true
		_:
			_playback.travel("idle")


func _on_Move_direction_changed(move_direction) -> void:
	player_direction = move_direction
