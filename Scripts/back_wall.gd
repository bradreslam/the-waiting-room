extends Node2D

@onready var bacakWallAnimation: AnimatedSprite2D = $BackWallAnimation

func _ready():
	bacakWallAnimation.play("default")
