extends Area2D
class_name WaterTilemap
onready var elec_collision = $ElecArea/ElecCollision
onready var water_collision = $WaterCollision
onready var sprite = $Sprite
onready var elec_timer = $ElecTimer
export var damage = 1
var electro = false
 
func _ready():
	elec_collision.set_deferred("disabled", true)
	sprite.play("Idle")

func _process(delta):
	pass

func electrocute():
	electro = true
	sprite.play("Water_Elec")
	elec_collision.set_deferred("disabled", false)
	elec_timer.start()
	var areas = get_overlapping_areas()
	for area in areas:
		if (area.is_in_group("water") and area.electro == false):
			area.electrocute()


func _on_Timer_timeout():
	electro = false
	elec_collision.set_deferred("disabled", true)
	sprite.play("Idle")



func _on_ElecArea_body_entered(body): #On Body Entered ELECTROCUTION
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if (body.name == "Enemy"):
			body.take_damage(damage)
		elif (body.name == "Player"):
			body.electrocute_player(damage)



func _on_WaterTile_body_entered(body):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if (body.name == "Enemy") or (body.name == "Player"):
			print("cooling " + body.name)
			body.fire = false
