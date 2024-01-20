extends Node

signal exp_collected(value: int, position: Vector2)
signal coin_collected(value: int, position: Vector2)
signal exp_dropped(value: int, position: Vector2)
signal coin_dropped(value: int, position: Vector2)


func emit_exp_collected(value: int, position: Vector2):
	exp_collected.emit(value, position)


func emit_coin_collected(value: int, position: Vector2):
	coin_collected.emit(value, position)
	
	
func emit_exp_dropped(value: int, position: Vector2):
	exp_dropped.emit(value, position)


func emit_coin_dropped(value: int, position: Vector2):
	coin_dropped.emit(value, position)
