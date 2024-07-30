extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -300.0
var count = 0

@onready var animated_sprite_2d = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	count += 1
	
	if (count == 15):
		animated_sprite_2d.animation = "default"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if (velocity.x > 1 || velocity.x < -1):
			animated_sprite_2d.animation = "walk"
		else:
			animated_sprite_2d.animation = "idle"
			
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		animated_sprite_2d.animation = "jump"
		velocity.y = JUMP_VELOCITY
		count = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var facingLeft = velocity.x < 0
	var facingRight = velocity.x > 0
	
	if facingLeft:
		animated_sprite_2d.flip_h = true
	elif facingRight:
		animated_sprite_2d.flip_h = false
	
	if Input.is_action_just_pressed("dash"):
		velocity.x = direction * SPEED * 10
	if Input.is_action_just_pressed("lantern"):
		get_tree().change_scene_to_file("res://scenes/room_2.tscn")
	move_and_slide()
	

