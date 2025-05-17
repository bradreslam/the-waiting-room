extends Node2D

@onready var pumpAnimation:AnimatedSprite2D = $pumpAnimation
@onready var pumpTrigger:Area2D = $pumpTrigger

var puzzleFixed: bool = false

func _ready():
	hide()
	pumpAnimation.animation = "open"
	pumpAnimation.frame = 0


func _on_pump_trigger_input_event(viewport, event, shape_idx):
	if puzzleFixed:
		pumpAnimation.play("pump")
	else:
		pumpAnimation.play("failedPump")

func _on_pump_trigger_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_pump_trigger_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_pump_animation_animation_finished():
	pumpAnimation.play("idle")
