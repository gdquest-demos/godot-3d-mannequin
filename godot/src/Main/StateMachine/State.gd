extends Node
class_name State
# State interface to use in Hierarchical State Machines. The lowest leaf tries
# to handle callbacks, and if it can't, it delegates the work to its parent.
#
# It's up to the user to call the parent state's functions, e.g.
# `_parent.physics_process(delta)`
#
# Use State as a child of a StateMachine node.

onready var _state_machine := _get_state_machine(self)

# Using the same class, i.e. State, as a type hint causes a memory leak in Godot
# 3.2.
var _parent = null


func _ready() -> void:
	yield(owner, "ready")
	var parent = get_parent()
	if not parent.is_in_group("state_machine"):
		_parent = parent


func unhandled_input(event: InputEvent) -> void:
	pass


func process(delta: float) -> void:
	pass


func physics_process(delta: float) -> void:
	pass


func enter(msg := {}) -> void:
	pass


func exit() -> void:
	pass


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
