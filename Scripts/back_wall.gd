extends Node2D

@export var endNoise:AudioStream
@export var unlock:AudioStream

@onready var backWallAnimation: AnimatedSprite2D = $BackWallAnimation
@onready var animationPlayer:AnimationPlayer = $AnimationPlayer
@onready var audioPlayer:AudioStreamPlayer2D = $AudioStreamPlayer2D

signal areaEntered
signal areaExited
signal theEnd

func _ready():
	var key = get_node("../Key")
	position = Vector2(0,0)
	if key.has_signal("keyDropped"):
		key.keyDropped.connect(self.end)
	backWallAnimation.play("default")

func play_sound(audio):
	audioPlayer.stop()
	audioPlayer.stream = audio
	audioPlayer.play()

func end():
	emit_signal("theEnd")
	backWallAnimation.play("opening")

func _on_area_2d_body_entered(body):
	if body.is_in_group("key"):
		emit_signal("areaEntered")

func _on_area_2d_body_exited(body):
	if body.is_in_group("key"):
		emit_signal("areaExited")

func _on_back_wall_animation_animation_finished():
	animationPlayer.play("opening")

func _on_back_wall_animation_frame_changed():
	if backWallAnimation.animation == "opening":
		if backWallAnimation.frame == 2:
			play_sound(unlock)


func _on_animation_player_animation_finished(_anim_name):
	play_sound(endNoise)
