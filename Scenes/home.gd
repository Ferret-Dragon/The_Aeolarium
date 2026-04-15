extends Node

@onready var canvas_modulate = $World/Background/CanvasModulate

func _ready():
	_apply_light(Global.light_value)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _apply_light(value: float):
	canvas_modulate.color = Color(value, value, value)
