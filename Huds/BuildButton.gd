extends Node

@onready var states : Dictionary = {"Disabled" : [$ButtonDisabled, $IconDisabled], "Normal" : [$Button, $Icon], "Pressed" : [$ButtonPressed, $IconPressed]}
var current_state : String = "Disabled"

var mouse_hovering : bool = false
var build_mode : bool = false

@onready var button_timer = $"../ButtonTimer"
@onready var mouse_sprite = $"../MouseSprite"

var cursor_texture = preload("res://Art/Tiny Swords/UI/Pointers/01.png")

# Allow user to cycle through builds
var chosen_build = 0
var builds = {0 : "house", 1 : "tower", 2 : "castle"}
var textures = {
	0 : preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Blue.png"),
	1 : preload("res://Art/Tiny Swords/Factions/Knights/Buildings/Tower/Tower_Blue.png"),
	2 : preload("res://Art/Tiny Swords/Factions/Knights/Buildings/Castle/Castle_Blue.png")
}

func _ready():
	# Mouse sprite is cursor by default
	mouse_sprite.texture = cursor_texture
	mouse_sprite.modulate.a = 1

func _process(delta):
	if mouse_hovering:
		if Input.is_action_just_pressed("click"):
			# Once button is clicked, we now in build mode
			_switch_states("Pressed")
			# Toggle type thing, if in build mode then can toggle out of it by pressing it again
			build_mode = not build_mode
			
			# To switch back to the normal state, simulate a clicked button
			button_timer.start()
	else:
		# If we in build mode, and we not govering over the button and the space isnt taken by another building and its on an allowed area
		if Input.is_action_just_pressed("click") and build_mode and Global.mouse_in_allowed_area and Global.mouse_on_used_area.size() == 0:
			# Add a build to the build queue
			Global.add_build(builds[chosen_build], $"../../Camera2D".get_global_mouse_position())
			build_mode = not build_mode
	if current_state != "Normal" and current_state != "Pressed":
		# Button should by default always always be Normal, unless its Pressed
		_switch_states("Normal")
	
	if build_mode:
		# Also if the user is in build mode and wants to cycle the builds
		if Input.is_action_just_pressed("switch_build"):
			chosen_build = (chosen_build + 1) % builds.size()
		
		# In build mode the cursor turns into the building selected
		mouse_sprite.texture = textures[chosen_build]
		mouse_sprite.modulate.a = 0.4
	else:
		# Otherwise have it as the cursor
		mouse_sprite.texture = cursor_texture
		mouse_sprite.modulate.a = 1

# Switches the texture of the cursor
func _switch_states(new_state : String):
	if new_state not in states:
		return

	for node in states[current_state]:
		node.visible = false
	current_state = new_state
	for node in states[current_state]:
		node.visible = true

# Checking if the mouse is hovering over the button
func _on_area_2d_mouse_entered():
	mouse_hovering = true
	Global.mouse_on_button = true

func _on_area_2d_mouse_exited():
	mouse_hovering = false
	Global.mouse_on_button = false

func _on_button_timer_timeout():
	_switch_states("Normal")
