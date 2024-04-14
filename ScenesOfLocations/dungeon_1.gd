extends Node2D

@onready var Transition = $TransitionScreen
# Called when the node enters the scene tree for the first time.
func _ready():
	Transition.transition_to_normal()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
