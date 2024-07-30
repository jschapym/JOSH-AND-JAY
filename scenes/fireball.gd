extends RigidBody2D

var speed = 500.0

func _physics_process(delta):
	linear_velocity = Vector2(speed, speed).rotated(rotation)
	gravity_scale = 0

func _on_Fireball_body_entered(body):
	if body:
		queue_free() 
