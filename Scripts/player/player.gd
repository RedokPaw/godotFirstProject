class_name Player
extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -340.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var gold = 0
var can_control : bool = true
@onready var weapon_collision = $WeaponSprite2D/WeaponArea2D/WeaponCollisionShape2D 
@onready var anim = $Animation



func _physics_process(delta):
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
		velocity.x = direction * SPEED
		if velocity.y == 0 and not anim.animation == "attack2":
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and not anim.animation == "attack2":
			anim.play("afk")
			
	#attack		
	if Input.is_action_just_pressed("ui_select"):
		weapon_collision.disabled = false
		anim.play("attack2")
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
		body.death()
