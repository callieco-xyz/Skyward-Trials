extends Control


@export var editmap: EditMap

var save_warning := "Your level needs a name to be saved"
var original_level_info: LevelInfo

@onready var info_popup: PopupPanel = $LevelInfo
@onready var level_name: LineEdit = $LevelInfo/Rows/LevelNameInput
@onready var level_desc: LineEdit = $LevelInfo/Rows/LevelDescInput
@onready var warning: Label = $LevelInfo/Rows/Warning
@onready var save: Button = $LevelInfo/Rows/HBoxContainer/SaveButton


func _ready() -> void:
	set_info()
	check_warning()


func set_info() -> void:
	if editmap:
		level_name.text = editmap.level_info.level_name
		level_desc.text = editmap.level_info.level_desc
		original_level_info = LevelInfo.new()
		original_level_info.level_name = editmap.level_info.level_name


func check_warning() -> void:
	if editmap:
		if editmap.level_info.level_name == "":
			warning.text = save_warning
			save.disabled = true
		else:
			warning.text = ""
			save.disabled = false


func _on_info_button_pressed() -> void:
	info_popup.show()


func _on_level_name_input_text_changed(new_text: String) -> void:
	if editmap:
		editmap.level_info.level_name = new_text
	check_warning()


func _on_level_desc_input_text_changed(new_text: String) -> void:
	if editmap:
		editmap.level_info.level_desc = new_text


func _on_save_button_pressed() -> void:
	if editmap:
		editmap.level_info.tilemap_data = editmap.levelmap.tile_map_data
		editmap.level_info.save_level_data()
		LevelInfo.delete_level(original_level_info.level_name)
	SignalBus.play_exit_pressed.emit()



func _on_discard_pressed() -> void:
	if editmap:
		editmap.level_info = original_level_info
	SignalBus.play_exit_pressed.emit()
	
