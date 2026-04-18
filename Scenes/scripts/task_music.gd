extends AudioStreamPlayer

@export var task_track: AudioStream = preload("res://Assets/Audio/minimum.ogg")

func _ready() -> void:
	stream = task_track
	play()

func _process(delta: float) -> void:
	if not playing:
		play()
