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
# Karakterin donmesi icin kullandigim degisken
var flip = Vector2.ZERO

func _physics_process(delta):		
	movement()
	hand_look()
	animation_prcess()
	flip_enemy()


# Yurume kodu
func movement():
	# Karakter ve Dusman arasindaki Mesafeyi ölçme 
	# abs negatif sayiyi pozitife cevirir 
	# cunku x ekseni eksi(-) ve arti(+) degeri alir 
	# biz de mesafeyi olcmek icin eksi degerini arti degeri yapiyoruz
	# Dusmanin x pozisyonunu - Karakterin x pozisyonunu = aralarindaki mesafe
	var distance = abs(position.x - player.position.x)
	
	# Eger yerde degilse direction degiskenine yer cekimi uyguluyoruz 
	if not is_on_floor():
		direction.y += GRAVITY
		
	# Yurume kodu
	move_and_slide(direction * WALK_SPEED)

	# Mesafeyi kontrol etme
	if distance < 200 and distance > 150:
		# Karakter pozisyonuna gore direction degiskeninin x degerini veriyoruz
		if player:
			direction.x = (player.position.x - position.x)
			
			direction = direction.normalized() 
	# Eger mesafe de degil ise direction degiskenin x ini 0 yapiyoruz
	else:
		direction.x = 0

# Animasyon islemleri Fonksyonu
func animation_prcess():
	# Eger direction degiskeni 0.75 dan buyuk ise yani yuruyorsa animasyon oynatilir
	# Ve eger -0.75 kucuk ise yani yuruyorsa animasyon oynatilir
	if direction.x < -0.75 or direction.x > 0.75:
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
	# Eger 0.1 den kucuk ise sala don
	if flip.x < -0.1:
		$Skeleton2D.scale = Vector2(-1,1)
		$polyons.scale = Vector2(-1,1)

# Elin Karakter pozisyonuna bakmasi
func hand_look():
	# Kolu karakterin global pozisyonuna baktiriyoruz 
	hand.look_at(player.global_position)	
