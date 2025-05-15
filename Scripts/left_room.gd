extends Node2D

@onready var roomAnimation:AnimatedSprite2D = $leftRoomAnimation

func _ready():
	roomAnimation.play("default")
