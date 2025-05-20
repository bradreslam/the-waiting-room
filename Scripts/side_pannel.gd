extends Node2D

@export var closingSpeed:float = 0.01
@export var ropeSpeed:float = 1
@export var slide:AudioStream
@export var ropeSwing:AudioStream
@export var ropePull:AudioStream

@onready var animator = $SidePannelAnimation
@onready var trigger = $Trigger
@onready var ropeEnd = $RopeEnd
@onready var rope = $Rope
@onready var ausioplayer = $sidePannelAudio

var open:bool = false
var ropeHasBeenPulled: bool = false
var moving:bool = false
var ropePullLimit:float = 28
var ropeStartPosition:float = 3
var playingAudio:bool = false

signal rope_pulled
signal pannel_opened

func _ready():
	var backWall = get_node("../BackWall")
	if backWall.has_signal("theEnd"):
		backWall.theEnd.connect(self.ending)
	animator.animation = "open"
	animator.frame = 0
	animator.hide()
	rope.hide()
	ropeEnd.hide()

func play_audio(audio):
	ausioplayer.stop()
	ausioplayer.stream = audio
	ausioplayer.play()

func _on_trigger_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		animator.show()
		animator.play("open")
		emit_signal("pannel_opened")
		trigger.hide()
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_side_pannel_animation_animation_finished():
	animator.play("idle")
	rope.show()
	rope.play("default")
	ropeEnd.show()

func _on_rope_end_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		moving = true
		ropeEnd.hide()

func _input(event):
	if moving:
		if !playingAudio and get_global_mouse_position().y > ropeStartPosition:
			play_audio(ropePull)
			playingAudio = true
		if Input.is_action_pressed("click"):
			if event is InputEventMouseMotion and get_global_mouse_position().y > ropeStartPosition:
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

func ending():
	animator.stop()
	rope.stop()


func _on_side_pannel_animation_frame_changed():
	if animator.animation == "open":
		if animator.frame == 8:
			play_audio(slide)
		if animator.frame == 12 or animator.frame == 16:
			play_audio(ropeSwing)


func _on_side_pannel_audio_finished():
	playingAudio = false
