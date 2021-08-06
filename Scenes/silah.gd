extends Sprite

const BULLET = preload("res://Objects/Bullet/EnemyBullet.tscn")
export(NodePath) var player 
var health = 100
var deathok = false
func die_check():
	if health <= 0:
		health = 0
		deathok = true

func _physics_process(delta):
	look_at(player.global_position)
	die_check()
	print(health)

		
		

func _ready():
	player = get_node(player)
	

		
func shoot():
		var bullet_instance = BULLET.instance()
		$shoot.play()
		bullet_instance.rotation = rotation
		bullet_instance.global_position = global_position
		get_parent().get_parent().add_child(bullet_instance)

func _on_Timer_timeout():
	if deathok == false:
		shoot()


		
	

func _on_HitBox_area_entered(area):
	if area.is_in_group("Bullet"):
		health -= 10
