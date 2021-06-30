extends Spatial

var selection = null

func _ready():
	select_target(get_node("ProbeSphere"))

func select_target(target):
	get_node("../../../MapView").texture = target.get_node("Viewport").get_texture()
	selection = target
	get_node("Radius").global_transform.origin = target.global_transform.origin
	get_node("Radius").mesh.radius = 0.1 + target.distance
	get_node("Radius").mesh.height = 2.0 * get_node("Radius").mesh.radius

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var camera = get_viewport().get_camera()
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 999.9

		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to, [], 2147483647, false, true)
		
		if result:
			select_target(result.collider.get_parent())

