class_name LevelInfoPanel extends PanelContainer


var delete_popup := preload("res://objects/ui/elements/delete_dialog/delete_dialog.tscn")
var ticked := preload("res://components/theme/textures/texture_tick.tres")
var crossed := preload("res://components/theme/textures/texture_cross.tres")
var level_info: LevelInfo
var share_tip_enabled := "Export this level as a .png file that other players can try."
var share_tip_disabled := "You have to play and complete your level to enable sharing."

@onready var level_name: Label = $Cols/Rows/LevelName/LevelName
@onready var completed: TextureRect = $Cols/Rows/LevelName/Completed
@onready var level_desc: Label = $Cols/Rows/LevelDesc
@onready var icon: TextureRect = $Cols/ImagePanel/LevelIcon
@onready var export_button: Button = $Cols/Rows/Actions/ExportButton
@onready var delete_button: Button = $Cols/Rows/Actions/DeleteButton


func _ready() -> void:
	set_up_info()


func set_up_info() -> void:
	if level_info == null:
		return
	level_name.text = level_info.level_name
	level_desc.text = level_info.level_desc
	icon.texture = ImageTexture.create_from_image(level_info.level_graphic)
	if level_info.completed == false:
		completed.texture = crossed
		export_button.disabled = true
		export_button.tooltip_text = share_tip_disabled
	else:
		completed.texture = ticked
		export_button.tooltip_text = share_tip_enabled


func _on_play_button_pressed() -> void:
	if level_info:
		SignalBus.level_play_pressed.emit(level_info)


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


func _on_delete_button_pressed() -> void:
	var new_delete_dialog = delete_popup.instantiate() as PopupPanel
	new_delete_dialog.filepath = level_info.resource_path
	get_tree().get_first_node_in_group("GameCanvas").add_child(new_delete_dialog)
