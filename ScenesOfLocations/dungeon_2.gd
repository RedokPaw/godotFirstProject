extends Node2D

@onready var PlayerNode = get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerNode.change_camera_position(-25, 100000, 175, 650)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
