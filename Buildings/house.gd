extends Building

func _ready():
	constructing_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Construction.png")
	normal_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Blue.png")
	destroyed_texture = preload("res://Art/Tiny Swords/Factions/Knights/Buildings/House/House_Destroyed.png")
	
	$Sprite2D.modulate.a = 0.4
	$Sprite2D.texture = normal_texture
	$Timers/DeleteTimer.start()
