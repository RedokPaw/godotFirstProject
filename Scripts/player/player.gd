extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $Animation



func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var jumping
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		jumping = true
		anim.play("jump")
		
	if jumping and velocity.y > 0:
		jumping = false
		anim.play("fall")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("afk")
		
	if direction == -1:
		anim.flip_h = true
		
	elif direction == 1:
		anim.flip_h = false
		
		
	move_and_slide()
