extends Label

var health = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "HP: " + str(health)
	
func set_health(hp):
	health = hp
	
