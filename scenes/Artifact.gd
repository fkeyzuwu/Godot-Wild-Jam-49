extends KinematicBody2D

var target: Node2D #change this depending on what target you should go towards

func _process(delta: float) -> void:
	if target != null:
		_move_toward_target()
		

func _on_artifact_body_entered(body: Node) -> void:
	if body is Player:
		var player = body as Player
		player.pick_up_artifact(self)
	elif body is Enemy:
		print("collided with enemy")

func _move_toward_target():
	pass
