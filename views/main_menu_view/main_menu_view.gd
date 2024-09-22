class_name MainMenu extends Control


var current_tab := MAIN

@onready var tabs := $Outer/Tabs

enum { MAIN, OPTIONS, PLAY }


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tabs.current_tab = current_tab
	SignalBus.title_play_pressed.connect(on_play_pressed)
	SignalBus.title_options_pressed.connect(on_options_pressed)
	SignalBus.title_back_pressed.connect(on_back_pressed)


func on_play_pressed() -> void:
	tabs.current_tab = PLAY


func on_options_pressed() -> void:
	tabs.current_tab = OPTIONS


func on_back_pressed() -> void:
	tabs.current_tab = MAIN
