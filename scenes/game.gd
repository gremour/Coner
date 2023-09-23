extends Node2D

var world_scene = preload("res://scenes/world.tscn")

func _ready():
	new_game()
	
func new_game():
	var new_world = world_scene.instantiate()
	new_world.name = "World"
	new_world.again.connect(self._on_world_again)
	new_world.exit.connect(self._on_world_exit)
	self.add_child(new_world)
	
func _on_world_exit():
	get_tree().quit()

func _on_world_again():
	$World.queue_free()
	remove_child(get_child(0))
	new_game()
