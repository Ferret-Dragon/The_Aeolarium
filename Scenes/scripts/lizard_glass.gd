extends TileMapLayer

func _ready():
	var area = $StaticBody2D
	area.input_pickable = true
	area.connect("input_event", _on_input_event)
	Global.connect("lizard_escaped_changed", _update_collision)
	_update_collision()

func _update_collision():
	var area = $StaticBody2D
	if Global.lizard_escaped:
		area.collision_layer = 0
	else:
		area.set_collision_layer_value(1, true)
		area.set_collision_layer_value(2, true)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Global.inventory.has("liz_food"):
				Global.inventory = []
				Global.lizard_contentment = 100
