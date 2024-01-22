extends CanvasLayer

@export var arena_time_manager: Node
@onready var time_label = %TimeLabel
@onready var enemies_label = %EnemiesLabel
@onready var stats_label = %StatsLabel


func _process(delta):
	
	if !arena_time_manager: 
		return
	var time_elapsed = arena_time_manager.get_time_elapsed();
	time_label.text = "time: " + format_seconds_to_sring(time_elapsed)
	enemies_label.text = "enemies: " + str(EnemyCounter.enemies)
	var stats_text = "Level: %s \nCoins: %s \nExp: %s \nNExtLvlExp: %s"
	stats_label.text = stats_text % [PlayerCounters.current_level, PlayerCounters.money, PlayerCounters.expirience, PlayerCounters.target_expirience]
	

func format_seconds_to_sring(seconds: float):
	if !seconds:
		return "GAME END"
		
	var minutes = floor(seconds/60)
	var remaining_seconds = floor(seconds) if minutes == 0 else int(seconds) % 60
	
	return ("%02d" % minutes) + ":" + ("%02d" % remaining_seconds) if minutes != 10 else "GAME END"
