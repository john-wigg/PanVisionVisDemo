extends HSplitContainer

var old_width

func _ready():
	connect("resized", self, "_on_resized")
	old_width = rect_size.x
	split_offset = 0.5 * rect_size.x
	_on_resized()
	
func _on_resized():
	var frac = split_offset / old_width
	split_offset = frac * rect_size.x
	old_width = rect_size.x
