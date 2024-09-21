class_name Projectile extends Area2D


var speed: float = 300.0
var direction: Vector2 = Vector2.RIGHT
var color: int = 2
var lifetime: float = 0.0
var green_glow := Color(0.5, 1.7, 1.7, 1.0)
var purple_glow := Color(1.4, 0.8, 1.9, 1.0)
var red_glow := Color(2.2, 0.7, 0.7, 1.0)

enum { RED, GREEN, PURPLE }


func _ready() -> void:
	match color:
		RED:
			set_red()
		GREEN:
			set_green()
		PURPLE:
			set_purple()
	direction = direction.normalized()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	lifetime += delta * 4
	$Sprites/Layer3.scale = Vector2(1.0, 1.0) + (Vector2(0.08, 0.08) * sin(lifetime))
	if lifetime > 16:
		queue_free()


func set_red() -> void:
	$Sprites.modulate = red_glow


func set_green() -> void:
	$Sprites.modulate = green_glow


func set_purple() -> void:
	$Sprites.modulate = purple_glow
