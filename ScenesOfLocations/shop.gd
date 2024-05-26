extends Node2D

var max_health = 100
var gold = 0
var playerDamage = 30
var save_path = "user://variable.save"
var save_next_level_path = "user://nextlevel.save"
var next_level

func _process(_delta):
	$CanvasLayer/currentHp.set_health(max_health)
	$CanvasLayer/currentDamage.set_damage(playerDamage)
	$CanvasLayer/currentGold.set_gold(gold)

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		max_health = file.get_var()
		gold = file.get_var()
		playerDamage = file.get_var()
	else:
		max_health = 100
		gold = 0
		playerDamage = 30
	$CanvasLayer/currentHp.set_health(max_health)
	$CanvasLayer/currentDamage.set_damage(playerDamage)
	$CanvasLayer/currentGold.set_gold(gold)
	var file = FileAccess.open(save_next_level_path, FileAccess.READ)
	next_level = file.get_var()
	
func _on_damage_button_up_pressed():
	if gold - 10 >= 0:
		playerDamage +=5
		gold -= 10

func _on_health_button_up_pressed():
	if gold - 10 >= 0:
		max_health += 10
		gold -= 10

func _on_resume_button_pressed():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(max_health)
	file.store_var(gold)
	file.store_var(playerDamage)
	file.close()
	handle_next_level()
	
func handle_next_level():
	get_tree().change_scene_to_file.bind(next_level).call_deferred()
