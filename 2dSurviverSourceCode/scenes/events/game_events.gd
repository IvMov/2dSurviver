extends Node

signal game_started()
signal game_win()
signal exp_collected(value: int, position: Vector2)
signal coin_collected(value: int, position: Vector2)
signal exp_dropped(value: int, position: Vector2)
signal coin_dropped(value: int, position: Vector2)
signal new_level(value: int)
signal call_abillity_upgrade()
signal ability_upgrade_applied()
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged(value: int)

func emit_game_started():
	game_started.emit()
	
func emit_game_win():
	game_win.emit()

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


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)
	
func emit_ability_upgrade_applied():
	ability_upgrade_applied.emit()
	
func emit_player_damaged(value: int):
	player_damaged.emit(value)
	
