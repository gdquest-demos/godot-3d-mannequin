extends State
class_name PlayerState


var player: Player
var skin: SkinMannequiny


func _ready() -> void:
	yield(owner, "ready")
	player = owner
	skin = owner.skin
