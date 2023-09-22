extends Area2D

var speed = 200
var viewport
var viewport_margin = 40

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport = get_viewport_rect()
	position = viewport.size / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		return
	
	var dirx = Input.get_axis("move_left", "move_right")
	var diry = Input.get_axis("move_up", "move_down")
	
	if dirx > 0 and position.x >= viewport.size.x - viewport_margin:
		dirx = 0
	if dirx < 0 and position.x <= viewport_margin:
		dirx = 0
	if diry > 0 and position.y >= viewport.size.y - viewport_margin:
		diry = 0
	if diry < 0 and position.y <= viewport_margin:
		diry = 0

	if dirx < 0:
		$Animation.flip_h = true
	elif dirx > 0:
		$Animation.flip_h = false
	
	if dirx != 0 or diry != 0:
		$Animation.play("run")
	else:
		$Animation.play("idle")

	var dir = Vector2(dirx, diry).normalized()
	position += dir * speed * delta


func _on_patchwerk_kill():
	print("Coner is killed")
	$Blood.emitting = true
	$Blood.one_shot = true
	$DeathSound.play()
	dead = true
	$Animation.play("dead")
