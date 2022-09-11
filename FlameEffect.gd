extends ArtifactEffect

func activate():
	print("activated")
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if (body is Enemy) or (body is Player):
			body.take_damage(2)
