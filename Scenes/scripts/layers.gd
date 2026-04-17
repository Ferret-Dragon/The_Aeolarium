extends Node

@export var player: Node2D

var current_room: String = ""

# Door config — maps room name to which door to hide
var door_map := {
	"Room_bedroom": "b_door",
	"Room_office":  "o_door",
	"Room_kitchen": "k_door",
	"Room_animals": "a_door",
}

# Room → player z-index
var room_z_map := {
	"Room_bedroom": -12,
	"Room_office":  -8,
	"Room_hall_front": -6,
	"Room_hall_back": -1,
	"Room_kitchen": 0,
	"Room_animals": 5,
	"Room_boiler": 9,
}

const Z_PLAYER_DEFAULT := 5

# Node references
@onready var doors_node = $Doors
@onready var rooms_node = $Rooms

# ----------------------------
# READY
# ----------------------------
func _ready():
	_connect_rooms()

# ----------------------------
# CONNECT ROOM SIGNALS
# ----------------------------
func _connect_rooms():
	for room in rooms_node.get_children():
		if room is Area2D:
			room.body_entered.connect(_on_room_entered.bind(room.name))
			room.body_exited.connect(_on_room_exited.bind(room.name))

# ----------------------------
# ROOM ENTER
# ----------------------------
func _on_room_entered(body: Node, room_name: String) -> void:
	body.z_index = room_z_map.get(room_name, Z_PLAYER_DEFAULT)
	print(body, " has entered ", room_name, ".  z index: ", body.z_index)
	if body != player:
		return
	current_room = room_name

	if room_name in door_map:
		var door = doors_node.get_node_or_null(door_map[room_name])
		if door:
			door.visible = false

	body.z_index = room_z_map.get(room_name, Z_PLAYER_DEFAULT)

# ----------------------------
# ROOM EXIT
# ----------------------------
func _on_room_exited(body: Node, room_name: String) -> void:
	if body != player:
		return
	current_room = ""

	if room_name in door_map:
		var door = doors_node.get_node_or_null(door_map[room_name])
		if door:
			door.visible = true

	#player.z_index = Z_PLAYER_DEFAULT
