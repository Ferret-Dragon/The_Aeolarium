extends Sprite2D
func _ready():
	var area = $Area2D
	area.input_pickable = true
	area.connect("input_event", _on_input_event)
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Global.inventory.has(name):
				Global.inventory = []
			else:
				Global.inventory = [name]
