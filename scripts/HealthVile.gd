extends AnimatedSprite


func _ready():
	visible = false

func take_damage():
	play("damage_taken")
	yield(self, "animation_finished")
	queue_free()
