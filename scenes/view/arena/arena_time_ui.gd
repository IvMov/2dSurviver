extends CanvasLayer

@export var arena_time_manager: Node
@onready var timeLabel = %TimeLabel
@onready var enemiesLabel = %EnemiesLabel

func _process(delta):
	
	if !arena_time_manager: 
		return
	var time_elapsed = arena_time_manager.get_time_elapsed();
	timeLabel.text = "time: " + format_seconds_to_sring(time_elapsed)
	enemiesLabel.text = "enemies: " + str(EnemyCounter.enemies);


func format_seconds_to_sring(seconds: float):
	if !seconds:
		return "GAME END"
		
	var minutes = floor(seconds/60)
	var remaining_seconds = floor(seconds) if minutes == 0 else int(seconds) % 60
	
	return ("%02d" % minutes) + ":" + ("%02d" % remaining_seconds)
