extends Node2D

var room_z_map := {
	"Room_bedroom": -12,
	"Room_office": -8,
	"Room_kitchen": -1,
	"Room_hall_front": 0,
	"Room_hall_back": 1
}

# Pomrat is now the scene root (CharacterBody2D), so reference it directly
@onready var pomrat = $pomrat  # adjust to wherever you instance it

func _ready():
	if pomrat == null:
		push_error("Pomrat node not found!")

	if not Global.pomrat_escaped_changed.is_connected(_on_escaped):
		Global.pomrat_escaped_changed.connect(_on_escaped)

	for room in get_tree().get_nodes_in_group("rooms"):
		if room.has_signal("body_entered"):
			room.body_entered.connect(_on_room_entered.bind(room.name))
		if room.has_signal("body_exited"):
			room.body_exited.connect(_on_room_exited.bind(room.name))

func _on_escaped():
	if pomrat:
		print("Calling start_wandering on: ", pomrat.name)
		pomrat.start_wandering()
		pomrat.timer.start()  # kick off wandering
	else:
		push_error("Cannot enable physics: pomrat is null")

func _on_room_entered(entered_body: Node2D, room_name: String):
	if not is_ancestor_of(entered_body):
		return
	z_index = room_z_map.get(room_name, 0)

func _on_room_exited(exited_body: Node2D, room_name: String):
	if not is_ancestor_of(exited_body):
		return
	z_index = 0
