extends Node


signal tick

signal title_play_pressed
signal title_options_pressed
signal title_back_pressed
signal title_help_pressed

signal level_play_pressed(level_info: LevelInfo)
signal level_edit_pressed(level_info: LevelInfo)

signal play_exit_pressed

signal edit_tool_selected(tool_id)

signal select_level_deleted
