extends Node2D

var next_spawn = 3
var period_patchwerk_spawn = 10
var k_patchwerk_spawn = 60
var next_spore_spawn = 15
var period_spore_spawn = 25

var game_over = false
var patchwerk_factory = preload("res://scenes/patchwerk.tscn")
var spore_factory = preload("res://scenes/spore.tscn")
var ring_factory = preload("res://scenes/ring.tscn")

var game_time = 0
var mob_score = 0

signal exit()
signal again()

func _ready():
	randomize()

func _process(delta):
	next_spawn -= delta
	next_spore_spawn -= delta
	if not game_over:
		game_time += delta
		
	@warning_ignore("integer_division")
	var game_time_text = "%d" % (int(game_time) / 60) + " : " + "%02d" % (int(game_time) % 60)
	$UI/Played.text = game_time_text
	
	if next_spawn <= 0 and not game_over:
		next_spawn = period_patchwerk_spawn * k_patchwerk_spawn / (k_patchwerk_spawn + game_time)
		var mob = patchwerk_factory.instantiate()
		mob.kill.connect($Coner._on_patchwerk_kill)
		mob.kill.connect(self._on_patchwerk_kill)
		mob.died.connect(self._on_patchwerk_died)
		$Mobs.add_child(mob)

	if next_spore_spawn <= 0 and not game_over:
		next_spore_spawn = period_spore_spawn
		var spore = spore_factory.instantiate()
		spore.spawn_ring.connect(self._on_spore_spawn_ring)
		spore.rotate_radius = 100.0 + randf() * 200.0
		$Mobs.add_child(spore)

func _on_patchwerk_kill():
	game_over = true
	var score = int(game_time) * 10 + mob_score
	$UI/Score.text = "Score : %d" % score
	$UI/GameOver.visible = true
	$UI/Score.visible = true
	$UI/AgainButton.visible = true
	$UI/ExitButton.visible = true
	
func _on_patchwerk_died():
	mob_score += 100
	
func _on_spore_spawn_ring(pos: Vector2):
	var ring = ring_factory.instantiate()
	ring.position = pos
	$Mobs.call_deferred("add_child", ring)

func _on_background_music_finished():
	$BackgroundMusic.play()

func _on_exit_button_pressed():
	exit.emit()

func _on_again_button_pressed():
	again.emit()
