extends Button

@onready var defaultModulate = $start.modulate

func _on_pressed():
	get_tree().change_scene_to_file("res://ScenesOfLocations/tutorial.tscn")

func on_mouse_entered():
	$start.modulate = Color.WEB_MAROON

func on_mouse_exited():
	$start.modulate = defaultModulate
