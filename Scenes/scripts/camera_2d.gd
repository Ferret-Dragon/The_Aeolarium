extends Camera2D

@export var player: Node2D
@export var peek_strength: float = 0.2 # 0.0 to 1.0
@export var smooth_speed: float = 5.0

func _process(delta):
	if not player: return
	
	# Get mouse position relative to center of screen
	var mouse_pos = get_local_mouse_position()
	
	# Calculate target offset based on strength
	var target_offset = mouse_pos * peek_strength
	
	# Smoothly move to the target offset
	offset = offset.lerp(target_offset, smooth_speed * delta)
