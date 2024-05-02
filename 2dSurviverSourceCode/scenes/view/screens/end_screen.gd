extends CanvasLayer

@onready var end_and_stats_button = %EndAndStatsButton
@onready var panel_container = $MarginContainer/PanelContainer
var continue_active = true

func _ready():
	PlayerCounters.run_coins+=100
	var tween = create_tween()
	panel_container.pivot_offset = panel_container.size / 2
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(panel_container, "scale", Vector2.ONE*1.2, .2)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .2)
	await tween.finished
	$AudioStreamPlayer.play()
	end_and_stats_button.pressed.connect(on_end_and_stats_button_pressed)
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)
	if continue_active:
		GameEvents.emit_game_win()
		%ContinueButton.pressed.connect(on_continue_button_pressed)
	get_tree().paused = true


func set_defeat():
	PlayerCounters.run_coins-=100
	$AudioStreamPlayer.stream = load("res://assets/audio/gameend/jingles_NES00.ogg")
	%TitleLabel.text = "You DIED!"
	%DescriptionLabel.text = "They ate you! But don't worry! \n Now you can go to the Menu and \n buy some UPGRADES in Shop!"
	
	%ContinueButton.queue_free()
	continue_active = false
	
	
func on_restart_button_pressed():
	get_tree().paused = false
	PlayerCounters.reset_counters()
	GameEvents.emit_game_started()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed():
	GameEvents.emit_save_game()
	get_tree().quit()


func on_continue_button_pressed():
	GameEvents.emit_save_game()
	get_tree().paused = false
	get_parent().random_audio_player_component.play_random_stream()
	queue_free()


func on_end_and_stats_button_pressed():
	GameEvents.emit_save_game()
	get_tree().paused = false
	PlayerCounters.reset_counters()
	get_tree().change_scene_to_file("res://scenes/menu/menu_screen.tscn")
	var scene = load("res://scenes/menu/stats_and_upgrade_screen.tscn")
	var properties = scene.instantiate()
	get_parent().add_child(properties)
