extends Node

@export var player: Node2D
var current_room: String = ""
var room_walls: Dictionary = {}

# ----------------------------
# CONSTANTS
# ----------------------------
const VERY_FRONT = 100
const VERY_BACK = 0

const Z_BEHIND_WALLS = 2
const Z_INFRONT_WALLS = 6

# ----------------------------
# AREA → PLAYER Z MAPPING
# ----------------------------
var area_z_map := {
	"back_ship": 10,
	"rooms_r2": 8,
	"lounge": 6,
	"rooms_l1": 4,
	"front_ship": 2
}

# Door config — maps room name to which door to hide
var door_map := {
	"Room_bedroom": "b_door",
	"Room_office":  "o_door",
	"Room_kitchen": "k_door",
	"Room_animals": "a_door"
}

# Track overlapping areas safely
var active_areas: Array[Area2D] = []

# Node references
@onready var tiers_node = $Tiers
@onready var areas_node = $AreaLayers
@onready var doors_node = $Doors  # adjust path if Doors is nested differently

# ----------------------------
# READY
# ----------------------------
func _ready():
	_setup_tiers()
	_connect_areas()
	_update_door_z()
	for room in get_children():
		if room is Area2D:
			room.body_entered.connect(_on_room_entered.bind(room.name))
			room.body_exited.connect(_on_room_exited.bind(room.name))

# ----------------------------
# SETUP TIERS (t1 → t9)
# ----------------------------
func _setup_tiers():
	var tiers = tiers_node.get_children()
	# Sort numerically (t1, t2, ..., t9)
	tiers.sort_custom(func(a, b):
		return int(a.name.substr(1)) < int(b.name.substr(1))
	)
	# Assign z-index (t1 front → t9 back)
	for i in range(tiers.size()):
		var tier = tiers[i]
		var z_value = VERY_FRONT - i
		tier.z_index = z_value

# ----------------------------
# CONNECT AREA SIGNALS
# ----------------------------
func _connect_areas():
	for area in areas_node.get_children():
		if area is Area2D:
			area.body_entered.connect(_on_body_entered.bind(area))
			area.body_exited.connect(_on_body_exited.bind(area))

# ----------------------------
# AREA ENTER
# ----------------------------
func _on_body_entered(body: Node2D, area: Area2D):
	if body != player:
		return
	if area not in active_areas:
		active_areas.append(area)
	_update_player_z()

# ----------------------------
# AREA EXIT
# ----------------------------
func _on_body_exited(body: Node2D, area: Area2D):
	if body != player:
		return
	active_areas.erase(area)
	_update_player_z()

# ----------------------------
# ROOM ENTER
# ----------------------------
func _on_room_entered(body: Node, room_name: String) -> void:
	if body.name != "Player_Character":
		return
	current_room = room_name
	print("Player entered: ", current_room)

	# Hide the door for this room
	if room_name in door_map:
		var door_name = door_map[room_name]
		var door = doors_node.get_node_or_null(door_name)
		if door:
			door.visible = false

	_update_door_z()

# ----------------------------
# ROOM EXIT
# ----------------------------
func _on_room_exited(body: Node, room_name: String) -> void:
	if body.name != "Player_Character":
		return
	current_room = "Room_hall"
	print("Player left: ", room_name)

	# Restore the door for the room we just left
	if room_name in door_map:
		var door_name = door_map[room_name]
		var door = doors_node.get_node_or_null(door_name)
		if door:
			door.visible = true

	var data = room_walls.get(room_name, {})
	for wall in data.get("hide", []):
		wall.visible = true

	_update_door_z()

# ----------------------------
# UPDATE DOOR Z-INDEX
# ----------------------------
func _update_door_z():
	var b_door = doors_node.get_node_or_null("b_door")
	var o_door = doors_node.get_node_or_null("o_door")
	var k_door = doors_node.get_node_or_null("k_door")
	var a_door = doors_node.get_node_or_null("a_door")

	# b and o: always in front of walls
	if b_door: b_door.z_index = Z_INFRONT_WALLS
	if o_door: o_door.z_index = Z_INFRONT_WALLS

	# k and a: always behind walls
	if k_door: k_door.z_index = Z_BEHIND_WALLS
	if a_door: a_door.z_index = Z_BEHIND_WALLS

# ----------------------------
# UPDATE PLAYER Z-INDEX
# ----------------------------
func _update_player_z():
	if active_areas.is_empty():
		return
	var best_z = VERY_BACK
	for area in active_areas:
		if area.name in area_z_map:
			print("Player in: ", area.name)
			var z = area_z_map[area.name]
			if z > best_z:
				best_z = z
	player.z_index = best_z
