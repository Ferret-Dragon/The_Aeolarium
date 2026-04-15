extends TileMapLayer

func _ready():
	var area = $StaticBody2D
	area.input_pickable = true
	area.connect("input_event", _on_input_event)
	if Global.lizard_escaped:
		area.set_collision_layer_value(2, true)
		area.set_collision_layer_value(1, false)
	else:
		area.set_collision_layer_value(1, true)
		area.set_collision_layer_value(2, true)
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Global.inventory.has("liz_food"):
				Global.inventory = []
				Global.lizard_contentment = 100
			else:
				pass
				# That's not lizard food, lizard gets hungry
