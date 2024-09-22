extends Node


var main_menu := preload("res://views/main_menu_view/main_menu_view.tscn")
var play_map := preload("res://views/play_view/play_view.tscn")
var edit_map := preload("res://objects/tilemaps/edit_map/edit_map.tscn")

@onready var game_canvas: CanvasLayer = $Game as CanvasLayer


func _ready() -> void:
	SignalBus.level_play_pressed.connect(on_level_play_pressed)
	SignalBus.level_edit_pressed.connect(on_level_edit_pressed)
	SignalBus.play_exit_pressed.connect(on_play_exit_pressed)


func on_play_exit_pressed() -> void:
	var menu = main_menu.instantiate() as MainMenu
	menu.current_tab = MainMenu.PLAY
	change_level(menu)


func on_level_play_pressed(level_info: LevelInfo) -> void:
	var new_play_map = play_map.instantiate()
	new_play_map.set_level_info(level_info)
	change_level(new_play_map)


func on_level_edit_pressed(level_info: LevelInfo) -> void:
	var new_edit_map = edit_map.instantiate() as EditMap
	new_edit_map.level_info = level_info
	change_level(new_edit_map)

func change_level(new_level_scene: Node) -> void:
	var current_level = game_canvas.get_children()
	for child in current_level:
		child.queue_free()
	
	game_canvas.add_child(new_level_scene)


func _on_tick_timeout() -> void:
	SignalBus.tick.emit()
