extends KinematicBody2D

const Gravity = 25
const ACCELERATION = 1000
const MAX_SPEED = 250
const JUMP_HEIGHT = -500
const UP = Vector2 ( 0 , -1 )
var motion = Vector2()
var input_vector = Vector2()

func _physics_process(delta):
	
	var friction = false
	motion.y += Gravity
	input_vector = Vector2.ZERO
	
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x+ACCELERATION , MAX_SPEED)
		$Skeleton2D.scale = Vector2(0.5,0.5)
		$Skeleton2D2.scale = Vector2(0.5,0.5)
		$polygons.scale = Vector2(0.5,0.5)
		$CollisionShape2D.position = (Vector2(0,0))
		input_vector.x = 1
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x-ACCELERATION , -MAX_SPEED)
		$Skeleton2D.scale = Vector2(-0.5,0.5)
		$Skeleton2D2.scale = Vector2(-0.5,0.5)
		$polygons.scale = Vector2(-0.5,0.5)
		$CollisionShape2D.position = (Vector2(-56.561,0))
		input_vector.x = -1
	else:
		friction = true
		
		
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
	
func _process_animation():
	
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