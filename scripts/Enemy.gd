extends KinematicBody2D
class_name Enemy

var health := 5

func take_damage(damage: int):
	health -= damage
	print("enemy health: " + str(health))
	if health <= 0:
		queue_free()
