extends CanvasLayer

@export var arena_time_manager: Node
@export var player: Player
@onready var time_label = %TimeLabel
@onready var enemies_label = %EnemiesLabel
@onready var stats_label = %StatsLabel
@onready var rules_label = %RulesLabel
@onready var ability_label = %AbilityLabel

var time: String
var is_pause: bool = false

func _process(delta):
	var format = "%0.01f";
	if !arena_time_manager: 
		return
	var time_elapsed = arena_time_manager.get_time_elapsed();
	time = format_seconds_to_sring(time_elapsed)
	time_label.text = "time: " + time
	enemies_label.text = "enemies: " + str(EnemyCounter.enemies)
	var stats_text = "MaxHP: %s\nCurrentHP: %s\nCurrentSpeed: %s\nLevel: %s\nExp: %s\nNextLvlExp: %s\nMore stats soon"
	stats_label.text = stats_text % [int(player.health_component.max_health), int(player.health_component.current_health), int(player.velocity_component.max_speed), PlayerCounters.current_level, PlayerCounters.expirience, PlayerCounters.target_expirience]
	var ability_text = "Abilities\n\n"
	var ability_blueprint = "%s\n Damage: %s\n Rate: %s\n"
	if player.is_inside_tree():
		var nodes = player.get_tree().get_nodes_in_group("ability_controller")
		for node in nodes:
			var damage = format % node.damage
			var wait_time = format % node.ability_timer.wait_time
			ability_text += ability_blueprint % [node.controller_name, damage, wait_time]
			ability_text += "___\n"
		ability_label.text = ability_text
	


func format_seconds_to_sring(seconds: float):
	if !seconds:
		return "GAME END"
		
	var minutes = floor(seconds/60)
	var remaining_seconds = floor(seconds) if minutes == 0 else int(seconds) % 60
	
	return ("%02d" % minutes) + ":" + ("%02d" % remaining_seconds) if minutes != 10 else "GAME END"


func _on_timer_ui_timeout():
	rules_label.queue_free()


func _on_button_close_pressed():
	get_tree().quit()


	
