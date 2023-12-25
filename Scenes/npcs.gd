extends Node

var mouse_in_allowed_area = false

func _on_allowed_area_mouse_entered():
	mouse_in_allowed_area = true

func _on_allowed_area_mouse_exited():
	mouse_in_allowed_area = false
