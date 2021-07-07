tool
extends Spatial

onready var viewport = get_node("Viewport")
onready var surface_mesh = get_node("SurfaceMesh")
onready var origin = viewport.get_node("Origin")
onready var param_mesh = viewport.get_node("Origin/ParamMesh")

export var mesh : Mesh setget set_mesh, get_mesh
var _mesh : Mesh

export var radius : float = 0.1 setget set_radius, get_radius
var _radius : float = 0.1

export var map_resolution : int = 1024 setget set_map_resolution, get_map_resolution
var _map_resolution : int = 1024

var map : ViewportTexture setget , get_map

func _ready():
	set_notify_transform(true)
	set_mesh(_mesh)
	set_radius(_radius)
	set_map_resolution(_map_resolution)
	param_mesh.material_override.set_shader_param("position", get_global_transform().origin)
	render_map()

func _notification(what):
	if what == Spatial.NOTIFICATION_TRANSFORM_CHANGED:
		param_mesh.material_override.set_shader_param("position", get_global_transform().origin)
		render_map()

func set_radius(p_radius):
	_radius = max(p_radius, 0.0)
	surface_mesh.material_override.next_pass.set_shader_param("radius", _radius)
	param_mesh.material_override.set_shader_param("max_dist", _radius)
	render_map()

func get_radius():
	return _radius

func show_radius():
	surface_mesh.material_override.next_pass.set_shader_param("visible", true)

func hide_radius():
	surface_mesh.material_override.next_pass.set_shader_param("visible", false)

func set_map_resolution(p_resolution):
	_map_resolution = max(p_resolution, 0)
	if is_inside_tree():
		viewport.size = Vector2(_map_resolution, _map_resolution)
		render_map()

func get_map_resolution():
	return _map_resolution

func set_mesh(p_mesh):
	_mesh = p_mesh
	if is_inside_tree():
		surface_mesh.mesh = _mesh
		param_mesh.mesh = _mesh
		get_node("Area/CollisionShape").shape = _mesh.create_convex_shape()
		render_map()

func get_mesh():
	return _mesh

func get_map() -> ViewportTexture:
	return viewport.get_texture()

func render_map():
	viewport.set_update_mode(Viewport.UPDATE_ONCE)

func is_selected():
	return get_parent().selection == self

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if is_selected():
					set_radius(get_radius() + 0.005)

			if event.button_index == BUTTON_WHEEL_DOWN:
				if is_selected():
					set_radius(get_radius() - 0.005)
