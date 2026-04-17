extends Node2D

var room_z_map := {
	"Room_bedroom": -12,
	"Room_office": -8,
	"Room_kitchen": -1,
	"Room_hall_front": 0,
	"Room_hall_back": 1
}

@onready var body = $lizard/CharacterBody2D

func _ready():
	# Connect the right signal based on which animal this is
	Global.lizard_escaped_changed.connect(_on_escaped)

	
	# Connect room detection
	for room in get_tree().get_nodes_in_group("rooms"):
		room.body_entered.connect(_on_room_entered.bind(room.name))
		room.body_exited.connect(_on_room_exited.bind(room.name))

func _on_escaped():
	body.set_physics_process(true)

func _on_room_entered(entered_body: Node2D, room_name: String):
	if not is_ancestor_of(entered_body):
		return
	z_index = room_z_map.get(room_name, 0)

func _on_room_exited(exited_body: Node2D, room_name: String):
	if not is_ancestor_of(exited_body):
		return
	z_index = 0
