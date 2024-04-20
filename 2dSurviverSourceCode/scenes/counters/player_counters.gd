extends Node

signal coin_added()
signal lvl_upped()

var expirience: int = 0
var current_level: int = 0
var start_expirience: int = 0
var target_expirience: int = 100
var base_exp_level: int = 200
var run_coins: int = 0
var run_kills: int = 0

func _ready():
	GameEvents.exp_collected.connect(handle_exp_collected)
	GameEvents.new_level.connect(on_level_up)
	GameEvents.ability_upgrade_applied.connect(on_ablility_upgrade_applied)
	GameEvents.coin_collected.connect(on_coin_collected)

	
func handle_exp_collected(value, pos):
	expirience+=value
	if expirience >= target_expirience:
		GameEvents.emit_new_level(expirience)
		
	
func on_level_up(value):
	current_level+=1
	start_expirience = target_expirience
	target_expirience += (base_exp_level * (current_level*2))
	GameEvents.emit_call_abillity_upgrade()
	lvl_upped.emit()

func reset_counters():
	expirience = 0
	current_level = 0
	start_expirience = 0
	target_expirience = 100
	base_exp_level = 200
	run_coins = 0
	run_kills = 0

func on_ablility_upgrade_applied():
	if expirience >= target_expirience:
		GameEvents.emit_new_level(expirience)
	else:
		get_tree().paused = false


func on_coin_collected(value: int, position: Vector2):
	run_coins+=value
	coin_added.emit()
