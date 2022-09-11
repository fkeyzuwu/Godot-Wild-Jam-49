extends KinematicBody2D
class_name Player

var velocity := Vector2.ZERO
var max_speed = 100
var accelration = 500
var friction = 750

var health = 3
export var invincibility_time = 2
var invincible := false
onready var health_viles = $"%Health_Viles"

onready var hurtbox_collider = $"%HurtboxCollider"

onready var sprite = $"%Sprite"

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
	
func take_damage(damage: int):
	if(invincible):
		return
	
	hurtbox_collider.set_deferred("disabled", true)
	sprite.modulate.a = 0.5
	health -= damage
	invincible = true
	
	if health <= 0:
		queue_free()
	else:
		call_deferred("_toggle_vile_visible", true)
		
		while damage > 0:
			var vile = health_viles.get_node("health" + var2str(health + damage))
			vile.call_deferred("take_damage")
			damage -= 1
		
		var timer = get_tree().create_timer(invincibility_time, false)
		yield(timer, "timeout") 
		
		hurtbox_collider.set_deferred("disabled", false)
		sprite.modulate.a = 1
		_toggle_vile_visible(false)
		invincible = false
	

func _toggle_vile_visible(state: bool):
	for vile in health_viles.get_children():
		vile.visible = state

