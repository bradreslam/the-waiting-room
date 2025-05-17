extends Node2D

@export var wallAnimationFrameCount: int = 17
@export var closingSpeed: float = 0.01

@onready var wallTop : Area2D = $leftWallTop
@onready var wallBottom : Area2D = $leftWallBottom
@onready var leftWallAnimation : Sprite2D = $leftWallAnimation
@onready var downCast : RayCast2D = $leftWallDownCast

var frameIntergers = []
var moving:bool = false

func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		change_left_wall_state(true)
		wallTop.set_block_signals(true)

func change_left_wall_state(opening: bool):
		frameIntergers.clear()
		var clickPoint = get_global_mouse_position()
		downCast.global_position = clickPoint
		downCast.target_position = Vector2(0, 320) if opening else Vector2(0, -320)
		downCast.force_raycast_update()
		if downCast.is_colliding():
			var bottomPoint = downCast.get_collision_point()
			var diference = bottomPoint.y - clickPoint.y if opening else clickPoint.y - bottomPoint.y
			var frameDiference = diference / wallAnimationFrameCount
			for i in 20:
				i+=1
				frameIntergers.append((frameDiference * i)+clickPoint.y)
			moving = true

func _input(event):
	if moving:
		if Input.is_action_pressed("click"):
			if event is InputEventMouseMotion:
				var mousePos = get_global_mouse_position().y
				for d in frameIntergers:
					var pos = frameIntergers.bsearch(d)
					if mousePos < d and mousePos > frameIntergers[pos-1]:
						leftWallAnimation.frame = pos
						break
		else:
			var dedadsa = leftWallAnimation.frame
			if leftWallAnimation.frame == wallAnimationFrameCount:
				moving = false
				Input.set_default_cursor_shape(Input.CURSOR_ARROW)
			else:
				var frame:int = leftWallAnimation.frame
				Input.set_default_cursor_shape(Input.CURSOR_ARROW)
				while frame >= 0:
					leftWallAnimation.frame = frame
					await get_tree().create_timer(closingSpeed).timeout
					frame -= 1
				moving = false
				wallTop.set_block_signals(false)

func _on_area_2d_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
