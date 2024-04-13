extends CanvasLayer


@onready var start_button = $MarginContainer/Bacground/VBoxContainer/StartButton
@onready var properties_button = $MarginContainer/Bacground/VBoxContainer/PropertiesButton
@onready var controls_button = $MarginContainer/Bacground/VBoxContainer/ControlsButton
@onready var quit_button = $MarginContainer/Bacground/VBoxContainer/QuitButton

var main_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	if !get_tree().paused:
		main_scene = preload("res://scenes/main/main.tscn")
	start_button.pressed.connect(on_start_button_pressed)
	properties_button.pressed.connect(on_properties_button_pressed)
	controls_button.pressed.connect(on_controls_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	if get_tree().paused:
		start_button.text = "Continue"
	if !MusicPlayer.playing:
		MusicPlayer.play()


func  _unhandled_input(event):
	if event.is_action_pressed("escape") && get_tree().paused:
		on_start_button_pressed()


func on_start_button_pressed():
	MusicPlayer.stop()
	if !get_tree().paused:
		ScreenTransition.play_transition()
		await ScreenTransition.animation_player.animation_finished
		get_tree().change_scene_to_packed(main_scene)
		ScreenTransition.play_transition_back()
		await ScreenTransition.animation_player.animation_finished
	else:
		get_tree().paused = false
		get_parent().random_audio_player_component.play_random_stream()
		queue_free()
	
	
	
func on_properties_button_pressed():
	var scene = load("res://scenes/menu/properties_screen.tscn")
	var properties = scene.instantiate()
	get_parent().add_child(properties)
	
	
func on_controls_button_pressed():
	var scene = load("res://scenes/menu/control_screen.tscn")
	var controls = scene.instantiate()
	get_parent().add_child(controls)
	
	
func on_quit_button_pressed():
	get_tree().quit()

