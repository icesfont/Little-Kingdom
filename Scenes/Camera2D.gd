extends Camera2D

var last_mouse_position = Vector2()
var dragging = false

@export var zoom_speed : float = 0.1
@export var min_zoom = Vector2(0.1, 0.1)
@export var max_zoom = Vector2(2, 2)

func _ready():
	# Set the initial zoom scales
	zoom.x = 0.5
	$"../HUD/MouseSprite".scale.x = 0.5
	zoom.y = 0.5
	$"../HUD/MouseSprite".scale.y = 0.5

func _input(event):
	if event is InputEventMouseButton:
		# Right click is how to drag the camera
		if event.is_action_pressed("right_click"):
			dragging = true
			last_mouse_position = get_global_mouse_position()
		elif event.is_action_released("right_click"):
			dragging = false

	if event is InputEventMouseMotion and dragging:
		var mouse_motion = event.relative
		position -= mouse_motion
	
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_handle_zoom(event)

# Mouse wheen up and down to handle zooming in and out
func _handle_zoom(event):
	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom -= Vector2(zoom_speed, zoom_speed)
	elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom += Vector2(zoom_speed, zoom_speed)
	
	# Clamp zoom to minimum and maximum values
	zoom.x = clamp(zoom.x, min_zoom.x, max_zoom.x)
	$"../HUD/MouseSprite".scale.x = clamp(zoom.x, min_zoom.x, max_zoom.x)
	zoom.y = clamp(zoom.y, min_zoom.y, max_zoom.y)
	$"../HUD/MouseSprite".scale.y = clamp(zoom.y, min_zoom.y, max_zoom.y)
