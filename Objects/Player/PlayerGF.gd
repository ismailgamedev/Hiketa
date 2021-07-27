extends KinematicBody2D

const BULLET = preload("res://Objects/Bullet/Bullet.tscn")
const GRAVITY = 25
const ACCELERATION = 1000
const MAX_SPEED = 150
const JUMP_HEIGHT = -450
const UP = Vector2 ( 0 , -1 )

var motion = Vector2()
var input_vector = Vector2()
var mouse_position
var health = 100

func _ready():
	pass

func _physics_process(delta):
	# Yer cekimi ve surtunme
	var friction = false
	motion.y += GRAVITY
	input_vector = Vector2.ZERO
	# kol 90 sag sola donunce karakterin donmesi
	if get_local_mouse_position().x < -7.30:
		$polyons.scale = Vector2(-1,1)
		$Skeleton2D.scale =Vector2(-1,1)
	if get_local_mouse_position().x > 7.30:
		$polyons.scale = Vector2(1,1)
		$Skeleton2D.scale = Vector2(1,1)
	
	# Fare pozisyonunu degiskene atama
	mouse_position = get_global_mouse_position()
	# Kolu mouse pozisyonuna gore dondurme 
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
	
	if is_on_floor():
		# Ziplama kodu
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			input_vector.y = 1
		if friction == true:
			motion.x = lerp(motion.x , 0 , 0.2)
	else:
		if friction == true:
			motion.x = lerp(motion.x , 0 , 0.009)
			
	# Karakter hareket etmesi icin
	motion = move_and_slide(motion , UP)
	
	# Animasyonlarin calismasi icin yapilan fonksyon
	_process_animation()
	
	die_check()
	
func _process(delta):
		# Ates Etme
		if Input.is_action_just_pressed("fire"):
			shoot()
		# Sarjor doldurma
		if Input.is_action_just_pressed("reload"):
			pass
			
		$Interface/UI/HealthBar.value = health

# Mermi firlatma fonksyonu
func shoot():
	var bullet_instance = BULLET.instance()
	bullet_instance.rotation = rotation
	bullet_instance.global_position = $"Skeleton2D/YariGovde/UstGovde/Sag Kol/Sag El/silah/Position2D".global_position
	get_parent().add_child(bullet_instance)

func _process_animation():
	# Ziplama Yurume ve dusme animasyonu 
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

func die_check():
	if health <= 0:
		health = 0
		$CollisionShape2D.disabled = true
		set_physics_process(false)

func _on_HurtBox_area_entered(area):
	if area.is_in_group("EnemyBullet"):
		health -= 1
		$Interface/UI/HealthBar.value = health
