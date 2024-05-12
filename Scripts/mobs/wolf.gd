extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 100
var chase = false

var Cooldown = load('res://Scripts/player/Cooldown.gd')

@onready var attack_cooldown = Cooldown.new(2)

@onready var anim = $WolfAnimatedSprite2D 

var alive = true

func _on_ready():
	add_to_group("Enemies")

func _physics_process(delta):
	attack_cooldown.tick(delta)
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
	if attack_cooldown.is_ready():
		anim.play("attack")
		body.health -=30

func _on_follow_area_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_follow_area_body_exited(body):
	if body.name == "Player":
		chase = false
		
func _on_death_2_body_entered(body):
	while true:
		if body.name == "Player":
			attack(body)
			await anim.animation_finished
			anim.play("afk")
		else:
			break
		if not $Death2.has_overlapping_bodies():
			anim.play("afk")
			break

func death():
	alive = false
	anim.modulate = Color(1, 0, 0)
	anim.play("death")
	await anim.animation_finished
	queue_free()


