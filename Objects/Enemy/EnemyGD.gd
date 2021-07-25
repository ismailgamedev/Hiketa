extends KinematicBody2D

# Hız ve yer çekimi degeri
const WALK_SPEED = 100
const GRAVITY = 25

# Sahnedeki karakter sahnesine ulaşma
onready var player = get_node("/root/Main/Player")
# Kol kemigini degiskene atama
onready var hand = get_node("Skeleton2D/YariGovde/UstGovde/Sag Kol")
# AnimationPlayeri degiskene atama
onready var animation_player = get_node("AnimationPlayer")

var direction = Vector2.ZERO
var flip = false

func _physics_process(delta):
	# Karakter ve Dusman arasindaki Mesafeyi ölçme 
	# abs negatif sayiyi pozitife cevirir 
	# cunku x ekseni eksi(-) ve arti(+) degeri alir 
	# biz de mesafeyi olcmek icin eksi degerini arti degeri yapiyoruz
	# Karakterin x pozisyonunu - Dusmanin x pozisyonunu = aralarindaki mesafe
	var distance = abs(position.x - player.position.x)
	
	# Eger yerde degilse direction degiskenine yer cekimi uyguluyoruz 
	if not is_on_floor():
		direction.y += GRAVITY
		
	# Yurume kodu
	move_and_slide(direction * WALK_SPEED)

	# Mesafeyi kontrol etme
	if distance < 150 and distance > 100:
		# Karakter pozisyonuna gore direction degiskeninin x degerini veriyoruz
		if player:
			direction.x = (player.position.x - position.x)
			direction = direction.normalized() 
	# Eger mesafe de degil ise direction degiskenin x ini 0 yapiyoruz
	else:
		direction.x = 0
		
	# Eger direction degiskeni 0.75 dan buyuk ise yani yuruyorsa animasyon oynatilir
	# Ve eger -0.75 kucuk ise yani yuruyorsa animasyon oynatilir
	if direction.x < -0.75 or direction.x > 0.75:
		$AnimationPlayer.play("walk")
	# direction 0 ise  idle animasyonu oynatilir
	else:
		$AnimationPlayer.play("idle")
		
	# Kolu karakterin global pozisyonuna baktiriyoruz 
	hand.look_at(player.global_position)
	
	if flip == true:
		$Skeleton2D.scale = Vector2(1,1)
		$polyons.scale = Vector2(1,1)
	else:
		$Skeleton2D.scale = Vector2(-1,1)
		$polyons.scale = Vector2(-1,1)
		
	print($"Skeleton2D/YariGovde/UstGovde/Sag Kol".rotation_degrees)
	if $"Skeleton2D/YariGovde/UstGovde/Sag Kol".rotation_degrees > 0:
		flip = false
	if $"Skeleton2D/YariGovde/UstGovde/Sag Kol".rotation_degrees < 0:
		flip = true
		


