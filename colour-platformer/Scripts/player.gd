extends CharacterBody2D

@export var speed: float = 160.0
@export var acceleration: float = 800.0
@export var friction: float = 1200.0
@export var jump_velocity: float = -320.0
@export var gravity: float = 900.0

@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.1

var is_jumping: bool = false
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# Horizontal movement
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Coyote time
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# Jump buffer
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# Jumping
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_velocity
		is_jumping = true
		jump_buffer_timer = 0
		coyote_timer = 0

	# Apply gravity and variable jump height
	if velocity.y < 0 and not Input.is_action_pressed("ui_accept"):
		# Short hop: apply extra gravity if jump released early
		velocity.y += gravity * delta * 2.5
	else:
		# Normal gravity
		velocity.y += gravity * delta

	# Reset jump state
	if is_on_floor():
		is_jumping = false

	move_and_slide()

func set_ink_color(new_color: Color) -> void:
	$AnimatedSprite2D.modulate = new_color
