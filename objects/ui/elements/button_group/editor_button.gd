class_name EditorButton extends Button


signal tool_selected(tool_id: int, tool_icon: AtlasTexture)

var tool_id


func _ready() -> void:
	pressed.connect(on_pressed_button)


func on_pressed_button() -> void:
	tool_selected.emit(tool_id, icon)
