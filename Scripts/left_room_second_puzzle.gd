extends Node2D

@export var puzzleSlideSound:AudioStream
@export var pannelTurnSound:AudioStream

@onready var animation:AnimatedSprite2D = $puzzleAnimation
@onready var piece1:Area2D = $piece1
@onready var piece1Animator:AnimatedSprite2D = $piece1/piece1Animantion
@onready var piece2:Area2D = $piece2
@onready var piece2Animator:AnimatedSprite2D = $piece2/piece2Animation
@onready var piece3:Area2D = $piece3
@onready var piece3Animator:AnimatedSprite2D = $piece3/piece3Animation
@onready var audioPlayer:AudioStreamPlayer2D = $AudioStreamPlayer2D

var opened: bool = false
var solved: bool = false
var piece1State:int = 1
var piece2State:int = 3
var piece3State:int = 2

signal second_puzzle_solved

func _ready():
	hide()
	piece1.hide()
	piece2.hide()
	piece3.hide()
	var backWall = get_node("../../BackWall")
	if backWall.has_signal("theEnd"):
		backWall.theEnd.connect(self.ending)
	var pump = get_node("../../ceilingPump")
	if pump.has_signal("succesPump"):
		pump.succesPump.connect(self.open)

func play_sound():
	audioPlayer.pitch_scale = randf_range(0.8,1.2)
	audioPlayer.stop()
	audioPlayer.stream = puzzleSlideSound
	audioPlayer.play()

func open():
	if !opened:
		opened = true
		show()
		audioPlayer.stop()
		audioPlayer.stream = pannelTurnSound
		audioPlayer.play()
		animation.play("open")

func _on_piece_1_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		move_piece_1()
		move_piece_2()

func move_piece_1():
	if piece1State != 3:
		piece1State += 1
	else:
		piece1State = 1
	piece1Animator.play("change" + str(piece1State))
	play_sound()

func _on_piece_2_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		move_piece_1()
		move_piece_2()
		move_piece_3()

func move_piece_2():
	if piece2State != 3:
		piece2State += 1
	else:
		piece2State = 1
	piece2Animator.play("change" + str(piece2State))
	play_sound()

func _on_piece_3_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		move_piece_2()
		move_piece_3()

func move_piece_3():
	if piece3State != 3:
		piece3State += 1
	else:
		piece3State = 1
	piece3Animator.play("change" + str(piece3State))
	play_sound()

func _on_puzzle_animation_animation_finished():
	piece1.show()
	piece1Animator.play("idle1")
	piece2.show()
	piece2Animator.play("idle3")
	piece3.show()
	piece3Animator.play("idle2")
	animation.play("idle")


func _on_piece_1_animantion_animation_finished():
	if piece1Animator.animation.erase(piece1Animator.animation.length() - 1, 1) != "idle":
		piece1Animator.play("idle" + str(piece1State))
		check_puzzle()

func _on_piece_2_animation_animation_finished():
	if piece2Animator.animation.erase(piece2Animator.animation.length() - 1, 1) != "idle":
		piece2Animator.play("idle" + str(piece2State))
		check_puzzle()

func _on_piece_3_animation_animation_finished():
	if piece3Animator.animation.erase(piece3Animator.animation.length() - 1, 1) != "idle":
		piece3Animator.play("idle" + str(piece3State))
		check_puzzle()
	
func check_puzzle():
	if !solved and piece1State == piece2State and piece2State == piece3State:
		solved = true
		emit_signal("second_puzzle_solved")

func ending():
	animation.stop()
	piece1Animator.stop()
	piece2Animator.stop()
	piece3Animator.stop()
	var frames1 = piece1Animator.sprite_frames
	var frames2 = piece2Animator.sprite_frames
	var frames3 = piece3Animator.sprite_frames
	frames1.set_animation_loop("idle1", false)
	frames1.set_animation_loop("idle2", false)
	frames1.set_animation_loop("idle3", false)
	frames2.set_animation_loop("idle1", false)
	frames2.set_animation_loop("idle2", false)
	frames2.set_animation_loop("idle3", false)
	frames3.set_animation_loop("idle1", false)
	frames3.set_animation_loop("idle2", false)
	frames3.set_animation_loop("idle3", false)
