extends Node

onready var world: GameWorld = get_parent()
onready var enemy_scene = preload("res://scenes/Enemy.tscn")

var enemies = []
var max_enemies := 3

var spawn_timer := Timer.new()
var spawn_time := 3.0

func _ready() -> void:
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	spawn_timer.start(spawn_time)
	spawn_timer.connect("timeout", self, "spawn_enemy")
	TimeManager.tilemap_timer.connect("timeout", self, "on_tilemap_changed")

func spawn_enemy() -> void:
	print("enemies size: " + str(enemies.size()))
	if enemies.size() == max_enemies:
		return
	
	var enemy = enemy_scene.instance() as Enemy
	enemy.connect("on_enemy_killed", self, "on_enemy_killed")
	enemies.append(enemy)
	
	world.current_stage.add_child(enemy)
	var random_spawn_point = world.current_stage.get_random_spawn_point()
	enemy.global_position = random_spawn_point.global_position

func on_enemy_killed(enemy: Enemy) -> void:
	enemies.remove(enemies.find(enemy))


func on_tilemap_changed():
	max_enemies += 1
	spawn_timer.wait_time -= 0.2
	print("max enemies = " + str(max_enemies))
