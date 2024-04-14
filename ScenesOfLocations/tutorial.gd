extends Node2D

@onready var Transition = get_node("TransitionScreen")

func _ready():
	Transition.transition_to_normal()

func handle_next_level():
	get_tree().change_scene_to_file.bind("res://ScenesOfLocations/dungeon_1.tscn").call_deferred()

func _on_next_level_area_body_entered(_body):
	Transition.transition()
	handle_next_level()
