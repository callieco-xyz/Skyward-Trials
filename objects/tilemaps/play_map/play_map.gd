class_name PlayMap extends Node2D


var level_info: LevelInfo

var bob_offset: float = 0.0
@export_range(0.1,2.0, 0.1) var bob_speed: float = 1.0
@export_range(2.0, 15.0, 0.25, "suffix:px") var bob_amount_high: float = 5.0
@export_range(2.0, 15.0, 0.25, "suffix:px") var bob_amount_low: float = 2.0

@onready var default_layer: TileMapLayer = $DefaultLayer
@onready var tilemaps: Array = $RenderLayers.get_children()


func _ready() -> void:
	set_up_default_tilemap()
	set_up_render_tilemaps()


func _physics_process(delta: float) -> void:
	update_bob_offset(delta)
	apply_motion_to_tilemaps()


func set_up_default_tilemap() -> void:
	if level_info:
		default_layer.tile_map_data = level_info.tilemap_data


func set_up_render_tilemaps() -> void:
	var default_layer_cells = default_layer.get_used_cells()
	for cell_location in default_layer_cells:
		set_cell_in_random_render_layer(cell_location)
	default_layer.hide()


func set_cell_in_random_render_layer(cell_location) -> void:
	var rand_render_layer = randi_range(0, 5)
	var cell_source: int = default_layer.get_cell_source_id(cell_location)
	var atlas_coords: Vector2i = default_layer.get_cell_atlas_coords(cell_location)
	tilemaps[rand_render_layer].set_cell(cell_location, cell_source, atlas_coords)


func update_bob_offset(delta: float) -> void:
	bob_offset += delta * bob_speed
	if bob_offset > TAU:
		bob_offset -= TAU


func apply_motion_to_tilemaps() -> void:
	tilemaps[0].position.y = sin(bob_offset) * bob_amount_high
	tilemaps[1].position.y = sin(bob_offset + PI / 2) * bob_amount_high
	tilemaps[2].position.y = sin(bob_offset + PI) * bob_amount_high
	tilemaps[3].position.y = cos(bob_offset) * bob_amount_low
	tilemaps[4].position.y = cos(bob_offset + PI) * bob_amount_low
	tilemaps[5].position.y = cos(bob_offset + PI / 2) * bob_amount_low
	tilemaps[0].position.x = sin(bob_offset + PI / 2) * bob_amount_low
	tilemaps[1].position.x = sin(bob_offset + PI) * bob_amount_low
	tilemaps[2].position.x = sin(bob_offset) * bob_amount_low
	tilemaps[3].position.x = cos(bob_offset + PI / 2) * bob_amount_low
	tilemaps[4].position.x = cos(bob_offset + PI) * bob_amount_low
	tilemaps[5].position.x = cos(bob_offset) * bob_amount_low
