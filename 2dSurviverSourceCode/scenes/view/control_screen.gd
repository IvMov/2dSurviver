extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("pause") || event.is_action_pressed("escape"):
		get_parent()._on_button_pause_pressed()
