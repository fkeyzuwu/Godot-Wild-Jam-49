extends Area2D

onready var spike_collision = $"%SpikeCollision"
onready var sprite = $"%Sprite"
onready var spike_timer = $"%SpikeTimer"
 
func _ready():
	spike_collision.set_deferred("disabled", true)
	sprite.play("Ready")
	spike_timer.start()


func _on_Timer_timeout():
	sprite.play("Spike")
	spike_collision.set_deferred("disabled", false)
	yield(sprite, "animation_finished")
	spike_collision.set_deferred("disabled",  true)
	sprite.play("Ready")
	spike_timer.start()


func _on_SpikeTile_body_entered(body: Node) -> void:
	if body is Player:
		body.take_damage(1)
