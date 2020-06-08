tool
extends Control
# Displays the values of properties of a given node
# You can directly change the `properties` property to display multiple values from the `reference` node
# E.g. properties = PoolStringArray(['speed', 'position', 'modulate'])

export var reference_path: NodePath
export var properties: PoolStringArray setget set_properties
export var round_decimals := 2

onready var _container: VBoxContainer = $VBoxContainer/MarginContainer/VBoxContainer
onready var _title: Label = $VBoxContainer/ReferenceName
onready var reference: Node = get_node(reference_path) setget set_reference

var _step := 1.0 / pow(10, round_decimals)


func _ready() -> void:
	if not reference:
		return
	_setup()


func _process(delta) -> void:
	_update()


func _setup() -> void:
	_clear()
	_title.text = reference.name
	for property in properties:
		track(property)


func _get_configuration_warning() -> String:
	return "" if not reference_path.is_empty() else "Reference Path should not be empty."


func track(property: String) -> void:
	var label := Label.new()
	label.autowrap = true
	label.name = property.capitalize()
	_container.add_child(label)
	if not property in properties:
		properties.append(property)


func _clear() -> void:
	for property_label in _container.get_children():
		property_label.queue_free()


func _update() -> void:
	if Engine.editor_hint:
		return
	var search_array: Array = properties
	for property in properties:
		var value = reference.get(property)
		var label: Label = _container.get_child(search_array.find(property))
		var text := ""
		if value is float:
			text = str(stepify(value, _step))
		if value is Vector2:
			text = "(%s %s)" % [stepify(value.x, _step), stepify(value.y, _step)]
		elif value is Vector3:
			text = get_vector3_as_string(value)
		elif value is Transform:
			var elements: PoolStringArray = [
				get_vector3_as_string(value.basis.x),
				get_vector3_as_string(value.basis.y),
				get_vector3_as_string(value.basis.z),
				get_vector3_as_string(value.origin)
			]
			text = elements.join("\n")
		else:
			text = str(value)
		label.text = "%s: %s" % [property.capitalize(), text]


func get_vector2_as_string(vector: Vector2) -> String:
	return "(%s %s)" % [stepify(vector.x, _step), stepify(vector.y, _step)]


func get_vector3_as_string(vector: Vector3) -> String:
	return (
		"(%s %s %s)"
		% [stepify(vector.x, _step), stepify(vector.y, _step), stepify(vector.z, _step)]
	)


func set_properties(value: PoolStringArray) -> void:
	properties = value
	if not reference:
		return
	_setup()


func set_reference(value: Node) -> void:
	reference = value
	if reference:
		_setup()
