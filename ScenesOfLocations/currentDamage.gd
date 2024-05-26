extends Label

var Damage = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Damage: " + str(Damage)

func set_damage(dmg):
	Damage = dmg
