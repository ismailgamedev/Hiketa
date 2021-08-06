extends Control

onready var _transition_rect := $ColorRect/SceneTraslition


func _on_Button_pressed():
	_transition_rect.transition_to("res://Scenes/MainMenu.tscn")
