extends Node

const DRAIN_RATE_LIZ: float = 1.7
const DRAIN_RATE_RAT: float = 5.3
const MIN_CONTENTMENT: float = 0.0

var escape_check_timer: float = 0.0
var escape_check_interval: float = 10.0

func _process(delta):
	Global.lizard_contentment = max(MIN_CONTENTMENT, Global.lizard_contentment - DRAIN_RATE_LIZ * delta)
	Global.pomrat_contentment = max(MIN_CONTENTMENT, Global.pomrat_contentment - DRAIN_RATE_RAT * delta)

	escape_check_timer += delta
	if escape_check_timer >= escape_check_interval:
		escape_check_timer = 0.0
		if not Global.lizard_escaped:
			_check_escape("lizard", Global.lizard_contentment)
		if not Global.pomrat_escaped:
			_check_escape("pomrat", Global.pomrat_contentment)

	_check_recapture()

func _check_escape(animal: String, contentment: float):
	var escape_chance = (1.0 - (contentment / 100.0)) * 0.5
	var roll = randf()
	if roll < escape_chance:
		_trigger_escape(animal)

func _trigger_escape(animal: String):
	print(animal, " is escaping!")
	if animal == "lizard":
		Global.lizard_escaped = true
	elif animal == "pomrat":
		Global.pomrat_escaped = true

	if Global.music:
		Global.music.play_malfunction()

func _check_recapture():
	if not Global.lizard_escaped and not Global.pomrat_escaped:
		if Global.music:
			Global.music.play_normal()
