extends Node

onready var world: GameWorld = get_parent()
onready var enemy_scene = preload("res://scenes/Enemy.tscn")

var enemies = []
var max_enemies = 3

var spawn_timer = Timer.new()
var spawn_time = 5.0

func _ready() -> void:
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	spawn_timer.start(spawn_time)
	spawn_timer.connect("timeout", self, "spawn_enemy")

func spawn_enemy() -> void:
	if enemies.size() == max_enemies:
		return
	
	var enemy = enemy_scene.instance() as Enemy
	enemy.connect("on_enemy_killed", self, "on_enemy_killed")
	enemies.append(enemy)
	
	world.current_stage.add_child(enemy)
	var random_spawn_point = world.current_stage.get_random_spawn_point()
	enemy.global_position = random_spawn_point.global_position
	#later make this random spawn point
	
	spawn_timer.wait_time = spawn_time
	#change this to speed up spawn time little by little
	print("enemy spawned. spawn_time = " + str(spawn_time))

func on_enemy_killed(enemy: Enemy) -> void:
	enemies.remove(enemies.find(enemy))
