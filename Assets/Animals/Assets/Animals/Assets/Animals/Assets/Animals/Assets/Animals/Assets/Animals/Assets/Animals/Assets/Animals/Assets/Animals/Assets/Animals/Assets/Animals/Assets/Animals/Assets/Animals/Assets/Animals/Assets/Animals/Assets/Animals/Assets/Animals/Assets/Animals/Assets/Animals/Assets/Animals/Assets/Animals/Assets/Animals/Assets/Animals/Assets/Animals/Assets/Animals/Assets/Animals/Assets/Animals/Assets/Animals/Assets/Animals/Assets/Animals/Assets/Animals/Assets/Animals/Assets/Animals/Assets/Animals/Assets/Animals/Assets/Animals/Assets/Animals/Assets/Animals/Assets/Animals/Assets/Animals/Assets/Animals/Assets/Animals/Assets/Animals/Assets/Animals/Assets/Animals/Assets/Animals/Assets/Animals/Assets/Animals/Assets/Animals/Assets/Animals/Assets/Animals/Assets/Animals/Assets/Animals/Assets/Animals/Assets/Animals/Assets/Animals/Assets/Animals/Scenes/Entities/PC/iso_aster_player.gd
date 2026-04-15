extends CharacterBody2D

@onready var _player_sprite = $AnimatedSprite2D

@export_category("Stats")
@export var base_speed: float = 200.0
var speed: float = 200.0
@onready var energy_timer = $Energy_Timer

var facing_direction: String = "down"

func update_speed():
	var energy_ratio = current_energy / max_energy
	speed = base_speed * energy_ratio
	
func _physics_process(_delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_vector.length() < 0.2:
		input_vector = Vector2.ZERO

	var is_moving: bool = input_vector != Vector2.ZERO
	
	# Normalize so diagonal isn't faster
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()

	# 4-direction facing
	if is_moving:

		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				facing_direction = "right"
			else:
				facing_direction = "left"
		else:
			if input_vector.y > 0:
				facing_direction = "down"
			else:
				facing_direction = "up"
	# Animation
	var anim_name: String = ("walk_" if is_moving else "idle_") + facing_direction

	if _player_sprite.animation != anim_name:
		_player_sprite.play(anim_name)

	velocity = input_vector * speed
	move_and_slide()


# Energy variables
var max_energy: float = 100.0
var current_energy: float = 100.0
var energy_burn_rate: float = 2.0 

# Signal to update UI
signal energy_updated(new_energy)

func _ready():
	current_energy = max_energy
	energy_timer.timeout.connect(_on_energy_timer_timeout)
	energy_timer.start()

func _on_energy_timer_timeout():
	# Decrease energy
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var is_moving: bool = input_vector != Vector2.ZERO
	if is_moving:
		energy_burn_rate = 2.0
		current_energy -= energy_burn_rate
		current_energy = clamp(current_energy, 0, max_energy)
		# Emit signal for UI
		energy_updated.emit(current_energy)
	else:
		energy_burn_rate = 0.5
		current_energy -= energy_burn_rate
		current_energy = clamp(current_energy, 0, max_energy)
		energy_updated.emit(current_energy)
		
	update_speed()
	

func eat(amount):
	current_energy += amount
	current_energy = clamp(current_energy, 0, max_energy)
	update_speed()
	energy_updated.emit(current_energy)
