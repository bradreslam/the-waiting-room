extends Node2D

@onready var roomAnimation:AnimatedSprite2D = $leftRoomAnimation

var puzzle_solved = false

signal puzzle_state

func _ready():
	var backWall = get_node("../BackWall")
	if backWall.has_signal("theEnd"):
		backWall.theEnd.connect(self.ending)
	var pump = get_node("../ceilingPump")
	if pump.has_signal("puzzle_check"):
		pump.puzzle_check.connect(self.check_puzzle)
	roomAnimation.play("default")

func check_puzzle():
	var puzzleState:Array
	for node in get_tree().get_nodes_in_group("leftRoomPuzzlePiece"):
		puzzleState.append(node.on)
	puzzleState.remove_at(2)
	if puzzleState.count(true) == 5:
		emit_signal("puzzle_state", true)
	else:
		emit_signal("puzzle_state", false)

func ending():
	roomAnimation.stop()
