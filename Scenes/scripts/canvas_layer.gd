extends CanvasLayer

@onready var health_bar = $Control/TopBar/HealthPanel/VBoxContainer/HealthBar
@onready var energy_bar = $Control/TopBar/EnergyPanel/VBoxContainer/EnergyBar
@onready var ship_bar = $Control/TopBar/ShipPanel/VBoxContainer/ShipBar
@onready var lizard_bar = $Control/BottomBar/LizardPanel/VBoxContainer/LizardBar
@onready var pomrat_bar = $Control/BottomBar/PomratPanel/VBoxContainer/PomratBar

@export var parallax_strength: float = 10.0
@export var smoothing: float = 3.0

'''func _process(_delta):
	health_bar.value = Global.health
	energy_bar.value = Global.energy
	ship_bar.value = Global.ship_power
	lizard_bar.value = Global.lizard_contentment
	pomrat_bar.value = Global.pomrat_contentment'''
	
const STEAM_REGEN_RATE: float = 5.0
const STEAM_TO_POWER_RATE: float = 3.0
const LIGHT_DRAIN_MAX: float = 3.0
const BASE_DRAIN: float = 1.0

const FLICKER_THRESHOLD: float = 0.10
const BLUE_SHIFT_THRESHOLD: float = 0.30

var flicker_timer: float = 0.0
var is_flickering: bool = false

@onready var canvas_modulate = get_tree().get_first_node_in_group("canvas_modulate")

func _process(delta):
	health_bar.value = Global.health
	energy_bar.value = Global.energy
	ship_bar.value = Global.ship_power
	lizard_bar.value = Global.lizard_contentment
	pomrat_bar.value = Global.pomrat_contentment
	_regen_steam(delta)
	_drain_power(delta)
	_update_light_color()
	_handle_flicker(delta)


func _regen_steam(delta):
	Global.steam_pressure = min(
		Global.max_steam_pressure,
		Global.steam_pressure + STEAM_REGEN_RATE * delta
	)
	var steam_used = min(Global.steam_pressure, STEAM_TO_POWER_RATE * delta)
	Global.steam_pressure -= steam_used
	Global.ship_power = min(Global.max_ship_power, Global.ship_power + steam_used)

func _drain_power(delta):
	var light_drain = lerp(BASE_DRAIN, LIGHT_DRAIN_MAX, Global.light_value)
	Global.ship_power = max(0.0, Global.ship_power - light_drain * delta)

func _update_light_color():
	if canvas_modulate == null:
		return
	var power_ratio = Global.ship_power / Global.max_ship_power

	if power_ratio <= BLUE_SHIFT_THRESHOLD:
		var blue_ratio = 1.0 - (power_ratio / BLUE_SHIFT_THRESHOLD)
		var r = lerp(Global.light_value, Global.light_value * 0.3, blue_ratio)
		var g = lerp(Global.light_value, Global.light_value * 0.5, blue_ratio)
		var b = lerp(Global.light_value, minf(Global.light_value * 1.5, 1.0), blue_ratio)
		canvas_modulate.color = Color(r, g, b)
	else:
		canvas_modulate.color = Color(
			Global.light_value,
			Global.light_value,
			Global.light_value
		)

func _handle_flicker(delta):
	var power_ratio = Global.ship_power / Global.max_ship_power

	if power_ratio > FLICKER_THRESHOLD:
		is_flickering = false
		return

	flicker_timer -= delta
	if flicker_timer <= 0.0:
		is_flickering = !is_flickering
		var urgency = 1.0 - power_ratio
		flicker_timer = randf_range(0.05, 0.4) * (1.0 - urgency * 0.8)

	if canvas_modulate:
		canvas_modulate.color = Color(
			canvas_modulate.color.r * (0.05 if is_flickering else 1.0),
			canvas_modulate.color.g * (0.05 if is_flickering else 1.0),
			canvas_modulate.color.b * (0.05 if is_flickering else 1.0)
		)
