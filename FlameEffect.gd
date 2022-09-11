extends ArtifactEffect

func activate():
	print("activated")
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is Enemy:
			print("enemy hit")
		elif body is Player:
			body.health -= 1
			print(body.health)
