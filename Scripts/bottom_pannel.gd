extends Node2D

@onready var panelAnimation:AnimatedSprite2D = $bottomPannelAnimation
@onready var screenAnimation:AnimatedSprite2D = $screen/screenAnimation
@onready var screen:Node2D = $screen
@onready var cloudAnimation:AnimatedSprite2D = $cloud
@onready var channelSwitch:Area2D = $screen/channelSwitch
@onready var upButton:Area2D = $screen/upButton
@onready var rightButton:Area2D = $screen/rightButton
@onready var downButton:Area2D = $screen/downButton
@onready var leftButton:Area2D = $screen/leftButton
@onready var cloudTrigger:Area2D = $goblinTrigger

var channel:int = 1
var awnser:Array = [2, 3, 1, 4, 1]
var inputs:Array
var balloonLv:int = 0

signal tv_puzzle_solved
signal spawn_key
signal areaEntered
signal areaExited

func _ready():
	var pump = get_node("../ceilingPump")
	if pump.has_signal("succesPump"):
		pump.succesPump.connect(self.raise)
	var rope = get_node("../SidePannel")
	if rope.has_signal("rope_pulled"):
		rope.rope_pulled.connect(self.open_pannel)
	var coin = get_node("../coin")
	if coin.has_signal("coinDropped"):
		coin.coinDropped.connect(self.coin_dropped)
	cloudAnimation.hide()
	screen.hide()
	panelAnimation.hide()
	cloudTrigger.hide()
	

func raise():
	if balloonLv != 3:
		balloonLv += 1
		panelAnimation.play("pump" + str(balloonLv))
	if balloonLv == 3:
		screen.hide()

func open_pannel():
	panelAnimation.show()
	panelAnimation.play("open")


func _on_bottom_pannel_animation_animation_finished():
	if panelAnimation.animation == "open":
		panelAnimation.play("openIdle")
		screen.show()
		screenAnimation.play("channel1")
	elif panelAnimation.animation != "close":
		panelAnimation.play(panelAnimation.animation + "Idle")
		if balloonLv == 3:
			cloudTrigger.show()
	else:
		hide()


func _on_channel_switch_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		if (channel != 8):
			channel += 1
		else:
			channel = 1
		screenAnimation.play("channel"+ str(channel))


func _on_up_button_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		inputs.append(1)
		if inputs.size() > 5:
			inputs.clear()
		if inputs == awnser:
			emit_signal("tv_puzzle_solved")

func _on_right_button_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		inputs.clear()
		inputs.append(2)
		if inputs.size() > 5:
			inputs.clear()

func _on_down_button_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		inputs.append(3)
		if inputs.size() > 5:
			inputs.clear()

func _on_left_button_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		inputs.append(4)
		if inputs.size() > 5:
			inputs.clear()


func _on_goblin_trigger_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		cloudAnimation.show()
		cloudAnimation.play("start")

func _on_cloud_animation_finished():
	cloudAnimation.hide()

func _on_goblin_trigger_body_entered(body):
	if panelAnimation.animation == "pump3Idle" and body.is_in_group("coin"):
		emit_signal("areaEntered")

func _on_goblin_trigger_body_exited(body):
	if panelAnimation.animation == "pump3Idle" and body.is_in_group("coin"):
		emit_signal("areaExited")

func coin_dropped():
	panelAnimation.play("close")
	
func _on_bottom_pannel_animation_frame_changed():
	if panelAnimation.animation == "close" and panelAnimation.frame == 6:
		emit_signal("spawn_key")
