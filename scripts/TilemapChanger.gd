extends Node2D

var file_names = []
var stage_path = "res://scenes/Stages/"
var current_stage: Node2D
var next_stage: Node2D
var last_index_file = -1

onready var next_stage_setup = $"%NextStageSetup"

var rng  = RandomNumberGenerator.new()

var player: Player = preload("res://scenes/Player.tscn").instance()
var artifact: RigidBody2D = preload("res://scenes/Artifact.tscn").instance()
var enemy: Enemy = preload("res://scenes/Enemy.tscn").instance()

func _ready() -> void:
	rng.randomize()
	file_names = _get_files(stage_path)
	
	current_stage = load_random_stage()
	next_stage = load_random_stage()
	next_stage_setup.setup()
	
	current_stage.add_child(player)
	player.global_position = Vector2(100, 100)
	current_stage.add_child(artifact)
	artifact.global_position = Vector2(250, 100)
	current_stage.add_child(enemy)
	enemy.global_position = Vector2(260, 130)
	
	TimeManager.tilemap_timer.connect("timeout", self, "switch_next_stage")


	
func load_random_stage() -> Node2D:
	var index = rng.randi() % file_names.size() - 1
	if index == last_index_file: #dont load the same scene twice
		return load_random_stage()
	var scene = load(stage_path + file_names[index])
	last_index_file = index
	var stage = scene.instance()
	add_child(stage)
	stage.z_index = 1
	return stage


func switch_next_stage():
	current_stage.queue_free()
	next_stage_setup.spawn_viewport.remove_child(next_stage)
	add_child(next_stage)
	next_stage.global_position = Vector2.ZERO
	
	_move_children()
	
	current_stage = next_stage
	current_stage.z_index = 1
	next_stage = load_random_stage()
	next_stage_setup.setup()


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
