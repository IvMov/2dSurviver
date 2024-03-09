extends CanvasLayer


func _ready():
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)
	%ContinueButton.pressed.connect(on_continue_button_pressed)

func set_defeat():
	%TitleLabel.text = "You DIED!"
	%DescriptionLabel.text = "What a shame, they ate you!"
	%ContinueButton.queue_free()
	
	
func on_restart_button_pressed():
	get_tree().paused = false
	PlayerCounters.reset_counters()
	EnemyCounter.reset_counters()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed():
	get_tree().quit()


func on_continue_button_pressed():
	get_tree().paused = false
	queue_free()
