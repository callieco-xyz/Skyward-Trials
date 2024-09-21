extends CenterContainer


var level_info_panel_scene: PackedScene = preload("res://objects/ui/elements/level_info_panel/level_info_panel.tscn")
var saved_levels_path: String = "res://saved_levels/"
var saved_levels: Array[LevelInfo]

@onready var level_select: GridContainer = $PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/LevelSelect


func _ready() -> void:
	reset_levels()
	SignalBus.select_level_deleted.connect(reset_levels)


func reset_levels() -> void:
	for level in level_select.get_children():
		level.queue_free()
		saved_levels = []
	get_saved_levels()
	populate_saved_levels()


func populate_saved_levels() -> void:
	if saved_levels.size() == 0:
		return
	for level in saved_levels:
		var new_level_panel = level_info_panel_scene.instantiate() as LevelInfoPanel
		new_level_panel.level_info = level
		level_select.add_child(new_level_panel)
		


func get_saved_levels() -> void:
	var saved_level_files := DirAccess.get_files_at(saved_levels_path)
	if saved_level_files.size() == 0:
		return
	for level_file in saved_level_files:
		saved_levels.append(load(saved_levels_path + level_file))


func _on_back_button_pressed() -> void:
	SignalBus.title_back_pressed.emit()
