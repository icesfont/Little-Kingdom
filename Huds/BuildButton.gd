extends Node

@onready var states : Dictionary = {"Disabled" : [$ButtonDisabled, $IconDisabled], "Normal" : [$Button, $Icon], "Pressed" : [$ButtonPressed, $IconPressed]}
var current_state : String = "Disabled"

var mouse_hovering : bool = false
var build_mode : bool = false

@onready var button_timer = $"../ButtonTimer"
@onready var mouse_sprite = $"../MouseSprite"

var house_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Blue.png")
var cursor_texture = preload("res://Art/Tiny Swords/UI/Pointers/01.png")

func _ready():
	mouse_sprite.texture = cursor_texture
	mouse_sprite.modulate.a = 1

func _process(delta):
	if mouse_hovering:
		if Input.is_action_just_pressed("click"):
			_switch_states("Pressed")
			build_mode = true
			
			button_timer.start()
	else:
		if Input.is_action_just_pressed("click") and build_mode and Global.mouse_in_allowed_area:
			Global.add_build("house", $"../../Camera2D".get_global_mouse_position())
			build_mode = not build_mode
	if current_state != "Normal" and current_state != "Pressed":
		_switch_states("Normal")
	
	if build_mode:
		mouse_sprite.texture = house_texture
		mouse_sprite.modulate.a = 0.4
	else:
		mouse_sprite.texture = cursor_texture
		mouse_sprite.modulate.a = 1

func _switch_states(new_state : String):
	if new_state not in states:
		return

	for node in states[current_state]:
		node.visible = false
	current_state = new_state
	for node in states[current_state]:
		node.visible = true


func _on_area_2d_mouse_entered():
	mouse_hovering = true
	Global.mouse_on_button = true

func _on_area_2d_mouse_exited():
	mouse_hovering = false
	Global.mouse_on_button = false

func _on_button_timer_timeout():
	_switch_states("Normal")
