extends CharacterBody2D

const SPEED = 100.0
const WANDER_INTERVAL_MIN = 0.01
const WANDER_INTERVAL_MAX = 0.7

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var detection_area: Area2D = $Area2D

var _ready_complete := false
var _wandering := false
var home_pos = Vector2(278, 250.55)
var exit_pos = Vector2(400, 150)

func _ready() -> void:
	set_physics_process(false)
	await get_tree().physics_frame
	await get_tree().physics_frame
	var map := get_world_2d().navigation_map
	nav_agent.path_desired_distance = 5.0
	nav_agent.target_desired_distance = 30.0
	timer.wait_time = randf_range(WANDER_INTERVAL_MIN, WANDER_INTERVAL_MAX)
	timer.timeout.connect(_pick_new_target)
	detection_area.body_entered.connect(_on_body_entered)
	_ready_complete = true

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		anim.play("default")
		return
	var next_pos := nav_agent.get_next_path_position()
	var direction := (next_pos - global_position).normalized()
	velocity = direction * SPEED
	move_and_slide()
	if direction.x != 0:
		anim.flip_h = direction.x < 0
	anim.play("default")

func _pick_new_target() -> void:
	if not _wandering:
		return
	var map := get_world_2d().navigation_map
	var random_point := NavigationServer2D.map_get_random_point(map, 1, false)
	nav_agent.target_position = random_point
	await get_tree().physics_frame
	timer.wait_time = randf_range(WANDER_INTERVAL_MIN, WANDER_INTERVAL_MAX)
	timer.start()

func _go_home() -> void:
	_wandering = false
	timer.stop()
	nav_agent.target_position = home_pos

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player_Character":
		Global.pomrat_escaped = false
		_go_home()

func start_wandering() -> void:
	if not _ready_complete:
		await get_tree().physics_frame
		await get_tree().physics_frame
	set_physics_process(true)
	_wandering = true
	position = exit_pos
	_pick_new_target()
