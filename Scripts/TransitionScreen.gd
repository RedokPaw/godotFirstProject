extends CanvasLayer

class_name TransitionScreen

signal transitioned

func transition() -> void:
	transition_to_black()
	
func transition_to_black() -> void:
	print("fading to black")
	$AnimationPlayer.play("fade_to_black")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("transitioned")
		
func transition_to_normal() -> void:
	print("fading to normal")
	$AnimationPlayer.play("fade_to_normal")
