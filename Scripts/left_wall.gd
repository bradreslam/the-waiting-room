extends Node2D

@onready var wallTop : Area2D = $leftWallTop
@onready var wallBottom : Area2D = $leftWallBottom
@onready var leftWallAnimation : AnimatedSprite2D = $leftWallAnimation
@onready var downCast : RayCast2D = $leftWallDownCast
@onready var upCast : RayCast2D = $leftWallUpCast

var topBottomDistance: float = 0

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		var clickPoint = get_global_mouse_position()
		downCast.global_position = clickPoint
		downCast.force_raycast_update()
		if downCast.is_colliding():
			var bottomPoint = downCast.get_collision_point()
			var diference = bottomPoint.y - clickPoint.y
			
		leftWallAnimation.play("default")
		wallTop.set_block_signals(true)
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_area_2d_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
