extends Node2D

@onready var backWallAnimation: AnimatedSprite2D = $BackWallAnimation
@onready var animationPlayer:AnimationPlayer = $AnimationPlayer

signal areaEntered
signal areaExited

func _ready():
	var key = get_node("../Key")
	if key.has_signal("keyDropped"):
		key.keyDropped.connect(self.end)
	backWallAnimation.play("default")

func end():
	backWallAnimation.play("opening")

func _on_area_2d_body_entered(body):
	if body.is_in_group("key"):
		emit_signal("areaEntered")

func _on_area_2d_body_exited(body):
	if body.is_in_group("key"):
		emit_signal("areaExited")


func _on_back_wall_animation_animation_finished():
	animationPlayer.play("RESET")
