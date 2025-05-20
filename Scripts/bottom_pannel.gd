extends Node2D

@export var balloonInflate:AudioStream
@export var balloonPop:AudioStream
@export var golblinNoise:AudioStream
@export var machineNoise:AudioStream
@export var fallingNoise:AudioStream
@export var closingNoise:AudioStream
@export var RisingNoise:AudioStream
@export var SteamNoise:AudioStream
@export var ButtonNoise:AudioStream
@export var channelAudio1:AudioStream
@export var channelAudio2:AudioStream
@export var channelAudio3:AudioStream
@export var channelAudio4:AudioStream
@export var channelAudio5:AudioStream
@export var channelAudio6:AudioStream
@export var channelAudio7:AudioStream
@export var channelAudio8:AudioStream

@onready var panelAnimation:AnimatedSprite2D = $bottomPannelAnimation
@onready var panelAudio:AudioStreamPlayer2D = $pannelAudio
@onready var screenAnimation:AnimatedSprite2D = $screen/screenAnimation
@onready var screen:Node2D = $screen
@onready var tvAudio:AudioStreamPlayer2D = $TvAudio
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
var channelAudio := {}
var tvSolved:bool = false

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
	channelAudio = {
	1 : channelAudio1,
	2 : channelAudio2,
	3 : channelAudio3,
	4 : channelAudio4,
	5 : channelAudio5,
	6 : channelAudio6,
	7 : channelAudio7,
	8 : channelAudio8,
	}
	
func play_audio(sfx):
	tvAudio.stop()
	tvAudio.stream = sfx
	tvAudio.play()

func play_pannel_audio(sfx):
	panelAudio.stop()
	panelAudio.stream = sfx
	panelAudio.play()

func raise():
	if balloonLv != 3:
		balloonLv += 1
		panelAnimation.play("pump" + str(balloonLv))
		play_pannel_audio(balloonInflate)
	if balloonLv == 3:
		screen.hide()
		tvAudio.stop()

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


func _on_channel_switch_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if (channel != 8):
			channel += 1
		else:
			channel = 1
		screenAnimation.play("channel"+ str(channel))
		panelAudio.pitch_scale = randf_range(0.8,1.2)
		play_pannel_audio(ButtonNoise)
		play_audio(channelAudio.get(channel))


func _on_up_button_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		panelAudio.pitch_scale = randf_range(0.8,1.2)
		play_pannel_audio(ButtonNoise)
		inputs.append(1)
		if inputs.size() > 5:
			inputs.clear()
		if inputs == awnser and !tvSolved:
			emit_signal("tv_puzzle_solved")
			tvSolved = true

func _on_right_button_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		panelAudio.pitch_scale = randf_range(0.8,1.2)
		play_pannel_audio(ButtonNoise)
		inputs.clear()
		inputs.append(2)
		if inputs.size() > 5:
			inputs.clear()

func _on_down_button_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		panelAudio.pitch_scale = randf_range(0.8,1.2)
		play_pannel_audio(ButtonNoise)
		inputs.append(3)
		if inputs.size() > 5:
			inputs.clear()

func _on_left_button_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		panelAudio.pitch_scale = randf_range(0.8,1.2)
		play_pannel_audio(ButtonNoise)
		inputs.append(4)
		if inputs.size() > 5:
			inputs.clear()


func _on_goblin_trigger_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		cloudAnimation.show()
		cloudAnimation.play("start")
		panelAudio.pitch_scale = randf_range(0.8,1.2)
		play_pannel_audio(golblinNoise)

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
	play_pannel_audio(machineNoise)
	cloudTrigger.hide()
	
func _on_bottom_pannel_animation_frame_changed():
	if panelAnimation.animation == "close":
		if panelAnimation.frame == 19:
			play_pannel_audio(closingNoise)
		if panelAnimation.frame == 7:
			play_pannel_audio(fallingNoise)
		if panelAnimation.frame == 6:
			emit_signal("spawn_key")
			play_audio(balloonPop)
	elif panelAnimation.animation == "open":
		if panelAnimation.frame == 7:
			play_pannel_audio(RisingNoise)
		if panelAnimation.frame == 6:
			play_audio(SteamNoise)
	elif panelAnimation.animation == "pump3":
		if panelAnimation.frame == 8:
			panelAudio.stop()
		if panelAnimation.frame == 4:
			play_pannel_audio(RisingNoise)

func _on_tv_audio_finished():
	if tvAudio.stream == channelAudio4:
		tvAudio.pitch_scale = randf_range(0.8,1.2)
		await get_tree().create_timer(0.5).timeout
		play_audio(tvAudio.stream)
	elif tvAudio.stream == channelAudio6:
		tvAudio.pitch_scale = randf_range(0.8,1.2)
		await get_tree().create_timer(randf_range(0.2,0.5)).timeout
		play_audio(tvAudio.stream)
	elif tvAudio.stream == channelAudio7:
		tvAudio.pitch_scale = randf_range(0.8,1.2)
		play_audio(tvAudio.stream)
