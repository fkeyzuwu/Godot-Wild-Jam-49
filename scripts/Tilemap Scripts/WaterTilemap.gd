extends Area2D
class_name WaterTilemap

var electrocuted = false
var electrocute_damage = 2
var electrocute_timer = Timer.new()
var electrocute_interval = 5.0

onready var water_tilemap = $WaterTilemap
onready var electric_tilemap = $ElectricTilemap

func _ready() -> void:
	add_to_group("water")
	electrocute_timer.wait_time = electrocute_interval
	electrocute_timer.one_shot = true
	add_child(electrocute_timer)

func set_electrocute(value: bool):
	if electrocuted == value:
		return
		
	electrocuted = value
	
	if electrocuted:
		print("water is electrocuted")
		var areas = get_overlapping_areas()
		for area in areas:
			if area.name == "Hurtbox" and area.get_parent() is Actor:
				area.get_parent().electrocute(electrocute_damage)
		set_tiles_electrocuted(true)
		electrocute_timer.start()
		electrocute_timer.connect("timeout", self, "set_electrocute", [false])
		#set the animation, wait timer
	else:
		print("water is not electrocuted")
		set_tiles_electrocuted(false)
		electrocute_timer.disconnect("timeout", self, "set_electrocute")
		#stop animation, stop timer

func _on_WaterCollision_body_entered(body: Node) -> void:
	print(body.name + " entered water")
	if (body is Player) or (body is Enemy):
		body.set_on_fire(false)
		if self.electrocuted:
			body.electrocute(electrocute_damage)

func set_tiles_electrocuted(value: bool):
	if value == true:
		water_tilemap.visible = false
		electric_tilemap.visible = true
	else:
		water_tilemap.visible = true
		electric_tilemap.visible = false
		#set them to regular
