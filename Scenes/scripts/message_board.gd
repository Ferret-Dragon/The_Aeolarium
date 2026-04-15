extends PanelContainer

@onready var message_list = $VBoxContainer/MessageList

const SLIDE_SPEED = 885.0
const VISIBLE_X = 860.0
const HIDDEN_X = 1300.0

var sci_font = preload("res://Assets/Fonts/Solid-Mono.ttf")
var target_x: float = HIDDEN_X
var active_messages: Dictionary = {}

const THRESHOLD = 30.0

var bars = {
	"Health":     { "get": func(): return Global.health,             "max": 100.0 },
	"Energy":     { "get": func(): return Global.energy,             "max": 100.0 },
	"Ship Power": { "get": func(): return Global.ship_power,         "max": 100.0 },
	"Lizard":     { "get": func(): return Global.lizard_contentment, "max": 100.0 },
	"Pomrat":     { "get": func(): return Global.pomrat_contentment, "max": 100.0 },
}

var messages = {
	"Health":     " ! Health low !",
	"Energy":     " ! Energy critical !",
	"Ship Power": " ! Ship power low !",
	"Lizard":     " ! Lizard unsettled !",
	"Pomrat":     " ! Pomrat restless !",
}

var tips = {
	"Health":     "Get some rest to revitalize",
	"Energy":     "Head to the kitchen for some food",
	"Ship Power": "Find ways to reduce power usage",
	"Lizard":     "Lizard is getting restless. Attend before escape.",
	"Pomrat":     "Pomrat is getting restless. Attend before escape.",
}

func _process(delta):
	_check_bars()
	_slide(delta)

func _check_bars():
	for bar_name in bars:
		var value = bars[bar_name]["get"].call()
		var max_val = bars[bar_name]["max"]
		var percent = (value / max_val) * 100.0
		if percent < THRESHOLD:
			_add_message(bar_name, messages[bar_name], 1, 0.4, 0.4)
			_add_message(bar_name + "_tip", tips[bar_name], 0.9, 0.7, 0.4)
		else:
			_remove_message(bar_name)
			_remove_message(bar_name + "_tip")

func _add_message(key: String, text: String, r: float, g: float, b: float):
	if active_messages.has(key):
		return
	var label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", Color(r, g, b))
	label.add_theme_font_override("font", sci_font)
	label.add_theme_font_size_override("font_size", 12)
	message_list.add_child(label)
	active_messages[key] = label
	target_x = VISIBLE_X

func _remove_message(key: String):
	if not active_messages.has(key):
		return
	active_messages[key].queue_free()
	active_messages.erase(key)
	if active_messages.is_empty():
		target_x = HIDDEN_X

func _slide(delta):
	position.x = move_toward(position.x, target_x, SLIDE_SPEED * delta)
