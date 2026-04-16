extends Node2D

@export var move_speed: float = 80.0

var wander_directions: Array = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var current_dir_index: int = 0

var stuck_timer: float = 0.0
var stuck_threshold: float = 0.5
var last_position: Vector2 = Vector2.ZERO

var animal_name: String = ""
var is_escaped: bool = false
var body: Area2D = null

var current_direction: Vector2 = Vector2.ZERO
var direction_timer: float = 0.0
var direction_change_interval: float = 2.0

var room_z_map := {
	"Room_bedroom": -12,
	"Room_office": -8,
	"Room_kitchen": -1,
	"Room_hall_front": 0,
	"Room_hall_back": 1
}
var default_z: int = 3

func _ready() -> void:
	# Find the Area2D child
	for child in get_children():
		if child is Area2D:
			body = child
			break
	
	animal_name = name
	last_position = body.global_position

	current_direction = _pick_random_direction()
	_connect_rooms()

func _process(delta: float) -> void:
	# Escape state
	if animal_name == "lizard":
		is_escaped = Global.lizard_escaped
	elif animal_name == "pomrat":
		is_escaped = Global.pomrat_escaped

	if is_escaped and body != null:
		_wander(delta)

func _pick_random_direction() -> Vector2:
	var angle = randf() * TAU
	return Vector2(cos(angle), sin(angle)).normalized()

func _wander(delta: float) -> void:
	stuck_timer += delta
	direction_timer += delta
	
	# Speed differences
	if animal_name == "lizard":
		move_speed = 60
	elif animal_name == "pomrat":
		move_speed = 90

	var moved = body.global_position.distance_to(last_position)
	var is_stuck = stuck_timer >= stuck_threshold and moved < 2.0

	if is_stuck or direction_timer >= direction_change_interval:
		current_direction = _pick_random_direction()
		stuck_timer = 0.0
		direction_timer = 0.0
		last_position = body.global_position

	body.global_position += current_direction * move_speed * delta

func _connect_rooms():
	for room in get_tree().get_nodes_in_group("rooms"):
		room.body_entered.connect(_on_room_entered.bind(room.name))
		room.body_exited.connect(_on_room_exited.bind(room.name))

func _on_room_entered(body_entered: Node2D, room_name: String):
	if not is_ancestor_of(body_entered):
		return
	z_index = room_z_map.get(room_name, default_z)

func _on_room_exited(body_exited: Node2D, room_name: String):
	if not is_ancestor_of(body_exited):
		return
	z_index = default_z
