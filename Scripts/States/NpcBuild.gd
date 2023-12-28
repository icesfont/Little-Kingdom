extends State
class_name NpcBuild

@export var npc : CharacterBody2D
@export var SPEED = 200.0

@onready var animation_player = npc.get_node("AnimationPlayer")

var job : Array
var walking_to_build : bool = true
var constructing : bool = false

var buildings = {
	"house" : preload("res://Buildings/house.tscn"),
	"tower" : preload("res://Buildings/tower.tscn"),
	"castle" : preload("res://Buildings/castle.tscn")
}
var building

func Enter():	
	constructing = false
	walking_to_build = true
	# Get job
	job = Global.build_queue[0]
	Global.build_queue.remove_at(0)
	
	# Preload building object
	building = buildings[job[0]]
	
	# Go to build location
	npc.nav_agent.target_position = job[1]
	
	# Instantiate the new building at the clicked position
	npc.newBuilding = building.instantiate()
	npc.newBuilding.position = job[1]
	npc.get_parent().add_child(npc.newBuilding)

func Physics_Update(_delta):
	if walking_to_build:
		# If user clicks somewhere else while walking to the build, destroy itself
		if npc.nav_agent.target_position != job[1]:
			npc.newBuilding.queue_free()
			Global.idle_villagers.append(npc)
			Transitioned.emit(self, "idle")
		
		# Pathfinding
		var direction = npc.to_local(npc.nav_agent.get_next_path_position())
		# In Building.gd when the correct builder comes by, saves it as attribute
		# This is checking if this instance is the correct builder
		if npc.newBuilding.current_builder != npc:
			npc.velocity = direction.normalized() * SPEED
		else:
			# If inside the build area then start building
			npc.velocity = Vector2.ZERO
			walking_to_build = false
			npc.nav_agent.target_position = npc.global_position
	else:
		if not constructing:
			# Change it to construction
			npc.newBuilding.switch_texture("constructing")
			npc.newBuilding.toggle_collision()
			constructing = true
		
	if npc.velocity.length() > 0:
		npc.get_node("AnimationPlayer").play("walking")
	else:
		npc.get_node("AnimationPlayer").play("building")
	
func Update(_delta):
	# If building disappears or its finished building or hes decided to go away while constructing,
	# Then villager is no longer building
	if not npc.newBuilding or npc.newBuilding.finished_building or (npc.velocity.length() > 0 and constructing):
		Global.idle_villagers.append(npc)
		Transitioned.emit(self, "idle")
