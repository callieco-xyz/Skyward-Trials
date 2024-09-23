extends HBoxContainer


@export var buttons: Array[EditorButtonData]

var popup_offset := Vector2(140.0, 0.0)

@onready var options := $Options
@onready var cols := $Options/Cols
@onready var selected_tool := $SelectedTool


enum tool { 
	WALL_BLOCK, SPIKE_BLOCK, SPIKES_OFFSET, BLINK_BLOCK, BLINK_OFFSET, WEAK_BLOCK,
	TUR_RED, TUR_RED_OFFSET, TUR_GREEN, TUR_GREEN_OFFSET, TUR_PURPLE, TUR_PURPLE_OFFSET,
	GROUND, DELETE }


func _ready() -> void:
	if buttons.size() > 0:
		set_first_button()
		create_buttons()


func set_first_button() -> void:
	selected_tool.icon = buttons[0].icon


func create_buttons() -> void:
	var i := 0
	for button in buttons:
		create_button(buttons[i])
		i += 1


func create_button(button: EditorButtonData) -> void:
	var new_button = EditorButton.new()
	new_button.toggle_mode = true
	new_button.theme_type_variation = "ToolButton"
	new_button.icon = button.icon
	new_button.tool_id = button.tool_id
	new_button.tooltip_text = button.tooltip
	cols.add_child(new_button)


func _on_expand_button_pressed() -> void:
	options.position = global_position + popup_offset
	options.show()
