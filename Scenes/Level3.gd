extends Node2D


onready var _transition_rect := $Horse/Interface/UI/SceneTraslition
	


func _on_LeftEnd_area_entered(area):
		_transition_rect.transition_to("res://Scenes/Level4.tscn")
