extends Node2D

@onready var RoomAnimation: AnimatedSprite2D = $RoomAnimation

func _ready():
	RoomAnimation.play("default")
