extends KinematicBody2D

func _ready() -> void:
	pass 


func _on_artifact_body_entered(body: Node) -> void:
	if body is Player:
		var player = body as Player
		player.pick_up_artifact()
	elif body is Enemy:
		print("collided with enemy")
