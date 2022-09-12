extends KinematicBody2D
class_name Enemy

var health := 5
export var on_fire_time = 12
var fire = false

func _ready() -> void:
	add_to_group("enemies")

func take_damage(damage: int):
	health -= damage
	print("enemy health: " + str(health))
	if health <= 0:
		queue_free()

func on_fire(damage:int):
	fire = true
	while fire:
		take_damage(damage)
		var timer = get_tree().create_timer(on_fire_time, false)
		yield(timer, "timeout")
		if is_on("water"):
			fire = false

func is_on(group_name:String) -> bool:
	var areas = $Hurtbox.get_overlapping_areas()
	for area in areas:
		if area.is_in_group(group_name):
			print("Im on: " +group_name)
			fire = false
			return true
	return false
