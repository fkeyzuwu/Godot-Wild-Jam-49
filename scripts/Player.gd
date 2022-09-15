extends KinematicBody2D
class_name Player

var velocity := Vector2.ZERO
export var max_speed = 100
export var acceleration = 500
export var friction = 750

var health = 3
export var invincibility_time = 2
export var on_fire_time = 7
export var electric_speed_timer= 5
export var electric_speed_multiplier = 1.2

var invincible := false
var fire = false
onready var health_viles = $"%Health_Viles"

onready var hurtbox_collider = $"%HurtboxCollider"

onready var sprite = $"%Sprite"

onready var feet_area = $FeetArea

onready var camera = $Camera2D

var _artifact: Node2D
var can_throw := true
var throw_cooldown := 1

func _ready():
	_toggle_vile_visible(false)
	camera.limit_left
	camera.limit_right
	camera.limit_top 
	camera.limit_bottom

func _process(delta: float) -> void:
	_move(delta)
	
	if Input.is_action_just_pressed("mouse_left") and _artifact != null:
		throw_artifact()

func throw_artifact() -> void:
	if !can_throw:
		return
	
	var throw_timer = get_tree().create_timer(throw_cooldown, false)
	throw_timer.connect("timeout", self, "set_can_throw")
	can_throw = false
	_artifact.throw()

func set_can_throw():
	can_throw = true

func _move(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward((Vector2.ZERO), friction * delta)
	
	velocity = 	move_and_slide(velocity)
	

func take_damage(damage: int, hitter: String):
	if(invincible):
		return
		
	print("took damage by " +  hitter)
	
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

func on_fire(damage:int):
	if not invincible:
		fire = true
		var timer = get_tree().create_timer(on_fire_time, false)
		yield(timer, "timeout")
		if is_on("water"):
			fire = false
		while fire: 
			print("toasty")
			take_damage(damage, "fire")
			timer = get_tree().create_timer(on_fire_time, false)
			yield(timer, "timeout")
			if is_on("water"):
				fire = false

func electrocute_player(damage):
	print("electrocute")
	if is_on("metal"):
		max_speed*= electric_speed_multiplier
		acceleration*= electric_speed_multiplier
		var timer = get_tree().create_timer(electric_speed_timer, false)
		yield(timer, "timeout")
		max_speed*= (1/electric_speed_multiplier)
		acceleration*= (1/electric_speed_multiplier)
	else:
		take_damage(damage, "electric")

func is_on(group_name:String) -> bool:
	var areas = feet_area.get_overlapping_areas()
	for area in areas:
		if area.is_in_group(group_name):
			print("Im on: " +group_name)
			return true
	return false

func _toggle_vile_visible(state: bool):
	for vile in health_viles.get_children():
		vile.visible = state
