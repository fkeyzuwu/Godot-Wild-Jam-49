extends KinematicBody2D
class_name Player

var velocity := Vector2.ZERO
var max_speed = 100
var accelration = 500
var friction = 750
var health = 3
export var invincibility_time = 2
var invincibility : int = 0
onready var health_viles = get_health_viles() setget , get_health_viles 

var _artifact: Node2D

func _ready():
	_toggle_vile_visible(false)

func _process(delta: float) -> void:
	_move(delta)
	
	if Input.is_action_just_pressed("mouse_left") and _artifact != null:
		throw_artifact()

func throw_artifact() -> void:
	_artifact.throw()

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

func get_health_viles():
	return get_tree().get_nodes_in_group("health_viles")

func _toggle_vile_visible(state: bool):
	for vile in get_health_viles():
		vile.visible = state

func _on_Area2D_area_entered(area):
	print("invincibility " +var2str(invincibility))
	if invincibility == 0:
		invincibility+=1
		if area.name == "SpikeTile" and invincibility==1:
			print (area.name)
			$Area2D/CollisionShape2D.set_deferred("disabled", true)
			$Sprite.modulate.a = 0.5
			health -= 1
			print("health " +var2str(health))
			if health < 1:
				queue_free()
			else:
				call_deferred("_toggle_vile_visible", true)
				var vile = get_node("health"+var2str(health+1))
				vile.call_deferred("_get_damage")
				var timer = Timer.new()
				timer.set_wait_time(invincibility_time)
				timer.set_one_shot(true)
				self.add_child(timer)
				timer.start()
				yield(timer, "timeout") 
				$Area2D/CollisionShape2D.set_deferred("disabled", false)
				$Sprite.modulate.a = 1
				_toggle_vile_visible(false)
		else:
			invincibility=0
		invincibility=0

