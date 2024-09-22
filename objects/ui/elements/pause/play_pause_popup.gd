extends PopupPanel


var map: PlayMap
var edit_tooltip_disabled := "You need to finish the level to be able to edit it."

@onready var edit_button: Button = $Rows/Actions/EditButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup_hide.connect(unpause)
	var play_map = get_tree().get_first_node_in_group("Map")
	if play_map:
		map = play_map
		if map.level_info.completed == false:
			edit_button.disabled = true
			edit_button.tooltip_text = edit_tooltip_disabled


func _process(_delta: float) -> void:
	if Input.is_action_just_released("pause"):
		if get_tree().paused == false:
			pause()
		else:
			unpause()


func pause() -> void:
	get_tree().paused = true
	show()


func unpause() -> void:
	get_tree().paused = false
	if visible:
		hide()


func _on_exit_button_pressed() -> void:
	unpause()
	SignalBus.play_exit_pressed.emit()


func _on_edit_button_pressed() -> void:
	unpause()
	if map:
		if map.level_info.completed:
			SignalBus.level_edit_pressed.emit(map.level_info)
