extends StaticBody2D

onready var box_collision = $BoxCollision
onready var sprite = $Sprite
onready var animation = $Sprite/AnimationPlayer
onready var nav_poly = $NavigationPolygonInstance

func _ready():
	animation.play("Idle")


func set_on_fire(true):
	animation.play("Fire")
	yield(animation, "animation_finished")
	break_box()

	
func break_box():
	box_collision.set_deferred("disabled", true)
	sprite.visible = false
	nav_poly.enabled = true
