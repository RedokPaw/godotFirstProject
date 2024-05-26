class_name Player
extends CharacterBody2D

var save_path = "user://variable.save"
const SPEED = 150.0
const JUMP_VELOCITY = -340.0
var knockback = Vector2.ZERO

# In some other file, e.g. Player.gd
var Cooldown = load('res://Scripts/player/Cooldown.gd')

@onready var attack_cooldown = Cooldown.new(0.5)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var gold = 0
var can_control : bool = true

@onready var weapon_collision = $WeaponSprite2D/WeaponArea2D/WeaponCollisionShape2D 
@onready var anim = $Animation

func _on_ready():
	load_data()

func _physics_process(delta):
	attack_cooldown.tick(delta)
	if not can_control: return
	
	if not is_on_floor():
		velocity.y += gravity * delta	
		
	var jumping
	if is_on_floor() and Input.is_action_just_pressed("ui_up") and not anim.animation == "attack2":
		velocity.y = JUMP_VELOCITY
		jumping = true
		anim.play("jump")
	if jumping and velocity.y > 0 and not anim.animation == "attack2":
		jumping = false
		anim.play("fall")
	
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED + knockback.x
		if velocity.y == 0 and not anim.animation == "attack2":
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) + knockback.x
		if velocity.y == 0 and not anim.animation == "attack2":
			anim.play("afk")
			
	#attack		
	if Input.is_action_just_pressed("ui_select") and attack_cooldown.is_ready():
		
		weapon_collision.disabled = false
		anim.play("attack2")
		$sfx/attackSound.play()
		await anim.animation_finished
		anim.play("afk")
		weapon_collision.disabled = true
			
	if direction == -1:
		anim.flip_h = true
		weapon_collision.position = Vector2(-6,0)
	elif direction == 1:
		anim.flip_h = false
		weapon_collision.position = Vector2(6,0)
			
	if health <= 0:
		handle_death()
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	
func handle_death() -> void:
	print("death of player detected")
	visible = false
	can_control = false
	var Transition = get_node("../../TransitionScreen")
	Transition.transition()
	
func reset_player() -> void:
	queue_free()
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
	visible = true
	can_control = true
	

func _on_transition_screen_transitioned():
	reset_player()
	
func _on_weapon_area_2d_body_entered(body):
	print("body entered weapon area")
	if body.is_in_group("Enemies") and anim.animation == "attack2":
		body.get_damage(30)
func hitKnockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * 200
	knockback = knockbackDirection
	move_and_slide()
func getDamage(damage, enemyVelocity):
	health -= damage
	hitKnockback(enemyVelocity)

func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(health)
	file.store_var(gold)
	file.close()
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		health = file.get_var()
		gold = file.get_var()
	else:
		health = 100
		gold = 0
func save_default_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(100)
	file.store_var(0)
	file.close()
	
func change_camera_position(limit_left, limit_right, limit_top, limit_bottom):
	$Camera2D.limit_left = limit_left
	$Camera2D.limit_right = limit_right
	$Camera2D.limit_top = limit_top
	$Camera2D.limit_bottom = limit_bottom
