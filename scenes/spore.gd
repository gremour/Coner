extends Area2D

var center: Vector2
var rotate_radius = 100.0
var phase = 0.0
var rotate_speed = PI / 4.0
var speed = 100

signal spawn_ring(pos: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport = get_viewport_rect()
	center = Vector2(viewport.size.x/4 + randf()*viewport.size.x/2, viewport.size.x/4 + randf()*viewport.size.y/2)
	position = center
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	phase += delta * rotate_speed
	var cur_target = center + Vector2(rotate_radius * cos(phase), rotate_radius * sin(phase))
	var dir = (cur_target - position).normalized()
	position += dir * speed * delta

func _on_area_entered(_area):
	spawn_ring.emit(position)
	self.queue_free()
