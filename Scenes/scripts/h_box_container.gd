extends HBoxContainer

func _ready():
	Global.inventory_changed.connect(_refresh)

func _refresh():
	for child in get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	var parent_height = size.y
	
	for item_name in Global.inventory:
		var texture_rect = TextureRect.new()
		texture_rect.texture = load("res://Assets/Items/" + item_name + ".png")
		
		texture_rect.custom_minimum_size = Vector2(parent_height, parent_height)
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		add_child(texture_rect)
