extends Node

const DRAIN_RATE_LIZ: float = 10#.08
const DRAIN_RATE_RAT: float = 20#.5

const MIN_CONTENTMENT: float = 0.0

var escape_check_timer: float = 0.0
var escape_check_interval: float = 5.0  # check for escape every 5 seconds

func _process(delta):
	# Drain contentment over time
	Global.lizard_contentment = max(MIN_CONTENTMENT, Global.lizard_contentment - DRAIN_RATE_LIZ * delta)
	Global.pomrat_contentment = max(MIN_CONTENTMENT, Global.pomrat_contentment - DRAIN_RATE_RAT * delta)

	# Check escape on interval rather than every frame
	escape_check_timer += delta
	if escape_check_timer >= escape_check_interval:
		escape_check_timer = 0.0
		_check_escape("lizard", Global.lizard_contentment)
		_check_escape("pomrat", Global.pomrat_contentment)

func _check_escape(animal: String, contentment: float):
	# Higher contentment = lower escape chance
	# At 100 contentment: 0% chance
	# At 50 contentment:  25% chance
	# At 0 contentment:   50% chance
	var escape_chance = (1.0 - (contentment / 100.0)) * 0.5

	var roll = randf()  # random number between 0.0 and 1.0
	#print(animal, " escape chance: ", snappedf(escape_chance * 100, 0.1), "% | rolled: ", snappedf(roll, 0.01))

	if roll < escape_chance:
		_trigger_escape(animal)

func _trigger_escape(animal: String):
	print(animal, " is escaping!")
	if animal == "lizard":
		Global.lizard_escaped = true
	elif animal == "pomrat":
		Global.pomrat_escaped = true
