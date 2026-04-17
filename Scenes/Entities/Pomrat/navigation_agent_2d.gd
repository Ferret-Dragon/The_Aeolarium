extends NavigationAgent2D


func _ready() -> void:
	await get_tree().physics_frame
	var map: RID = get_world_2d().navigation_map
	print("Nav map valid: ", map.is_valid())
	print("Nav map region count: ", NavigationServer2D.map_get_regions(map).size())
