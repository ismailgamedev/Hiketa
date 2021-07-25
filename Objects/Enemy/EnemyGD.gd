extends KinematicBody2D

# Hız ve yer çekimi
const WALK_SPEED = 100
const GRAVITY = 25

# Sahnedeki karakter sahnesine ulaşma
onready var player = get_node("/root/Main/Player")
onready var kol = get_node("Skeleton2D/YariGovde/UstGovde/Sag Kol")
onready var anim_tree = get_node("AnimationTree")
onready var state_machine = anim_tree["parameters/playback"]

var direction = Vector2.ZERO

func _physics_process(delta):
	# Karakter ve Dusman arasindaki Mesafeyi ölçme
	var distance = abs(position.x - player.position.x)
	# Yer çekimi
	
	print(distance)
	if not is_on_floor():
		direction.y += GRAVITY
	move_and_slide(direction * WALK_SPEED)

	# Mesafeye göre takip etme ve durma 
	if distance < 150 and distance > 100:
		if player:
			direction.x = (player.position.x - position.x)
			direction = direction.normalized() 
	else:
		direction.x = 0
		
		
	print(direction)
	if direction.x < -0.75 or direction.x > 0.75:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
		
	kol.look_at(player.global_position)

	
