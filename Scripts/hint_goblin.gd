extends Node2D

@onready var goblinAnimation :AnimatedSprite2D = $goblinAnimation
@onready var goblinTrigger :Area2D = $Area2D
@onready var hintAnimation :AnimatedSprite2D = $hint
@onready var audioPlayer :AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sign :AnimatedSprite2D = $sign
@onready var signAudio :AudioStreamPlayer2D = $signAudio


var found:bool = false
var gameState:int = 1
var pumps:int = 0
var closed:bool = true
var signFinished:bool = false

func _ready():
	display_sign()
	sign.hide()
	goblinAnimation.hide()
	hintAnimation.hide()
	var backWall = get_node("../BackWall")
	if backWall.has_signal("theEnd"):
		backWall.theEnd.connect(self.update_gameState)
	var bottomPannel = get_node("../bottomPannel")
	if bottomPannel.has_signal("spawn_key"):
		bottomPannel.spawn_key.connect(self.update_gameState)
	var sidePannel = get_node("../SidePannel")
	if sidePannel.has_signal("pannel_opened"):
		sidePannel.pannel_opened.connect(self.update_gameState)
	if sidePannel.has_signal("rope_pulled"):
		sidePannel.rope_pulled.connect(self.update_gameState)
	var tv = get_node("../bottomPannel")
	if tv.has_signal("tv_puzzle_solved"):
		tv.tv_puzzle_solved.connect(self.update_gameState)
	var pump = get_node("../ceilingPump")
	if pump.has_signal("succesPump"):
		pump.succesPump.connect(self.update_gameStatePump)
	var secondPuzzle = get_node("../leftRoom/leftRoomSecondPuzzle")
	if secondPuzzle.has_signal("second_puzzle_solved"):
		secondPuzzle.second_puzzle_solved.connect(self.update_gameState)

func play_sound():
	audioPlayer.stop()
	audioPlayer.pitch_scale = randf_range(0.8,1.2)
	audioPlayer.play()

func display_sign():
	var prevGameState = gameState
	await get_tree().create_timer(20).timeout
	if !found and prevGameState == gameState:
		sign.play("open")
		sign.show()
	else:
		display_sign()

func update_gameState():
	gameState += 1

func update_gameStatePump():
	pumps += 1
	if pumps == 1 or pumps == 3:
		gameState += 1

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		found = true
		goblinAnimation.show()
		goblinTrigger.hide()
		closed = false
		goblinAnimation.play("open")

func _on_goblin_animation_animation_finished():
	if goblinAnimation.animation == "open" and !closed:
		goblinAnimation.play("idle")
		hintAnimation.show()
		if gameState == 6 and pumps == 3:
			hintAnimation.play("hint5")
		else:
			hintAnimation.play("hint"+str(gameState))
	elif goblinAnimation.animation == "open" and closed:
		goblinAnimation.hide()
		goblinTrigger.show()

func _on_hint_animation_finished():
	closed = true
	goblinAnimation.play_backwards("open")
	hintAnimation.hide()


func _on_goblin_animation_frame_changed():
	if goblinAnimation.animation == "open" and !closed and goblinAnimation.frame == 7:
		play_sound()


func _on_sign_animation_finished():
	if !signFinished:
		sign.play_backwards("open")
		signFinished = true
	else:
		sign.hide()


func _on_sign_frame_changed():
	if !signFinished and sign.frame == 5:
		signAudio.play()
	elif signFinished and sign.frame == 19:
		signAudio.play()
