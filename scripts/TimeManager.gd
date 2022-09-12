extends Node

onready var effect_timer: Timer
onready var tilemap_timer: Timer

var time_for_event := 4.0 # make this faster over time

func _ready() -> void:
	effect_timer = Timer.new()
	effect_timer.one_shot = false
	add_child(effect_timer)
	effect_timer.start(time_for_event / 2)
	effect_timer.wait_time = time_for_event
	
	tilemap_timer = Timer.new()
	tilemap_timer.wait_time = time_for_event
	tilemap_timer.one_shot = false
	add_child(tilemap_timer)
	tilemap_timer.start()
	
	effect_timer.connect("timeout", self, "debug", ["effect_timer"])
	tilemap_timer.connect("timeout", self, "debug", ["tilemap_timer"])
	
func debug(timer: String):
	print(timer + "emited")
