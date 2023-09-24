extends Node2D

var next_spawn = 3
var period_patchwerk_spawn = 10
var k_patchwerk_spawn = 60
var next_spore_spawn = 15
var period_spore_spawn = 25
var spawn_count = 0

var game_over = false
var patchwerk_factory = preload("res://scenes/patchwerk.tscn")
var kel_factory = preload("res://scenes/kel_thuzad.tscn")
var spore_factory = preload("res://scenes/spore.tscn")
var ring_factory = preload("res://scenes/ring.tscn")
var void_zone_factory = preload("res://scenes/void_zone.tscn")

var game_time = 0
var mob_score = 0
var cur_character = -1

signal exit()
signal again(character: int)

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

		var mob
		if cur_character > 0 and spawn_count % 5 == 4:
			mob = kel_factory.instantiate()
			mob.kill.connect($Coner._on_patchwerk_kill)
			mob.kill.connect(self._on_patchwerk_kill)
			mob.died.connect(self._on_kel_died)
			mob.spawn_void_zone.connect(self._on_kel_spawn_void_zone)
		else:
			mob = patchwerk_factory.instantiate()
			mob.kill.connect($Coner._on_patchwerk_kill)
			mob.kill.connect(self._on_patchwerk_kill)
			mob.died.connect(self._on_patchwerk_died)

		$Mobs.add_child(mob)
		spawn_count += 1

	if next_spore_spawn <= 0 and not game_over:
		next_spore_spawn = period_spore_spawn
		var spore = spore_factory.instantiate()
		spore.spawn_ring.connect(self._on_spore_spawn_ring)
		spore.rotate_radius = 100.0 + randf() * 200.0
		$Mobs.add_child(spore)

func setup(character: int):
	cur_character = character
	$Coner.setup(cur_character)
	
	if cur_character < 0:
		game_over = true
		$UI/GameOver.visible = false
		$UI/Score.visible = false
		$UI/ConerButton.visible = true
		$UI/ArtneyButton.visible = true
		$UI/ExitButton.visible = true
		$Coner.visible = false
		return

	game_over = false
	$UI/GameOver.visible = false
	$UI/Score.visible = false
	$UI/ConerButton.visible = false
	$UI/ArtneyButton.visible = false
	$UI/ExitButton.visible = false
	$UI/GameOver.text = "%s is dead\nGAME OVER" % ("Coner" if cur_character == 0 else "Artney")
	$BeginSound.autoplay = true
	$BackgroundMusic.autoplay = true
	
func _on_patchwerk_kill():
	game_over = true
	var score = int(game_time) * 10 + mob_score
	$UI/Score.text = "Score : %d" % score
	$UI/GameOver.visible = true
	$UI/Score.visible = true
	$UI/ConerButton.visible = true
	$UI/ArtneyButton.visible = true
	$UI/ExitButton.visible = true
	
func _on_patchwerk_died():
	mob_score += 100

func _on_kel_died():
	mob_score += 300
	
func _on_spore_spawn_ring(pos: Vector2):
	var ring = ring_factory.instantiate()
	ring.position = pos
	$Mobs.call_deferred("add_child", ring)

func _on_kel_spawn_void_zone(pos: Vector2):
	var void_zone = void_zone_factory.instantiate()
	void_zone.position = pos
	void_zone.kill.connect($Coner._on_patchwerk_kill)
	void_zone.kill.connect(self._on_patchwerk_kill)
	$Mobs.call_deferred("add_child", void_zone)

func _on_background_music_finished():
	$BackgroundMusic.play()

func _on_exit_button_pressed():
	exit.emit()

func _on_coner_button_pressed():
	again.emit(0)
	
func _on_artney_button_pressed():
	again.emit(1)

