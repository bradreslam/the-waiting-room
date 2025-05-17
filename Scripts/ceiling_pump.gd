extends Node2D

@onready var pumpAnimation:AnimatedSprite2D = $pumpAnimation
@onready var pumpTrigger:Area2D = $pumpTrigger

var puzzleFixed: bool = false

signal puzzle_check
signal succesPump

func _ready():
	hide()
	var tv = get_node("../bottomPannel")
	if tv.has_signal("tv_puzzle_solved"):
		tv.tv_puzzle_solved.connect(self.open_pannel)
	var puzzle = get_node("../leftRoom")
	if puzzle.has_signal("puzzle_state"):
		puzzle.puzzle_state.connect(self.pump)

func _on_pump_trigger_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		emit_signal("puzzle_check")

func pump(solved:bool):
	pumpTrigger.hide()
	if solved:
		pumpAnimation.play("pump")
		emit_signal("succesPump")
	else:
		pumpAnimation.play("failedPump")

func _on_pump_animation_animation_finished():
	pumpAnimation.play("idle")
	pumpTrigger.show()

func open_pannel():
	show()
	pumpAnimation.play("open")
