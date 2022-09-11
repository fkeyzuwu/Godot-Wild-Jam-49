extends Area2D

onready var elec_collision = $"%ElecCollision"
onready var water_collision = $"%WaterCollision"
onready var sprite = $"%Sprite"
onready var elec_timer = $"%ElecTimer"

 
func _ready():
	elec_collision.set_deferred("disabled", true)
	z_index= -98
	sprite.play("Idle")


func _electrocute():
	var areas = get_overlapping_areas()
	for area in areas:
		if (area.name == "ElectricEffect") or (area.name == "WaterArea"):
			sprite.play("Water_Elec")
			


func _on_Timer_timeout():
	elec_collision.set_deferred("disabled", true)
	sprite.play("Idle")




func _on_SpikeTile_body_entered(body: Node) -> void:
	if body is Player:
		body.take_damage(1)
