extends KinematicBody2D
class_name Player

var velocity := Vector2.ZERO
var max_speed = 100
var accelration = 500
var friction = 750

var _artifact: Node2D
	
func _process(delta: float) -> void:
	_move(delta)
	
	if Input.is_action_just_pressed("mouse_left") and _artifact != null:
		throw_artifact()

func throw_artifact() -> void:
	print("threw artifact")
	var artifact_location = _artifact.global_position
	self.call_deferred("remove_child", _artifact)
	get_parent().call_deferred("add_child", _artifact)
	_artifact.set_deferred("global_position", artifact_location)
	_artifact = null


func pick_up_artifact(artifact: Node2D) -> void:
	print("picked up artifact")
	var artifact_location = artifact.global_position
	var artifact_parent = artifact.get_parent()
	artifact_parent.call_deferred("remove_child", artifact)
	self.call_deferred("add_child", artifact)
	artifact.set_deferred("global_position", artifact_location)
	_artifact = artifact

func _move(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, accelration * delta)
	else:
		velocity = velocity.move_toward((Vector2.ZERO), friction * delta)
	
	velocity = 	move_and_slide(velocity)
