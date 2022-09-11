extends ArtifactEffect
class_name ElectricEffect

var timer

func _ready():
	$CollisionShape2D.disabled= true

func activate():
	print("electric")
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if (body is Enemy) or (body is Player):
			body.take_damage(2)


