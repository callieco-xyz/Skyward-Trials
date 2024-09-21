class_name NewLevelPanel extends Control


func set_hover_state_on() -> void:
	theme_type_variation = "InnerPanelHover"


func set_hover_state_off() -> void:
	theme_type_variation = "InnerPanel"


func _on_mouse_entered() -> void:
	set_hover_state_on()


func _on_mouse_exited() -> void:
	set_hover_state_off()


func _on_focus_entered() -> void:
	set_hover_state_on()


func _on_focus_exited() -> void:
	set_hover_state_off()
