extends Area2D
class_name ArtifactEffect

var color: Color
var animation: String
var sfx: Array
var sfx_path: String = "res://assets/Sfx/"

func _ready() -> void:
	add_to_group("artifact_effects")
	sfx = _get_files(sfx_path + name)


func activate():
	pass

func _get_files(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
