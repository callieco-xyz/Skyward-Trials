extends TileMapLayer


var level_info: LevelInfo


func _ready() -> void:
	save_level_data("Prayers Please")


func load_level_data() -> void:
	level_info = load("res://components/level_info/my_new_level.tres")
	tile_map_data = level_info.tilemap_data


func save_level_data(level_name: String) -> void:
	level_info = LevelInfo.new()
	level_info.level_name = level_name
	level_info.tilemap_data = tile_map_data
	var new_image := Image.create_empty(256, 256, false, Image.FORMAT_RGB8)
	new_image.fill(Color.DARK_ORANGE)
	level_info.level_graphic = new_image
	level_info.completed = true
	
	var file_name = level_info.level_name.to_snake_case() + ".tres"
	var file_path = "res://saved_levels/" + file_name
	var err = ResourceSaver.save(level_info, file_path)
