extends CharacterBody2D


var SPEED = 150.0
var JUMP_VELOCITY = -200.0
@onready var animation_right = $AnimatedSprite
@onready var UI = %UI

func apply_speed_boost(new_speed: int, new_jump:int, duration: float):
	SPEED = new_speed
	JUMP_VELOCITY = new_jump
	await get_tree().create_timer(duration).timeout
	SPEED = 130.0
	JUMP_VELOCITY = -200.0

func _physics_process(delta: float) -> void:
	#keď je otvorené pc nehýbe sa
	if UI.monitor_open:
		return
	
	if UI.in_animation:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# smer buď 0, 1, -1
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		animation_right.play("walk_right")
		if (direction > 0):
			animation_right.flip_h = false
		elif (direction < 0):
			animation_right.flip_h = true
	else:
		animation_right.play("stand")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
