extends CharacterBody2D

@onready var _player_sprite = $AnimatedSprite2D
@onready var energy_timer = $Energy_Timer

@export_category("Stats")
@export var base_speed: float = 200.0
@export var max_health: float = 100.0
@export var max_energy: float = 100.0
@export var energy_burn_moving: float = 2.0
@export var energy_burn_idle: float = 0.5

var speed: float = 200.0
var facing_direction: String = "down"

signal energy_updated(new_energy)
signal health_updated(new_health)

func _ready():
	energy_timer.timeout.connect(_on_energy_timer_timeout)
	energy_timer.start()
	if Global.player_position_saved:
		global_position = Global.player_position

func update_speed():
	var energy_ratio = Global.energy / max_energy
	# Minimum 20% speed so player isn't completely stuck
	speed = base_speed * max(0.2, energy_ratio)

func _physics_process(_delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	if input_vector.length() < 0.2:
		input_vector = Vector2.ZERO
	var is_moving: bool = input_vector != Vector2.ZERO

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()

	# 4-direction facing
	if is_moving:
		if abs(input_vector.x) > abs(input_vector.y):
			facing_direction = "right" if input_vector.x > 0 else "left"
		else:
			facing_direction = "down" if input_vector.y > 0 else "up"

	# Animation
	var anim_name: String = ("walk_" if is_moving else "idle_") + facing_direction
	if _player_sprite.animation != anim_name:
		_player_sprite.play(anim_name)

	velocity = input_vector * speed
	move_and_slide()

func _on_energy_timer_timeout():
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	var is_moving: bool = input_vector != Vector2.ZERO

	var burn = energy_burn_moving if is_moving else energy_burn_idle
	Global.energy = clamp(Global.energy - burn, 0, max_energy)

	energy_updated.emit(Global.energy)
	update_speed()

func take_damage(amount: float):
	Global.health = clamp(Global.health - amount, 0, max_health)
	health_updated.emit(Global.health)
	if Global.health <= 0:
		_on_death()

func heal(amount: float):
	Global.health = clamp(Global.health + amount, 0, max_health)
	health_updated.emit(Global.health)

func eat(amount: float):
	Global.energy = clamp(Global.energy + amount, 0, max_energy)
	energy_updated.emit(Global.energy)
	update_speed()

func _on_death():
	print("Player has died")
	# Add death logic here
