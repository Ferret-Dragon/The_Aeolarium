extends CharacterBody2D

var segments: Array = []
var segment_history: Array = []
var history_length: int = 20
@export var segment_distance: int = 0

@export var move_speed: float = 120.0
var wander_target: Vector2

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	segments.append($tail_segment_1)
	segments.append($tail_segment_1/tail_segment_2)
	segments.append($tail_segment_1/tail_segment_2/tail_segment_3)

	for i in range(history_length):
		segment_history.append(global_position)

	_pick_new_wander_target()

	anim_sprite.play("default")


func _physics_process(delta):
	if Global.lizard_escaped:
		_wander(delta)
	else:
		_follow_normal()

func _update_tail():
	segment_history.insert(0, global_position)

	if segment_history.size() > history_length:
		segment_history.pop_back()

	for i in range(segments.size()):
		var index = (i + 1) * segment_distance

		if index < segment_history.size():
			segments[i].global_position = segment_history[index]

			if index > 0:
				var ahead = segment_history[index - 1]
				segments[i].rotation = (ahead - segments[i].global_position).angle()
# ----------------------------
# NORMAL FOLLOW MODE
# ----------------------------
func _follow_normal():
	segment_history.insert(0, global_position)

	if segment_history.size() > history_length:
		segment_history.pop_back()

	for i in range(segments.size()):
		var index = (i + 1) * segment_distance
		if index < segment_history.size():
			segments[i].global_position = segment_history[index]

			if index > 0:
				var ahead = segment_history[index - 1]
				segments[i].rotation = (ahead - segments[i].global_position).angle()

	# Flip sprite
	if velocity.x != 0:
		anim_sprite.flip_h = velocity.x < 0
		_update_tail()

# ----------------------------
# ESCAPE / WANDER MODE
# ----------------------------
func _wander(delta):
	# move toward target
	var direction = (wander_target - global_position)

	if direction.length() < 10:
		_pick_new_wander_target()
		direction = (wander_target - global_position)

	velocity = direction.normalized() * move_speed
	move_and_slide()

	# record movement for tail
	segment_history.insert(0, global_position)

	if segment_history.size() > history_length:
		segment_history.pop_back()

	for i in range(segments.size()):
		var index = (i + 1) * segment_distance
		if index < segment_history.size():
			segments[i].global_position = segment_history[index]

			if index > 0:
				var ahead = segment_history[index - 1]
				segments[i].rotation = (ahead - segments[i].global_position).angle()

	# Flip sprite
	if velocity.x != 0:
		anim_sprite.flip_h = velocity.x < 0
		_update_tail()


# ----------------------------
# RANDOM TARGET PICKING
# ----------------------------
func _pick_new_wander_target():
	var radius = 200  # adjust based on room size
	var offset = Vector2(
		randf_range(-radius, radius),
		randf_range(-radius, radius)
	)

	wander_target = global_position + offset
