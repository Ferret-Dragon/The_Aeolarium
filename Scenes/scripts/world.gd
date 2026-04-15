extends Node2D

@export var parallax_strength: float = 0.05  # Very subtle, adjust to taste
@export var smoothing: float = 3.0

var target_offset: Vector2 = Vector2.ZERO

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	target_offset = player.global_position * parallax_strength
	global_position = lerp(global_position, target_offset, smoothing * delta)
