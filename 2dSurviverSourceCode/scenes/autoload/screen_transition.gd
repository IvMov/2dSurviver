extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func play_transition():
	animation_player.play("default")
	
func play_transition_back():
	animation_player.play_backwards("default")
