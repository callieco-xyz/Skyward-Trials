class_name EditMap extends Node2D


var level_info: LevelInfo
var tool_id: int = tool.GROUND
var draw_mode := false
var has_focus := true

enum tool { 
	WALL_BLOCK, SPIKE_BLOCK, SPIKES_OFFSET, BLINK_BLOCK, BLINK_OFFSET, WEAK_BLOCK,
	TUR_RED, TUR_RED_OFFSET, TUR_GREEN, TUR_GREEN_OFFSET, TUR_PURPLE, TUR_PURPLE_OFFSET,
	START, END, GROUND, DELETE }

@onready var editor_hint: TileMapLayer = $EditorHint
@onready var levelmap: TileMapLayer = $LevelMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.edit_tool_selected.connect(tool_changed)
	if level_info == null:
		level_info = LevelInfo.new()


func _process(_delta: float) -> void:
	draw_editor_hint()
	if draw_mode and Input.is_action_pressed("edit_draw"):
		draw_tilemap_cell()
	if draw_mode and Input.is_action_pressed("edit_erase"):
		erase_tilemap_cell()
	set_draw_mode()


func set_draw_mode() -> void:
	draw_mode = false
	var mouse_pos = get_viewport().get_mouse_position()
	var window_size = get_viewport_rect()
	if mouse_pos. x < 150:
		return
	if mouse_pos.x > window_size.size.x - 150:
		return
	if mouse_pos.y < 150:
		return
	if mouse_pos.y > window_size.size.y - 150:
		return
	var pops = get_tree().get_nodes_in_group("Popup") 
	has_focus = true
	for popup in pops:
		if popup.visible:
			has_focus = false
	if not has_focus:
		return
	draw_mode = true


func draw_editor_hint() -> void:
	editor_hint.clear()
	if draw_mode:
		var cell_pos = editor_hint.local_to_map(get_local_mouse_position())
		draw_editor_cell(editor_hint, cell_pos)


func is_cell_in_range(cell: Vector2i) -> bool:
	if cell.x < 0:
		return false
	if cell.x > 63:
		return false
	if cell.y < 0:
		return false
	if cell.y > 63:
		return false
	return true


func draw_editor_cell(tilemap: TileMapLayer ,cell_location: Vector2i) -> void:
	if not is_cell_in_range(cell_location):
		return
	match tool_id:
		tool.WALL_BLOCK:
			tilemap.set_cell(cell_location, 0, Vector2i(0,1))
		tool.SPIKE_BLOCK:
			tilemap.set_cell(cell_location, 0, Vector2i(8,0))
		tool.SPIKES_OFFSET:
			tilemap.set_cell(cell_location, 0, Vector2i(8,1))
		tool.BLINK_BLOCK:
			tilemap.set_cell(cell_location, 0, Vector2i(6,0))
		tool.BLINK_OFFSET:
			tilemap.set_cell(cell_location, 0, Vector2i(6,1))
		tool.WEAK_BLOCK:
			tilemap.set_cell(cell_location, 0, Vector2i(7, 0))
		tool.TUR_RED:
			tilemap.set_cell(cell_location, 0, Vector2i(3, 1))
		tool.TUR_RED_OFFSET:
			tilemap.set_cell(cell_location, 0, Vector2i(3, 3))
		tool.TUR_GREEN:
			tilemap.set_cell(cell_location, 0, Vector2i(1, 1))
		tool.TUR_GREEN_OFFSET:
			tilemap.set_cell(cell_location, 0, Vector2i(1, 3))
		tool.TUR_PURPLE:
			tilemap.set_cell(cell_location, 0, Vector2i(2, 1))
		tool.TUR_PURPLE_OFFSET:
			tilemap.set_cell(cell_location, 0, Vector2i(2, 3))
		tool.START:
			tilemap.set_cell(cell_location, 0, Vector2i(5, 2))
		tool.END:
			tilemap.set_cell(cell_location, 0, Vector2i(6, 4))
		tool.GROUND:
			tilemap.set_cell(cell_location, 0, Vector2i(0,0))


func draw_tilemap_cell() -> void:
	var cell_pos = levelmap.local_to_map(get_local_mouse_position())
	if not is_cell_in_range(cell_pos):
		return
	match tool_id:
		tool.WALL_BLOCK:
			levelmap.set_cell(cell_pos, 0, Vector2i(0,1))
		tool.SPIKE_BLOCK:
			levelmap.set_cell(cell_pos, 0, Vector2i(8,0))
		tool.SPIKES_OFFSET:
			levelmap.set_cell(cell_pos, 0, Vector2i(8,1))
		tool.BLINK_BLOCK:
			levelmap.set_cell(cell_pos, 0, Vector2i(6,0))
		tool.BLINK_OFFSET:
			levelmap.set_cell(cell_pos, 0, Vector2i(6,1))
		tool.WEAK_BLOCK:
			levelmap.set_cell(cell_pos, 0, Vector2i(7, 0))
		tool.TUR_RED:
			levelmap.set_cell(cell_pos, 0, Vector2i(3, 1))
		tool.TUR_RED_OFFSET:
			levelmap.set_cell(cell_pos, 0, Vector2i(3, 3))
		tool.TUR_GREEN:
			levelmap.set_cell(cell_pos, 0, Vector2i(1, 1))
		tool.TUR_GREEN_OFFSET:
			levelmap.set_cell(cell_pos, 0, Vector2i(1, 3))
		tool.TUR_PURPLE:
			levelmap.set_cell(cell_pos, 0, Vector2i(2, 1))
		tool.TUR_PURPLE_OFFSET:
			levelmap.set_cell(cell_pos, 0, Vector2i(2, 3))
		tool.START:
			levelmap.set_cell(cell_pos, 0, Vector2i(5, 2))
		tool.END:
			levelmap.set_cell(cell_pos, 0, Vector2i(6, 4))
		tool.GROUND:
			var ground = levelmap.get_cell_tile_data(cell_pos)
			if ground == null:
				levelmap.set_cells_terrain_connect([cell_pos], 0,0)
			elif ground.terrain_set == 0:
				return
			else:
				levelmap.set_cells_terrain_connect([cell_pos], 0,0)



func erase_tilemap_cell() -> void:
	var cell_pos = levelmap.local_to_map(get_local_mouse_position())
	if not is_cell_in_range(cell_pos):
		return
	levelmap.erase_cell(cell_pos)


func tool_changed(new_tool_id) -> void:
	tool_id = new_tool_id
