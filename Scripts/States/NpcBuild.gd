extends State
class_name NpcBuild

@export var npc : CharacterBody2D
@export var SPEED = 200.0

@onready var animation_player = npc.get_node("AnimationPlayer")

var job : Array
var walking_to_build : bool = true
var constructing : bool = false

# Temporarily only a house!!
var building = preload("res://Buildings/house.tscn")
var newBuilding

func Enter():	
	constructing = false
	walking_to_build = true
	# Get job
	job = Global.build_queue[0]
	Global.build_queue.remove_at(0)
	# Go to build location
	npc.nav_agent.target_position = job[1]
	
	newBuilding = building.instantiate()
	newBuilding.position = job[1]
	npc.get_parent().get_parent().get_node("Buildings").add_child(newBuilding)

func Physics_Update(_delta):
	if walking_to_build:
		var direction = npc.to_local(npc.nav_agent.get_next_path_position())
		if abs(npc.global_position - job[1]).length() > 85:
			npc.velocity = direction.normalized() * SPEED
		else:
			npc.velocity = Vector2.ZERO
			walking_to_build = false
			npc.nav_agent.target_position = npc.global_position
	else:
		if not constructing:
			newBuilding.switch_texture("constructing")
			newBuilding.toggle_collision()
			constructing = true
		
	if npc.velocity.length() > 0:
		npc.get_node("AnimationPlayer").play("walking")
	else:
		npc.get_node("AnimationPlayer").play("building")
	
func Update(_delta):
	if not newBuilding or newBuilding.finished_building or (npc.velocity.length() > 0 and constructing):
		Global.idle_villagers.append(npc)
		Transitioned.emit(self, "idle")
