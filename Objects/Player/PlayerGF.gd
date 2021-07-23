extends KinematicBody2D

const Bullet = preload("res://Objects/Bullet.tscn")
const Gravity = 25
const ACCELERATION = 1000
const MAX_SPEED = 150
const JUMP_HEIGHT = -450
const UP = Vector2 ( 0 , -1 )

var motion = Vector2()
var input_vector = Vector2()
var mouse_position

export var magazines: int = 7 # how many magazines does the player have
export var magazine_capacity: int = 10 # how many bullets in a magazine
export var current_magazine: int = 0 # track the bullets in the loaded magazine
export var have_ammo: bool = false # does the player have ammo?

func _ready():
	_reload()

func _physics_process(delta):
	var friction = false
	motion.y += Gravity
	input_vector = Vector2.ZERO
	
	# kol 90 sag sola donunce karakterin donmesi
	if get_local_mouse_position().x < -35:
		$polyons.scale = Vector2(-1,1)
		$Skeleton2D.scale =Vector2(-1,1)
	if get_local_mouse_position().x > -35:
		$polyons.scale = Vector2(1,1)
		$Skeleton2D.scale = Vector2(1,1)
	
	# Kolu mouse pozisyonuna gore dondurme 
	mouse_position = get_global_mouse_position()
	$"Skeleton2D/YariGovde/UstGovde/Sag Kol".look_at(mouse_position)

	# Sag Sola input alma
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x+ACCELERATION , MAX_SPEED)
		input_vector.x = 1		
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x-ACCELERATION , -MAX_SPEED)
		input_vector.x = -1
	else:
		friction = true
	
	# Ziplama
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			input_vector.y = 1
		if friction == true:
			motion.x = lerp(motion.x , 0 , 0.2)
	else:
		if friction == true:
			motion.x = lerp(motion.x , 0 , 0.009)
	motion = move_and_slide(motion , UP)
	_process_animation()
	
func _process(delta):
		#ates etme
		if Input.is_action_just_pressed("fire"):
			shoot()
		if Input.is_action_just_pressed("reload"):
			_reload()



# Mermi firlatma fonksyonu
func shoot():
	var bullet_instance = Bullet.instance()
	if have_ammo: # only shoot if we have ammo
		current_magazine -= 1 # take a bullet out of the magazine
		bullet_instance.rotation = rotation
		bullet_instance.global_position = $"Skeleton2D/YariGovde/UstGovde/Sag Kol/Sag El/silah/Position2D".global_position
		get_parent().add_child(bullet_instance)
		if current_magazine < 1: # if we've used the last bullet, reload.
			_reload()
	else:
		print("out of ammo")
	
func _reload() -> void:
	if magazines > 0: # if there are any magazines left, reload
		have_ammo = true # we still have ammo
		magazines -= 1 # but we have 1 less magazine
		current_magazine = magazine_capacity # reload the current magazine
		print("Reload - Magazines left ",  magazines)
	else:
		have_ammo = false # no more ammo
	
func _process_animation():
	# Ziplama ve dusme animasyonu
	if is_on_floor():
		if input_vector.y > 0.75:
			$AnimationPlayer.play("jumping")	
		elif input_vector.x < -0.75 or input_vector.x > 0.75:
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.play("idle")
	else:		
		if motion.y < 0:
			$AnimationPlayer.play("jumping")
		elif motion.y > 0:
			$AnimationPlayer.play("falling")
		elif motion.y -- 0:
			$AnimationPlayer.play("landing")
