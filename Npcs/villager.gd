extends CharacterBody2D
class_name Villager

const SPEED = 200.0

var selected : bool = false
var moving : bool = false

var mouse_hovering : bool = false
var mouse_in_allowed_area : bool = false

var direction : Vector2
var target_position : Vector2

func _physics_process(delta):
	if moving:
		direction = target_position - global_position
		if direction.length() > 10:
			velocity = direction.normalized() * SPEED
		else:
			velocity = Vector2.ZERO
			moving = false
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
	
	if velocity.length() > 0:
		$AnimationPlayer.play("walking")
	else:
		$AnimationPlayer.play("idle")
	
	move_and_slide()

func _process(delta):
	# If mouse is hovering over villager
	if mouse_hovering:
		if not selected:
			if Input.is_action_just_pressed("click"):
				selected = true
				moving = false
		else:
			if Input.is_action_just_pressed("click"):
				selected = false
			
	# If the villager has been selected then next click is where he goes
	# If character is moving, allow target to be changed
	elif selected or moving:
		if mouse_in_allowed_area:
			if Input.is_action_just_pressed("click"):
				target_position = get_global_mouse_position()
				selected = false
				moving = true
				
	
	# Indicate this villager is selected
	if selected or moving:
		$SelectShape.visible = true
	else:
		$SelectShape.visible = false

	

func _on_area_2d_mouse_entered():
	mouse_hovering = true

func _on_area_2d_mouse_exited():
	mouse_hovering = false

func _on_allowed_area_mouse_entered():
	mouse_in_allowed_area = true

func _on_allowed_area_mouse_exited():
	mouse_in_allowed_area = false
