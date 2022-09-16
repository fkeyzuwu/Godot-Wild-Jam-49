extends Actor
class_name Enemy

onready var navi_agent = $NavigationAgent2D
onready var player = get_parent().get_node("Player")
var did_arrive = false
var path :Array

var move_direction : Vector2
var velocity : Vector2
export var max_speed = 30
export var acceleration = 300

signal on_enemy_killed(enemy)

signal path_changed(path)

func _ready() -> void:
	add_to_group("enemies")
	health = 30

func _process(delta):
	if player:
		generate_path()
		navigate()
	

#func _move():
#	path.remove(0)
#	navi_agent.set_target_location(path[0])
#	move_direction = position.direction_to(navi_agent.get_next_location())
#	velocity = move_direction* max_speed
#	navi_agent.set_velocity(velocity) 

func arrived_at_location() -> bool:
	return navi_agent.is_navigation_finished()
	

func die():
	.die()
	emit_signal("on_enemy_killed", self)
	queue_free()


func get_player_location():
	if is_instance_valid(player):
		return player.global_position
	else:
		return global_position

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if not arrived_at_location():
		velocity = move_and_slide(safe_velocity)

func navigate():
	if path.size()> 0:
		navi_agent.set_target_location(path[1])
		move_direction = global_position.direction_to(navi_agent.get_next_location())
		velocity = move_direction* max_speed
		velocity = move_and_slide(velocity) 
		navi_agent.set_velocity(velocity)
		
		if global_position == path[0]:
			path.pop_front()

func generate_path():
	path = Navigation2DServer.map_get_path(navi_agent.get_navigation_map(), global_position, get_player_location(), false)
