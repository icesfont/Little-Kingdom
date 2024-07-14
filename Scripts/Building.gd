extends StaticBody2D
class_name Building

# This is an abstract class, since all buildings are pretty much exactly the same
# They can all use the same script

var type

var finished_building : bool = false
var current_builder : CharacterBody2D
var destroyed : bool = false

var constructing_texture
var normal_texture
var destroyed_texture

func _physics_process(delta):
	if current_builder:
		# If the builder isn't building and it hasnt finished building then destory self :(
		if current_builder.current_state.name.to_lower() != "build" and not finished_building:
			destroy_self()

# When the object exists but builder is still walking to it, then no collisions
func toggle_collision():
	$CollisionShape2D.disabled = not $CollisionShape2D.disabled

func switch_texture(texture : String):
	$Sprite2D.modulate.a = 1
	if texture == "constructing":
		$Sprite2D.texture = constructing_texture
	elif texture == "normal":
		$Sprite2D.texture = normal_texture
	elif texture == "destroyed":
		$Sprite2D.texture = destroyed_texture

func destroy_self():
	# Change to the destroyed texture for 5 seconds before disappearing
	destroyed = true
	switch_texture("destroyed")
	$Timers/DestroyedTimer.start()


func _on_build_area_body_entered(body):
	print("MEOW")
	# This is checking if the villager that entered its build area is the correct builder
	if body is Villager and body.newBuilding and body.newBuilding == self:
		current_builder = body
		$Timers/BuildTimer.start()
	
func _on_build_area_body_exited(body):
	if current_builder and current_builder == body and not finished_building:
		destroy_self()


func _on_taken_space_mouse_entered():
	Global.mouse_on_used_area.append(1)

func _on_taken_space_mouse_exited():
	Global.mouse_on_used_area.remove_at(0)


func _on_destroyed_timer_timeout():
	queue_free()

# This is just a timer to finish the building animation
func _on_build_timer_timeout():
	if not destroyed:
		switch_texture("normal")
		finished_building = true

# This timer starts when the object is instantiated
# It so that if the builder for some reason cant get to the build in a reasonable time
# it doesn't stay there forever and destroys self
# However it adds it back to the queue for another villager to do it
func _on_delete_timer_timeout():
	if not current_builder:
		Global.add_build(type, position)
		queue_free()
