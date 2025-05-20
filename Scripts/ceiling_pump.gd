extends Node2D

@export var pumpNoise:AudioStream
@export var pompFailNoise:AudioStream
@export var steamHissNoise:AudioStream

@onready var pumpAnimation:AnimatedSprite2D = $pumpAnimation
@onready var pumpTrigger:Area2D = $pumpTrigger
@onready var audioPlayer:AudioStreamPlayer2D = $AudioStreamPlayer2D

var puzzleFixed: bool = false

signal puzzle_check
signal succesPump

func _ready():
	hide()
	var backWall = get_node("../BackWall")
	if backWall.has_signal("theEnd"):
		backWall.theEnd.connect(self.ending)
	var tv = get_node("../bottomPannel")
	if tv.has_signal("tv_puzzle_solved"):
		tv.tv_puzzle_solved.connect(self.open_pannel)
	var puzzle = get_node("../leftRoom")
	if puzzle.has_signal("puzzle_state"):
		puzzle.puzzle_state.connect(self.pump)

func play_audio(audio):
	audioPlayer.pitch_scale = randf_range(0.8,1.2)
	audioPlayer.stop()
	audioPlayer.stream = audio
	audioPlayer.play()

func _on_pump_trigger_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		emit_signal("puzzle_check")

func pump(solved:bool):
	pumpTrigger.hide()
	if solved:
		pumpAnimation.play("pump")
		emit_signal("succesPump")
		play_audio(pumpNoise)
	else:
		pumpAnimation.play("failedPump")
		play_audio(pompFailNoise)

func _on_pump_animation_animation_finished():
	if pumpAnimation.animation != "idle":
		pumpAnimation.play("idle")
		pumpTrigger.show()

func open_pannel():
	show()
	pumpAnimation.play("open")
	play_audio(steamHissNoise)

func ending():
	var frames = pumpAnimation.sprite_frames
	pumpAnimation.stop()
	frames.set_animation_loop("idle", false)
