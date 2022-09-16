extends ArtifactEffect

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	._ready()
	color = Color(0.690196, 0.54902, 1)
	animation = "Teleport_Buildup"
	rng.randomize()

func activate():
	var bodies = get_overlapping_bodies()
	var random_position = _get_random_position()
	for body in bodies:
		if (body.name == "Player") or (body.name == "Enemy") or (body.name == "Artifact"):
			body.global_position = random_position
			print(str(body) + " teleported")

func _get_random_position() -> Vector2:
	var world = get_tree().current_scene
	var bg_tilemap = world.current_stage.get_node("YSort").get_node("BackgroundTilemap") as TileMap
	var used_cells = bg_tilemap.get_used_cells()
	var cell_position = used_cells[rng.randi() % used_cells.size() - 1]
	return bg_tilemap.map_to_world(cell_position) + bg_tilemap.cell_size / 2
