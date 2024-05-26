extends Node2D

@onready var Transition = $TransitionScreen
@onready var PlayerNode = get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	Transition.transition_to_normal()
	PlayerNode.change_camera_position(-85, 100000, 100, 650)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
