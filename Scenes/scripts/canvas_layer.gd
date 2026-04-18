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
	
const STEAM_REGEN_RATE: float = 2.0
const STEAM_TO_POWER_RATE: float = 3.0
const LIGHT_DRAIN_MAX: float = 3.0
const BASE_DRAIN: float = 2.0

@onready var canvas_modulate = get_tree().get_first_node_in_group("canvas_modulate")

func _process(delta):
	health_bar.value = Global.health
	energy_bar.value = Global.energy
	ship_bar.value = Global.ship_power
	lizard_bar.value = Global.lizard_contentment
	pomrat_bar.value = Global.pomrat_contentment
	_danger_check(delta)
	_regen_steam(delta)
	_drain_power(delta)


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

func _danger_check(delta):
	var liz_flag = $Control/BottomBar/LizardPanel/VBoxContainer/danger
	var pom_flag = $Control/BottomBar/PomratPanel/VBoxContainer/danger
	if Global.lizard_escaped:
		liz_flag.visible = true
	else:
		liz_flag.visible = false
	if Global.pomrat_escaped:
		pom_flag.visible = true
	else:
		pom_flag.visible = false
