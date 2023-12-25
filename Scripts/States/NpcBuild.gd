extends State
class_name NpcBuild

@export var npc : CharacterBody2D
@export var SPEED = 200.0

@onready var animation_player = npc.get_node("AnimationPlayer")

func Enter():
	animation_player.play("building")
	
