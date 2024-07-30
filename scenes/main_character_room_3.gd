extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0
const FIREBALL_SPEED = 500.0 
var count = 0

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var fireball_scene_path: String = "res://scenes/rigid_body_2D.tscn"
var fireball_scene: PackedScene

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if fireball_scene_path:
		fireball_scene = load(fireball_scene_path)
		if fireball_scene:
			print("Fireball scene loaded successfully.")
		else:
			print("Error: Failed to load Fireball scene.")
	else:
		print("Error: Fireball scene path is not set.")

func _physics_process(delta):
	count += 1
	
	if count == 15:
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
	
		# Fireball
	if Input.is_action_just_pressed("fireball"):
		throw_fireball()
	move_and_slide()

func throw_fireball():
	if fireball_scene: 
		var fireball_instance = fireball_scene.instantiate()
		fireball_instance.position = position
		var direction = PI if animated_sprite_2d.flip_h else 0
		fireball_instance.rotation = direction

		get_tree().current_scene.add_child(fireball_instance)
	else:
		print("Error: Fireball scene is not loaded.")
