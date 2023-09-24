extends Area2D

var speed = 30
var fading = false
var fading_time = 1.0
var margin = 80

var cast_cooldown = 3.0
var max_cast_cooldown = 5.0
var min_cast_cooldown = 2.0

var viewport

signal kill()
signal died()

signal spawn_void_zone(pos: Vector2)

func _ready():
	viewport = get_viewport_rect()
	var spawn_pos = randf()
	var spawn_side = randi() % 4
	if spawn_side == 0:
		position = Vector2(spawn_pos * viewport.size.x, -50)
	elif spawn_side == 1:
		position = Vector2(spawn_pos * viewport.size.x, viewport.size.y + 50)
	elif spawn_side == 2:
		position = Vector2(-50, spawn_pos * viewport.size.y)
	else:
		position = Vector2(viewport.size.x + 50, spawn_pos * viewport.size.y)

	$Animation.play("idle")
	$EnterSound.play()


func _process(delta):
	if fading:
		fading_time -= delta
		modulate.a = fading_time
		if fading_time <= 0:
			died.emit()
			queue_free()
	
	var world = get_node("/root/Game/World")
	if world.game_over or fading:
		return
		
	var coner = get_node("/root/Game/World/Coner")

	cast_cooldown -= delta
	if cast_cooldown <= 0:
		cast_cooldown = max_cast_cooldown
		max_cast_cooldown *= 0.8
		if max_cast_cooldown < min_cast_cooldown:
			max_cast_cooldown = min_cast_cooldown
		$Animation.play("cast")
		$CastTimer.start()
		spawn_void_zone.emit(coner.position)

	var move_dir: Vector2 = (coner.position - Vector2(0, 24) - position)
	move_dir = move_dir.normalized()

	if move_dir.x < 0:
		$Animation.flip_h = true
	elif move_dir.x > 0:
		$Animation.flip_h = false

	if (position.x < margin or position.x > viewport.size.x - margin) or (position.y < margin or position.y > viewport.size.y - margin):
		position += move_dir * speed * delta

func _on_area_entered(_area):
	if fading:
		return
	kill.emit()

func spore_buff():
	fading = true
	$DeadSound.play(1.75)

func _on_cast_timer_timeout():
	$Animation.play("idle")
