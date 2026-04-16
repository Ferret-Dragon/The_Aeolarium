extends TileMapLayer

func _ready():
	var area = $StaticBody2D
	area.input_pickable = true
	area.connect("input_event", _on_input_event)
	Global.connect("pomrat_escaped_changed", _update_collision)
	_update_collision()  # run once on load in case already escaped

func _update_collision():
	$StaticBody2D/CollisionPolygon2D.disabled = Global.pomrat_escaped

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Global.inventory.has("pomrat_food"):
				Global.inventory = []
				Global.pomrat_contentment = 100
