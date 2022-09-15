extends TileMap


func _ready():
	update_dirty_quadrants()
	visible = false
