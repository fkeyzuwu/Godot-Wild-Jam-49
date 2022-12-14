extends TileMap
class_name InteractiveTilemap

export(Dictionary) var TILE_SCENES : = {
	0: preload("res://scenes/TilemapItems/Old/Spikes.tscn"),
	2: preload("res://scenes/TilemapItems/Old/MetalTile.tscn"),
	3: preload("res://scenes/TilemapItems/Old/WoodboxTile.tscn"),
}

onready var half_cell_size = cell_size * 0.5

func _ready():
	yield(get_tree(), "idle_frame")
	_replace_tiles_with_scenes()

func _replace_tiles_with_scenes(scene_dictionary: Dictionary = TILE_SCENES):
	for tile_pos in get_used_cells():
		var tile_id = get_cell(tile_pos.x, tile_pos.y)
		
		if scene_dictionary.has(tile_id):
			var object_scene = scene_dictionary[tile_id]
			_replace_tiles_with_object(tile_pos,object_scene)

func _replace_tiles_with_object(tile_pos: Vector2, object_scene: PackedScene, parent: Node = get_parent()):
	#clear the cell in TileMap
	if get_cellv(tile_pos) != INVALID_CELL:
		set_cellv(tile_pos, -1)
		update_bitmask_region()
	
	#spawn the object
	if object_scene:
		var obj = object_scene.instance()
		var ob_pos = map_to_world(tile_pos) + half_cell_size
		
		parent.add_child(obj)
		obj.global_position = ob_pos 
		#godot is stupid so you need to on-off the navigation for it to recognise it
		var nav_poly = obj.get_node("NavigationPolygonInstance")
		if nav_poly != null:
			nav_poly.enabled = false
			nav_poly.enabled = true
			#Navigation2DServer.agent_set_map(nav_poly.navpoly.get_rid(), get_world_2d().navigation_map)
		#obj.z_index = -98
