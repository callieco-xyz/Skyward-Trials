class_name EditMap extends Node2D


var level_info: LevelInfo
var tool_id: int
var tool_coords: Array[Vector2i] = [
	Vector2i(0,1), Vector2i(8,0), Vector2i(8,1), Vector2i(6,0), Vector2i(6,1), Vector2i(7,0),
	Vector2i(3,1), Vector2i(3,3), Vector2i(1,1), Vector2i(1,3), Vector2i(2,1), Vector2i(2,3),
]

enum tool { 
	WALL_BLOCK, SPIKE_BLOCK, SPIKES_OFFSET, BLINK_BLOCK, BLINK_OFFSET, WEAK_BLOCK,
	TUR_RED, TUR_RED_OFFSET, TUR_GREEN, TUR_GREEN_OFFSET, TUR_PURPLE, TUR_PURPLE_OFFSET,
	GROUND, DELETE }


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.edit_tool_selected.connect(tool_changed)
	if level_info == null:
		level_info = LevelInfo.new()


func tool_changed(_new_tool_id) -> void:
	pass
