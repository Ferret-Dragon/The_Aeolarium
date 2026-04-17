extends Polygon2D

@export var flicker_speed_min: float = 0.05
@export var flicker_speed_max: float = 1.0
@export var base_max_alpha: float = 0.05  # max opacity when power is full
@export var fade_speed: float = 4.0      # how fast it fades in/out

var flicker_timer: float = 0.0
var current_interval: float = 0.1
var target_alpha: float = 0.0

func _ready() -> void:
	modulate.a = 0.0

func _process(delta: float) -> void:
	flicker_timer += delta

	if flicker_timer >= current_interval:
		flicker_timer = 0.0
		current_interval = randf_range(flicker_speed_min, flicker_speed_max)
		_pick_target_alpha()

	# Smoothly move current alpha toward target
	modulate.a = move_toward(modulate.a, target_alpha, fade_speed * delta)

func _pick_target_alpha() -> void:
	var power: float = clampf(Global.ship_power, 0.0, 1.0)

	# As power drops, the ceiling for how opaque darkness can get rises
	var max_alpha: float = lerpf(1.0, base_max_alpha, power)

	# Randomly pick a target anywhere from 0 to that ceiling
	target_alpha = randf() * max_alpha
