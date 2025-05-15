extends CharacterBody2D

signal clicked

var held = false
var drag_speed = 1000.0
var gravity = 500
var friction = 500
var bounce = 0.3

func _physics_process(delta):
	if held:
		var mouse_pos = get_global_mouse_position()
		var direction = mouse_pos - global_position

		if direction.length() > 1.0:
			var move_vec = direction.normalized() * min(direction.length(), drag_speed * delta)
			var collision = move_and_collide(move_vec)
	else:
		velocity.y += gravity * delta
		
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	var collision = move_and_collide(velocity * delta)
	if collision and not held:
		# Bounce only when not held
		var n = collision.get_normal()
		velocity = velocity.bounce(n) * bounce
	move_and_slide()

func pickup():
	if held:
		return
	held = true

func drop(impulse=Vector2.ZERO):
	if held:
		held = false
		velocity = impulse

func _on_input_event(_viewport, event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		if event.pressed:
			clicked.emit(self)

func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
