extends Area2D

var player_inside := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	input_event.connect(_on_input_event)
	input_pickable = true  # Required for input_event to fire

func _on_body_entered(body):
	player_inside = true

func _on_body_exited(body):
	player_inside = false

func _go_home():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		Global.player_position = player.global_position
		Global.player_position_saved = true
	
func _on_input_event(_viewport, event, _shape_idx):
	if not player_inside:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_switch_scene()

func _input(event):
	# Controller A button — still uses _input since controllers aren't positional
	if not player_inside:
		return

	if event.is_action_pressed("ui_accept"):
		_switch_scene()

func _switch_scene():
	_go_home()
	get_tree().change_scene_to_file("res://Scenes/control_lights.tscn")
