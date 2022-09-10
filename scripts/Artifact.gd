extends KinematicBody2D

var fly_to_pos := Vector2.ZERO #change this depending on what target you should go towards
var picked := false
var hitted_enemy = false

var FOLLOW_SPEED := 4.0

func _physics_process(delta: float) -> void:
	if picked or hitted_enemy:
		_follow_player(delta)
		
		

func _on_artifact_body_entered(body: Node) -> void:
	if body is Player:
		var player = body as Player
		player._artifact = self
		picked = true
		print("picked")
	elif body is Enemy:
		print("collided with enemy")
		fly_to_pos = Vector2.ZERO
		hitted_enemy = true

func throw():
	fly_to_pos = get_global_mouse_position()
	picked = false
	
func _follow_player(delta):
	var player_position = get_node("../Player/ArtifactPosition").global_position
	position = position.linear_interpolate(player_position, delta * FOLLOW_SPEED)
