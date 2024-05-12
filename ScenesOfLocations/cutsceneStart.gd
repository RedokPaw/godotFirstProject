extends Node2D


@onready var Transition = get_node("TransitionScreen")

signal on_transit

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Transition.transition_to_normal()
	Dialogic.start("timelineCutscene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_dialogic_signal(argument:String):
	if argument == "transit":
		Transition.transition_to_black()
		get_tree().change_scene_to_file("res://ScenesOfLocations/tutorial.tscn")
