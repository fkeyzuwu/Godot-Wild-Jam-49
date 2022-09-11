extends Node

onready var effect_timer: Timer

func _ready() -> void:
	effect_timer = Timer.new()
	effect_timer.wait_time = 5
	effect_timer.one_shot = false
	add_child(effect_timer)
	effect_timer.start()
