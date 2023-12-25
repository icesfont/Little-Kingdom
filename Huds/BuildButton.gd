extends Node

@onready var states : Dictionary = {"Disabled" : [$ButtonDisabled, $IconDisabled], "Normal" : [$Button, $Icon], "Pressed" : [$ButtonPressed, $IconPressed]}
var current_state : String = "Disabled"

var mouse_hovering : bool = false

@onready var button_timer = $"../ButtonTimer"

func _process(delta):
	if Global.npc_selected:
		if mouse_hovering:
			if Input.is_action_just_pressed("click"):
				_switch_states("Pressed")
				button_timer.start()
		
		if current_state != "Normal" and current_state != "Pressed":
			_switch_states("Normal")
	else:
		if current_state != "Disbaled":
			_switch_states("Disabled")
	

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

func _on_area_2d_mouse_exited():
	mouse_hovering = false

func _on_button_timer_timeout():
	_switch_states("Normal")
