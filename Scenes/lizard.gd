extends CharacterBody2D

var segments: Array = []
var segment_history: Array = []
var history_length: int = 20

@export var segment_distance: int = 0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	segments.append($tail_segment_1)
	segments.append($tail_segment_1/tail_segment_2)
	segments.append($tail_segment_1/tail_segment_2/tail_segment_3)
	for i in range(history_length):
		segment_history.append(global_position)
	anim_sprite.play("default")

func _physics_process(_delta):
	_update_tail()

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
