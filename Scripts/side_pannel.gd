extends Node2D

@export var closingSpeed:float = 0.01
@export var ropeSpeed:float = 1

@onready var animator = $SidePannelAnimation
@onready var trigger = $Trigger
@onready var ropeEnd = $RopeEnd
@onready var rope = $Rope

var open:bool = false
var moving:bool = false
var ropePullLimit:float = 28
var ropeStartPosition:float = 3

func _ready():
	ropeEnd.set_block_signals(true)
	animator.animation = "open"
	animator.frame = 0
	animator.hide()
	rope.hide()

func _on_trigger_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		animator.show()
		animator.play("open")
		trigger.set_block_signals(true)
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_trigger_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_trigger_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_side_pannel_animation_animation_finished():
	animator.play("idle")
	rope.show()
	rope.play("default")
	ropeEnd.set_block_signals(false)


func _on_rope_end_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_rope_end_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_rope_end_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		moving = true
		ropeEnd.set_block_signals(true)

func _input(event):
	if moving:
		if Input.is_action_pressed("click"):
			if event is InputEventMouseMotion:
				rope.position.y = get_global_mouse_position().y
				if rope.position.y >= ropePullLimit:
					Input.set_default_cursor_shape(Input.CURSOR_ARROW)
					moving = false
					ropeEnd.set_block_signals(false)
		else:
			moving = false
			ropeEnd.set_block_signals(false)

func _process(_delta):
	if moving == false and rope.position.y != 3:
		rope.position.y = move_toward(rope.position.y, ropeStartPosition, ropeSpeed)
