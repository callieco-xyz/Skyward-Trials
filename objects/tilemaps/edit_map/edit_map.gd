class_name EditMap extends Node2D


var level_info: LevelInfo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if level_info == null:
		level_info = LevelInfo.new()
