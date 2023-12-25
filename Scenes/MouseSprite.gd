extends Sprite2D

func _ready():
	# Make sure the mouse cursor is visible
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	# Update the position of the sprite to the mouse position
	position = get_global_mouse_position()
