extends Node2D

@onready var animator = $SidePannelAnimation
@onready var trigger = $Trigger
@onready var rope = $RopeEnd

var open:bool = false

func _ready():
	rope.set_block_signals(true)
	animator.animation = "open"
	animator.frame = 0

func _on_trigger_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		animator.play("open")
		trigger.set_block_signals(true)
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_trigger_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_trigger_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_side_pannel_animation_animation_finished():
	animator.play("idle")
	rope.set_block_signals(false)


func _on_rope_end_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_rope_end_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_rope_end_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
