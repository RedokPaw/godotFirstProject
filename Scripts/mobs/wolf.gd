extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 100
var chase = false
var can_attack = true

@onready var anim = $WolfAnimatedSprite2D 
@onready var AttackTimer = $Death2/Timer

var alive = true

func _on_ready():
	add_to_group("Enemies")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	
	if alive == true:
		if chase == true and not anim.animation == "attack":
			velocity.x = direction.x * speed
			anim.play ("run")
			
		else:
			if not anim.animation == "attack":
				velocity.x = 0
				anim.play("afk")
			
		if direction.x < 0:
			anim.flip_h = false
			
		else:
			anim.flip_h = true
	
	move_and_slide()
	
func attack(body):
	if can_attack:
		can_attack = false
		body.health -=30
		get_tree().create_timer(3).timeout.connect(func(): can_attack = true)

func _on_follow_area_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_follow_area_body_exited(body):
	if body.name == "Player":
		chase = false
		
func _on_death_2_body_entered(body):
	while true:
		if body.name == "Player":
			await get_tree().create_timer(1).timeout
			anim.play("attack")
			attack(body)
			await anim.animation_finished
			anim.play("afk")
		else:
			break
		if $Death2.has_overlapping_bodies():
			anim.play("afk")
			break
			
		

func death():
	alive = false
	anim.modulate = Color(1, 0, 0)
	anim.play("death")
	await anim.animation_finished
	queue_free()


