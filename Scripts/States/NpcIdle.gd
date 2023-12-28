extends State
class_name NpcIdle

@export var npc : CharacterBody2D

var direction : Vector2

# Very in depth state
func Physics_Update(_delta : float):
	if npc.velocity.length() > 0:
		npc.get_node("AnimationPlayer").play("walking")
	else:
		npc.get_node("AnimationPlayer").play("idle")


