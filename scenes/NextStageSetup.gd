extends Node2D

onready var world = get_parent()
onready var spawn_viewport = $"%Viewport"
onready var screenshot = $"%Screenshot"
var stage_spawn_pos = Vector2(0, 180)

func setup():
	screenshot_next_stage()
	tween_screenshot()

func screenshot_next_stage():
	world.remove_child(world.next_stage)
	spawn_viewport.add_child(world.next_stage)
	
	var stage_image = spawn_viewport.get_texture().get_data()
	var texture = ImageTexture.new()
	texture.create_from_image(stage_image, 0)
	screenshot.set_texture(texture)

func tween_screenshot():
	screenshot.global_position = stage_spawn_pos
	screenshot.z_index = 2
	screenshot.modulate.a = 0
	
	var tween = create_tween().set_parallel()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	var tween_time = TimeManager.tilemap_timer.wait_time
	
	tween.tween_property(screenshot, "global_position", Vector2(0, 0), tween_time)
	tween.tween_property(screenshot, "modulate", Color(1, 1, 1, 1), tween_time)
