extends HBoxContainer


@export var button_images: Array[AtlasTexture]
@export var button_tool_ids: Array[tool]

var popup_offset := Vector2(140.0, 0.0)

@onready var options := $Options
@onready var cols := $Options/Cols
@onready var selected_tool := $SelectedTool


enum tool { 
	WALL_BLOCK, SPIKE_BLOCK, SPIKES_OFFSET, BLINK_BLOCK, BLINK_OFFSET, WEAK_BLOCK,
	TUR_RED, TUR_RED_OFFSET, TUR_GREEN, TUR_GREEN_OFFSET, TUR_PURPLE, TUR_PURPLE_OFFSET,
	GROUND, DELETE }


func _ready() -> void:
	if button_images.size() > 0:
		set_first_button()
		create_buttons()


func set_first_button() -> void:
	selected_tool.icon = button_images[0]


func create_buttons() -> void:
	var i := 0
	for button_image in button_images:
		create_button(button_image, button_tool_ids[i])


func create_button(new_icon: AtlasTexture, tool_id: int) -> void:
	var new_button = EditorButton.new()
	new_button.toggle_mode = true
	new_button.theme_type_variation = "ToolButton"
	new_button.icon = new_icon
	cols.add_child(new_button)


func _on_expand_button_pressed() -> void:
	options.position = global_position + popup_offset
	options.show()
