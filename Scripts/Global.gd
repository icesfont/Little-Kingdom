extends Node

var npc_selected : bool = false
var mouse_on_button : bool = false
var mouse_in_allowed_area : bool = false

# Queue of jobs that need to be fulfilled
var build_queue = []
var villagers = []
var idle_villagers = []

func add_build(job : String, coords : Vector2):
	build_queue.append([job, coords])

func _process(delta):
	if build_queue.size() > 0 and idle_villagers.size() > 0:
		idle_villagers[0].get_node("State Machine").on_child_transition(idle_villagers[0].current_state, "build")
		idle_villagers.remove_at(0)
