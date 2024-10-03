extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_ui = get_node("/root/Game/HealthUI/HBoxContainer")

var max_health = 3
var current_health = 3

func _ready():
	if health_ui:
		print("HealthUI found. Updating health display.")
		update_health_ui()
	else:
		push_error("HealthUI not found. Make sure the path is correct.")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		# Flip the sprite based on direction
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Always play the "idle" animation since we don't have a "run" animation
	animated_sprite.play("idle")

	move_and_slide()

func take_damage(amount):
	current_health = max(0, current_health - amount)
	update_health_ui()
	if current_health == 0:
		die()

func heal(amount):
	current_health = min(max_health, current_health + amount)
	update_health_ui()

func update_health_ui():
	if health_ui:
		for i in range(health_ui.get_child_count()):
			var heart = health_ui.get_child(i)
			heart.visible = i < current_health
	else:
		push_error("HealthUI is null. Cannot update health display.")

func die():
	# Implement death logic here
	print("Player died")
	# You might want to restart the level, show a game over screen, etc.
