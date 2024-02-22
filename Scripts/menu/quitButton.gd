extends Button

func _on_pressed():
	get_tree().quit()
	
func _on_mouse_entered():
	$Sprite2D.visible = true
	
