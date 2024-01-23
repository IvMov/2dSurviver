extends Node

var money: int = 0
var expirience: int = 0
var current_level: int = 0
var start_expirience: int = 0
var target_expirience: int = 100
var base_exp_level: int = 100;

func _ready():
	GameEvents.coin_collected.connect(handle_coin_collected)
	GameEvents.exp_collected.connect(handle_exp_collected)
	GameEvents.new_level.connect(on_level_up)
	
func handle_coin_collected(value, pos):
	money+=value
	
	
func handle_exp_collected(value, pos):
	expirience+=value
	if expirience >= target_expirience:
		GameEvents.emit_new_level(expirience)
	
func on_level_up(value):
	current_level+=1
	start_expirience = target_expirience
	target_expirience += (base_exp_level * (current_level))
	GameEvents.emit_call_abillity_upgrade()
