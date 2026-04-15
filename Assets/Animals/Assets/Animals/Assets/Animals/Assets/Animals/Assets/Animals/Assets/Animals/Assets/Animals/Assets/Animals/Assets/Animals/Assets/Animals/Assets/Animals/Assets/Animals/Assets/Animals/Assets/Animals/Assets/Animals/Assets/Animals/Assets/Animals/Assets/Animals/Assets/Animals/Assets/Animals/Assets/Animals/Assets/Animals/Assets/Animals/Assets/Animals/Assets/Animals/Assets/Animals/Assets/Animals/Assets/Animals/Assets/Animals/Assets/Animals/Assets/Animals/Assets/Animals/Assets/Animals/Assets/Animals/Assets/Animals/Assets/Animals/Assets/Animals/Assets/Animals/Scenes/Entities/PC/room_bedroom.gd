extends Area2D

@export var room_name: String

func _on_body_entered(body):
	if body.name == "Player_Character":
		body.current_room = room_name
		print("Entered:", room_name)

func _on_body_exited(body):
	if body.name == "Player_Character":
		print("Exited:", room_name)
