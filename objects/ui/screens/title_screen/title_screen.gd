extends CenterContainer


func _on_play_button_pressed() -> void:
	SignalBus.title_play_pressed.emit()


func _on_options_button_pressed() -> void:
	SignalBus.title_options_pressed.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
