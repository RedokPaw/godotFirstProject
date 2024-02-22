extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var runaway = false
var speed = 50

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	if runaway == true:
		direction *= -1
		velocity.x = direction.x * speed
		
	move_and_slide()


func _on_detector_body_entered(body):
	if body.name == "Player":
		runaway = true
