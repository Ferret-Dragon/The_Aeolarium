extends Control

@onready var player = get_parent().get_parent()
@onready var energy_bar = $VBoxContainer/HBoxContainer/ProgressBar

func _ready():
	player.energy_updated.connect(_on_player_energy_updated)
	_on_player_energy_updated(player.current_energy)

func _on_player_energy_updated(new_energy):
	energy_bar.value = new_energy
