extends Control

onready var _transition_rect := $SceneTraslition



func _on_Play_pressed():
	_transition_rect.transition_to("res://Scenes/Level1.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_Info_pressed():
	_transition_rect.transition_to("res://Objects/UI/InfoMenu.tscn")
