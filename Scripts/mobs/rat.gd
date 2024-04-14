extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var runaway = false
var speed = 80
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	
	if runaway == true:
		direction *= -1
		velocity.x = direction.x * speed
		anim.play("run")
		
	else:
		velocity.x = 0
		anim.play("afk")
		
	if direction.x <= 0:
		anim.flip_h = true
		
	elif velocity.x >= 0:
		anim.flip_h = false
		
	move_and_slide()
	
func _on_detector_body_entered(body):
	if body.name == "Player":
		runaway = true

func _on_detector_body_exited(body):
	if body.name == "Player":
		runaway = false
