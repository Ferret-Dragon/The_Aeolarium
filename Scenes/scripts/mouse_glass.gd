extends TileMapLayer

func _ready():
	var area = $StaticBody2D
	area.input_pickable = true
	area.connect("input_event", _on_input_event)
	Global.connect("pomrat_escaped_changed", _update_collision)
	
func _process(delta):
	_update_collision()

func _update_collision():
	var colllision_area = $StaticBody2D/CollisionPolygon2D
	if Global.pomrat_escaped:
		colllision_area.disabled = true
	else:
		colllision_area.disabled = false

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Global.inventory.has("pomrat_food"):
				Global.inventory = []
				Global.pomrat_contentment = 100
