extends OptionButton

onready var vis = get_node("../../../ViewportContainer/Viewport/3DVis")

func _ready():
	add_item("256 px")
	add_item("512 px")
	add_item("1024 px")
	add_item("2048 px")

	connect("item_selected", self, "_on_item_selected")
	vis.connect("selection_changed", self, "_on_selection_changed")

func _on_item_selected(idx):
	var selection = vis.selection
	if !selection:
		return
	match idx:
		0:
			selection.map_resolution = 256
		1:
			selection.map_resolution = 512
		2:
			selection.map_resolution = 1024
		3:
			selection.map_resolution = 2048

func _on_selection_changed():
	if !vis.selection:
		return
	match vis.selection.map_resolution:
		256:
			select(0)
		512:
			select(1)
		1024:
			select(2)
		2048:
			select(3)