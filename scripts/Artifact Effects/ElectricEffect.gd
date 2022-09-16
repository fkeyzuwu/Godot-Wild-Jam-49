extends ArtifactEffect
class_name ElectricEffect

var timer
export var damage = 1

func _ready() -> void:
	._ready()
	color = Color(0.980392, 1, 0.301961)
	animation = "Electric_Buildup"

func activate():
	print("electric")
	var areas = get_overlapping_areas()
	for area in areas:
		if (area.name == "Hurtbox"):
			if area.get_parent() is Actor:
				area.get_parent().electrocute(damage)
		elif (area.is_in_group("water") and area.electrocuted == false):
			area.set_electrocute(true)

