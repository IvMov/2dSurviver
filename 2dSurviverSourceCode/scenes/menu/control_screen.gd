extends CanvasLayer

@onready var back_button = $MarginContainer/ColorRect/VBoxContainer2/BackButton


func _ready():
	back_button.pressed.connect(on_back_button_pressed)
	
func _input(event):
	if event.is_action_pressed("escape"):
		on_back_button_pressed()


func on_back_button_pressed():
	queue_free()
