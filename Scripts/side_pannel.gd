extends Node2D

@export var closingSpeed:float = 0.01
@export var ropeSpeed:float = 1

@onready var animator = $SidePannelAnimation
@onready var trigger = $Trigger
@onready var ropeEnd = $RopeEnd
@onready var rope = $Rope

var open:bool = false
var ropeHasBeenPulled: bool = false
var moving:bool = false
var ropePullLimit:float = 28
var ropeStartPosition:float = 3

signal rope_pulled

func _ready():
	animator.animation = "open"
	animator.frame = 0
	animator.hide()
	rope.hide()
	ropeEnd.hide()

func _on_trigger_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		animator.show()
		animator.play("open")
		trigger.hide()
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_side_pannel_animation_animation_finished():
	animator.play("idle")
	rope.show()
	rope.play("default")
	ropeEnd.show()

func _on_rope_end_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		moving = true
		ropeEnd.hide()

func _input(event):
	if moving:
		if Input.is_action_pressed("click"):
			if event is InputEventMouseMotion:
				rope.position.y = get_global_mouse_position().y
				if rope.position.y >= ropePullLimit:
					Input.set_default_cursor_shape(Input.CURSOR_ARROW)
					moving = false
					ropeEnd.show()
					if !ropeHasBeenPulled:
						ropeHasBeenPulled = true
						emit_signal("rope_pulled")
		else:
			moving = false
			ropeEnd.show()

func _process(_delta):
	if moving == false and rope.position.y != 3:
		rope.position.y = move_toward(rope.position.y, ropeStartPosition, ropeSpeed)
