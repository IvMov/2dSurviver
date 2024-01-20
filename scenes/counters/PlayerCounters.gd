extends Node

var money: int = 0;
var exp: int = 0;

func _ready():
	GameEvents.coin_collected.connect(handle_coin_collected)
	GameEvents.exp_collected.connect(handle_exp_collected)
	
func handle_coin_collected(value, pos):
	money+=value
	
	
func handle_exp_collected(value, pos):
	exp+=value
	
	
