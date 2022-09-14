extends KinematicBody2D
class_name Enemy

onready var navi_agent = $NavigationAgent2D
onready var line = $Line2D
onready var player = get_parent().get_node("Player")
var did_arrive = false

var move_direction : Vector2
var velocity : Vector2
export var max_speed = 50
export var acceleration = 500

export var health := 5
export var on_fire_time = 12
var fire = false

signal path_changed(path)

func _ready() -> void:
	add_to_group("enemies")
	#Navigation

func _process(delta):
	_move()
	

func _move():
	navi_agent.set_target_location(get_player_location())
	var move_direction = position.direction_to(navi_agent.get_next_location())
	velocity = move_direction* max_speed
	navi_agent.set_velocity(velocity) 

func arrived_at_location() -> bool:
	return navi_agent.is_navigation_finished()

func take_damage(damage: int):
	health -= damage
	print("enemy health: " + str(health))
	if health <= 0:
		queue_free()


func on_fire(damage:int):
	fire = true
	while fire:
		take_damage(damage)
		var timer = get_tree().create_timer(on_fire_time, false)
		yield(timer, "timeout")
		if is_on("water"):
			fire = false

func is_on(group_name:String) -> bool:
	var areas = $Hurtbox.get_overlapping_areas()
	for area in areas:
		if area.is_in_group(group_name):
			print("Im on: " +group_name)
			fire = false
			return true
	return false


func get_player_location():
	return player.global_position

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if not arrived_at_location():
		velocity = move_and_slide(safe_velocity)
