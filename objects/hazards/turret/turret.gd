extends Node2D


@export_enum("Red", "Green", "Purple") var color: int = 2
@export var on = false

var offset_amount: float = 0.0
var green_glow := Color(0.5, 1.7, 1.7, 1.0)
var purple_glow := Color(1.5, 0.8, 1.7, 1.0)
var red_glow := Color(2.0, 0.6, 0.55, 1.0)
var projectile := preload("res://objects/hazards/projectile/projectile.tscn")
var purple_spread: Array[Vector2] = [
	Vector2(1, 0),
	Vector2(0.866025, 0.5),
	Vector2(0.5, 0.866025),
	Vector2(-0, 1),
	Vector2(-0.5, 0.866025),
	Vector2(-0.866025, 0.5),
	Vector2(-1, -0),
	Vector2(-0.866025, -0.5),
	Vector2(-0.5, -0.866025),
	Vector2(0, -1),
	Vector2(0.5, -0.866025),
	Vector2(0.866025, -0.5),
]
var green_max := 4
var green_count := 0
@onready var green_sprite: Sprite2D = $Sprite/Green
@onready var purple_sprite: Sprite2D = $Sprite/Purple
@onready var red_sprite: Sprite2D = $Sprite/Red
@onready var sprite: Node2D = $Sprite
@onready var particles: GPUParticles2D = $Sprite/Particles

enum { RED, GREEN, PURPLE }


func _ready() -> void:
	match color:
		RED:
			set_red()
			SignalBus.tick.connect(fire_red)
		GREEN:
			set_green()
			SignalBus.tick.connect(fire_green)
		PURPLE:
			set_purple()
			SignalBus.tick.connect(fire_purple)


func _process(delta: float) -> void:
	apply_bobbing_motion(delta)


func apply_bobbing_motion(delta: float) -> void:
	offset_amount += delta
	if offset_amount > TAU:
		offset_amount -= TAU
	sprite.position.y = sin(offset_amount) * 6


func set_red() -> void:
	purple_sprite.hide()
	green_sprite.hide()
	red_sprite.show()
	particles.modulate = red_glow


func set_green() -> void:
	purple_sprite.hide()
	green_sprite.show()
	red_sprite.hide()
	particles.modulate = green_glow


func set_purple() -> void:
	
	purple_sprite.show()
	green_sprite.hide()
	red_sprite.hide()
	particles.modulate = purple_glow


func fire_red() -> void:
	pass


func fire_green() -> void:
	if on:
		particles.emitting = false
		on = false
		fire_green_projectile()
		$GreenTimer.start()
	else:
		on = true
		$GreenTimer.stop()
		green_count = 0
		particles.emitting = true


func fire_green_projectile() -> void:
	if green_count < green_max:
		green_count += 1
		$GreenTimer.start()
		var proj_n = projectile.instantiate() as Projectile
		var proj_e = projectile.instantiate() as Projectile
		var proj_s = projectile.instantiate() as Projectile
		var proj_w = projectile.instantiate() as Projectile
		proj_n.direction = Vector2.UP
		proj_e.direction = Vector2.RIGHT
		proj_s.direction = Vector2.DOWN
		proj_w.direction = Vector2.LEFT
		proj_n.position = $Sprite/Emitter.global_position
		proj_e.position = $Sprite/Emitter.global_position
		proj_s.position = $Sprite/Emitter.global_position
		proj_w.position = $Sprite/Emitter.global_position
		proj_n.color = GREEN
		proj_e.color = GREEN
		proj_s.color = GREEN
		proj_w.color = GREEN
		get_tree().get_first_node_in_group("GameCanvas").add_child(proj_n)
		get_tree().get_first_node_in_group("GameCanvas").add_child(proj_e)
		get_tree().get_first_node_in_group("GameCanvas").add_child(proj_s)
		get_tree().get_first_node_in_group("GameCanvas").add_child(proj_w)


func fire_purple() -> void:
	if on:
		particles.emitting = false
		on = false
		for direction in purple_spread:
			var new_projectile = projectile.instantiate() as Projectile
			new_projectile.position = $Sprite/Emitter.global_position
			new_projectile.direction = direction
			new_projectile.color = PURPLE
			get_tree().get_first_node_in_group("GameCanvas").add_child(new_projectile)
	else:
		on = true
		particles.emitting = true


func _on_green_timer_timeout() -> void:
	fire_green_projectile()
