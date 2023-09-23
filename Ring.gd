extends Area2D

var size_growth = 20
var size = 1.0
var ttl = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	size += delta * size_growth
	scale.x = size
	scale.y = size
	modulate.a = ttl
	ttl -= delta
	if ttl < 0:
		queue_free()

func _on_area_entered(area):
	area.spore_buff()
