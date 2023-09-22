extends Area2D

var speed = 50
var hook_cooldown = 5
var max_hook_cooldown = 5

var hooking = false
var viewport

signal kill()

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
	
	$Chain.set_texture_mode(Line2D.LINE_TEXTURE_TILE)
	$Chain.points[0] = Vector2.ZERO 
	$Chain.points[1] = Vector2.ZERO 
	$Hook.patchwerk = self
	$Hook.chain = $Chain
	$Chain.visible = false
	$Animation.play("walk")
	$EnterSound.play()

func _process(delta):
	var world = get_node("/root/World")
	if world.game_over:
		$Animation.play("idle")
		return

	var coner = get_node("/root/World/Coner")
	var move_dir: Vector2 = (coner.position - Vector2(0, 24) - position)
	var dir: Vector2 = (coner.position - position)

	if hooking:
		return

	if hook_cooldown <= 0 and not hooking:
		dir = dir.normalized()
		hooking = true
		$Hook.start(dir, $ChainSpot.position)
		$HookSound.play()
		
		$Animation.play("hook")
	else:
		hook_cooldown -= delta

		if move_dir.length() < 4:
			move_dir = Vector2.ZERO
		move_dir = move_dir.normalized()

		if move_dir.x < 0:
			$Animation.flip_h = true
		elif move_dir.x > 0:
			$Animation.flip_h = false

		position += move_dir * speed * delta

func _on_hook_hit():
	$Animation.play("troll")

func _on_hook_returned():
	hooking = false
	hook_cooldown = max_hook_cooldown
	$Animation.play("walk")

func _on_area_entered(_area):
	kill.emit()

