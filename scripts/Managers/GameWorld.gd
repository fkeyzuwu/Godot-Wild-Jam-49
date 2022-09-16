extends Node2D
class_name GameWorld

var stages := [
	preload("res://scenes/Stages/LStage_1_Pacman.tscn"),
	preload("res://scenes/Stages/LStage_2_GoRiver.tscn"),
	preload("res://scenes/Stages/LStage_3_BomberStyle.tscn"),
	preload("res://scenes/Stages/LStage_4_Ring.tscn")
]

var current_stage: Stage
var next_stage: Stage
var last_stage_index = -1
var stage_spawn_pos = Vector2(0, 640)

var rng  = RandomNumberGenerator.new()

var player: Player = preload("res://scenes/Entities/Player.tscn").instance()
var artifact: RigidBody2D = preload("res://scenes/Entities/Artifact.tscn").instance()
var enemy: Enemy = preload("res://scenes/Entities/Enemy.tscn").instance()

func _ready() -> void:
	rng.randomize()
	
	current_stage = load_random_stage()
	next_stage = load_random_stage()
	yield(get_tree(),"idle_frame")
	next_stage.global_position = stage_spawn_pos
	
	current_stage.add_child(player)
	player.global_position = Vector2(100, 100)
	player.connect("on_player_death", self, "game_over")
	current_stage.add_child(artifact)
	artifact.global_position = Vector2(200, 100)
	
	TimeManager.tilemap_timer.connect("timeout", self, "switch_next_stage")


func load_random_stage() -> Stage:
	var random_index = rng.randi() % stages.size() - 1
	while random_index == last_stage_index: #dont load the same scene twice
		random_index = rng.randi() % stages.size() - 1
	last_stage_index = random_index
	var stage = stages[random_index].instance()
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


func game_over():
	TimeManager.tilemap_timer.disconnect("timeout", self, "switch_next_stage")
