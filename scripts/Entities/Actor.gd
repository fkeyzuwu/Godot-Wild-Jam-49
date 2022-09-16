extends KinematicBody2D
class_name Actor

var is_on_fire := false
var health = 3
var fire_damage_timer := Timer.new()
var fire_damage_interval := 5.0

func _ready() -> void:
	fire_damage_timer.wait_time = fire_damage_interval
	fire_damage_timer.one_shot = false
	add_child(fire_damage_timer)
	

func set_on_fire(value: bool):
	if is_on_fire == value:
		return
	
	if is_on("water"):
		is_on_fire = false
	else:
		is_on_fire = value
	
	if is_on_fire:
		fire_damage_timer.connect("timeout", self, "take_damage", [1])
		fire_damage_timer.start()
		print(self.name + " is on fire")
		#play burning animation
	else:
		fire_damage_timer.disconnect("timeout", self, "take_damage")
		fire_damage_timer.stop()
		print(self.name + " is not on fire")
		#stop burning animation
	
func electrocute(damage):
	take_damage(damage)
	#do electrocute effect

func is_on(group_name: String) -> bool:
	var areas = $Hurtbox.get_overlapping_areas()
	for area in areas:
		if area.is_in_group(group_name):
			print("I'm on: " + group_name)
			return true
			
	return false

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		die()
		
func die():
	if fire_damage_timer.is_connected("timeout", self, "take_damage"):
		fire_damage_timer.disconnect("timeout", self, "take_damage")
