extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 30
var chase = false

@onready var anim = $AnimatedSprite2D

var alive = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	
	if alive == true:
		if chase == true:
			velocity.x = direction.x * speed
			anim.play ("walk")
			
		else:
			velocity.x = 0
			anim.play("afk")
			
		if direction.x < 0:
			anim.flip_h = true
			
		else:
			anim.flip_h = false
	
	move_and_slide()
# Called when the node enters the scene tree for the first time.


func _on_follow_area_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_follow_area_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_death_body_entered(body):
	if body.name == "Player":
		death()
		
func _on_death_2_body_entered(body):
	if body.name == "Player":
		if alive == true:
			body.health -= 30
		death()
		
func death():
	alive = false
	anim.play("death")
	await anim.animation_finished
	queue_free()
