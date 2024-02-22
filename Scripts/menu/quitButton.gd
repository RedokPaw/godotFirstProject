extends Button

@onready var defaultModulate = $quit.modulate

func _on_pressed():
	get_tree().quit()
	
func _on_mouse_entered(): 
	$quit.modulate = Color.WEB_MAROON

func _on_mouse_exited():
	$quit.modulate = defaultModulate
