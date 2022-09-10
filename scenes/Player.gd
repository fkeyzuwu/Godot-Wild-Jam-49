extends KinematicBody2D

var velocity := Vector2.ZERO
var max_speed = 500
var accelration = 80
var friction = 900

func _ready() -> void:
	pass 
	
func _process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, accelration * delta)
	else:
		velocity = velocity.move_toward((Vector2.ZERO), friction * delta)
	
	velocity = 	move_and_slide(velocity)
