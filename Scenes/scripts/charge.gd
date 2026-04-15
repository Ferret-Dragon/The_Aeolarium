extends Node2D

# --- Config ---
const PLAYER_SPEED = 300.0
const COIN_RADIUS = 10.0
const SPAWN_INTERVAL = 2.0   # seconds between new coins
const MAX_COINS = 15

# --- State ---
var score = 0

# --- Node refs ---
@onready var player = $shipcon
@onready var coins_container = $Coins
@onready var score_label = $ScoreLabel
@onready var coin_timer = $CoinTimer

func _ready():
	# Style the score label
	score_label.position = Vector2(16, 16)
	score_label.add_theme_font_size_override("font_size", 28)
	update_score_display()

	# Start the repeating spawn timer
	coin_timer.wait_time = SPAWN_INTERVAL
	coin_timer.timeout.connect(_spawn_coin)
	coin_timer.start()

	# Spawn a handful of coins right away
	for i in 8:
		_spawn_coin()

# ─────────────────────────────────────────
# PLAYER MOVEMENT
# ─────────────────────────────────────────
func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	player.velocity = direction * PLAYER_SPEED
	player.move_and_slide()

	# Keep player on screen
	var screen = get_viewport_rect().size
	player.position = player.position.clamp(Vector2.ZERO, screen)

	# Check coin collisions every frame
	_check_coin_collection()

# ─────────────────────────────────────────
# COIN SPAWNING
# ─────────────────────────────────────────
func _spawn_coin():
	if coins_container.get_child_count() >= MAX_COINS:
		return  # don't exceed the cap

	var screen = get_viewport_rect().size
	var coin = _make_coin()
	coin.position = Vector2(
		randf_range(COIN_RADIUS, screen.x - COIN_RADIUS),
		randf_range(COIN_RADIUS, screen.y - COIN_RADIUS)
	)
	coins_container.add_child(coin)

@onready var coin_template = $Coins/CoinTemplate

func _make_coin() -> Node2D:
	var coin = Node2D.new()
	coin.set_meta("is_coin", true)
	
	# Duplicate the AnimatedSprite2D from the template
	var sprite = coin_template.duplicate()
	sprite.visible = true
	sprite.play("default")  # replace "default" with your animation name
	coin.add_child(sprite)
	
	return coin

func _coin_draw_script() -> GDScript:
	var s = GDScript.new()
	s.source_code = """
extends Node2D
func _draw():
    draw_circle(Vector2.ZERO, 12.0, Color.GOLD)
    draw_arc(Vector2.ZERO, 12.0, 0, TAU, 32, Color.ORANGE, 2.0)
"""
	s.reload()
	return s

# ─────────────────────────────────────────
# COLLISION & SCORE
# ─────────────────────────────────────────
func _check_coin_collection():
	for coin in coins_container.get_children():
		var dist = player.position.distance_to(coin.position)
		if dist < COIN_RADIUS + 20.0:  # 20 = rough player radius
			coin.queue_free()
			_add_score(1)

func _add_score(amount: int):
	score += amount
	update_score_display()

func update_score_display():
	score_label.text = "Score: %d" % score
