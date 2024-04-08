extends CanvasLayer

@onready var panel_container = $MarginContainer/PanelContainer
var continue_active = true

func _ready():
	
	var tween = create_tween()
	panel_container.pivot_offset = panel_container.size / 2
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(panel_container, "scale", Vector2.ONE*1.2, .2)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .2)
	await tween.finished
	$AudioStreamPlayer.play()
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)
	if continue_active:
		%ContinueButton.pressed.connect(on_continue_button_pressed)
	get_tree().paused = true

func set_defeat():
	$AudioStreamPlayer.stream = load("res://assets/audio/gameend/jingles_NES00.ogg")
	%TitleLabel.text = "You DIED!"
	%DescriptionLabel.text = "What a shame, they ate you!"
	%ContinueButton.queue_free()
	continue_active = false
	
	
func on_restart_button_pressed():
	get_tree().paused = false
	PlayerCounters.reset_counters()
	EnemyCounter.reset_counters()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed():
	get_tree().quit()


func on_continue_button_pressed():
	get_tree().paused = false
	get_parent().random_audio_player_component.play_random_stream()
	queue_free()
