extends CanvasLayer

@onready var back_button = $MarginContainer/Bacground/VBoxContainer/BackButton
@onready var sfx_slider = $MarginContainer/Bacground/VBoxContainer/VBoxContainer/SfxSound/SfxSlider
@onready var music_slider = $MarginContainer/Bacground/VBoxContainer/VBoxContainer/MusicSound/MusicSlider
@onready var window_button = $MarginContainer/Bacground/VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/WindowButton
@onready var sfx_random_audio_player_component = $SfxRandomAudioPlayerComponent
@onready var reset_button = $MarginContainer/Bacground/VBoxContainer/ResetButton



func _ready():
	window_button.pressed.connect(on_window_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	reset_button.pressed.connect(on_reset_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	update_display()

func _unhandled_input(event):
	if event.is_action_pressed("escape"):
		on_back_button_pressed()
		
		
func update_display():
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	window_button.text = "Windowed" if is_fullscreen else "Full screen"
	sfx_slider.value = get_bus_volume("sfx")
	music_slider.value = get_bus_volume("music")


func get_bus_volume(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	
	return db_to_linear(volume_db)


func set_bus_volume(value: float, bus_name):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func on_window_button_pressed():
	if DisplayServer.window_get_mode() ==  DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	update_display()


func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume(value, bus_name)
	if bus_name == "sfx":
		sfx_random_audio_player_component.play_random_stream()

func on_reset_button_pressed():
	MetaProgression.reset_file();


func on_back_button_pressed():
	queue_free()
