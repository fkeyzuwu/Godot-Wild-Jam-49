extends ArtifactEffect

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func activate():
	var bodies = get_overlapping_bodies()
	var random_position = _get_random_position()
	for body in bodies:
		if (body is Enemy) or (body is Player) or (body.name == "Artifact"):
			body.global_position = random_position
			print(str(body) + " teleported")

func _get_random_position() -> Vector2:
	var bg_tilemap = get_parent().get_parent().get_parent().get_node("BackgroundTilemap") as TileMap
	var used_cells = bg_tilemap.get_used_cells()
	var cell_position = used_cells[rng.randi() % used_cells.size() - 1]
	return bg_tilemap.map_to_world(cell_position) + bg_tilemap.cell_size / 2