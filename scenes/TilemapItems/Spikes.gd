extends Area2D
 
func _ready():
	$Spike_colision.set_deferred("disabled", true)
	z_index= -98
	$Sprite.play("Ready")
	$SpikeTimer.start()


func _on_Timer_timeout():
	$Sprite.play("Spike")
	$Spike_colision.set_deferred("disabled", false)
	yield($Sprite, "animation_finished")
	$Spike_colision.set_deferred("disabled",  true)
	$Sprite.play("Ready")
	$SpikeTimer.start()
