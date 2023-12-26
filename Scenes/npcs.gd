extends Node

func _on_allowed_area_mouse_entered():
	Global.mouse_in_allowed_area = true

func _on_allowed_area_mouse_exited():
	Global.mouse_in_allowed_area = false
