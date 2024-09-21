extends Control


@onready var info_popup: PopupPanel = $LevelInfo


func _on_info_button_pressed() -> void:
	info_popup.show()
