extends CharacterBody2D
class_name Villager

var mouse_hovering = false
@onready var parent_node = get_parent()

var selected = false
@onready var target_position : Vector2 = global_position

var current_state : State

func _physics_process(delta):
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
	
	move_and_slide()

func _process(delta):
		# If mouse is hovering over villager
	if mouse_hovering:
		if not selected:
			if Input.is_action_just_pressed("click"):
				selected = true
				Global.npc_selected = true
		else:
			if Input.is_action_just_pressed("click"):
				selected = false
				Global.npc_selected = false
			
	# If the villager has been selected then next click is where he goes
	elif selected:
		if parent_node.mouse_in_allowed_area:
			if Input.is_action_just_pressed("click"):
				target_position = get_global_mouse_position()
				selected = false
				Global.npc_selected = false
				
	# Indicate this villager is selected
	if selected:
		get_node("SelectShape").visible = true
	else:
		get_node("SelectShape").visible = false

func _on_area_2d_mouse_entered():
	mouse_hovering = true

func _on_area_2d_mouse_exited():
	mouse_hovering = false
