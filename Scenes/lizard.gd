extends CharacterBody2D

var segments: Array = []
var segment_history: Array = []
var history_length: int = 0

@export var segment_distance: int = 0
@onready var anim_sprite: Sprite2D = $zirelisk

const SPEED = 200.0
const WANDER_INTERVAL_MIN = 1.0
const WANDER_INTERVAL_MAX = 3.7

@onready var anim: AnimatedSprite2D = $zirelisk/AnimatedSprite2D
@onready var mina: Sprite2D = $zirelisk
@onready var timer: Timer = $zirelisk/Timer
@onready var nav_agent: NavigationAgent2D = $zirelisk/NavigationAgent2D
@onready var detection_area: Area2D = $zirelisk/Area2D

var _ready_complete := false
var _wandering := false
var home_pos = Vector2(679.0, 199.179)
var exit_pos = Vector2(400, 150)

func _ready():
	segments.append($zirelisk/tail_segment_1)
	segments.append($zirelisk/tail_segment_1/tail_segment_2)
	segments.append($zirelisk/tail_segment_1/tail_segment_2/tail_segment_3)
	for i in range(history_length):
		segment_history.append(global_position)
	anim.play("default")
	
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
		anim_sprite.flip_h = direction.x > 0  # true = moving right, false = moving left

	anim.play("default")
	_update_tail()
	
func _update_tail():
	segment_history.insert(0, global_position)
	if segment_history.size() > history_length:
		segment_history.pop_back()
	for i in range(segments.size()):
		var index = (i + 1) * segment_distance
		if index < segment_history.size():
			segments[i].global_position = segment_history[index]
			if index > 0:
				var ahead = segment_history[index - 1]
				segments[i].rotation = (ahead - segments[i].global_position).angle()


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
		_go_home()
		Global.lizard_contentment = 100

func start_wandering() -> void:
	if not _ready_complete:
		await get_tree().physics_frame
		await get_tree().physics_frame
	set_physics_process(true)
	_wandering = true
	position = exit_pos
	_pick_new_target()
