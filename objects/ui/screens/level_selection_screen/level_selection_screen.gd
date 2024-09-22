extends CenterContainer


var level_info_panel_scene: PackedScene = preload("res://objects/ui/elements/level_info_panel/level_info_panel.tscn")
var saved_levels_path: String = "res://saved_levels/"
var saved_levels: Array[LevelInfo]

@onready var scroll: ScrollContainer = $PanelContainer/VBoxContainer/ScrollContainer
@onready var level_select: HFlowContainer = $PanelContainer/VBoxContainer/ScrollContainer/MarginContainer/LevelSelect


func _ready() -> void:
	repopulate_level_panels()
	set_level_select_width()
	get_tree().root.size_changed.connect(set_level_select_width)
	SignalBus.select_level_deleted.connect(repopulate_level_panels)


func set_level_select_width() -> void:
	var screen_width := get_viewport_rect().size.x
	level_select.custom_minimum_size.x = 556
	if screen_width > 1300:
		level_select.custom_minimum_size.x = 1120
	if screen_width > 1900:
		level_select.custom_minimum_size.x = 1680
	scroll.custom_minimum_size.y = get_viewport_rect().size.y * 0.4


func repopulate_level_panels() -> void:
	for level in level_select.get_children():
		level.queue_free()
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
	saved_levels.clear()
	if saved_level_files.size() == 0:
		return
	for level_file in saved_level_files:
		saved_levels.append(load(saved_levels_path + level_file))


func _on_back_button_pressed() -> void:
	SignalBus.title_back_pressed.emit()
