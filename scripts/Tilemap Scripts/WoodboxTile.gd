extends StaticBody2D

onready var box_collision = $BoxCollision
onready var sprite = $Sprite
onready var animation = $Sprite/AnimationPlayer
onready var nav_poly = $NavigationPolygonInstance
onready var health = 1

func _ready():
	animation.play("Idle")

func take_damage(damage):
	health -= damage
	print("Box Destroyed")
	if health <= 0:
		box_collision.set_deferred("disabled", true)
		sprite.visible = false
		nav_poly.enabled = true
		#Navigation2DServer.agent_set_map(nav_poly.navpoly.get_rid(), get_world_2d().navigation_map)
	

func on_fire(damage):
	animation.play("Fire")
	yield(animation, "animation_finished")
	take_damage(damage)
