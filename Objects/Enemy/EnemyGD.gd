extends KinematicBody2D

const WALK_SPEED = 100
const GRAVITY = 600

onready var player = get_node("/root/Main/Player")


func _physics_process(delta):
	
	var playerPos = player.position.x
	var enemyPos = position.x
	var distance = enemyPos.distance_to(playerPos)

	if distance < 150:
		if player:
			var direction = (player.position - position).normalized()
			if not is_on_floor():
				direction.y += GRAVITY
			
			move_and_slide(direction * WALK_SPEED)
