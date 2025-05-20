extends CharacterBody2D

@export var goblinNoise:AudioStream
@export var collisionNoise:AudioStream

@onready var animator:AnimatedSprite2D = $Animation
@onready var collider:CollisionShape2D = $CollisionShape2D
@onready var audioStreamPlayer:AudioStreamPlayer2D = $AudioStreamPlayer2D

signal clicked
signal coinDropped
signal keyDropped

var coin:bool = false
var held = false
var drag_speed = 1000.0
var gravity = 500
var friction = 30
var bounce = 0.3
var collision
var prevCollision
var spawned = false
var canDrop = false

func _ready():
	if is_in_group("coin"):
		coin = true
	var backWall = get_node("../BackWall")
	var secondPuzzle = get_node("../leftRoom/leftRoomSecondPuzzle")
	var bottomPannel = get_node("../bottomPannel")
	if secondPuzzle.has_signal("second_puzzle_solved"):
		secondPuzzle.second_puzzle_solved.connect(self.spawnCoin)
	if bottomPannel.has_signal("spawn_key"):
		bottomPannel.spawn_key.connect(self.spawnKey)
	if bottomPannel.has_signal("areaEntered"):
		bottomPannel.areaEntered.connect(self.coinAreaEntered)
	if bottomPannel.has_signal("areaExited"):
		bottomPannel.areaExited.connect(self.coinAreaExited)
	if backWall.has_signal("areaEntered"):
		backWall.areaEntered.connect(self.keyAreaEntered)
	if backWall.has_signal("areaExited"):
		backWall.areaExited.connect(self.keyAreaExited)
	hide()
	collider.set_deferred("disabled", true)
	set_physics_process(false)

func play_audio(audio):
	audioStreamPlayer.stop()
	audioStreamPlayer.pitch_scale = randf_range(0.8,1.2)
	audioStreamPlayer.stream = audio
	audioStreamPlayer.play()
	

func spawnCoin():
	if coin and !spawned:
		spawned = true
		show()
		collider.set_deferred("disabled", false)
		animator.play("spawn")

func spawnKey():
	if !coin and !spawned:
		spawned = true
		animator.play("idle")
		show()
		collider.set_deferred("disabled", false)
		set_physics_process(true)

func _physics_process(delta):
	if held:
		var mouse_pos = get_global_mouse_position()
		var direction = mouse_pos - global_position

		if direction.length() > 1.0:
			var move_vec = direction.normalized() * min(direction.length(), drag_speed * delta)
			collision = move_and_collide(move_vec)
			if collision:
				var actual_move = move_vec - collision.get_remainder()
				var actual_speed = actual_move.length() / delta
				if actual_speed > 100 and collision != prevCollision:
					play_audio(collisionNoise)
			var prevCollision = collision
	else:
		velocity.y += gravity * delta
		
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, friction * delta)
		
		collision = move_and_collide(velocity * delta)
		if collision:
			if velocity.length() > 50:
				play_audio(collisionNoise)
			if not held:
				var n = collision.get_normal()
				velocity = velocity.bounce(n) * bounce

func pickup():
	velocity = Vector2.ZERO
	if held:
		return
	held = true

func drop(impulse=Vector2.ZERO):
	if canDrop:
		if coin:
			held = false
			rotation = deg_to_rad(270)
			animator.play_backwards("spawn")
			play_audio(goblinNoise)
		else:
			emit_signal("keyDropped")
			collider.set_deferred("disabled", true)
			hide()
	elif held:
		held = false
		velocity = impulse

func coinAreaEntered():
	if coin:
		canDrop = true
	
func coinAreaExited():
	if coin:
		canDrop = false
	
func keyAreaEntered():
	if !coin and held:
		canDrop = true
		animator.play("open")
	
func keyAreaExited():
	if !coin and held:
		canDrop = false
		animator.play_backwards("open")

func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		clicked.emit(self)


func _on_animation_animation_finished():
	if coin:
		set_physics_process(true)
		animator.play("idle")
		if canDrop:
			emit_signal("coinDropped")
			collider.set_deferred("disabled", true)
			hide()
	else:
		if canDrop:
			animator.play("openIdle")
		else:
			animator.play("idle")
