extends Node
class_name Stage

var enemy_spawn_points = []
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	enemy_spawn_points = get_spawn_points()


func get_spawn_points() -> Array:
	var points = []
	points.append(get_node("SpawnPoint"))
	
	var i = 1
	while(get_node_or_null("SpawnPoint" + str(i)) != null):
		points.append(get_node("SpawnPoint" + str(i)))
		
	return points
	
func get_random_spawn_point():
	return enemy_spawn_points[rng.randi % enemy_spawn_points.size - 1]
