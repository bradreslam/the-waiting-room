extends Area2D

@onready var puzzleAnimation:AnimatedSprite2D = $puzzlePieceAnimation

var on:bool

func _ready():
	if randi() % 2:
		on = true
		puzzleAnimation.play("idle1")
	else:
		on = false
		puzzleAnimation.play("idle2")
	puzzleAnimation.animation_finished.connect(_on_puzzle_piece_animation_animation_finished)
func _input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		if on:
			puzzleAnimation.play("turn")
			on = false
		else:
			puzzleAnimation.play_backwards("turn")
			on = true

func _on_puzzle_piece_animation_animation_finished():
	if on:
		puzzleAnimation.play("idle1")
	else:
		puzzleAnimation.play("idle2")
