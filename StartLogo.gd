extends Node2D

@onready var Transition = get_node("Sprite2D/TransitionScreen")

# Called when the node enters the scene tree for the first time.
func _ready():
	Transition.transition_to_normal()


func _on_timer_timeout():
	Transition.transition_to_black()


func _on_transition_screen_transitioned():
	get_tree().change_scene_to_file("res://ScenesOfLocations/menu.tscn")
