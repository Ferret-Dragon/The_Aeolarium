extends HSlider

@onready var light_label = $Label
func _ready():
	value = Global.light_value
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float):
	Global.light_value = new_value
	var display_value = remap(new_value, 0.1, 1.5, 0.1, 1.0)
	light_label.text = "%.2f" % display_value
