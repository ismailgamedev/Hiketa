extends Area2D

var speed = 15
var movement = Vector2()
onready var mouse_pos = null

func _ready():
	# Mermiyi canlandirinca fare pozisyonunu degiskene almak icin
	mouse_pos = get_local_mouse_position()
	
func _physics_process(delta):
	# Mermiyi fare pozisyonuna gonderme
	movement = movement.move_toward(mouse_pos,delta)
	movement = movement.normalized() * speed
	position = position + movement

# Ekrandan cikinca silinmesi icin
func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


	


func _on_Bullet_area_entered(area):
	if area.name != "Horse":
		self.queue_free()


func _on_Bullet_body_entered(body):
	if body.name != "Horse":
		self.queue_free()
