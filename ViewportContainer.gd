extends ViewportContainer

onready var viewport = get_node("Viewport")

func _ready():
	set_process_input(true)

func _input(event):
	viewport.input(event)
