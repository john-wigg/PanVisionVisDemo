extends Spatial

signal selection_changed

var selection = null

func select_target(target):
	get_node("../../../MapView").texture = target.get_map()
	if selection:
		selection.hide_radius()
	target.show_radius()
	selection = target

	emit_signal("selection_changed")

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var camera = get_viewport().get_camera()
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 999.9

		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to, [], 2147483647, false, true)
		
		if result:
			select_target(result.collider.get_parent())

