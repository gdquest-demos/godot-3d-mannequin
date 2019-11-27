extends Sprite3D


func _ready() -> void:
	set_as_toplevel(true)


func update(ray: RayCast) -> void:
	ray.force_raycast_update()

	if ray.is_colliding():
		var collision_point: = ray.get_collision_point()
		global_transform.origin = collision_point
		look_at(collision_point - ray.get_collision_normal(), global_transform.basis.y.normalized())
		visible = true
	else:
		visible = false
