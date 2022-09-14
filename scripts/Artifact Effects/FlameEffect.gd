extends ArtifactEffect

export var damage = 2

func _ready() -> void:
	._ready()
	color = Color(1, 0, 0)

func activate():
	print("fire")
	var areas = get_overlapping_areas()
	for area in areas:
		if (area.name == "Hurtbox" or area.name == "WoodBoxHurtbox"):
			area.get_parent().on_fire(damage)
