extends PopupPanel


var filepath: String


func _on_button_yes_pressed() -> void:
	if not filepath:
		return
	if FileAccess.file_exists(filepath):
		var err = DirAccess.remove_absolute(filepath)
		if err == OK:
			SignalBus.select_level_deleted.emit()
	queue_free()


func _on_button_no_pressed() -> void:
	queue_free()
