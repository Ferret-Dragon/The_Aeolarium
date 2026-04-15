extends Area2D

signal collected

func _on_body_entered(body):
	if body.name == "shipcon":
		emit_signal("collected")
		queue_free()
