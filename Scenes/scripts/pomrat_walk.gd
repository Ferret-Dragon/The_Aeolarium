extends Node2D

var room_z_map := {
	"Room_bedroom": -12,
	"Room_office": -8,
	"Room_kitchen": -1,
	"Room_hall_front": 0,
	"Room_hall_back": 1,
	"Room_animals": 7
}

# Pomrat is now the scene root (CharacterBody2D), so reference it directly
@onready var pomrat = $pomrat  # adjust to wherever you instance it

func _ready():
	pomrat.z_index = 7

	if not Global.pomrat_escaped_changed.is_connected(_on_escaped):
		Global.pomrat_escaped_changed.connect(_on_escaped)


func _on_escaped():
	if pomrat:
		pomrat.start_wandering()
		pomrat.timer.start()  # kick off wandering


func _on_room_entered(entered_body: Node2D, room_name: String):
	if not is_ancestor_of(entered_body):
		return
	#if entered_body == pomrat:
		#if room_name in room_z_map:
			#pomrat.z_index = room_z_map[room_name]

func _on_room_exited(exited_body: Node2D, room_name: String):
	if not is_ancestor_of(exited_body):
		return
	#z_index = 0
