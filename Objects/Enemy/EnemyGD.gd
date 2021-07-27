extends KinematicBody2D

# Hız ve yer çekimi degeri
const WALK_SPEED = 200
const GRAVITY = 25
const BULLET = preload("res://Objects/Bullet/EnemyBullet.tscn")

# Sahnedeki karakter sahnesine ulaşma
onready var player = get_node("/root/Main/Player")
# Kol kemigini degiskene atama
onready var hand = get_node("Skeleton2D/YariGovde/UstGovde/Sag Kol")

# AnimationPlayeri degiskene atama
onready var animation_player = get_node("AnimationPlayer")

var direction = Vector2.ZERO
# Karakterin donmesi icin kullandigim degisken
var flip = Vector2.ZERO

var health = 100

var distance = 0

func _physics_process(delta):		
	movement()
	hand_look()
	animation_prcess()
	flip_enemy()
	die_check()

# Yurume kodu
func movement():
	# Karakter ve Dusman arasindaki Mesafeyi ölçme 
	# abs negatif sayiyi pozitife cevirir 
	# cunku x ekseni eksi(-) ve arti(+) degeri alir 
	# biz de mesafeyi olcmek icin eksi degerini arti degeri yapiyoruz
	# Dusmanin x pozisyonunu - Karakterin x pozisyonunu = aralarindaki mesafe
	distance = abs(position.x - player.position.x)
	
	# Eger yerde degilse direction degiskenine yer cekimi uyguluyoruz 
	direction.y += GRAVITY
		
	# Yurume kodu
	move_and_slide(direction * WALK_SPEED)

	# Mesafeyi kontrol etme
	if distance < 250 and distance > 100:
		# Karakter pozisyonuna gore direction degiskeninin x degerini veriyoruz
		if player:
			direction.x = (player.position.x - position.x)
			
			direction = direction.normalized() 
	# Eger mesafe de degil ise direction degiskenin x ini 0 yapiyoruz
	else:
		direction.x = 0
		
	# Kaybola hatasini düzeltmek için yazdığım kod :) 
	direction.y = position.y

# Animasyon islemleri Fonksyonu
func animation_prcess():
	# Eger direction degiskeni 0.1 dan buyuk ise yani yuruyorsa animasyon oynatilir
	# Ve eger -0.1 kucuk ise yani yuruyorsa animasyon oynatilir
	if direction.x < -0.1 or direction.x > 0.1:
		$AnimationPlayer.play("walk")
	# direction 0 ise  idle animasyonu oynatilir
	else:
		$AnimationPlayer.play("idle")

# Karakterin pozisyonuna gore karakteri dondurme
func flip_enemy():
	# Direction degiskenindeki mantik gibi buna da pozisyonu atiyoruz 
	# ama move_and_slide fonksyonuna yazmiyoruz 
	# yani sadece degiskende degisiyor pozisyon
	flip.x = (player.position.x - position.x)
	# Eger 0.1 den buyuk ise sag don
	if flip.x > 0.1:
		$Skeleton2D.scale = Vector2(1,1)
		$polyons.scale = Vector2(1,1)
	# Eger 0.1 den kucuk ise sa don
	if flip.x < -0.1:
		$Skeleton2D.scale = Vector2(-1,1)
		$polyons.scale = Vector2(-1,1)

# Elin Karakter pozisyonuna bakmasi
func hand_look():
	# Kolu karakterin global pozisyonuna baktiriyoruz 
	if player.health > 0:
		hand.look_at(player.global_position)	
	
func shoot():
	if distance < 250 and health > 0 and player.health > 0:
		var bullet_instance = BULLET.instance()
		bullet_instance.rotation = rotation
		bullet_instance.global_position = $"Skeleton2D/YariGovde/UstGovde/Sag Kol/Sag El/silah/Position2D".global_position
		get_parent().add_child(bullet_instance)

func _on_Timer_timeout():
	shoot()
	
func die_check():
	if health <= 0:
		health = 0
		$AnimationPlayer.play("die")
		$CollisionShape2D.disabled = true
		set_physics_process(false)
	
func _on_HurtBox_area_entered(area):
	if area.is_in_group("Bullet"):
		health -= 10


func _on_VisibilityNotifier2D_screen_exited():
	if health <= 0:
		self.queue_free()
