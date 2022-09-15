extends ArtifactEffect

export var damage = 2

func _ready() -> void:
	._ready()
	color = Color(1, 0.270588, 0.301961)
	animation = "Flame_Buildup"

func activate():
	print("fire")
	var areas = get_overlapping_areas()
	for area in areas:
		if (area.name == "Hurtbox" or area.name == "WoodBoxHurtbox"):
			area.get_parent().on_fire(damage)

