extends Node2D

@onready var slider = $CanvasLayer/Sprite2D/HSlider

func _ready():
	slider.value = Global.light_value
	slider.value_changed.connect(_on_slider_changed)

func _on_slider_changed(value: float):
	Global.light_value = value

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/home.tscn")
