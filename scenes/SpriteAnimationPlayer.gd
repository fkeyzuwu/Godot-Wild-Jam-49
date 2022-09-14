extends AnimationPlayer

var amplitude = 0
var shake_interval = 0.05
onready var sprite = get_parent().get_node("Sprite")
onready var build_up_timer = Timer.new()
onready var build_down_timer =Timer.new()

func _ready() -> void:
	build_up_timer.one_shot = false
	add_child(build_up_timer)
	build_up_timer.start(shake_interval)
	
	build_down_timer.one_shot = false
	add_child(build_down_timer)
	build_down_timer.start(shake_interval)


func start_shake():
	if !build_up_timer.is_connected("timeout", self , "shake_build_up"):
		build_up_timer.connect("timeout", self , "shake_build_up")
		
	if build_down_timer.is_connected("timeout", self , "shake_build_down"):
		build_down_timer.disconnect("timeout", self , "shake_build_down")
	
func stop_shake():
	if build_up_timer.is_connected("timeout", self , "shake_build_up"):
		build_up_timer.disconnect("timeout", self , "shake_build_up")
		
	if !build_down_timer.is_connected("timeout", self , "shake_build_down"):
		build_down_timer.connect("timeout", self , "shake_build_down")
 

func shake_build_up():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	amplitude += 0.1
	var tween = create_tween()
	tween.tween_property(sprite, "position", rand, shake_interval)
	
func shake_build_down():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	amplitude -= 0.1
	var tween = create_tween()
	tween.tween_property(sprite, "position", rand, shake_interval * 3)

