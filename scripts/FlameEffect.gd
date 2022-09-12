extends ArtifactEffect

export var damage = 2

func activate():
	print("fire")
	var areas = get_overlapping_areas()
	for area in areas:
		if (area.name == "Hurtbox"):
			area.get_parent().on_fire(damage)
