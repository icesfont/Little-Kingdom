extends CharacterBody2D

var villager_building = false
var exists = false
var current_builder : CharacterBody2D

var constructing_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Construction.png")
var normal_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Blue.png")
var destroyed_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Destroyed.png")

func _process(delta):
	if not exists:
		if villager_building:
			$Sprite2D.texture = constructing_texture
			exists = true


func _on_build_area_body_entered(body):
	if not current_builder and body is Villager and body.current_state.name.to_lower() == "build":
		current_builder = body
	
func _on_build_area_body_exited(body):
	if current_builder and  current_builder == body:
		pass # Stop building
