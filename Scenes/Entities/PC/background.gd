extends Node2D

@onready var canvas_modulate = $CanvasModulate

func _ready():
	_apply_light(Global.light_value)

func _apply_light(value: float):
	canvas_modulate.color = Color(value, value, value)
