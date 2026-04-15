extends Node
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
var light_value: float = 1.2

# Player stats
var health: float = 100.0
var energy: float = 100.0
var player_position: Vector2 = Vector2.ZERO
var player_position_saved: bool = false

# Power
var ship_power: float = 100.0
var max_ship_power: float = 100.0

# Steam regenerates power over time
var steam_pressure: float = 100.0
var max_steam_pressure: float = 100.0

# Animal contentment (0 = unhappy, 100 = content)
var lizard_contentment: float = 100.0
var pomrat_contentment: float = 100.0

# Whether animals have escaped
signal lizard_escaped_changed

var lizard_escaped: bool = false:
	set(value):
		lizard_escaped = value
		emit_signal("lizard_escaped_changed")
signal pomrat_escaped_changed

var pomrat_escaped: bool = false:
	set(value):
		pomrat_escaped = value
		emit_signal("pomrat_escaped_changed")

# Inventory init
signal inventory_changed
var _inventory: Array = []
var inventory: Array:
	get:
		return _inventory
	set(value):
		_inventory = value
		emit_signal("inventory_changed")
