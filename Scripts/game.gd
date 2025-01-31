extends Node2D

@export var pipe_scene : PackedScene
var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.game_restarted.connect(new_game)
	SignalBus.player_died.connect(_on_player_player_died)
	screen_size = get_window().size
	ground_height = screen_size.y
	new_game()
# Reset state of game
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	spawn_pipe()
	$scoreLabel.text = "SCORE : %d" % score
	$Player.reset()
	$gameOverLabel.hide()
	$restartButton.hide()

func start_game():
	game_running = true
	game_over = false
	$Timer.start()
	$Player.is_falling = true
	$Player.flap()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !game_over and Input.is_action_just_pressed("jump"):
		if !game_running:
			start_game()
		elif $Player.is_falling:
			$Player.flap()
	if game_running:
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

func _on_score_update():
	pass
	
func stop_game():
	$Timer.stop()
	$gameOverLabel.show()
	$restartButton.show()
	game_over = true
	game_running = false

func _on_player_player_died() -> void:
	#$Timer.stop()
	#$gameOverLabel.show()
	if game_running:
		stop_game()
		#game_over = true
		#game_running = false

func _on_timer_timeout() -> void:
	spawn_pipe()
	if game_running and not game_over:
		score += 1
		$scoreLabel.text = "SCORE : %d" % score

func spawn_pipe():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = screen_size.y / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	add_child(pipe)
	pipes.append(pipe)
	
func clear_pipe():
	pass
