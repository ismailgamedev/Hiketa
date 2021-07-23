extends Area2D

var speed = 18
var movement = Vector2()
onready var mouse_pos = null

func _ready():
	mouse_pos = get_local_mouse_position()
	
func _physics_process(delta):
	movement = movement.move_toward(mouse_pos,delta)
	movement = movement.normalized() * speed
	position = position + movement

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


	
