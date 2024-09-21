extends Node


var play_map := preload("res://objects/tilemaps/play_map/play_map.tscn")

@onready var game_canvas: CanvasLayer = $Game as CanvasLayer


func _ready() -> void:
	SignalBus.level_play_pressed.connect(on_level_play_pressed)


func on_level_play_pressed(level_info: LevelInfo) -> void:
	var new_play_map = play_map.instantiate() as PlayMap
	new_play_map.level_info = level_info
	change_level(new_play_map)


func change_level(new_level_scene: Node) -> void:
	var current_level = game_canvas.get_children()
	for child in current_level:
		child.queue_free()
	
	game_canvas.add_child(new_level_scene)


func _on_tick_timeout() -> void:
	SignalBus.tick.emit()
