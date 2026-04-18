extends Polygon2D

@export var flicker_speed_min: float = 0.05
@export var flicker_speed_max: float = 1.0
@export var base_max_alpha: float = 0.05
@export var fade_speed: float = 4.0

var flicker_timer: float = 0.0
var current_interval: float = 0.1
var target_alpha: float = 0.0

func _ready() -> void:
	modulate.a = 0.0

func _process(delta: float) -> void:
	var power: float = clampf(Global.ship_power, 0.0, 1.0)

	# At zero power, lock to solid black immediately
	if power == 0.0:
		modulate.a = move_toward(modulate.a, 1.0, fade_speed * delta)
		return

	flicker_timer += delta
	if flicker_timer >= current_interval:
		flicker_timer = 0.0
		# Flicker gets much faster as power drops
		var speed_min = lerpf(flicker_speed_max, flicker_speed_min, 1.0 - power)
		var speed_max = lerpf(flicker_speed_max, flicker_speed_min * 2.0, 1.0 - power)
		current_interval = randf_range(speed_min, speed_max)
		_pick_target_alpha(power)

	modulate.a = move_toward(modulate.a, target_alpha, fade_speed * delta)

func _pick_target_alpha(power: float) -> void:
	var max_alpha: float = lerpf(1.0, base_max_alpha, power)

	# At low power, bias toward higher alpha values (more darkness)
	# pow() with a low exponent skews randf() toward 1.0
	var bias: float = lerpf(0.2, 1.0, power)  # low power = low bias = skews high
	var rand = pow(randf(), bias)

	target_alpha = rand * max_alpha
