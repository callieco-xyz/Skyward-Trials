class_name EditorButton extends Button


signal tool_selected(tool_id: int, tool_icon: AtlasTexture)

var tool_id

func _ready() -> void:
	pressed.connect(tool_button_selected)


func tool_button_selected() -> void:
	tool_selected.emit(tool_id, icon)
