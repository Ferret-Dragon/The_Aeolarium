extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	var screen = get_viewport_rect().size
	
	position.x = clamp(position.x, 0, screen.x)
	position.y = clamp(position.y, 0, screen.y)

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	velocity = direction.normalized() * SPEED
	move_and_slide()
