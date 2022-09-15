extends Node2D

var file_names = []
var stage_path = "res://scenes/Stages/"
var current_stage: Node2D
var next_stage: Node2D
var last_index_file = -1
var stage_spawn_pos = Vector2(0, 180)

var rng  = RandomNumberGenerator.new()

var player: Player = preload("res://scenes/Player.tscn").instance()
var artifact: RigidBody2D = preload("res://scenes/Artifact.tscn").instance()
var enemy: Enemy = preload("res://scenes/Enemy.tscn").instance()

func _ready() -> void:
	rng.randomize()
	file_names = _get_files(stage_path)
	
	current_stage = load_random_stage()
	next_stage = load_random_stage()
	yield(get_tree(),"idle_frame")
	next_stage.global_position = stage_spawn_pos
	
	current_stage.add_child(player)
	player.global_position = Vector2(100, 100)
	current_stage.add_child(artifact)
	artifact.global_position = Vector2(250, 100)
	current_stage.add_child(enemy)
	enemy.global_position = Vector2(260, 130)
	
	TimeManager.tilemap_timer.connect("timeout", self, "switch_next_stage")

func _get_files(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files	
	
func load_random_stage() -> Node2D:
	var random_index = rng.randi() % file_names.size() - 1
	while random_index == last_index_file: #dont load the same scene twice
		random_index = rng.randi() % file_names.size() - 1
	var scene = load(stage_path + file_names[random_index])
	last_index_file = random_index
	
	var stage = scene.instance()
	add_child(stage)
	return stage
	
	
func switch_next_stage():
	next_stage.global_position = Vector2.ZERO
	_move_children()
	current_stage.queue_free()
	current_stage = next_stage
	next_stage = load_random_stage()
	yield(get_tree(),"idle_frame")
	next_stage.global_position = stage_spawn_pos

func _move_children():
	_move_child(player)
	_move_child(artifact)
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		_move_child(enemy)

func _move_child(child: Node2D):
	if child == null:
		return
		
	var child_position = child.global_position
	current_stage.remove_child(child)
	next_stage.add_child(child)
	child.global_position = child_position
