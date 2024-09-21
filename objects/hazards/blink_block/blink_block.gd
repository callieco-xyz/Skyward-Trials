extends Node2D


@export var on := true



func _ready() -> void:
	SignalBus.tick.connect(on_tick)


func on_tick() -> void:
	if on:
		on = false
		fade_out()
	else:
		on = true
		fade_in()


func fade_in() -> void:
	var tw = get_tree().create_tween()
	tw.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.1), 1.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)


func fade_out() -> void:
	var tw = get_tree().create_tween()
	tw.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.9), 1.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
