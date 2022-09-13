extends Area2D
class_name ArtifactEffect

var color: Color
var animation: String

func _ready() -> void:
	add_to_group("artifact_effects")

func activate():
	pass
