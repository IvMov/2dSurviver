extends CanvasLayer

@export var arena_time_manager: Node
@export var player: Player

@onready var time_label = %TimeLabel
@onready var button_menu = %ButtonMenu
@onready var speed_label = $MarginContainer/StatsContainer/VBoxContainer/SpeedContainer/MarginContainer/SpeedLabel
@onready var coins_label = $MarginContainer/StatsContainer/VBoxContainer/CoinsContainer/MarginContainer/CoinsLabel
@onready var sword_ability_container_ui = $MarginContainer/StatsContainer/VBoxContainer/SwordAbilityContainerUI
@onready var axe_ability_container_ui = $MarginContainer/StatsContainer/VBoxContainer/AxeAbilityContainerUI


var time: String
var control_scene

func _ready():
	reset_labels()
	GameEvents.ability_upgrade_applied.connect(on_ability_upgrade_applied)
	PlayerCounters.coin_added.connect(on_coin_added)


func _process(delta):
	if !arena_time_manager || !player: 
		return
	var time_elapsed = arena_time_manager.get_time_elapsed();
	time = format_seconds_to_sring(time_elapsed)
	time_label.text = "time: " + time
	
	speed_label.text = "%3d / 250" % player.velocity.length()


func _unhandled_input(event):
	if event.is_action_pressed("pause") || event.is_action_pressed("escape"):
		_on_button_menu_pressed()

	
func reset_labels():
	sword_ability_container_ui.reset_skill_ui()
	axe_ability_container_ui.reset_skill_ui()
	coins_label.text = "%8d $" % 0
	speed_label.text = "%3d / %3d" % [0, 0]

		
func format_seconds_to_sring(seconds: float):
	if !seconds:
		return "GAME END"
		
	var minutes = floor(seconds/60)
	var remaining_seconds = floor(seconds) if minutes == 0 else int(seconds) % 60
	
	return ("%02d" % minutes) + ":" + ("%02d" % remaining_seconds) if minutes != 10 else "GAME END"


func _on_button_close_pressed():
	get_tree().quit()


func _on_button_menu_pressed():
	get_tree().paused = true
	get_parent().random_audio_player_component.stop()
	var menu_screen = load("res://scenes/menu/menu_screen.tscn")
	var menu = menu_screen.instantiate()
	get_parent().add_child(menu)


func on_ability_upgrade_applied():
	if !player.is_inside_tree():
		return
		
	var nodes = player.get_tree().get_nodes_in_group("ability_controller")
	for node in nodes:
		if sword_ability_container_ui.ability_name == node.controller_name:
			sword_ability_container_ui.dmg = node.damage
			sword_ability_container_ui.cd = node.ability_timer.wait_time
			sword_ability_container_ui.update_skill_ui()
			
		elif axe_ability_container_ui.ability_name == node.controller_name:
			axe_ability_container_ui.dmg = node.damage
			axe_ability_container_ui.cd = node.ability_timer.wait_time
			axe_ability_container_ui.update_skill_ui()

func on_coin_added():
	coins_label.text = "%8d $" % PlayerCounters.run_coins
