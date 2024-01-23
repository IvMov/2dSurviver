extends Node

signal exp_collected(value: int, position: Vector2)
signal coin_collected(value: int, position: Vector2)
signal exp_dropped(value: int, position: Vector2)
signal coin_dropped(value: int, position: Vector2)
signal new_level(value: int)
signal call_abillity_upgrade()


func emit_exp_collected(value: int, position: Vector2):
	exp_collected.emit(value, position)


func emit_coin_collected(value: int, position: Vector2):
	coin_collected.emit(value, position)
	
	
func emit_exp_dropped(value: int, position: Vector2):
	exp_dropped.emit(value, position)


func emit_coin_dropped(value: int, position: Vector2):
	coin_dropped.emit(value, position)


func emit_new_level(value: int):
	new_level.emit(value)


func emit_call_abillity_upgrade():
	call_abillity_upgrade.emit()
