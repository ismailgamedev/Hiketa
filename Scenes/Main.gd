extends Node2D

onready var _transition_rect := $Player/Interface/UI/SceneTraslition



func _on_LeftEnd_body_entered(body):
	if body.name == "Player":
		_transition_rect.transition_to("res://Scenes/Level2.tscn")
