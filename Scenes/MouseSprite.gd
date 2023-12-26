extends Sprite2D

func _ready():
	# Make sure the mouse cursor is visible
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	# Update the position of the sprite to the mouse position
	if $"../Build".build_mode:
		position.x = get_global_mouse_position().x
		position.y = get_global_mouse_position().y - 16
	else:
		position = get_global_mouse_position()
	
