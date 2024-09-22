@tool
class_name LevelInfo extends Resource

@export var update: bool = false:
	set(value):
		save_level_data()
@export var level_name: String:
	set(value):
		if value.length() == 0:
			level_name = "New Level"
		else:
			level_name = value
@export var level_desc: String
@export var level_graphic: Image
@export var completed: bool = false
@export var tilemap_data: PackedByteArray


func save_level_data() -> void:
	var new_image := Image.create_empty(128, 128, false, Image.FORMAT_RGB8)
	new_image.fill(Color.DARK_ORANGE)
	level_graphic = new_image
	var file_name = level_name.to_snake_case() + ".tres"
	file_name = file_name.validate_filename()
	if file_name.length() == 0:
		file_name = "invalid_level_name.tres"
	var file_path = "res://saved_levels/" + file_name
	ResourceSaver.save(self, file_path)
