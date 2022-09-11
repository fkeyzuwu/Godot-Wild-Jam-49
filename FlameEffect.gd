extends ArtifactEffect

func activate():
	print("activated")
	var bodies = get_overlapping_bodies()
	for body in bodies:
		print(str(body) + "fire")
