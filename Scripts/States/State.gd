extends Node
class_name State

# Abstract class to define a state

signal Transitioned

func Enter():
	pass
	
func Exit():
	pass

func Update(_delta : float):
	pass
	
func Physics_Update(_delta : float):
	pass

