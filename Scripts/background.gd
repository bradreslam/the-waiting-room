extends ParallaxBackground

@export var scroll_speed = Vector2(100, 0)

func _process(delta):
	scroll_base_offset += scroll_speed * delta
