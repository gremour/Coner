extends Node2D

var next_spawn = 3
var period_patchwerk_spawn = 10
var game_over = false
var patchwerk_factory = preload("res://scenes/patchwerk.tscn")

var game_time = 0

func _ready():
	randomize()

func _process(delta):
	next_spawn -= delta
	if not game_over:
		game_time += delta
		
	@warning_ignore("integer_division")
	var game_time_text = "%d" % (int(game_time) / 60) + " : " + "%02d" % (int(game_time) % 60)
	%Played.text = game_time_text
	
	
	if next_spawn <= 0 and not game_over:
		next_spawn = period_patchwerk_spawn
		var mob = patchwerk_factory.instantiate()
		mob.kill.connect($Coner._on_patchwerk_kill)
		mob.kill.connect(self._on_patchwerk_kill)
		$Mobs.add_child(mob)

func _on_patchwerk_kill():
	game_over = true
	var score = int(game_time) * 10
	%Score.text = "Score : %d" % score
	%GameOver.visible = true
	%Score.visible = true

func _on_background_music_finished():
	$BackgroundMusic.play()
