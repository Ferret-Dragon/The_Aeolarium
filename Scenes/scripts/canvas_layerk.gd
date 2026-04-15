extends CanvasLayer

@export var parallax_strength: float = 10.0
@export var smoothing: float = 3.0

func _process(delta: float) -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	var normalized = (mouse_pos / viewport_size - Vector2(0.5, 0.5)) * 2.0
	var target_offset = normalized * parallax_strength
	
	offset = lerp(offset, target_offset, smoothing * delta)
