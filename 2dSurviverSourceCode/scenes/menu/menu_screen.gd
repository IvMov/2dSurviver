extends CanvasLayer


@onready var start_button = $MarginContainer/Bacground/VBoxContainer/StartButton
@onready var restart_button = $MarginContainer/Bacground/VBoxContainer/RestartButton
@onready var stats_and_upgrades_button = $MarginContainer/Bacground/VBoxContainer/StatsAndUpgradesButton
@onready var properties_button = $MarginContainer/Bacground/VBoxContainer/PropertiesButton
@onready var controls_button = $MarginContainer/Bacground/VBoxContainer/ControlsButton
@onready var quit_button = $MarginContainer/Bacground/VBoxContainer/QuitButton
@onready var give_up_button = $MarginContainer/Bacground/VBoxContainer/GiveUpButton


# Called when the node enters the scene tree for the first time.
func _ready():
	if !get_tree().paused:
		restart_button.visible = false
		give_up_button.visible = false
		stats_and_upgrades_button.visible = true
	start_button.pressed.connect(on_start_button_pressed)
	
	stats_and_upgrades_button.pressed.connect(on_stats_and_upgrades_button)
	properties_button.pressed.connect(on_properties_button_pressed)
	controls_button.pressed.connect(on_controls_button_pressed)
	restart_button.pressed.connect(on_restart_button_pressed)
	give_up_button.pressed.connect(on_give_up_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	if get_tree().paused:
		restart_button.visible = true
		give_up_button.visible = true
		stats_and_upgrades_button.visible = false
		start_button.text = "Continue"
	if !MusicPlayer.playing:
		MusicPlayer.play()


func  _unhandled_input(event):
	if event.is_action_pressed("escape") && get_tree().paused:
		on_start_button_pressed()


func on_start_button_pressed():
	
	if !get_tree().paused:
		var scene = load("res://scenes/menu/start_game_screen.tscn")
		var start = scene.instantiate()
		get_parent().add_child(start)
	else:
		MusicPlayer.stop()
		get_tree().paused = false
		get_parent().random_audio_player_component.play_random_stream()
		queue_free()

func on_restart_button_pressed():
	GameEvents.emit_save_game()
	MusicPlayer.stop()
	PlayerCounters.reset_counters()
	get_tree().paused = false
	ScreenTransition.play_transition()
	await ScreenTransition.animation_player.animation_finished
	GameEvents.emit_game_started()
	get_tree().change_scene_to_packed(GameEvents.main_scene)
	ScreenTransition.play_transition_back()
	
	
func on_stats_and_upgrades_button():
	var scene = load("res://scenes/menu/stats_and_upgrade_screen.tscn")
	var properties = scene.instantiate()
	get_parent().add_child(properties)

	
func on_properties_button_pressed():
	var scene = load("res://scenes/menu/properties_screen.tscn")
	var properties = scene.instantiate()
	get_parent().add_child(properties)
	
	
func on_controls_button_pressed():
	var scene = load("res://scenes/menu/control_screen.tscn")
	var controls = scene.instantiate()
	get_parent().add_child(controls)

func on_give_up_button_pressed():
	GameEvents.emit_save_game()
	PlayerCounters.reset_counters()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu_screen.tscn")
	
func on_quit_button_pressed():
	GameEvents.emit_save_game()
	get_tree().quit()

