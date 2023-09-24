extends Area2D

var lifetime = 0.0
var ttl = 2.0
var coner_inside = false

signal kill()

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = -1
	modulate.a = 0
	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime += delta
	
	if lifetime < 1.0:
		modulate.a = lifetime
	
	if lifetime > ttl:
		modulate.a = 1.0 - (lifetime-ttl)
		modulate.b = 0
		modulate.g = 0
		if coner_inside:
			kill.emit()
	
	if lifetime > ttl+1:
		queue_free()

func _on_area_entered(_area):
	coner_inside = true

func _on_area_exited(_area):
	coner_inside = false
