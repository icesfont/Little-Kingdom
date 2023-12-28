extends Node

@export var initial_state : State
@export var npc : CharacterBody2D

var states : Dictionary = {}

# This all handles switching between states for the villagers
# Same script can be used for any characterbody2d

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		npc.current_state = initial_state
			
func _process(delta):
	if npc.current_state:
		npc.current_state.Update(delta)

func _physics_process(delta):
	if npc.current_state:
		npc.current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != npc.current_state:
		return
	
	var new_state = states.get(new_state_name)
	if not new_state:
		return
	
	if npc.current_state:
		npc.current_state.Exit()
	
	new_state.Enter()
	
	npc.current_state = new_state
