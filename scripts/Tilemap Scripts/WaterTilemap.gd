extends Area2D
class_name WaterTilemap

var electrocuted = false

func electrocute():
	electrocuted = true
	print("water is electrocuted")
	#set the animation, wait timer

func _on_WaterCollision_body_entered(body: Node) -> void:
	print(body.name + " entered water")
	if (body is Player) or (body is Enemy):
		body.set_on_fire(false)
		if self.electrocuted:
			body.electrocute()
