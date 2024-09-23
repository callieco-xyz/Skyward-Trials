extends HBoxContainer


@export var buttons: Array[EditorButtonData]

var popup_offset := Vector2(140.0, 0.0)

@onready var options := $Options
@onready var cols := $Options/Cols
@onready var selected_tool := $SelectedTool


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
	new_button.theme_type_variation = "ToolButton"
	new_button.icon = button.icon
	new_button.tool_id = button.tool_id
	new_button.tooltip_text = button.tooltip
	new_button.tool_selected.connect(on_tool_button_pressed)
	cols.add_child(new_button)


func on_tool_button_pressed(_tool_id, icon) -> void:
	selected_tool.icon = icon
	options.hide()


func _on_expand_button_pressed() -> void:
	options.position = global_position + popup_offset
	options.show()
