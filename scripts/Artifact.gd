extends RigidBody2D

var current_effect: ArtifactEffect
onready var effects = get_tree().get_nodes_in_group("effects")

var picked := false
var hitted_enemy := false

var FOLLOW_SPEED := 4.0
var THROW_SPEED := 900.0

func _ready() -> void:
	mode = RigidBody2D.MODE_KINEMATIC
	TimeManager.effect_timer.connect("timeout", self, "_activate_effect")
	_set_random_effect()

func _activate_effect():
	current_effect.activate()
	_set_random_effect()
	
func _set_random_effect():
	current_effect = effects[randi() % effects.size() - 1]

func _physics_process(delta: float) -> void:
	if picked or hitted_enemy:
		_follow_player(delta)
		

func _on_artifact_body_entered(body: Node) -> void:
	if body is Player:
		var player = body as Player
		player._artifact = self
		picked = true
		hitted_enemy = false
		set_deferred("mode", RigidBody2D.MODE_CHARACTER)
		set_deferred("linear_velocity", Vector2.ZERO)
	elif body is Enemy:
		hitted_enemy = true
		set_deferred("mode", RigidBody2D.MODE_KINEMATIC)

func throw():
	var throw_direction = get_global_mouse_position() - global_position
	set_deferred("mode", RigidBody2D.MODE_CHARACTER)
	call_deferred("apply_central_impulse", throw_direction.normalized() * THROW_SPEED)
	(get_node("../Player") as Player)._artifact = null
	picked = false
	
func _follow_player(delta):
	if get_node("../Player/ArtifactPosition") != null:
		var player_position = get_node("../Player/ArtifactPosition").global_position
		position = position.linear_interpolate(player_position, delta * FOLLOW_SPEED)
