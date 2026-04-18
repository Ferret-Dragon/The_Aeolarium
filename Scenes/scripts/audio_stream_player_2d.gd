extends AudioStreamPlayer

@export var normal_track: AudioStream = preload("res://Assets/Audio/JDSherbert - Ambiences Music Pack - Cosmic Star.mp3")
@export var malfunction_track: AudioStream = preload("res://Assets/Audio/malfunction.ogg")

func _ready() -> void:
	Global.music = self
	stream = normal_track
	play()

func _process(delta: float) -> void:
	if not playing:
		play()

func play_normal() -> void:
	if stream != normal_track:
		stream = normal_track
		play()

func play_malfunction() -> void:
	if stream != malfunction_track:
		stream = malfunction_track
		play()
