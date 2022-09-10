extends KinematicBody2D
class_name Player

var velocity := Vector2.ZERO
var max_speed = 100
var accelration = 500
var friction = 750

var hasArtifact = false
	
func _process(delta: float) -> void:
	_move(delta)
	if Input.is_action_just_pressed("mouse_left") and hasArtifact:
		throw_artifact()

func throw_artifact() -> void:
	print("threw artifact")
	hasArtifact = false

func pick_up_artifact() -> void:
	print("picked up artifact")
	hasArtifact = true

func _move(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, accelration * delta)
		velocity.clamped(max_speed)
	else:
		velocity = velocity.move_toward((Vector2.ZERO), friction * delta)
	
	velocity = 	move_and_slide(velocity)
