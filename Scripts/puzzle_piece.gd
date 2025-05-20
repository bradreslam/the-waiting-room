extends Area2D

@export var turnNoise:AudioStream

@onready var puzzleAnimation:AnimatedSprite2D = $puzzlePieceAnimation
@onready var audioPlayer:AudioStreamPlayer2D = $AudioStreamPlayer2D

var on:bool

func _ready():
	var backWall = get_node("../../BackWall")
	if backWall.has_signal("theEnd"):
		backWall.theEnd.connect(self.ending)
	if randi() % 2:
		on = true
		puzzleAnimation.play("idle1")
	else:
		on = false
		puzzleAnimation.play("idle2")
	puzzleAnimation.animation_finished.connect(_on_puzzle_piece_animation_animation_finished)

func play_audio():
	audioPlayer.pitch_scale = randf_range(0.8,1.2)
	audioPlayer.stop()
	audioPlayer.stream = turnNoise
	audioPlayer.play()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if on:
			puzzleAnimation.play("turn")
			on = false
			play_audio()
		else:
			puzzleAnimation.play_backwards("turn")
			on = true
			play_audio()

func _on_puzzle_piece_animation_animation_finished():
	if puzzleAnimation.animation == "turn":
		if on:
			puzzleAnimation.play("idle1")
		else:
			puzzleAnimation.play("idle2")

func ending():
	puzzleAnimation.stop()
	var frames = puzzleAnimation.sprite_frames
	frames.set_animation_loop("idle1", false)
	frames.set_animation_loop("idle2", false)
