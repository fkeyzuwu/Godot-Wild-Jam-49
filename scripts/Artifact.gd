extends KinematicBody2D

var fly_to_pos := Vector2.ZERO #change this depending on what target you should go towards
var picked := false
var hitted_enemy := false

var FOLLOW_SPEED := 4.0
var FLYING_SPEED := 200.0

func _physics_process(delta: float) -> void:
	if picked or hitted_enemy:
		_follow_player(delta)
	elif fly_to_pos != Vector2.ZERO:
		_fly(delta)
		

func _on_artifact_body_entered(body: Node) -> void:
	if body is Player:
		var player = body as Player
		player._artifact = self
		picked = true
		hitted_enemy = false
	elif body is Enemy:
		fly_to_pos = Vector2.ZERO
		hitted_enemy = true

func throw():
	fly_to_pos = get_global_mouse_position()
	picked = false

func _fly(delta: float):
	position = position.move_toward(fly_to_pos, delta * FLYING_SPEED)

func _follow_player(delta):
	if get_node("../Player/ArtifactPosition") != null:
		var player_position = get_node("../Player/ArtifactPosition").global_position
		position = position.linear_interpolate(player_position, delta * FOLLOW_SPEED)
