extends Node2D

## How far this segment trails behind its target point
@export var segment_length: float = 24.0

## How quickly the segment follows (1.0 = instant, lower = more lag)
@export var follow_speed: float = 10.0

## The world-space position this segment is chasing
var target_position: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	# The target is the parent's global position (i.e. the attachment point above us)
	target_position = get_parent().global_position

	# Direction from this segment toward the target
	var direction: Vector2 = target_position - global_position

	# If we're already close enough, don't snap — keep segment_length distance
	if direction.length() > segment_length:
		global_position = target_position - direction.normalized() * segment_length

	# Smoothly interpolate position for a fleshy, organic feel
	global_position = global_position.lerp(
		target_position - direction.normalized() * segment_length,
		clamp(follow_speed * delta, 0.0, 1.0)
	)

	# Rotate to face the target (point "up" toward the parent)
	rotation = direction.angle() + PI / 2.0
