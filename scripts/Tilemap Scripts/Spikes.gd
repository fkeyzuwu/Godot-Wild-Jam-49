extends Area2D

onready var spike_colision = $SpikeCollision
onready var sprite = $"%Sprite"
onready var spike_timer = $"%SpikeTimer"
 
func _ready():
	spike_colision.set_deferred("disabled", true)
	z_index= -98
	sprite.play("Ready")
	spike_timer.start()


func _on_Timer_timeout():
	sprite.play("Spike")
	spike_colision.set_deferred("disabled", false)
	yield(sprite, "animation_finished")
	spike_colision.set_deferred("disabled",  true)
	sprite.play("Ready")
	spike_timer.start()



func _on_SpikeTile_body_entered(body: Node) -> void:
	if body is Player:
		body.take_damage(1, "spikes")
