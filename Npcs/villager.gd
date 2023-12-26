extends CharacterBody2D
class_name Villager

@export var SPEED = 200

var mouse_hovering = false
@onready var parent_node = get_parent()

var selected = false

@onready var target_position : Vector2 = global_position
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

var current_state : State

func _ready():
	makepath()
	Global.villagers.append(self)
	Global.idle_villagers.append(self)

func _physics_process(delta):
	var direction = to_local(nav_agent.get_next_path_position())
	if direction.length() > 10:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
	
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
		if Global.mouse_in_allowed_area and not Global.mouse_on_button:
			if Input.is_action_just_pressed("click"):
				target_position = get_global_mouse_position()
				makepath()
				selected = false
				Global.npc_selected = false
				
	# Indicate this villager is selected
	if selected:
		get_node("SelectShape").visible = true
	else:
		get_node("SelectShape").visible = false

func makepath():
	nav_agent.set_target_position(target_position)
	

func _on_area_2d_mouse_entered():
	mouse_hovering = true

func _on_area_2d_mouse_exited():
	mouse_hovering = false
