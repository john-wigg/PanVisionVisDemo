tool
extends MeshInstance

export var distance: float setget set_distance, get_distance
var _distance: float = 0.1

func _enter_tree():
	set_distance(_distance)

func set_distance(p_distance):
	_distance = max(p_distance, 0.0)
	if is_inside_tree():
		get_parent().get_node("Radius").mesh.radius = 0.1 + _distance
		get_parent().get_node("Radius").mesh.height = 2.0 * get_parent().get_node("Radius").mesh.radius
		get_node("Viewport/ColorRect").material.set_shader_param("max_dist", _distance)
	
func get_distance():
	return _distance

func _ready():
	get_node("Area").connect("input_event", self, "_on_input_event")

func _process(delta):
	get_node("Viewport/ColorRect").material.set_shader_param("position", get_global_transform().origin)

func is_selected():
	return get_parent().selection == self

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				if is_selected():
					set_distance(get_distance() + 0.005)
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				if is_selected():
					set_distance(get_distance() - 0.005)
