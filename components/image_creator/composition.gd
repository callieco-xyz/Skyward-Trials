class_name Composition extends Control


@onready var level_name := $VBoxContainer/MarginContainer/LevelName


func set_level_name(new_level_name: String) -> void:
	level_name.text = new_level_name
