extends ArtifactEffect

var timer

func _ready():
	$CollisionShape2D.disabled= true

func activate():
	print("electric")
