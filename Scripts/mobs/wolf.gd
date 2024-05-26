extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 65
var health = 100
var chase = false
var knockbackPower = 5
var knockback = Vector2.ZERO

var Cooldown = load('res://Scripts/player/Cooldown.gd')

@onready var attack_cooldown = Cooldown.new(2)

@onready var anim = $WolfAnimatedSprite2D 

var alive = true

func _on_ready():
	add_to_group("Enemies")

func _physics_process(delta):
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	attack_cooldown.tick(delta)
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if alive == true:
		if chase == true:
			velocity.x = direction.x * speed + knockback.x
			if anim.animation != "attack":
				anim.play("run")
			
		else:
			if not anim.animation == "attack":
				velocity.x = 0
				anim.play("afk")
			
		if direction.x < 0:
			anim.flip_h = false
			
		else:
			anim.flip_h = true
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.05)
	
func attack(body):
	if attack_cooldown.is_ready():
		anim.stop()
		anim.play("attack")
		body.getDamage(30, velocity)
		hitKnockback()
		await anim.animation_finished
		anim.play("afk")

func _on_follow_area_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_follow_area_body_exited(body):
	if body.name == "Player":
		chase = false
		
func _on_death_2_body_entered(body):
	while alive:
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
	velocity.x = 0
	alive = false
	anim.modulate = Color(1, 0, 0)
	anim.play("death")
	await anim.animation_finished
	queue_free()
	
func get_damage(damage):
	health -= damage
	if health < 0:
		death()
		return
	hitKnockback()
	anim.stop()
	anim.play("takeHit")
	$hit.play("get_hit")
	await anim.animation_finished
	anim.play("afk")
	
func _on_wolf_animated_sprite_2d_animation_finished():
	anim.play("afk")
	
func hitKnockback():
	var knockbackDirection = Vector2(-velocity.x, 0) * knockbackPower
	knockback = knockbackDirection
	move_and_slide()
