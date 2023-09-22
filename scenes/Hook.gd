extends Area2D

var speed = 600
var max_range = 400

var start_position: Vector2
var dir: Vector2
var chain: Line2D
var target: Area2D
var returning = false
var patchwerk

signal returned()
signal hit()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible:
		return
		
	position += dir * speed * delta
	chain.points[1] = position
	if target != null:
		target.position = global_position

	var distance = (position - start_position).length()
	if distance >= max_range:
		returning = true
		dir = -dir
		
	if returning and distance < 10:
		visible = false
		chain.visible = false
		returned.emit()

func start(d, s):
	target = null
	returning = false
	start_position = s
	position = s
	rotation = Vector2.RIGHT.angle_to(d)
	dir = d
	chain.points[0] = s
	visible = true
	chain.visible = true

func _on_area_entered(area):
	if area == patchwerk:
		return
	target = area
	if not returning:
		returning = true
		dir = -dir
	hit.emit()
