extends ArtifactEffect
class_name ElectricEffect

var timer
export var damage = 2

func activate():
	print("electric")
	var areas = get_overlapping_areas()
	for area in areas:
		if (area.name == "Hurtbox"):
			if area.get_parent() is Player:
				area.get_parent().electrocute_player(damage)
			else:
				area.get_parent().take_damage(damage)
		if (area.is_in_group("water") and area.electro == false):
			area.electrocute()


