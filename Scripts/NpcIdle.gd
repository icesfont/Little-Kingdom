extends State
class_name NpcIdle

@export var npc : CharacterBody2D
@export var SPEED = 200.0

var direction : Vector2
	
func Physics_Update(_delta : float):
	direction = npc.target_position - npc.global_position
	if direction.length() > 10:
		npc.velocity = direction.normalized() * SPEED
	else:
		npc.velocity = Vector2.ZERO
	
	if npc.velocity.length() > 0:
		npc.get_node("AnimationPlayer").play("walking")
	else:
		npc.get_node("AnimationPlayer").play("idle")
			
