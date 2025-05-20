extends Node2D

@onready var RoomAnimation: AnimatedSprite2D = $RoomAnimation
@onready var leftWall: Node2D = $LeftWall
@onready var backWall: Node2D = $BackWall
@onready var background: ParallaxBackground = $background

var held_object = null

func _ready():
	background.hide()
	RoomAnimation.play("default")
	if backWall.has_signal("theEnd"):
		backWall.theEnd.connect(self.ending)
	if leftWall.has_signal("left_wall_opened"):
		leftWall.left_wall_opened.connect(self.start_puzzle_left)
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)
		
	for node in get_tree().get_nodes_in_group("clickable"):
		node.mouse_entered.connect(_on_mouse_entered)
		node.mouse_exited.connect(_on_mouse_exited)

func start_puzzle_left():
	for node in get_tree().get_nodes_in_group("leftRoomPuzzlePiece"):
		node.mouse_entered.connect(_on_mouse_entered)
		node.mouse_exited.connect(_on_mouse_exited)

func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object
		
func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop((Input.get_last_mouse_velocity() / 5.0))
			held_object = null

func ending():
	RoomAnimation.stop()
	background.show()
