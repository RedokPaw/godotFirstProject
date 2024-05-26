extends Node2D

@onready var Transition = get_node("TransitionScreen")
@onready var PlayerNode = get_node("Player/Player")


func _ready():
	Transition.transition_to_normal()
	PlayerNode.save_default_data()
	PlayerNode.change_camera_position(-30, 100000, 175, 645)

func handle_next_level():
	get_tree().change_scene_to_file.bind("res://ScenesOfLocations/dungeon_1.tscn").call_deferred()

func _on_next_level_area_body_entered(body):
	if body.name == "Player":
		body.can_control = false
		Transition.transition_to_black()
		await get_tree().tree_changed
		handle_next_level()
