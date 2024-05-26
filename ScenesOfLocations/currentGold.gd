extends Label

var gold = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Gold: " + str(gold)

func set_gold(gld):
	gold = gld

