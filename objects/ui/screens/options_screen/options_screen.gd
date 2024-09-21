extends CenterContainer


func _on_back_button_pressed() -> void:
	SignalBus.title_back_pressed.emit()
