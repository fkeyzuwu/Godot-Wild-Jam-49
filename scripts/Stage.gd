extends Node
class_name Stage

var enemy_spawn_points = []

func _ready() -> void:
	enemy_spawn_points = get_spawn_points()


func get_spawn_points() -> Array:
	var points = []
	points.append(get_node("SpawnPoint"))
	
	var i = 1
	while(get_node_or_null("SpawnPoint" + str(i)) != null):
		points.append(get_node("SpawnPoint" + str(i)))
		
	return points
